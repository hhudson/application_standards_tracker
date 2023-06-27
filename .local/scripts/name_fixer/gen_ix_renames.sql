----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2022. All Rights Reserved.
--
-- Author: Clive Bostock
--
-- DESCRIPTION
--
--   This script must be run in SQL*Plus - not sqlcl.
--   The script also relies on xxx_constraints_cache 
--   table, having been populated via the sister, constraints
--   scripts (gen_non_fk_renames.sql and gen_fk_renames.sql).
--
--
--   Code generator; generates DDL fixes for indexes
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
--   NOTES: The script takes account of existing indexes which
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
spool ix_renames.sql
declare

  c_schema_name          constant  varchar2(30)   := sys_context('userenv', 'current_schema');
  l_table_abbreviation             varchar2(30);
  l_r_table_name                   varchar2(64); -- Referenced table (used by FKs section)
  l_r_table_abbreviation           varchar2(30); -- Referenced table abbreviation (used by FKs section)
  l_expected_name                  varchar2(60);
  l_base_name                      varchar2(60);
  l_index_name                     varchar2(60);
  l_constraint_name                varchar2(60);
  l_index_columns                  varchar2(200);
  l_index_category                 varchar2(1);
  l_spooled                        boolean        := false; 
  l_subscript                      pls_integer    := 0;

  l_last_subscripted_basename      varchar2(64)   := null;
  l_index_type                     varchar2(1);

  function associated_constraint ( p_constraint_type  in varchar2
                                 , p_table_name       in varchar2 
                                 , p_column_list      in varchar2 )
  return varchar2
  is
    l_constraint             varchar2(64);
  begin
    begin
      select expected_constraint_name 
        into l_constraint
       from xxx_constraints_cache
       where column_list     = p_column_list
         and table_name      = p_table_name
         and constraint_type = p_constraint_type;  
   exception
     when no_data_found then
       l_constraint := 'NOT_FOUND';
     when too_many_rows then
       dbms_output.put_line('[Too Many Rows] Error in associated_constraint; finding unique index type for p_column_list: ' || p_table_name || p_constraint_type || ' / ' || p_column_list );
       raise;
   end;

   return l_constraint;
    
  end associated_constraint;

  function unique_index_type ( p_column_list  in varchar2
                             , p_table_name   in varchar2 
                             , p_index_name   in varchar2 )
  return varchar2
  is
    l_constraint_type     varchar2(1);
  begin
    begin
      select constraint_type into l_constraint_type
        from xxx_constraints_cache
       where column_list = p_column_list
         and table_name  = p_table_name
         and constraint_type in ('P', 'U');

      return l_constraint_type;

    exception
   when no_data_found then
      -- Lower case 'u' indicates a unique index, without an associated constraint.
      RETURN 'u';
   when too_many_rows then
      dbms_output.put_line('[Too Many Rows] Error, in unique_index_type; finding unique index type for p_column_list: ' || p_table_name || ' / ' || p_index_name || ' / ' || p_column_list   );
      raise;
    end;
  end unique_index_type;

  -------------------------------------------------------------------------------
  --  The index_columns function, returns a colon separated list of columns, in 
  -- the same order that they are listed in the index creation.                 
  -------------------------------------------------------------------------------
  function index_columns ( p_index_name in varchar2 )
  return varchar2
  is
    l_column_list                  varchar2(500) := null;
  begin
    for r in (select column_name
                from all_ind_columns
               where table_owner = c_schema_name
                 and index_name  = p_index_name
                order by column_position asc)
    loop
      l_column_list := l_column_list || ':' || r.column_name;
    end loop;
    return l_column_list;   

  end index_columns;

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
  --  The nonunique_index_category function us a little more involved than the      
  -- seemingly similar functions before it. Here we need to establish the type  
  -- of index (BTREE, BITMAP or FUNCTION-BASED).  We also need to establish     
  -- whether the index can be associated with a foreign key constraint. We      
  -- return 'N', 'B', 'F' or 'R' respectively.                                  
  -------------------------------------------------------------------------------
  function nonunique_index_category ( p_table_name      in varchar2 
                                    , p_index_name      in varchar2 
                                    , p_index_type      in varchar2
                                    , p_index_columns   in varchar2 )
  return varchar2
  is
    l_associated_constraint  varchar2(64);
  begin
                                        -----------------------------------------
                                        --  Bitmap and Function based are a     
                                        -- quick win.                           
                                        -----------------------------------------
    if p_index_type = 'BITMAP'
    then
       return 'B';
    elsif p_index_type like 'FUNCTION%'
    then 
       return 'F';  
    end if;

    l_associated_constraint := associated_constraint ( p_constraint_type  => 'R'
                                                     , p_table_name       => p_table_name
                                                     , p_column_list      => p_index_columns );
    if l_associated_constraint != 'NOT_FOUND'
    then
      return 'R';
    end if;
                                        -----------------------------------------
                                        --  If we reach this point, we assume we
                                        -- have a normal index, not associated  
                                        -- with a foreign key constraint;.      
                                        -----------------------------------------
    return 'N';

  end nonunique_index_category;

  -------------------------------------------------------------------------------
  --  The table_abbreviation function returns the table_abbreviation as defined 
  -- in the dev_table_abbreviations table.                                             
  -------------------------------------------------------------------------------
  function table_abbreviation ( p_table_name in varchar2 )
  return varchar2  
  is
    l_table_abbreviation     varchar2(15);
  begin
    select table_abbreviation
       into l_table_abbreviation
      from dev_table_abbreviations
     where schema_name = c_schema_name
       and table_name  = p_table_name;
     return l_table_abbreviation;
  exception
    when no_data_found
    then
      wrap('ERROR [table_abbreviation]: could not rerieve table abbreviation for: ' ||  p_table_name);
      return 'UNKOWN';
  end table_abbreviation;

  -------------------------------------------------------------------------------
  --  The next_free_name function works from a basename of an index, and adds a
  -- subscript. It iterates until it finds an unused object and then returns the     
  -- generated name. This is used for indexes, whose names are not based on
  -- constraint names.
  -------------------------------------------------------------------------------
  function next_free_name (p_base_name   in varchar2)
  return varchar2
  is
    l_counter            pls_integer := 0;
    l_hit_count          number;
    l_index_name         varchar2(60);
  begin
    if p_base_name != l_last_subscripted_basename or l_last_subscripted_basename is null
    then
      l_subscript := 0;
      l_last_subscripted_basename := p_base_name;
    end if;

    while l_subscript < 501
    loop
      l_subscript := l_subscript + 1;
      l_index_name := p_base_name || l_subscript;

      select count(*)
        into l_hit_count
      from all_indexes i
      where i.index_name = l_index_name;

      if l_hit_count = 0
      then
        return l_index_name;
      end if;
    end loop;

    raise_application_error(-20001, 'Unable to resolve a index name from base name: ' || p_base_name);
  end next_free_name;


  -------------------------------------------------------------------------------
  --  The next_free_ronin_name function works from a basename of an object, and 
  -- adds a subscript followed by '_IX'. It iterates until it finds an unused
  -- object and then returns the generated name.                                                            
  -------------------------------------------------------------------------------
  function next_free_ronin_name (p_base_name   in varchar2)
  return varchar2
  is
    l_counter            pls_integer := 0;
    l_hit_count          number;
    l_index_name         varchar2(60);
  begin

    if p_base_name != l_last_subscripted_basename or l_last_subscripted_basename is null
    then
      l_subscript := 0;
      l_last_subscripted_basename := p_base_name;
    end if;
    
    while l_subscript < 101
    loop
      l_subscript  := l_subscript + 1;
      l_index_name := p_base_name || l_subscript || '_IDX';
      select count(*)
        into l_hit_count
      from all_indexes i
      where i.index_name = l_index_name;
      if l_hit_count = 0
      then
        return l_index_name;
      end if;
    end loop;

    raise_application_error(-20001, 'Unable to resolve a index name from base name: ' || p_base_name);

  end next_free_ronin_name;


  -------------------------------------------------------------------------------
  --  The valid_index_name, returns a boolean. Where the expected basename is  
  -- congruent with the actual index name (i.e. the first portion of the   
  -- actual index name begins with the basename and ends with a subscript),
  -- it returns TRUE, else it returns FALSE;                                   
  --
  -- The basename is pre-determined before calling, based on the contents of the 
  --  dev_table_abbreviations table and the relevant naming standards.
  --
  -- This function should only be used for indexes of the follow index 
  -- categories:
  --
  --  *  Non-unique btree indexes
  --  *  Bitmap indexes
  --  *  Function based indexes
  -- 
  --  PK and UK index names are based on constraint names, which have already 
  --  applied a subscript, and so should not be used with this function.
  -- 
  -------------------------------------------------------------------------------
  function valid_index_name ( p_base_name       in varchar2
                            , p_index_name      in varchar2 )
  return boolean
  is
    l_base             varchar2(100) := p_base_name;
    l_index_name       varchar2(100) := p_index_name;
    l_end_str          varchar2(100);
  begin
   -- Remove the (expected, beginning string, from the name).
   l_end_str := replace(l_index_name, l_base);
   -- Find out if the name of the constraint ends in only digits.
   if regexp_like(l_end_str, '^[[:digit:]]*$')
   then
     -- Name must be of valid form.
     return true;
   else
     -- Name must invalid form.
     return false;
   end if;
  end valid_index_name;

begin
  dbms_output.put_line('set serverout on format wrapped');
  dbms_output.put_line('set feedback off head off pagesize 0');
  dbms_output.put_line('set linesize 250 trimspool on');
  l_subscript := 0;
  -- Table Objects (non-FK)
  for t in ( select table_name, table_abbreviation
               from dev_table_abbreviations 
              where table_name like upper('&&table_match')
              and   schema_name = c_schema_name )
  loop -- MAIN loop
    l_table_abbreviation := t.table_abbreviation;
    -- Unique/Primary key indexes
    for r in (select table_name, index_name
                from all_indexes i
                where i.uniqueness      = 'UNIQUE'
                and   i.owner           = c_schema_name
                and   i.table_name      = t.table_name
                order by i.index_name )  
    loop
      l_index_columns  := index_columns(p_index_name => r.index_name);

                                        -----------------------------------------
                                        --  First check to see if we are dealing
                                        -- with a PK.                           
                                        -----------------------------------------
      l_index_type := unique_index_type ( p_column_list   => l_index_columns
                                        , p_table_name    => r.table_name
                                        , p_index_name    => r.index_name );

      if l_index_type != 'P'
      then
        continue;
      end if;

      l_constraint_name := associated_constraint( p_constraint_type => 'P' 
                                                , p_table_name      => r.table_name
                                                , p_column_list     => l_index_columns );

      l_expected_name := l_constraint_name || '_IDX';

      if r.index_name != l_expected_name
      then
        if not l_spooled
        then
          l_spooled := true;
          dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
          dbms_output.put_line('begin');
        end if;

        wrap('-- Fix non compliant PK index name on table ' || t.table_name   || ': ' || r.index_name || ' -> ' || l_expected_name);
        wrap('declare');
        wrap('  no_such_index exception;');
        wrap('  pragma exception_init (no_such_index, -01418);');
        wrap('begin');
        wrap(q'[  execute immediate 'alter index ]' ||  r.index_name || q'[ rename to ]' || l_expected_name || q'[';]');
        wrap(q'[  dbms_output.put_line('Table: ]' || t.table_name || q'[: alter index ]' || r.index_name || q'[ rename to ]' || l_expected_name || q'[');]');
        wrap('exception');
        wrap('  when no_such_index then');
        wrap(q'[    dbms_output.put_line('Table: ]' || t.table_name || q'[: index ]' || r.index_name || q'[ already renamed to ]' || l_expected_name || q'[');]');
        wrap('    null;');
        wrap('end;');
        wrap('/');

      end if;
    end loop; -- PK loop

    for r in (select table_name, index_name
                from all_indexes i
                where i.uniqueness      = 'UNIQUE'
                  and i.owner           = c_schema_name
                  and i.table_name      = t.table_name )  
    loop  -- UK loop
      l_index_columns   := index_columns(p_index_name => r.index_name);

                                        -----------------------------------------
                                        --  First check to see if we are dealing
                                        -- with a UK.                           
                                        -----------------------------------------
      l_index_type := unique_index_type ( p_column_list   => l_index_columns
                                        , p_table_name    => r.table_name
                                        , p_index_name    => r.index_name );

      if l_index_type != 'U'
      then
        continue;
      end if;

      l_constraint_name := associated_constraint( p_constraint_type => 'U' 
                                                , p_table_name      => r.table_name
                                                , p_column_list     => l_index_columns );

      l_expected_name := l_constraint_name || '_IDX';
      -- Check to see whether index name is already valid.
      if l_expected_name = r.index_name
      then 
        continue;
      else
        if not l_spooled
        then
          l_spooled := true;
          dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
          dbms_output.put_line('begin');
        end if;
        
        wrap('-- Fix non compliant UK index name on table ' || t.table_name   || ': ' || r.index_name || ' -> ' || l_expected_name);
        wrap('declare');
        wrap('  no_such_index exception;');
        wrap('  pragma exception_init (no_such_index, -01418);');
        wrap('begin');
        wrap(q'[  execute immediate 'alter index ]' ||  r.index_name || q'[ rename to ]' || l_expected_name || q'[';]');
        wrap(q'[  dbms_output.put_line('alter index ]' || r.index_name || q'[ rename to ]' || l_expected_name || q'[');]');
        wrap('exception');
        wrap('  when no_such_index then');
        wrap(q'[    dbms_output.put_line('Table: ]' || t.table_name || q'[: index ]' || r.index_name || q'[ already renamed to ]' || l_expected_name || q'[');]');
        wrap('    null;');
        wrap('end;');
        wrap('/');
      end if;

    end loop; 

    -- Now let's deal with unique indexes which have no associated constraint (ronins).
    for r in (select table_name, index_name
               from all_indexes i
               where i.uniqueness      = 'UNIQUE'
                 and i.owner           = c_schema_name
                 and i.table_name      = t.table_name
               order by i.index_name )  
    loop  -- Ronin loop
      l_index_columns := index_columns(p_index_name => r.index_name);

                                        -----------------------------------------
                                        --  First check to see if we are dealing
                                        -- with a rogue UK key.                 
                                        -----------------------------------------
      l_index_type := unique_index_type ( p_column_list   => l_index_columns
                                        , p_table_name    => r.table_name
                                        , p_index_name    => r.index_name );

      if l_index_type != 'u'
      then
        continue;
      end if;

      -- For these "ronin" indexes, we deviate from standards (they are an aberation).
      -- Here we use an "<table_abbreviation>_UN" to form a basename.
      -- These then become "<table_abbreviation>_UN1_IDX", "<table_abbreviation>_UN2_IDX" etc
      l_base_name := t.table_abbreviation || '_UN';
      -- Check to see whether index name is already valid.
      l_index_name := next_free_ronin_name( p_base_name => l_base_name );

      if not l_spooled
      then
        l_spooled := true;
        dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
        dbms_output.put_line('begin');
      end if;
 
      wrap('-- Fix non compliant unique (ronin) index name on table ' || t.table_name   || ': ' || r.index_name || ' -> ' || l_index_name);
      wrap('declare');
      wrap('  no_such_index exception;');
      wrap('  pragma exception_init (no_such_index, -01418);');
      wrap('begin');
      wrap(q'[  execute immediate 'alter index ]' ||  r.index_name || q'[ rename to ]' || l_index_name || q'[';]');
      wrap(q'[  dbms_output.put_line('alter index ]' || r.index_name || q'[ rename to ]' || l_index_name || q'[');]');
      wrap('exception');
      wrap('  when no_such_index then');
      wrap(q'[    dbms_output.put_line('Table: ]' || t.table_name || q'[; index ]' || r.index_name || q'[ already renamed to ]' || l_index_name || q'[');]');
      wrap('    null;');
      wrap('end;');
      wrap('/');
    end loop; -- Ronin loop


    for r in (select table_name, index_name, index_type
                from all_indexes i
                where i.uniqueness      = 'NONUNIQUE'
                  and i.owner           = c_schema_name
                  and i.table_name      = t.table_name
                order by i.index_name )  
    loop  -- FK associated indexes loop
      l_index_columns   := index_columns(p_index_name => r.index_name);

                                        -----------------------------------------
                                        --  Check to see if the index can be    
                                        -- associated with a foreign key...     
                                        -----------------------------------------
      l_index_category := nonunique_index_category ( p_table_name      => r.table_name
                                                   , p_index_name      => r.index_name
                                                   , p_index_type      => r.index_type
                                                   , p_index_columns   => l_index_columns );

      if l_index_category != 'R'
      then
        continue;
      end if;

      l_constraint_name := associated_constraint( p_constraint_type => 'R' 
                                                , p_table_name      => r.table_name
                                                , p_column_list     => l_index_columns );

      l_index_name := l_constraint_name || '_IDX';
      -- Check to see whether index name is already valid.
      if  l_index_name = r.index_name 
      then
        continue;
      end if;

      if not l_spooled
      then
        l_spooled := true;
        dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
        dbms_output.put_line('begin');
      end if;
 
      wrap('-- Fix non compliant (FK associated) index name on table ' || t.table_name   || ': ' || r.index_name || ' -> ' || l_index_name);
      wrap('declare');
      wrap('  no_such_index exception;');
      wrap('  pragma exception_init (no_such_index, -01418);');
      wrap('begin');
      wrap(q'[  execute immediate 'alter index ]' ||  r.index_name || q'[ rename to ]' || l_index_name || q'[';]');
      wrap(q'[  dbms_output.put_line('alter index ]' || r.index_name || q'[ rename to ]' || l_index_name || q'[');]');
      wrap('exception');
      wrap('  when no_such_index then');
      wrap(q'[    dbms_output.put_line('Table: ]' || t.table_name || q'[; index ]' || r.index_name || q'[ already renamed to ]' || l_index_name || q'[');]');
      wrap('    null;');
      wrap('end;');
      wrap('/');

    end loop; -- FK associated indexes loop

    -- Now deal with Btree indexes 
    for r in (select table_name, index_name, index_type
               from all_indexes i
               where i.owner           = c_schema_name
                 and i.index_type      = 'NORMAL'
                 and i.uniqueness      = 'NONUNIQUE'
                 and i.table_name      = t.table_name )  
    loop  --Bitmap index loop

      l_index_category := nonunique_index_category ( p_table_name      => r.table_name
                                                   , p_index_name      => r.index_name
                                                   , p_index_type      => r.index_type
                                                   , p_index_columns   => l_index_columns );

      if l_index_category != 'N'
      then
        continue;
      end if;

      l_base_name := t.table_abbreviation || '_IDX';
      -- Check to see whether index name is already valid.
      if valid_index_name ( l_base_name, r.index_name )
      then
        continue;
      end if;

      l_index_name := next_free_name( p_base_name => l_base_name );

      if not l_spooled
      then
        l_spooled := true;
        dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
        dbms_output.put_line('begin');
      end if;
 
      wrap('-- Fix non compliant btree index name on table ' || t.table_name   || ': ' || r.index_name || ' -> ' || l_index_name);
      wrap('declare');
      wrap('  no_such_index exception;');
      wrap('  pragma exception_init (no_such_index, -01418);');
      wrap('begin');
      wrap(q'[  execute immediate 'alter index ]' ||  r.index_name || q'[ rename to ]' || l_index_name || q'[';]');
      wrap(q'[  dbms_output.put_line('alter index ]' || r.index_name || q'[ rename to ]' || l_index_name || q'[');]');
      wrap('exception');
      wrap('  when no_such_index then');
      wrap(q'[    dbms_output.put_line('Table: ]' || t.table_name || q'[; index ]' || r.index_name || q'[ already renamed to ]' || l_index_name || q'[');]');
      wrap('    null;');
      wrap('end;');
      wrap('/');

    end loop; -- Btree index loop

    -- Now deal with Bitmap indexes 
    for r in (select table_name, index_name, index_type
               from all_indexes i
               where i.owner           = c_schema_name
                 and i.index_type      = 'BITMAP'
                 and i.table_name      = t.table_name )  
    loop  --Bitmap index loop
      dbms_output.put_line('-- DBG: Processing index ' || r.index_type || ', ' || r.index_name); 

      l_base_name := t.table_abbreviation || '_BIDX';
      -- Check to see whether index name is already valid.
      if valid_index_name ( l_base_name, r.index_name )
      then
        continue;
      end if;

      l_index_name := next_free_name( p_base_name => l_base_name );

      if not l_spooled
      then
        l_spooled := true;
        dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
        dbms_output.put_line('begin');
      end if;
 
      wrap('-- Fix non compliant bitmap index name on table ' || t.table_name   || ': ' || r.index_name || ' -> ' || l_index_name);
      wrap('declare');
      wrap('  no_such_index exception;');
      wrap('  pragma exception_init (no_such_index, -01418);');
      wrap('begin');
      wrap(q'[  dbms_output.put_line('alter index ]' || r.index_name || q'[ rename to ]' || l_index_name || q'[');]');
      wrap(q'[  execute immediate 'alter index ]' ||  r.index_name || q'[ rename to ]' || l_index_name || q'[';]');
      wrap('exception');
      wrap('  when no_such_index then');
      wrap('    null;');
      wrap('end;');
      wrap('/');

    end loop; -- Bitmap index loop


    -- Now deal with Function based indexes 
    for r in (select table_name, index_name, index_type
               from all_indexes i
               where i.owner           = c_schema_name
                 and i.index_type      like 'FUNCTION%'
                 and i.table_name      = t.table_name )  
    loop  --Bitmap index loop

      l_base_name := t.table_abbreviation || '_FIDX';
      -- Check to see whether index name is already valid.
      if valid_index_name ( l_base_name, r.index_name )
      then
        continue;
      end if;

      l_index_name := next_free_name( p_base_name => l_base_name );

      if not l_spooled
      then
        l_spooled := true;
        dbms_output.put_line('spool tables/' || t.table_name || '.sql append');
        dbms_output.put_line('begin');
      end if;
 
      wrap('-- Fix non compliant function based index name on table ' || t.table_name   || ': ' || r.index_name || ' -> ' || l_index_name);
      wrap('declare');
      wrap('  no_such_index exception;');
      wrap('  pragma exception_init (no_such_index, -01418);');
      wrap('begin');
      wrap(q'[  dbms_output.put_line('alter index ]' || r.index_name || q'[ rename to ]' || l_index_name || q'[');]');
      wrap(q'[  execute immediate 'alter index ]' ||  r.index_name || q'[ rename to ]' || l_index_name || q'[';]');
      wrap('exception');
      wrap('  when no_such_index then');
      wrap('    null;');
      wrap('end;');
      wrap('/');

    end loop; -- Function based index loop


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
@ix_renames.sql
set feedback on
