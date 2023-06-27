----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2022. All Rights Reserved.
--
-- Author: Clive Bostock
--
-- DESCRIPTION
--
--   This script must be run in SQL*Plus - not sqlcl.
--
--   Code generator; generates DDL fixes for constraints
--   which violate naming conventions. The script assumes the
--   tables in the CURRENT_SCHEMA. So either connect as the 
--   schema or do an *alter session set current_schema = <SCHEMA_NAME>*
--
--   
--
--   The script will generate PL/SQL. Take the PL/SQL and launch
--   SQLcl from the directory which contains the tables and foreign_keys
--   directories. This will augment (append to) the existing files. 
--
--   If you wish to check the output before running the appends into 
--   you existing files, simply create a scratch directory containing
--   tables, and foreign_keys directories.
-- 
--   NOTES: The script takes account of existing constraints which
--          are standards compliant, ensuring that it doesn't generate
--          a name which clashes with existing names.
--
--          For OHMS, these four scripts will need manual editing 
--          after being augmented:
--
--          SCH_REGISTRANT_PROCEDURES.sql
--          SCH_REGISTRANTS.sql
--          SCH_USER_ROLES.sql
--          SCH_USERS.sql
--
--          These 4 include audit table operations and it is suggested that
--          no DDL should appear after them. That said, the changes made
--          here, should not impinge on the auditing.
--
----------------------------------------------------------------------------
set serverout on size unlimited
set linesize 250
set trimspool on feedback off
whenever sqlerror exit failure
spool non_fk_renames.sql
declare

  c_schema_name          constant  varchar2(30)   := sys_context('userenv', 'current_schema');
  l_table_abbreviation             varchar2(30);
  l_r_table_abbreviation           varchar2(30); -- Referenced table (used for FKs section)
  l_expected_name                  varchar2(60);
  l_base_name                      varchar2(60);
  l_constraint_name                varchar2(60);
  l_constraint_columns             varchar2(1000);
  l_spooled                        boolean        := false; 
  l_subscript                      pls_integer    := 0;
  l_last_subscripted_basename      varchar2(64)   := null;

  -------------------------------------------------------------------------------
  --  The constraint_columns function, returns a colon separated list of columns, in 
  -- the same order that they are listed at the constraint creation.                 
  -------------------------------------------------------------------------------
  function constraint_columns ( p_constraint_name in varchar2
                              , p_constraint_type in varchar2 )
  return varchar2
  is
    l_column_list                  varchar2(500) := null;
  begin
    if p_constraint_type = 'C'
    then
      return '';
    end if;

    for r in (select column_name
                from all_cons_columns
               where owner = c_schema_name
                 and constraint_name = p_constraint_name
                order by position asc)
    loop
      l_column_list := l_column_list || ':' || r.column_name;
    end loop;
    return l_column_list;   

  end;

  -------------------------------------------------------------------------------
  --  The cache_constraint procedure is called for every constraint processed   
  -- (whether the current constraint is valid or not) and details are cached for
  -- later use, during index processing.                                        
  -------------------------------------------------------------------------------
  procedure cache_constraint ( p_table_name             in varchar2
                             , p_current_constr_name    in varchar2
                             , p_expected_constr_name   in varchar2
                             , p_constraint_type        in varchar2
                             , p_column_list            in varchar2 )
  is
  begin
    begin
      insert into xxx_constraints_cache 
        ( 
          table_name
        , current_constraint_name 
        , expected_constraint_name 
        , constraint_type 
        , column_list
        )
      values
       ( p_table_name
       , p_current_constr_name
       , p_expected_constr_name
       , p_constraint_type
       , p_column_list
       );
    exception
      when dup_val_on_index then
        dbms_output.put_line('--  [cache_constraint] Duplicate on: ' || p_table_name || ' - ' || p_current_constr_name || '/' || p_expected_constr_name);
        raise;
    end;
  end cache_constraint;


  -------------------------------------------------------------------------------
  --  The wrap procedure takes any generated lines of PL/SQL code and wraps them
  -- within a dbms_output.put_line, whilst protecting any quotes.                   
  -------------------------------------------------------------------------------
  procedure wrap (p_text            varchar2)
  is
  begin
    -- dbms_output.put_line(p_text);
    dbms_output.put_line('dbms_output.put_line(q' || '''' || '[' || p_text || ']' || '''' || ');');
  end wrap;

  -------------------------------------------------------------------------------
  --  The table_abbreviation function returns the table_abbreviation as defined 
  -- in the dev_table_abbreviations table.                                             
  -------------------------------------------------------------------------------
  function table_abbreviation (p_schema_name    in varchar2, p_table_name in varchar2)
  return varchar2  
  is
    l_table_abbreviation     varchar2(15);
  begin
    select table_abbreviation
       into l_table_abbreviation
      from dev_table_abbreviations
     where schema_name = p_schema_name
       and table_name  = p_table_name;
     return l_table_abbreviation;
  exception
    when no_data_found
    then
      wrap('ERROR [table_abbreviation]: could not rerieve table abbreviation for ' || p_schema_name || ' / ' || p_table_name);
      return 'UNKOWN';
  end table_abbreviation;

  -------------------------------------------------------------------------------
  --  The next_free_name function works from a basename of a constraint, and adds
  -- a subscript. It iterates until it finds an unused object and then returns
  -- the generated name.                                                            
  -------------------------------------------------------------------------------
  function next_free_name (p_base_name   in varchar2)
  return varchar2
  is
    l_counter            pls_integer := 0;
    l_hit_count          number;
  begin

    if p_base_name != l_last_subscripted_basename or l_last_subscripted_basename is null
    then
      l_subscript := 0;
      l_last_subscripted_basename := p_base_name;
    end if;

    while l_subscript < 501
    loop
      l_subscript := l_subscript + 1;
      l_constraint_name := p_base_name || l_subscript;
      select count(*)
        into l_hit_count
      from all_constraints c
      where c.constraint_name = l_constraint_name;
      if l_hit_count = 0
      then
        return l_constraint_name;
      end if;
    end loop;
    raise_application_error(-20001, 'Unable to resolve a constraint name from base name: ' || p_base_name);

  end next_free_name;

  -------------------------------------------------------------------------------
  --  The valid_constr_name, returns a boolean. Where the expected basename is  
  -- congruent with the actual constraint name (i.e. the first portion of the   
  -- actual constraint name begins with the basename and ends with a subscript),
  -- it returns TRUE, else it returns FALSE;                                   
  --
  -- The basename is pre-determined before calling, based on the contents of the 
  -- dev_table_abbreviations table and the relevant naming standards.
  -------------------------------------------------------------------------------
  function valid_constr_name ( p_base_name       in varchar2
                             , p_constraint_name in varchar2)
  return boolean
  is
    l_base             varchar2(100) := p_base_name;
    l_constr_name      varchar2(100) := p_constraint_name;
    l_end_str          varchar2(100);
  begin
   -- Remove the (expected, beginning string, from the name).
   l_end_str := replace(l_constr_name, l_base);
   -- Find out if the name of the constraint ends in only digits.
   if regexp_like(l_end_str, '^[[:digit:]]*$')
   then
     -- Name must be of valid form.
     return true;
   else
     -- Name must invalid form.
     return false;
   end if;
  end valid_constr_name;

begin
  dbms_output.put_line('set serverout on format wrapped');
  dbms_output.put_line('set feedback off head off pagesize 0');
  dbms_output.put_line('set linesize 250 trimspool on');
  delete from  xxx_constraints_cache
  where constraint_type != 'R';
  commit;
  -- Table Objects (non-FK)
  for t in (select table_name, table_abbreviation
              from dev_table_abbreviations 
             where table_name like upper('&&table_match')
             and   schema_name = c_schema_name)
  loop
    l_table_abbreviation := t.table_abbreviation;
    -- Primary key constraints
    for r in (select table_name, constraint_name
                from all_constraints c
                where c.constraint_type = 'P'
                and   c.owner           = c_schema_name
                and   c.table_name      = t.table_name )  
    loop
      l_expected_name      := l_table_abbreviation || '_PK';
      l_constraint_columns := constraint_columns ( p_constraint_name => r.constraint_name
                                                 , p_constraint_type => 'P' );

                                        -----------------------------------------
                                        -- Cache the constraint details.
                                        -- These need to be married up to the   
                                        -- indexes at a later stage, to ensure  
                                        -- that index names are consistent with 
                                        -- their constraint name counterpart.   
                                        -----------------------------------------
      cache_constraint ( p_table_name               => r.table_name
                       , p_current_constr_name      => r.constraint_name
                       , p_expected_constr_name     => l_expected_name
                       , p_constraint_type          => 'P'
                       , p_column_list              => l_constraint_columns );

      if r.constraint_name != l_expected_name
      then
         if not l_spooled
         then
           l_spooled := true;
           dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
           dbms_output.put_line('begin');
         end if;
         wrap('-- Fix non compliant PK constraint name: ' || r.constraint_name || ' -> ' || l_expected_name);
         wrap('declare');
         wrap('  no_such_constraint exception;');
         wrap('  pragma exception_init (no_such_constraint, -23292);');
         wrap('begin');
         wrap(q'[  execute immediate 'alter table ]' || t.table_name || q'[ rename constraint ]' || r.constraint_name || ' to ' || l_expected_name || q'[';]');
         wrap(q'[  dbms_output.put_line('alter table ]' || t.table_name || q'[ rename constraint ]' || r.constraint_name || ' to ' || l_expected_name || q'[');]');
         wrap('exception');
         wrap('  when no_such_constraint then');
         wrap(q'[    dbms_output.put_line('Table ]' || t.table_name || q'[, has previously renamed constraint, ]' || r.constraint_name || ' to ' || l_expected_name || q'[');]');
         wrap('    null;');
         wrap('end;');
         wrap('/');
       end if;
     end loop;

    for r in (select table_name, constraint_name
                from all_constraints c
                where c.constraint_type = 'U'
                and   c.owner           = c_schema_name
                and   c.table_name      = t.table_name )  
    loop
      l_base_name := l_table_abbreviation || '_UK';

      l_constraint_columns := constraint_columns ( p_constraint_name => r.constraint_name
                                                 , p_constraint_type => 'U' );
      if valid_constr_name(l_base_name, r.constraint_name)
      then 

        cache_constraint ( p_table_name               => r.table_name
                         , p_current_constr_name      => r.constraint_name
                         , p_expected_constr_name     => r.constraint_name
                         , p_constraint_type          => 'U'
                         , p_column_list              => l_constraint_columns );
        continue;
      else
         if not l_spooled
         then
           l_spooled := true;
           dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
           dbms_output.put_line('begin');
         end if;
                                        -----------------------------------------
                                        --  Get the next valid free name, taking
                                        -- account of name subscripting.        
                                        -----------------------------------------
         l_constraint_name := next_free_name(p_base_name => l_base_name);


                                        -----------------------------------------
                                        -- Cache the constraint details.
                                        -- These need to be married up to the   
                                        -- indexes at a later stage, to ensure  
                                        -- that index names are consistent with 
                                        -- their constraint name counterpart.   
                                        -----------------------------------------
         cache_constraint ( p_table_name               => r.table_name
                          , p_current_constr_name      => r.constraint_name
                          , p_expected_constr_name     => l_constraint_name
                          , p_constraint_type          => 'U'
                          , p_column_list              => l_constraint_columns );


         wrap('-- Fix non compliant UK constraint name: ' || r.constraint_name || ' -> ' || l_constraint_name);
         wrap('declare');
         wrap('  no_such_constraint exception;');
         wrap('  pragma exception_init (no_such_constraint, -23292);');
         wrap('begin');
         wrap(q'[  execute immediate 'alter table ]' || t.table_name || q'[ rename constraint ]' || r.constraint_name || ' to ' || l_constraint_name || q'[';]');
         wrap(q'[  dbms_output.put_line('alter table ]' || t.table_name || q'[ rename constraint ]' || r.constraint_name || ' to ' || l_constraint_name || q'[');]');
         wrap('exception');
         wrap('  when no_such_constraint then');
         wrap(q'[    dbms_output.put_line('Table ]' || t.table_name || q'[, has previously renamed constraint, ]' || r.constraint_name || ' to ' || l_constraint_name || q'[');]');
         wrap('    null;');
         wrap('end;');
         wrap('/');

      end if;
    end loop;

    for r in (select table_name, constraint_name
                from all_constraints c
                where c.constraint_type = 'C'
                and   c.owner           = c_schema_name
                and   c.table_name      = t.table_name
                and   c.search_condition_vc not like '%NOT NULL' )  
    loop
      l_base_name := l_table_abbreviation || '_CK';

      if valid_constr_name(l_base_name, r.constraint_name)
      then 
        continue;
      else
         if not l_spooled
         then
           l_spooled := true;
           dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
           dbms_output.put_line('begin');
         end if;

         l_constraint_name := next_free_name(p_base_name => l_base_name);
         wrap('-- Fix non compliant CK constraint name: ' || r.constraint_name || ' -> ' || l_constraint_name);
         wrap('declare');
         wrap('  no_such_constraint exception;');
         wrap('  pragma exception_init (no_such_constraint, -23292);');
         wrap('begin');
         wrap(q'[  execute immediate 'alter table ]' || t.table_name || q'[ rename constraint ]' || r.constraint_name || ' to ' || l_constraint_name || q'[';]');
         wrap(q'[  dbms_output.put_line('alter table ]' || t.table_name || q'[ rename constraint ]' || r.constraint_name || ' to ' || l_constraint_name || q'[');]');
         wrap('exception');
         wrap('  when no_such_constraint then');
         wrap(q'[    dbms_output.put_line('Table ]' || t.table_name || q'[, has previously renamed constraint, ]' || r.constraint_name || ' to ' || l_constraint_name || q'[');]');
         wrap('end;');
         wrap('/');

      end if;
     end loop;

     l_subscript := 0;
     if l_spooled
     then
       l_spooled := false;
       dbms_output.put_line('end;');
       dbms_output.put_line('/');
       dbms_output.put_line('spool off');
    end if;

  end loop; -- End TABLES MAIN loop
  commit;

end;
/
spool off
@non_fk_renames.sql
set feedback on
