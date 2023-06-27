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
--   The script will generate PL/SQL (which in turn generates Pl/SQL). 
--   Take the PL/SQL and launch SQLcl from the directory which contains 
--   the tables and foreign_keys directories. This will generate a script,
--   fk_renames.sql. When executed, this will augment (append to) the 
--   existing files, within the foreign_keys folder. 
--
--   If you wish to check the output before running the appends into 
--   you existing files, simply create a scratch directory containing
--   tables, and foreign_keys directories.
-- 
--   NOTE: The script takes account of existing constraints which
--         are standards compliant, ensuring that it doesn't generate
--         a name which clashes with existing names.
--
--
----------------------------------------------------------------------------
set serverout on size unlimited
set linesize 250
set trimspool on feedback off
whenever sqlerror exit failure
spool fk_renames.sql
declare

  c_schema_name          constant  varchar2(30)  := sys_context('userenv', 'current_schema');
  l_table_abbreviation             varchar2(30);
  l_r_table_abbreviation           varchar2(30); -- Referenced table (used for FKs section)
  l_expected_name                  varchar2(60);
  l_base_name                      varchar2(60);
  l_constraint_name                varchar2(60);
  l_constraint_columns             varchar2(200);
  l_spooled                        boolean        := false; 
  l_subscript                      pls_integer    := 0;
  l_last_subscripted_basename      varchar2(64)   := null;

  -------------------------------------------------------------------------------
  --  Based on the constraint name the constraint_columns function, returns the 
  -- number of columns associated. Where the constraint type is passed as 'C',  
  -- it returns an empty string.                                                
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

  end constraint_columns;

  -------------------------------------------------------------------------------
  --  The cache_constraint procedure is called for every constraint processed   
  -- (whether the current constraint is valid or not) and details are cached for
  -- later use, during index processing.                                        
  -------------------------------------------------------------------------------
  procedure cache_constraint ( p_table_name             in varchar2
                             , p_current_constr_name    in varchar2
                             , p_expected_constr_name   in varchar2
                             , p_constraint_type        in varchar2
                             , p_column_list            in varchar2 
                             , p_r_table_name           in varchar2 )
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
        , r_table_name
        )
      values
       ( p_table_name
       , p_current_constr_name
       , p_expected_constr_name
       , p_constraint_type
       , p_column_list
       , p_r_table_name
       );
       commit;
       -- dbms_output.put_line('-- [cache_constraint] Cache on: ' || p_table_name || ' - ' || p_current_constr_name || '/' || p_expected_constr_name);
    exception
      when dup_val_on_index then
        dbms_output.put_line('-- [cache_constraint] Duplicate on: ' || p_table_name || ' - ' || p_current_constr_name || '/' || p_expected_constr_name);
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
       and table_name  = p_table_name
       and schema_name = c_schema_name;

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

    while l_subscript < 101
    loop

      l_subscript := l_subscript + 1;
      l_constraint_name := p_base_name || l_subscript;

      select count(*)
        into l_hit_count
      from all_constraints c
      where c.constraint_name = l_constraint_name;

      if l_hit_count = 0
      then
                                        -----------------------------------------
                                        --  We may have previously cached the   
                                        -- subscripted basename - let's check.  
                                        -----------------------------------------
        select count(*)
          into l_hit_count
        from xxx_constraints_cache
       where expected_constraint_name = l_constraint_name;
      end if;

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
  --  dev_table_abbreviations table and the relevant naming standards.
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
  where constraint_type = 'R';
  commit;

 -- Foreign key constraints
  for t in (select table_name, table_abbreviation
              from dev_table_abbreviations 
             where table_name like upper('&&table_match')
             and   schema_name = c_schema_name
            order by table_name)
  loop -- FK MAIN loop

    for r in (select r.table_name, r.constraint_name, r.r_constraint_name, p.table_name as r_table_name
               from all_constraints    r
                  , all_constraints    p
               where r.constraint_type = 'R'
               and   p.constraint_name = r.r_constraint_name
               and   r.table_name      = t.table_name
               and   p.owner           = c_schema_name
               and   r.owner           = c_schema_name
             order by r.table_name, r.constraint_name )
    loop

      l_table_abbreviation := t.table_abbreviation;
      l_r_table_abbreviation := table_abbreviation(c_schema_name, r.r_table_name);
      l_base_name := l_table_abbreviation || '_' || l_r_table_abbreviation || '_FK';

                                        -----------------------------------------
                                        --  Here we store the columns of the    
                                        -- associated PK for later use when     
                                        -- looking at indexes.                  
                                        -----------------------------------------
      l_constraint_columns := constraint_columns ( p_constraint_name => r.constraint_name
                                                 , p_constraint_type => 'R' );

      if valid_constr_name( l_base_name, r.constraint_name )
      then 
        cache_constraint ( p_table_name               => r.table_name
                         , p_current_constr_name      => r.constraint_name
                         , p_expected_constr_name     => r.constraint_name
                         , p_constraint_type          => 'R'
                         , p_column_list              => l_constraint_columns 
                         , p_r_table_name             => r.r_table_name );
        continue;
      else
        if not l_spooled
        then
          l_spooled := true;
          dbms_output.put_line('spool foreign_keys/' || t.table_name || '.sql append');
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
                         , p_constraint_type          => 'R'
                         , p_column_list              => l_constraint_columns 
                         , p_r_table_name             => r.r_table_name );

        wrap('-- Fix non compliant FK constraint name: ' || r.constraint_name || ' -> ' || l_constraint_name);
        wrap('declare');
        wrap('  no_such_constraint exception;');
        wrap('  pragma exception_init (no_such_constraint, -23292);');
        wrap('begin');
        wrap(q'[  execute immediate 'alter table ]' || t.table_name || q'[ rename constraint ]' || r.constraint_name || ' to ' || l_constraint_name || q'[';]');
        wrap(q'[  dbms_output.put_line('alter table ]' || t.table_name || q'[ rename constraint ]' || r.constraint_name || ' to ' || l_constraint_name || q'[');]');
        wrap('exception');
        wrap('  when no_such_constraint then');
        wrap(q'[    dbms_output.put_line('Table: ]' || t.table_name || q'[, has previously renamed constraint, ]' || r.constraint_name || ' to ' || l_constraint_name || q'[');]');
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

  end loop; -- FK MAIN loop;
  commit;
end;
/
spool off
@fk_renames.sql
set feedback on
