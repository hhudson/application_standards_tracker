create or replace PACKAGE BODY dev_support_utils AS
  -------------------------------------------------------------------------------
  -- Copyright (c) Oracle Corporation 2021. All Rights Reserved.
  --
  -- NAME
  --
  -- dev_support_utils
  --
  -- DESCRIPTION
  --
  -- This package provides routines for development support.
  --
  --
  -- RUNTIME DEPLOYMENT: No
  --
  -- MODIFIED (MM/DD/YYYY)
  --
  -- c. bostock 30/01/2021 - Created
  -------------------------------------------------------------------------------

  -------------------------------------------------------------------------------
  -- Exceptions
  -------------------------------------------------------------------------------

  -------------------------------------------------------------------------------
  --  Global Constants                                                     
  -------------------------------------------------------------------------------
  gc_scope_prefix     constant varchar2(32)      := lower($$plsql_unit) || '.';
  TS_FORMAT           constant varchar2(35)      := 'YYYY-MM-DD"T"hh24:mi:ss';
  TSTZ_FORMAT         constant varchar2(35)      := 'YYYY-MM-DD"T"hh24:mi:sstzh:tzm';
  DATE_FORMAT         constant varchar2(35)      := 'YYYY-MM-DD"T"hh24:mi:ss';
  MAX_STRING_LENGTH   constant number            := 32767;


  -------------------------------------------------------------------------------
  -- INTERNAL FUNCTION/PROCEDURE PROTOTYPES                                
  -------------------------------------------------------------------------------

  procedure process_error (message_text     in varchar2);

  -------------------------------------------------------------------------------
  -- PROCEDURES / FUNCTIONS                                                  
  -------------------------------------------------------------------------------
  function generate_add_tab_col_script(p_table_name varchar2
                                      ,p_column_name varchar2 default null) return clob is
  l_clob clob;
  begin
    for c1 in (select * 
               from user_tab_cols
               where table_name = upper(p_table_name)
               and column_name = nvl(upper(p_column_name),column_name)
               and virtual_column = 'NO'
               order by column_id
              )
    loop
       l_clob:= l_clob||chr(10)||
                'declare'||chr(10)|| 
                 'already_exists EXCEPTION;'||chr(10)|| 
                  'pragma exception_init (already_exists, -01430);'||chr(10)|| 
       'begin'||chr(10);
       l_clob:=l_clob||' execute immediate q''[ALTER TABLE '||c1.table_name||' ADD ('||c1.column_name||' ';
       l_clob:=l_clob||c1.data_type||case when c1.data_type in ('NUMBER','VARCHAR2') then '('||c1.data_length ||case when c1.data_scale is not null then ','||c1.data_scale else null end ||')' else null end; 
       l_clob:=l_clob ||case c1.nullable when 'N' then ' NOT NULL ENABLE' else null end;
       l_clob:=l_clob||')]'''||';'||chr(10)||
       'dbms_output.put_line(q''[ table '||c1.table_name||' column '||c1.column_name||' added ]'');'||chr(10)||
       'exception'||chr(10)||'  when already_exists then null;'||chr(10);       
       l_clob:= l_clob||'end;'||chr(10)||'/';
    end loop; 
    return l_clob;
  end generate_add_tab_col_script;  


  function generate_table_constraint_script( p_table_name varchar2 ) 
  return clob 
  is
    l_constraints clob;
    l_clob clob;
  begin
     for c_sys in (select uc.constraint_name --, uc.search_condition, uc.constraint_type, ucc.column_name, pk_c.column_name
                   from  user_constraints uc
                    inner join user_cons_columns ucc on uc.constraint_name = ucc.constraint_name
                    left join (select uc.table_name, ucc.column_name
                                   from  user_constraints uc
                                   inner join useR_CONS_COLUMNS ucc on uc.constraint_name = ucc.constraint_name
                                  where uc.constraint_type = 'P') pk_c on  pk_c.table_name = uc.table_name
                                                                       and pk_c.column_name = ucc.column_name 
                  where uc.table_name = upper(p_table_name)
                    and uc.constraint_type != 'R'
                    and uc.constraint_name like 'SYS%'
                    and pk_c.column_name is null
                    order by 1)
     loop 
      SELECT DBMS_METADATA.GET_DDL('CONSTRAINT',c_sys.constraint_name)
       into l_constraints
       FROM dual;

       l_clob:=l_clob||chr(10)||
               l_constraints||chr(10)||'/'||chr(10);
     end loop;

     for c1 in (
                 select uc.constraint_name, uc.search_condition --, ucc.column_name
                   from  user_constraints uc
                  where uc.table_name = upper(p_table_name)
                    and uc.constraint_type != 'R'
                    and uc.constraint_name not like 'SYS%'
                    order by 1
                )
     loop
       SELECT DBMS_METADATA.GET_DDL('CONSTRAINT',c1.constraint_name)
       into l_constraints
       FROM dual;

       l_clob:=l_clob||chr(10)||
               apex_string.format(q'[--precondition-sql-check expectedResult:0 select count(*) from user_constraints where upper(constraint_name)  = '%s']', 
               c1.constraint_name)||chr(10)||
               l_constraints||chr(10)||'/'||chr(10);
     end loop;
     return l_clob;
  end generate_table_constraint_script;

  function generate_table_index_script(p_table_name varchar2) return clob is
  l_indexes clob;
  l_clob clob;
  begin
     for c1 in (select index_name 
                from   user_indexes
                where table_name = upper(p_table_name)
                and constraint_index = 'NO'
                and index_name not like 'SYS_%'
                )
     loop
       SELECT DBMS_METADATA.GET_DDL('INDEX',c1.index_name)
       into l_indexes
       FROM dual;

       l_clob:=l_clob||l_indexes||chr(10)||'/'||chr(10);
     end loop;
     return l_clob;
  end generate_table_index_script;

  function generate_table_script( p_table_name varchar2
                                , p_include_add_cols varchar2 default 'N'
                                , p_remove_quotes varchar2 default 'N'
                                , p_remove_nls    varchar2 default 'N'
                                , p_author        varchar2 default null
                                ) 
  return clob 
  is
    c_scope constant varchar2(128) := gc_scope_prefix || 'generate_table_script';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    c_table_name      constant varchar2(100) := upper(p_table_name);
    c_liquibase_start constant varchar2(500) := apex_string.format(
      p_message => q'[--liquibase formatted sql
--changeset table_script:%0 stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('%0');
]',
     p0 => c_table_name
    );
    c_liquibase_end constant varchar(200)      := apex_string.format(
      p_message => '--rollback drop table %0;',
      p0 => c_table_name
    );
    l_table_clob   clob;
    l_constraints  clob;
    l_indexes      clob;
    l_cols         clob;
    l_author       varchar2(60)       := coalesce(p_author,v('APP_USER'), user);
    l_banner       varchar2(2000);
    l_divider      varchar2(100)       := lpad('-',80, '-') || chr(10);
    l_table_script varchar2(32000);


  begin
     apex_debug.message(c_debug_template,'START', 
                                         'p_table_name', p_table_name,
                                         'p_include_add_cols', p_include_add_cols,
                                         'p_remove_quotes', p_remove_quotes,
                                         'p_remove_nls', p_remove_nls,
                                         'p_author',p_author
                        );

     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
     dbms_metadata.set_transform_param(DBMS_METADATA.session_transform,'CONSTRAINTS', false);
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'REF_CONSTRAINTS',false);
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'EMIT_SCHEMA',false);
     dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', false); 
     dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);

     SELECT DBMS_METADATA.GET_DDL('TABLE',c_table_name)
     into l_table_clob
     FROM dual;

-- fix as no way to get rid of flashback


     l_table_clob:= replace(l_table_clob,'ALTER TABLE "'||c_table_name||'" FLASHBACK ARCHIVE "COVID_2YEAR"');

     l_indexes:= generate_table_index_script(p_table_name=>c_table_name);
     l_constraints:= generate_table_constraint_script(p_table_name=>c_table_name);

     l_banner := l_divider  || '--' || chr(10) 
                              || '--      Author:  ' || l_author || chr(10)
                              || '-- Script name:  ' || c_table_name || '.sql' || chr(10)
                              || '--        Date:  ' || to_char(sysdate, 'DD-Mon-YYYY HH24:MI') || chr(10)
                              || '--     Purpose:  ' || 'Table creation DDL for table ' 
                                                     || c_table_name || chr(10) 
                                                     || '--               and related objects.' || chr(10)
                              || '--' || chr(10) 
                              || l_divider;

     if p_include_add_cols = 'Y'
     then
        l_cols:= generate_add_tab_col_script(p_table_name=>c_table_name);
     end if; 
     l_table_script :=   c_liquibase_start
                      || l_banner 
                      || chr(10) 
                      || l_table_clob
                      || chr(10) ||'/'|| chr(10)
                      || l_indexes || chr(10) || chr(10) 
                      || l_constraints || chr(10) || chr(10) 
                      || l_cols
                      || c_liquibase_end;

    l_table_script := case when p_remove_nls = 'Y'
                           then replace(
                                replace(l_table_script,
                                ' COLLATE "USING_NLS_COMP"'),
                                '  DEFAULT COLLATION "USING_NLS_COMP"')
                           else l_table_script
                           end;

    l_table_script := case when p_remove_quotes = 'Y'
                           then replace(l_table_script,'"','')
                           else l_table_script
                           end;


    return l_table_script;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_table_script;

  function generate_table_fk_script( p_table_name varchar2 
                                   , p_author     varchar2 default null) 
  return clob 
  is
    c_scope constant varchar2(128) := gc_scope_prefix || 'generate_table_fk_script';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_table_name      constant varchar2(100) := upper(p_table_name);
    c_liquibase_start constant varchar2(500) := apex_string.format(
      p_message => q'[--liquibase formatted sql
--changeset fk_script:%0 stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('%0');
]',
     p0 => c_table_name
    );
    l_liquibase_fk_precondition varchar2(500) := q'[--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = '%0';]';
    l_constraints clob;
    l_clob clob;
    l_author                varchar2(60)       := coalesce(p_author,v('APP_USER'), user);
    l_banner              varchar2(2000);
    l_divider               varchar2(100)      := lpad('-',80, '-') || chr(10);
    l_script                clob               := null;
    c_trailing_slash     constant varchar2(5) := '/';
  begin
     apex_debug.message(c_debug_template,'START', 
                                         'p_table_name', p_table_name,
                                         'p_author', p_author);

     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
     dbms_metadata.set_transform_param(dbms_metadata.session_transform,'EMIT_SCHEMA',false);
     dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', false); 

     l_banner := l_divider  || '--' || chr(10) 
                              || '--      Author:  ' || l_author || chr(10)
                              || '-- Script name:  ' || c_table_name || '.sql' || chr(10)
                              || '--        Date:  ' || to_char(sysdate, 'DD-Mon-YYYY HH24:MI') || chr(10)
                              || '--     Purpose:  ' || 'Foreign key creation DDL for table ' 
                                                     || c_table_name || chr(10) 
                                                     || '--               and related objects.' || chr(10)
                              || '--' || chr(10) 
                              || l_divider;

     for c1 in (select upper(constraint_name) constraint_name
                from   user_constraints
                where table_name = c_table_name
                AND CONSTRAINT_TYPE = 'R'
                )
     loop

       SELECT DBMS_METADATA.GET_DDL('REF_CONSTRAINT',c1.constraint_name)
       into l_constraints
       FROM dual;

       l_clob:=l_clob
              ||apex_string.format(l_liquibase_fk_precondition,c1.constraint_name)
              ||chr(10)
              ||replace(l_constraints,'"')
              ||chr(10)
              ||c_trailing_slash
              ||chr(10);
     end loop;
     return c_liquibase_start || l_banner || chr(10) || l_clob;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_table_fk_script;

  function generate_biu_trigger_script( p_table_name   varchar2
                                      , p_sqlplus_mode varchar2 := 'Y'
                                      , p_author       varchar2 default null ) 
  return clob
  is
    c_scope constant varchar2(128) := gc_scope_prefix || 'generate_biu_trigger_script';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    c_table_name           constant user_tables.table_name%TYPE := replace(upper(p_table_name), '_BIU');
    c_liquibase_start constant varchar2(500) := apex_string.format(
      p_message => q'[--liquibase formatted sql
--changeset trigger_script:%0_BIU stripComments:false 
]',
     p0 => c_table_name
    );
    l_author               varchar2(60)       := coalesce(p_author,v('APP_USER'), user);
    l_banner               varchar2(2000);
    l_divider              varchar2(100)       := lpad('-',80, '-') || chr(10);
    l_script               clob;
    l_trigger_name         user_tables.table_name%TYPE             := c_table_name || '_BIU';
    l_steps                number                                  := 0;
    l_pk_code_snippet      varchar2(4000);
    l_sqlplus_mode         varchar2(1)        := upper(p_sqlplus_mode);

    function column_exists ( p_table_name  in varchar2
                           , p_column_name in varchar2 )
    return boolean
    is
      l_count                number := 0;
      l_table_name           user_tables.table_name%TYPE           := upper(p_table_name);
      l_column_name          user_tab_columns.column_name%type     := upper(p_column_name);
      l_script               clob;
    begin
      l_count := 0;
      select count(*) into l_count
        from user_tab_columns
       where table_name  = l_table_name
         and column_name = l_column_name; 

      if l_count > 0
      then
        return true;
      else
        return false;
      end if;

    end column_exists;

    function pk_code_snippet
    return varchar2
    is
      l_surrogate_key_col    user_tab_columns.column_name%type     := null;
      l_surr_key_data_type   user_tab_columns.column_name%type     := null;
      l_data_default         user_tab_columns.data_default%type    := null;
      l_script               clob;
      l_count                number                                := 0;
    begin

                                  ------------------------------------ 
                                  -- We need to ensure our table has   
                                  -- a single column primary key, so   
                                  -- we count them.                    
                                  ------------------------------------ 
      select count(*)
        into l_count
        from user_constraints   uc
           , user_indexes       ui
           , user_ind_columns   ic
           , user_cons_columns  cc
       where uc.constraint_type = 'P'
         and uc.index_name      = ui.index_name
         and ic.index_name      = ui.index_name
         and ic.table_name      = uc.table_name
         and uc.table_name      = ui.table_name
         and cc.column_name     = ic.column_name
         and cc.constraint_name = uc.constraint_name
         and uc.table_name      = c_table_name;

      if l_count = 1
      then
        select ic.column_name
             , tc.data_type
             , tc.data_default
          into l_surrogate_key_col
             , l_surr_key_data_type
             , l_data_default
          from user_constraints   uc
             , user_indexes       ui
             , user_ind_columns   ic
             , user_tab_columns   tc
             , user_cons_columns  cc
         where uc.constraint_type = 'P'
           and uc.index_name      = ui.index_name
           and ic.index_name      = ui.index_name
           and ic.table_name      = uc.table_name
           and uc.table_name      = ui.table_name
           and tc.table_name      = ui.table_name
           and tc.column_name     = ic.column_name
           and cc.column_name     = ic.column_name
           and cc.constraint_name = uc.constraint_name
           and uc.table_name      = c_table_name;
      else
        return l_divider || '--  INFORMATION: The table ' || c_table_name || ' has no' || chr(10)
                         || '--               single column surrogate (primary) key to auto-populate.' || chr(10)
                         || l_divider;
      end if;

      if l_surr_key_data_type != 'NUMBER'
      then
        return l_divider || '--  INFORMATION: The table ' || c_table_name || ' has ' || chr(10)
                         || '--               no numeric surrogate (primary) key to auto-populate.' || chr(10)
                         || l_divider;
      elsif instr(upper(l_data_default), 'NEXTVAL') > 0
      then
        return l_divider || '--  INFORMATION: The table ' || c_table_name || ' appears to' || chr(10)
                         || '                 have an identity column surrogate key.' || chr(10)
                         || l_divider;
      end if; 

      l_script := '  if :new.' || l_surrogate_key_col || ' is null' || chr(10)
                               || '  then ' || chr(10)
                               || '    :new.' || l_surrogate_key_col 
                               || ' :=  to_number(sys_guid(), ''XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'');' || chr(10)
                               || '  end if;' || chr(10);
      return l_script;

    end pk_code_snippet;

    function trigger_already_exists_yn return varchar2
    is 
    l_trigger_exists_yn varchar2(1) := 'N';
    begin

      select case when count(*) = 1
                        then 'Y'
                        else 'N'
                        end into l_trigger_exists_yn
                from sys.dual where exists (
                    select * 
                    from user_triggers
                    where trigger_name = l_trigger_name
                );

      apex_debug.message(c_debug_template, 'l_trigger_exists_yn', l_trigger_exists_yn);
      return l_trigger_exists_yn;

    end trigger_already_exists_yn;

  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name,
                                        'p_sqlplus_mode', p_sqlplus_mode,
                                        'p_author', p_author
                                        );

    l_banner := l_divider  || '--' || chr(10) 
                             || '--      Author:  ' || l_author || chr(10)
                             || '-- Script name:  ' || c_table_name || '_BIU.sql' || chr(10)
                             || '--        Date:  ' || to_char(sysdate, 'DD-Mon-YYYY HH24:MI') || chr(10)
                             || '--     Purpose:  ' || 'BIU Trigger creation DDL for table ' 
                                                    || c_table_name || chr(10) 
                             || '--' || chr(10) 
                             || l_divider;

    if trigger_already_exists_yn = 'N' then
      l_pk_code_snippet :=  pk_code_snippet;
      if instr(l_pk_code_snippet, ' INFORMATION:') = 0
      then
        l_steps := l_steps + 1;
      end if;

      l_script := 'create or replace editionable trigger "' || l_trigger_name || '"' || chr(10)
                      || '  before insert or update' || chr(10)
                      || '  on ' || c_table_name     || chr(10)
                      || '  for each row'            || chr(10)
                      || 'begin'                     || chr(10)
                      || l_pk_code_snippet;

      if column_exists( p_table_name  => c_table_name
                      , p_column_name => 'CREATED_ON' ) 
        and 
        column_exists( p_table_name  => c_table_name
                      , p_column_name => 'CREATED_BY' ) 
      then
        l_script := l_script || '  if inserting' || chr(10)
                            || '  then'         || chr(10)
                            || '    :new.created_on := localtimestamp;' || chr(10)
                            || '    :new.created_by := lower(nvl(sys_context(''APEX$SESSION'',''APP_USER''),user));' || chr(10)
                            || '  end if;' || chr(10);
        l_steps := l_steps + 1;
      elsif column_exists( p_table_name  => c_table_name
                      , p_column_name => 'CREATED_ON' ) 
        and not
        column_exists( p_table_name  => c_table_name
                      , p_column_name => 'CREATED_BY' ) 
      then
        l_script := l_script || '  if inserting' || chr(10)
                            || '  then'         || chr(10)
                            || '    :new.created_on := localtimestamp;' || chr(10)
                            || '  end if;' || chr(10);
        l_steps := l_steps + 1;
      end if;

      if column_exists( p_table_name  => c_table_name
                      , p_column_name => 'UPDATED_ON' ) 
        and 
        column_exists( p_table_name  => c_table_name
                      , p_column_name => 'UPDATED_BY' ) 
      then
        l_script := l_script || '  :new.updated_on := localtimestamp;' || chr(10) 
                            || '  :new.updated_by := lower(nvl(sys_context(''APEX$SESSION'',''APP_USER''),user));' || chr(10);
        l_steps := l_steps + 1;
      elsif column_exists( p_table_name  => c_table_name
                      , p_column_name => 'UPDATED_ON' ) 
        and not
        column_exists( p_table_name  => c_table_name
                      , p_column_name => 'UPDATED_BY' ) 
      then
        l_script := l_script || '  :new.updated_on := localtimestamp;' || chr(10);
        l_steps := l_steps + 1;
      end if;

      l_script := l_script || 'end ' || l_trigger_name || ';';

    else /* The trigger already exists */
      l_steps := l_steps + 1;

      select dbms_metadata.get_ddl('TRIGGER',l_trigger_name) 
      into l_script
      from dual;

      l_script := replace(l_script,'"'||user||'".');
      l_script := case when l_sqlplus_mode = 'Y'
                       then replace(l_script,'_biu;','_biu;'|| chr(10) || '/')
                       else l_script
                       end;
    end if;

    l_script := replace(l_script, '"');

    if l_sqlplus_mode = 'Y'
    then
      l_script := l_script || chr(10) || '/';
    end if;

    if l_steps > 0 and l_sqlplus_mode = 'Y'
    then
      return c_liquibase_start||l_banner || l_script;
    elsif l_steps > 0 and l_sqlplus_mode = 'N'
    then
      return c_liquibase_start||l_script;
    else
                                  ------------------------------------ 
                                  -- The trigger contains no actual    
                                  -- steps, so give an error           
                                  -- instead.                          
                                  ------------------------------------ 
      return 'ERROR: This table does not appear to require a standard OHMS BIU trigger:' || chr(10) || chr(10) ||
              '  o No suitable surrogate key found.' || chr(10) ||
              '  o No "WHO" ("CREATED_BY", "CREATED_ON" etc.) columns detected.' || chr(10);
    end if;
  end generate_biu_trigger_script;

------------------------------------------------------------------------------

  function generate_comment_script(p_table_name in user_col_comments.table_name%type,
                                   p_author     in varchar2 default null) 
  return clob
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_comment_script';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_table_name      constant user_col_comments.table_name%type := upper(p_table_name);
  c_liquibase_start constant varchar2(500) := apex_string.format(
      p_message => q'[--liquibase formatted sql
--changeset comment_script:%0 stripComments:false 
]',
     p0 => c_table_name
    );
  c_author         constant varchar2(60) := coalesce(p_author, v('APP_USER'), user);
  l_banner         varchar2(2000);
  l_divider        varchar2(100) := lpad('-',80, '-') || chr(10);
  l_col_comment    clob;
  l_tbl_comment    clob;
  l_comment_script clob;
  begin
    apex_debug.message(c_debug_template,'START', 'p_table_name', p_table_name);

    l_banner := l_divider  || '--' || chr(10) 
                           || '--      Author:  ' || c_author || chr(10)
                           || '-- Script name:  ' || c_table_name || '.sql' || chr(10)
                           || '--        Date:  ' || to_char(sysdate, 'DD-Mon-YYYY HH24:MI') || chr(10)
                           || '--     Purpose:  ' || 'Comment DDL for table ' 
                                                  || c_table_name || chr(10) 
                           || '--' || chr(10) 
                           || l_divider;

    for crec in (select apex_string.format(
                  p_message => q'@comment on column %0.%1 is q'[%2]';@',
                      p0        => table_name,
                      p1        => rpad(column_name,45),
                      p2        => case when comments is null
                                        then case when column_name in ('CREATED','CREATED_ON')
                                                  then 'The date the record was created'
                                                  when column_name in ('CREATED_BY')
                                                  then 'The user who created the record'
                                                  when column_name in ('UPDATED','UPDATED_ON')
                                                  then 'The date the record was updated'
                                                  when column_name in ('UPDATED_BY')
                                                  then 'The user who updated the record'
                                                  when column_name in ('ID')
                                                  then 'Primary Key'
                                                  when column_name in ('ROW_VERSION')
                                                  then 'A number that increments up every time the record is updated'
                                                  when column_name in ('TENANT_ID')
                                                  then 'This is will be used for VPD'
                                                  end
                                        else comments
                                        end
                  ) stmt
                  from user_col_comments
                  where table_name = c_table_name)
      loop
        l_col_comment := l_col_comment || crec.stmt || chr(10);
      end loop;

      select apex_string.format(
              p_message => q'@comment on table %0 is q'[%1]';@',
              p0 => table_name,
              p1 => comments
            ) stmt
      into l_tbl_comment
      from user_tab_comments
      where table_name = c_table_name
      order by 1;

    l_comment_script := c_liquibase_start
                        || l_banner
                        || chr(10) 
                        || l_tbl_comment 
                        || chr(10) 
                        || l_col_comment;

    return l_comment_script;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_comment_script;

------------------------------------------------------------------------------

  function generate_package_script(p_package_name in all_source.name%type,
                                   p_schema       in all_source.owner%type default null,
                                   p_type         in all_source.type%type default null)  
  return clob
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_package_script';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_package_name constant all_source.name%type := upper(p_package_name);
  c_schema       constant all_source.name%type := coalesce(upper(p_schema),sys_context('userenv', 'current_schema'));
  c_type         constant all_source.name%type := coalesce(upper(p_type),'PACKAGE');
  c_liquibase_start constant varchar2(500) := apex_string.format(
      p_message => q'[--liquibase formatted sql
--changeset %1_script:%0 stripComments:false endDelimiter:/ runOnChange:true
]',
     p0 => c_package_name,
     p1 => replace(lower(c_type),' ','_')
    );
  c_liquibase_end constant varchar(200)      := apex_string.format(
      p_message => '
--rollback drop package %0;',
      p0 => c_package_name
    );
  c_create_code  constant varchar2(50) := 'create or replace ';

  l_package_script clob;
  l_LAST_line      clob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_package_name', p_package_name,
                                        'p_schema', p_schema,
                                        'p_type', p_type);

    for crec in (select text
                from all_source
                where owner=c_schema
                and name =c_package_name
                and type = c_type
                order by line)
      loop
        l_package_script := l_package_script || crec.text;
        l_LAST_line := crec.text;
      end loop;

      l_package_script := l_package_script||
                          case when instr(l_LAST_line,chr(10),1) = 0 
                               then chr(10)||'/'
                               else '/'
                               end;

    return c_liquibase_start||c_create_code||l_package_script||chr(10)||c_liquibase_end;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_package_script;


------------------------------------------------------------------------------

  function expected_uk_name ( p_table_name          in varchar2
                            , p_current_constr_name in varchar2
                            , p_option              in varchar2
                            , p_schema_name         in varchar2 := sys_context( 'userenv', 'current_schema' ))
  return varchar2 result_cache 
  --relies_on (all_constraints) 
  is
    c_scope          constant varchar2(128)  := gc_scope_prefix || 'expected_uk_name';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_table_name           varchar2(60)                                     := p_table_name;
    l_current_constr_name  varchar2(60)                                     := p_current_constr_name;
    l_option               varchar2(20)                                     := p_option;
    l_schema_name          varchar2(60)                                     := p_schema_name;
    l_table_abbreviation   dev_table_abbreviations.table_abbreviation%type;
    l_constraint_name      varchar2(60);
    l_base_uk_name         varchar2(60);
    l_name_index           number;
    l_constr_posn          number;
  begin

    select table_abbreviation into l_table_abbreviation
      from dev_table_abbreviations
     where schema_name = l_schema_name
       and table_name  = l_table_name;

    l_base_uk_name := l_table_abbreviation || '_UK';

                                ------------------------------------
                                -- If the passed constraint has
                                -- the correct format, just return
                                -- it back.
                                ------------------------------------
    if regexp_like(l_current_constr_name, l_base_uk_name || '[0-9]+')
    then
      return l_current_constr_name;
    END IF;
                                ------------------------------------
                                --  First we need to find any
                                -- existing check constraints for
                                -- the table, which comply with the
                                -- naming standard. Any such UCs
                                -- will have a numeric subscript.
                                -- We need to get the maximum
                                -- subscript value + 1, as a
                                -- startpoint for renaming non
                                -- compliant foreign keys.
                                ------------------------------------
    select nvl(substr(max(constraint_name), length(max(constraint_name))),0) into l_name_index
      from all_constraints
     where regexp_like(constraint_name, l_base_uk_name || '[0-9]+')
       and owner = l_schema_name;

                                ------------------------------------
                                -- We now need to scan the sibling
                                -- constraints for this table ->
                                -- parent table, which are non
                                -- compliant, in alphabetical
                                -- order of constraint_name. The
                                -- position of our constraint in
                                -- the list marks plus our
                                -- l_name_index value, will be
                                -- used to generate the new name.
                                ------------------------------------

    select constr_posn  into l_constr_posn
      from
        ( select table_name,  constraint_name,
                 row_number() over (partition by table_name order by constraint_name desc) constr_posn
              from all_constraints
             where constraint_type = 'U'
               and not regexp_like(constraint_name, l_base_uk_name || '[0-9]+') -- exclude compliant names
               and table_name        = l_table_name
               and owner             = l_schema_name
          )
     where upper(constraint_name) = l_current_constr_name;


    -- process_error('Index now ' || l_name_index || ' constr_posn: ' || l_constr_posn);
    l_name_index := l_name_index + l_constr_posn;

    l_constraint_name := l_base_uk_name || l_name_index;

    if l_option = 'COMPLIANT_NAME'
    then
      return l_constraint_name;
    else
      return 'ALTER TABLE ' || l_table_name || ' RENAME CONSTRAINT ' ||  l_current_constr_name || ' TO ' || l_constraint_name;
    end if;
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;

  end expected_uk_name;

  procedure update_cssap ( p_mode                 in  varchar2
                         , p_start_total_tables   out number
                         , p_end_total_tables     out number
                         , p_start_total_elements out number
                         , p_end_total_elements   out number
                         , p_inserts              out number
                         , p_skipped              out number
                         , p_updates              out number
                         , p_cssap_discards       out number
                         , p_blacklist_discards   out number)
  is
    c_scope          constant varchar2(128)  := gc_scope_prefix || 'update_cssap';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_table_name                    varchar2(60);
    l_column_name                   varchar2(60);
    l_data_element                  varchar2(125);
    l_customer_data_default         varchar2(3)  := 'Yes';
    l_customer_data                 varchar2(3);
    l_geo_location_default          varchar2(500) := 'Replicated Across Regions';
    l_geo_location                  varchar2(500);
    l_method_of_collection_default  varchar2(500) := 'Input via application';
    l_method_of_collection          varchar2(500);
    l_justification                 varchar2(500) := 'data element is used for OHMS application';
    l_classification_default        varchar2(500) := 'Confidential - Oracle Highly Restricted';
    l_classification                varchar2(500);
    l_data_retention_default        varchar2(30) := 'Contract Dependent';
    l_start_total_tables            number;
    l_end_total_tables              number;
    l_start_total_elements          number;
    l_end_total_elements            number;
    l_inserts                       number       := 0;
    l_skipped                       number       := 0;
    l_updates                       number       := 0;
    l_cssap_discards                number       := 0;
    l_blacklist_discards            number       := 0;
    l_rowcount                      number       := 0;

    function includes_tenant (p_table_name    varchar2)
    return boolean
    is
      n_count     number;
    begin

      if p_table_name like '%TENANT%'
      then
        return true;
      end if;

      select count(*) into n_count
        from user_tab_columns
       where table_name = p_table_name
         and column_name = 'TENANT_ID';

      if n_count > 0
      then
        return true;
      else
        return false;
      end if;
    end includes_tenant;

    function is_fk_column ( p_table_name    varchar2
                          , p_column_name   varchar2 )
    return boolean
    is
      n_count     number;
    begin


    select count(*) into n_count
      from user_cons_columns l
         , user_constraints  c
    where l.constraint_name = c.constraint_name
      and l.table_name      = c.table_name
      and c.constraint_type ='R'
      and c.table_name        = p_table_name
      and l.column_name       = p_column_name;

      if n_count > 0
      then
        return true;
      else
        return false;
      end if;

    end is_fk_column;

  begin

    select count(distinct table_name)
         , count(*)
    into
           l_start_total_tables
         , l_start_total_elements
     from dev_ohms_cssap_data_matrix;

    for r in ( select table_name
                    , column_name
                    , table_name || '.' || column_name  as data_element
                    , data_type
               from  user_tab_columns
              where table_name in ( select *
                                      from
                                        ( select distinct(table_name)
                                          from apex_application_page_regions
                                          where source_type  in ('Form', 'Report', 'Interactive Report')
                                          and table_name is not null
                                          and application_id between MIN_PROD_APP_ID and MAX_PROD_APP_ID
                                        union
                                         select distinct referenced_name as table_name
                                         from
                                            all_dependencies
                                         where name in (select object_name from user_objects where object_type = 'PACKAGE')
                                         and owner = 'CARS'
                                         and referenced_type = 'TABLE'
                                        union
                                        select upper(regexp_replace(translate(region_source, chr(10)||chr(11)||chr(13), ' ')
                                                 , 'select.*from[[:space:][:blank:]]+([\.a-z_0-9]*).*', '\1', 1, 1, 'i')) table_name
                                        from  apex_application_page_regions
                                        where source_type  in ('Form', 'Report', 'Interactive Report')
                                        and application_id between MIN_PROD_APP_ID and MAX_PROD_APP_ID
                                        and region_source is not null)
                                     minus
                                     (
                                       select table_name
                                        from dev_blacklisted_tables
                                       where inc_cssap_compliance = 'N'
                                       union
                                       select table_name
                                         from dev_table_abbreviations
                                        where review_status = 'R'
                                     )
                                 )
               )
    loop
      l_table_name           := r.table_name;
      l_column_name          := r.column_name;
      l_data_element         := r.data_element;
      l_customer_data        := l_customer_data_default;
      l_geo_location         := l_geo_location_default;
      l_method_of_collection := l_method_of_collection_default;



      if r.column_name in ('ADDRESS', 'SENDER_ADDRESS') or
         r.column_name in ('PHONE', 'LOCATION_PHONE', 'CONTACT_PHONE') or
         r.column_name = 'AGE' or
         r.column_name in ('FIRST_NAME', 'MIDDLE_NAME', 'LAST_NAME') or
         r.column_name = 'DOB' or
         r.column_name like 'BIOLOGICAL_SEX%' or
         r.column_name like 'GENDER_SEX%' or
         r.column_name like 'RACE%' or
         r.column_name like 'ETHNICITY%'
      then
        l_classification       := l_classification_default || ' (May include / indicate personal details)';
      else
        l_classification       := l_classification_default;
      end if;

      if r.column_name in ('CREATED_ON', 'CREATED_BY', 'UPDATED_ON', 'UPDATED_BY', 'CREATED_BY_SID', 'UPDATED_BY_SID')
      then
        continue;
      end if;

      if includes_tenant(p_table_name => r.table_name)
      then
        l_geo_location := 'Restricted by tenant';
      else
        l_geo_location :=  l_geo_location_default;
      end if;

      if r.column_name = 'ID'
      then
        l_method_of_collection := 'System generated primary key';
      elsif r.column_name = 'TOKEN'
      then
        l_method_of_collection := 'System generated';
      elsif is_fk_column ( p_table_name => r.table_name
                         , p_column_name => r.column_name )
      then
        l_method_of_collection := 'System generated foreign key';
      end if;

      begin
        if p_mode = 'UPSERT'
        then
          update dev_ohms_cssap_data_matrix
          set data_element               = r.data_element
            , justification              = r.data_element || ' ' || l_justification
            , customer_data              = l_customer_data
            , geographic_location        = l_geo_location
            , data_classification        = l_classification
            , data_retention             = l_data_retention_default
            , method_of_data_collection  = l_method_of_collection
          where table_name = r.table_name
            and column_name = r.column_name;
            l_rowcount := sql%rowcount;

            l_updates := l_updates + l_rowcount;
        end if;

        if (l_rowcount = 0 and  p_mode = 'UPSERT') or p_mode = 'INSERT'
        then
          insert into dev_ohms_cssap_data_matrix
            ( table_name
            , column_name
            , data_element
            , justification
            , customer_data
            , geographic_location
            , data_classification
            , data_retention
            , method_of_data_collection )
          values
            ( r.table_name
            , r.column_name
            , r.data_element
            , r.data_element || ' ' || l_justification
            , l_customer_data
            , l_geo_location
            , l_classification
            , l_data_retention_default
            , l_method_of_collection );
            l_inserts := l_inserts + 1;
        end if;
        commit;
      exception
        when dup_val_on_index then
          l_skipped := l_skipped + 1;
      end;
    end loop;
                                  ------------------------------------
                                  --  Ensure the entries are table
                                  -- entries and not views.
                                  ------------------------------------
    delete from dev_ohms_cssap_data_matrix
        where table_name
          not in ( select table_name
                     from user_tables);

    ------------------------------------------------------------------
    -- These next two tables are maintained in application 17000010.
    ------------------------------------------------------------------
                                  ------------------------------------
                                  -- Ensure we only have table,
                                  -- subject to CCSAP compliance
                                  -- reporting.
                                  ------------------------------------
    delete from dev_ohms_cssap_data_matrix
        where table_name
           in ( select table_name
                  from dev_table_abbreviations
                 where inc_cssap_compliance = 'N' );
    l_cssap_discards     := sql%rowcount;
                                  ------------------------------------
                                  -- Remove any which are in the
                                  -- modelling blacklist.
                                  ------------------------------------
    delete from dev_ohms_cssap_data_matrix
        where table_name
           in ( select table_name
                  from dev_blacklisted_tables);
    l_blacklist_discards := sql%rowcount;


    update dev_ohms_cssap_data_matrix
       set data_retention = 'Life of System'
         , customer_data  = 'No'
      where (schema_name, table_name)
         in (select schema_name, table_name
               from dev_table_abbreviations
              where system_config_table = 'Y');

    select count(distinct table_name)
         , count(*)
    into
           l_end_total_tables
         , l_end_total_elements
     from dev_ohms_cssap_data_matrix;

    p_inserts              := l_inserts;
    p_skipped              := l_skipped;
    p_updates              := l_updates;
    p_cssap_discards       := l_cssap_discards;
    p_blacklist_discards   := l_blacklist_discards;
    p_start_total_tables   := l_start_total_tables;
    p_start_total_elements := l_start_total_elements;
    p_end_total_tables     := l_end_total_tables;
    p_end_total_elements   := l_end_total_elements;

    commit;

  exception
    when others then
      dbms_output.put_line('Error ' || sqlcode || ' on loading table_name / column_name / data_element: '
                                    || l_table_name || ' / ' || l_column_name || ' / ' || l_data_element);
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end update_cssap;


  procedure load_cssap
  is
    l_inserts                       number       := 0;
    l_skipped                       number       := 0;
    l_updates                       number       := 0;
    l_cssap_discards                number       := 0;
    l_blacklist_discards            number       := 0;
    l_start_total_tables            number;
    l_end_total_tables              number;
    l_start_total_elements          number;
    l_end_total_elements            number;
  begin

    update_cssap ( p_mode                 => 'INSERT'
                 , p_start_total_tables   => l_start_total_tables
                 , p_end_total_tables     => l_end_total_tables
                 , p_start_total_elements => l_start_total_elements
                 , p_end_total_elements   => l_end_total_elements
                 , p_inserts              => l_inserts
                 , p_skipped              => l_skipped
                 , p_updates              => l_updates
                 , p_cssap_discards       => l_cssap_discards
                 , p_blacklist_discards   => l_blacklist_discards
                 );
    dbms_output.put_line('Inserts          : ' || l_inserts);
    dbms_output.put_line('Skipped          : ' || l_skipped);
    dbms_output.put_line('CSSAP Discards   : ' || l_cssap_discards);
    dbms_output.put_line('Blacklist Rejects: ' || l_blacklist_discards);
    dbms_output.put_line('Tables at Start  : ' || l_start_total_tables);
    dbms_output.put_line('Tables at End    : ' || l_end_total_tables);
    dbms_output.put_line('Elements at Start: ' || l_start_total_elements);
    dbms_output.put_line('Elements at End  : ' || l_end_total_elements);


  end load_cssap;

----------------------------------------------------------------------------
-- The process_error procedure, determines if we are in an APEX session   --
-- or not. If we are it performs an apex_error.add_error, otherwise an    --
-- application error is raised.                                           --
----------------------------------------------------------------------------

  procedure process_error (message_text     in varchar2)
  is
  begin
    if v('APP_SESSION') is null
    then
      raise_application_error(-20001, 'Error encountered ' || message_text);
    else
      apex_error.add_error( p_message          => message_text
                          , p_display_location => 'INLINE_IN_NOTIFICATION');
    end if;
  end  process_error;

  function valid_constr_name ( p_constraint_name  in varchar2
                             , p_option           in varchar2
                             , p_schema_name      in varchar2 := sys_context( 'userenv', 'current_schema' )
                             , p_table_name       in varchar2 default null
                             )
  return varchar2
  is
    c_scope          constant varchar2(128) := gc_scope_prefix || 'valid_constr_name';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    pragma udf;
    l_constraint_name        varchar2(60)              := upper(p_constraint_name);
    l_option                 varchar2(20)              := upper(p_option);
    l_schema_name            varchar2(60)              := upper(p_schema_name);
    c_table_name             constant varchar2(60)     := upper(p_table_name);
    r_cons                   all_constraints%rowtype;
    l_count                  number;

    ------------------------------------------------------------------------------
    -- Nested function to return expected primary key name 
    ------------------------------------------------------------------------------
    function expected_pk_name ( p_table_name          in varchar2
                              , p_current_constr_name in varchar2
                              , p_option              in varchar2
                              , p_schema_name         in varchar2 := sys_context( 'userenv', 'current_schema' ))
    return varchar2  result_cache 
    --relies_on (dev_table_abbreviations)
    is
      l_table_name           varchar2(60)                                     := p_table_name;
      l_current_constr_name  varchar2(60)                                     := p_current_constr_name;
      l_option               varchar2(20)                                     := p_option;
      l_schema_name          varchar2(60)                                     := p_schema_name;
      l_table_abbreviation   dev_table_abbreviations.table_abbreviation%type;
      l_constraint_name      varchar2(60);
    begin
      apex_debug.message(c_debug_template,'START expected_pk_name'
                                         , 'p_table_name', p_table_name          
                                         , 'p_current_constr_name', p_current_constr_name 
                                         , 'p_option', p_option              
                                         , 'p_schema_name', p_schema_name
                                         , 'p_table_name', p_table_name         
                                         );

      select table_abbreviation into l_table_abbreviation
        from dev_table_abbreviations
       where schema_name = l_schema_name
         and table_name  = l_table_name;

      l_constraint_name := l_table_abbreviation || '_PK';
      if l_option = 'COMPLIANT_NAME'
      then
        return l_constraint_name;
      else
        return 'ALTER TABLE ' || l_table_name || ' RENAME CONSTRAINT ' ||  l_current_constr_name || ' TO ' || l_constraint_name;
      end if;

      -- return l_constraint_name; -- unreachable

    end expected_pk_name;

    ------------------------------------------------------------------------------
    -- Nested function to return expected unique key name 
    ------------------------------------------------------------------------------
    function expected_uk_name ( p_table_name          in varchar2
                              , p_current_constr_name in varchar2
                              , p_option              in varchar2
                              , p_schema_name         in varchar2 := sys_context( 'userenv', 'current_schema' ))
    return varchar2 result_cache 
    --relies_on (all_constraints) 
    is
      l_table_name           varchar2(60)                                     := p_table_name;
      l_current_constr_name  varchar2(60)                                     := p_current_constr_name;
      l_option               varchar2(20)                                     := p_option;
      l_schema_name          varchar2(60)                                     := p_schema_name;
      l_table_abbreviation   dev_table_abbreviations.table_abbreviation%type;
      l_constraint_name      varchar2(60);
      l_base_uk_name         varchar2(60);
      l_name_index           number;
      l_constr_posn          number;
    begin
      apex_debug.message(c_debug_template,'START expected_uk_name'
                                         , 'p_table_name', p_table_name          
                                         , 'p_current_constr_name', p_current_constr_name 
                                         , 'p_option', p_option              
                                         , 'p_schema_name', p_schema_name         
                                         );

      select table_abbreviation into l_table_abbreviation
        from dev_table_abbreviations
       where schema_name = l_schema_name
         and table_name  = l_table_name;

      l_base_uk_name := l_table_abbreviation || '_UK';
      apex_debug.message(c_debug_template, 'l_base_uk_name', l_base_uk_name);

                                  ------------------------------------
                                  -- If the passed constraint has
                                  -- the correct format, just return
                                  -- it back.
                                  ------------------------------------
      if regexp_like(l_current_constr_name, l_base_uk_name || '[0-9]+')
      then
        return l_current_constr_name;
      END IF;
                                  ------------------------------------
                                  --  First we need to find any
                                  -- existing check constraints for
                                  -- the table, which comply with the
                                  -- naming standard. Any such UCs
                                  -- will have a numeric subscript.
                                  -- We need to get the maximum
                                  -- subscript value + 1, as a
                                  -- startpoint for renaming non
                                  -- compliant foreign keys.
                                  ------------------------------------
      select nvl(substr(max(constraint_name), length(max(constraint_name))),0) into l_name_index
        from all_constraints
       where regexp_like(constraint_name, l_base_uk_name || '[0-9]+')
         and owner = l_schema_name;
      apex_debug.message(c_debug_template, 'l_name_index', l_name_index);
                                  ------------------------------------
                                  -- We now need to scan the sibling
                                  -- constraints for this table ->
                                  -- parent table, which are non
                                  -- compliant, in alphabetical
                                  -- order of constraint_name. The
                                  -- position of our constraint in
                                  -- the list marks plus our
                                  -- l_name_index value, will be
                                  -- used to generate the new name.
                                  ------------------------------------

      select constr_posn  into l_constr_posn
        from
          ( select table_name,  constraint_name,
                   row_number() over (partition by table_name order by constraint_name desc) constr_posn
                from all_constraints
               where constraint_type = 'U'
                 and not regexp_like(constraint_name, l_base_uk_name || '[0-9]+') -- exclude compliant names
                 and table_name        = l_table_name
                 and owner             = l_schema_name
            )
       where upper(constraint_name) = l_current_constr_name;

      apex_debug.message(c_debug_template, 'l_constr_posn', l_constr_posn);

      -- process_error('Index now ' || l_name_index || ' constr_posn: ' || l_constr_posn);
      l_name_index := l_name_index + l_constr_posn;

      l_constraint_name := l_base_uk_name || l_name_index;

      if l_option = 'COMPLIANT_NAME'
      then
        return l_constraint_name;
      else
        return 'ALTER TABLE ' || l_table_name || ' RENAME CONSTRAINT ' ||  l_current_constr_name || ' TO ' || l_constraint_name;
      end if;
    exception
      when others then
apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;

    end expected_uk_name;


    ------------------------------------------------------------------------------
    -- Nested function to return parent table name
    ------------------------------------------------------------------------------
    function fk_parent_table ( p_constraint_name  in varchar2
                             , p_schema_name      in varchar2 := sys_context( 'userenv', 'current_schema' ))
    return varchar2 result_cache 
    --relies_on (all_constraints)
    is
      l_owner             all_users.username%type      := p_schema_name;
      l_constraint_name   all_objects.object_name%type := p_constraint_name;
      l_table_name        all_tables.table_name%type   := null;


      cursor c_parent ( p_owner          varchar2
                      , p_cname          varchar2 )
      is
        select p.table_name  parent_table
          from all_constraints c
             , all_constraints p
         where c.constraint_type ='R'
           and c.r_constraint_name = p.constraint_name(+)
           and p.constraint_type  IN ('P')
           and p.owner(+)            = c.owner
           and c.constraint_name     = p_cname
           and c.owner               = p_owner;

    begin
      apex_debug.message(c_debug_template,'START fk_parent_table'
                                         , 'p_constraint_name', p_constraint_name          
                                         , 'p_schema_name', p_schema_name         
                                         );

                                  ----------------------------------------
                                  -- Here we extract the constraint     --
                                  -- name from the error message. Note  --
                                  -- that it is also prefixed with the  --
                                  -- constraint owner.                  --
                                  ----------------------------------------

      open c_parent (l_owner, l_constraint_name);
      fetch c_parent into l_table_name;
      close c_parent;

      apex_debug.message(c_debug_template, 'l_table_name', l_table_name);
      return l_table_name;

    exception
      when others then
         apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
         raise;
    end fk_parent_table;

    ------------------------------------------------------------------------------
    -- Nested function to return expected foreign key name
    ------------------------------------------------------------------------------
    function expected_fk_name ( p_table_name          in varchar2
                              , p_current_constr_name in varchar2
                              , p_option              in varchar2
                              , p_schema_name         in varchar2 := sys_context( 'userenv', 'current_schema' ))
    return varchar2 result_cache 
    --relies_on (all_constraints)
    is
      l_table_name           varchar2(60)                                     := p_table_name;
      l_parent_table_name    varchar2(60);
      l_current_constr_name  varchar2(60)                                     := p_current_constr_name;
      l_r_constr_name        varchar2(60);
      l_option               varchar2(20)                                     := p_option;
      l_schema_name          varchar2(60)                                     := p_schema_name;
      l_table_abbreviation   dev_table_abbreviations.table_abbreviation%type;
      l_parent_abbreviation  dev_table_abbreviations.table_abbreviation%type;
      l_constraint_name      varchar2(60);
      l_base_fk_name         varchar2(60);
      l_name_index           number;
      l_constr_posn          number;
    begin
      apex_debug.message(c_debug_template,'START expected_fk_name'
                                         , 'p_table_name', p_table_name          
                                         , 'p_current_constr_name', p_current_constr_name 
                                         , 'p_option', p_option              
                                         , 'p_schema_name', p_schema_name         
                                         );

      select table_abbreviation into l_table_abbreviation
        from dev_table_abbreviations
       where schema_name = l_schema_name
         and table_name  = l_table_name;

      apex_debug.message(c_debug_template, 'l_table_abbreviation', l_table_abbreviation);

      l_parent_table_name := fk_parent_table ( p_constraint_name => l_current_constr_name
                                             , p_schema_name     => l_schema_name);

      apex_debug.message(c_debug_template, 'l_parent_table_name', l_parent_table_name);
      begin
        select table_abbreviation into l_parent_abbreviation
          from dev_table_abbreviations
         where schema_name = l_schema_name
           and table_name  = l_parent_table_name;
      exception
        when others then
          process_error('Parent table, ' || l_schema_name || '.' || l_parent_table_name
                                         || ' of constraint '    || l_current_constr_name
                                         || ' is not registered to DEV_TABLE_ABBREVIATIONS table.');
          raise;
      end;

      l_base_fk_name := l_table_abbreviation || '_' || l_parent_abbreviation || '_FK';

                                  ------------------------------------
                                  -- If the passed constraint has
                                  -- the correct format, just return
                                  -- it back.
                                  ------------------------------------
      if regexp_like(l_current_constr_name, l_base_fk_name || '[0-9]+')
      then
        return l_current_constr_name;
      END IF;
                                  ------------------------------------
                                  --  First we need to find any
                                  -- existing foreign keys for the
                                  -- table, which comply with the
                                  -- naming standard. Any such FKs
                                  -- will have a numeric subscript.
                                  -- We need to get the maximum
                                  -- subscript value + 1, as a
                                  -- startpoint for renaming non
                                  -- compliant foreign keys.
                                  ------------------------------------
      select nvl(substr(max(constraint_name), length(max(constraint_name))),0) into l_name_index
        from all_constraints
       where regexp_like(constraint_name, l_base_fk_name || '[0-9]+')
         and owner = l_schema_name;




                                  ------------------------------------
                                  --  We are going to need the
                                  -- parent constraint name for our
                                  -- current constraint.
                                  ------------------------------------
      select r_constraint_name into l_r_constr_name
        from all_constraints
       where owner                  = l_schema_name
         and upper(constraint_name) = l_current_constr_name;

                                  ------------------------------------
                                  -- We now need to scan the sibling
                                  -- constraints for this table ->
                                  -- parent table, which are non
                                  -- compliant, in alphabetical
                                  -- order of constraint_name. The
                                  -- position of our constraint in
                                  -- the list marks plus our
                                  -- l_name_index value, will be
                                  -- used to generate the new name.
                                  ------------------------------------

      select constr_posn  into l_constr_posn
        from
          ( select table_name,  constraint_name,
                   row_number() over (partition by table_name order by constraint_name desc) constr_posn
                from all_constraints
               where constraint_type = 'R'
                 and not regexp_like(constraint_name, l_base_fk_name || '[0-9]+') -- exclude compliant names
                 and table_name        = l_table_name
                 and r_constraint_name = l_r_constr_name
                 and owner             = l_schema_name
            )
       where upper(constraint_name) = l_current_constr_name;

      -- process_error('Index now ' || l_name_index || ' constr_posn: ' || l_constr_posn);
      l_name_index := l_name_index + l_constr_posn;


      l_constraint_name := l_base_fk_name || l_name_index;

      if l_option = 'COMPLIANT_NAME'
      then
        return l_constraint_name;
      else
        return 'ALTER TABLE ' || l_table_name || ' RENAME CONSTRAINT ' ||  l_current_constr_name || ' TO ' || l_constraint_name;
      end if;
    exception
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;

    end expected_fk_name;

    ------------------------------------------------------------------------------
    -- Nested function to return expected check constraint name
    ------------------------------------------------------------------------------
    function expected_ck_name ( p_table_name          in varchar2
                              , p_current_constr_name in varchar2
                              , p_option              in varchar2
                              , p_schema_name         in varchar2 := sys_context( 'userenv', 'current_schema' ))
    return varchar2 result_cache 
    --relies_on (all_constraints) 
    is
      l_table_name           varchar2(60)                                     := p_table_name;
      l_current_constr_name  varchar2(60)                                     := p_current_constr_name;
      l_r_constr_name        varchar2(60);
      l_option               varchar2(20)                                     := p_option;
      l_schema_name          varchar2(60)                                     := p_schema_name;
      l_table_abbreviation   dev_table_abbreviations.table_abbreviation%type;
      l_constraint_name      varchar2(60);
      l_base_ck_name         varchar2(60);
      l_name_index           number;
      l_constr_posn          number;
    begin
      apex_debug.message(c_debug_template,'START expected_ck_name'
                                         , 'p_table_name', p_table_name          
                                         , 'p_current_constr_name', p_current_constr_name 
                                         , 'p_option', p_option              
                                         , 'p_schema_name', p_schema_name         
                                         );


      select table_abbreviation into l_table_abbreviation
        from dev_table_abbreviations
       where schema_name = l_schema_name
         and table_name  = l_table_name;

      l_base_ck_name := l_table_abbreviation || '_CK';
      apex_debug.message(c_debug_template, 'l_table_abbreviation', l_table_abbreviation);

                                  ------------------------------------
                                  -- If the passed constraint has
                                  -- the correct format, just return
                                  -- it back.
                                  ------------------------------------
      if regexp_like(l_current_constr_name, l_base_ck_name || '[0-9]+')
      then
        return l_current_constr_name;
      END IF;
                                  ------------------------------------
                                  --  First we need to find any
                                  -- existing check constraints for
                                  -- the table, which comply with the
                                  -- naming standard. Any such FKs
                                  -- will have a numeric subscript.
                                  -- We need to get the maximum
                                  -- subscript value + 1, as a
                                  -- startpoint for renaming non
                                  -- compliant foreign keys.
                                  ------------------------------------
      select nvl(substr(max(constraint_name), length(max(constraint_name))),0) into l_name_index
        from all_constraints
       where regexp_like(constraint_name, l_base_ck_name || '[0-9]+')
         and owner = l_schema_name;

                                  ------------------------------------
                                  -- We now need to scan the sibling
                                  -- constraints for this table ->
                                  -- parent table, which are non
                                  -- compliant, in alphabetical
                                  -- order of constraint_name. The
                                  -- position of our constraint in
                                  -- the list marks plus our
                                  -- l_name_index value, will be
                                  -- used to generate the new name.
                                  ------------------------------------

      select constr_posn  into l_constr_posn
        from
          ( select table_name,  constraint_name,
                   row_number() over (partition by table_name order by constraint_name desc) constr_posn
                from all_constraints
               where constraint_type = 'C'
                 and not regexp_like(constraint_name, l_base_ck_name || '[0-9]+') -- exclude compliant names
                 and table_name        = l_table_name
                 and owner             = l_schema_name
                 and search_condition_vc not like '%IS NOT NULL'
            )
       where upper(constraint_name) = l_current_constr_name;

      -- process_error('Index now ' || l_name_index || ' constr_posn: ' || l_constr_posn);
      l_name_index := l_name_index + l_constr_posn;
      apex_debug.message(c_debug_template, 'l_name_index', l_name_index);

      l_constraint_name := l_base_ck_name || l_name_index;

      if l_option = 'COMPLIANT_NAME'
      then
        return l_constraint_name;
      else
        return 'ALTER TABLE ' || l_table_name || ' RENAME CONSTRAINT ' ||  l_current_constr_name || ' TO ' || l_constraint_name;
      end if;
    exception
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;

    end expected_ck_name;

  begin
    apex_debug.message(c_debug_template,'START'
                                      , 'p_constraint_name', p_constraint_name
                                      , 'p_option', p_option
                                      , 'p_schema_name', p_schema_name
                                      , 'p_table_name', p_table_name
                                      );

    if l_option not in ( 'COMPLIANT_NAME'
                       , 'RENAME_DDL' )
    then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      process_error ('Invalid parameter value, ' || l_option || ', passed for p_attribute!');
      return '';
    end if;


    begin
      select * into r_cons
        from all_constraints
       where owner                  = l_schema_name
         and upper(constraint_name) = l_constraint_name
         and (table_name             = c_table_name or c_table_name is null) /* it is possible for constraint names to not be unique */
         ;

    exception
      when others then
        process_error('Error processing constraint, ' || l_schema_name || '.' || l_constraint_name || ' ( ' || sqlerrm || ' )');
        raise;
    end;


                                  ------------------------------------
                                  -- Check that the table is
                                  -- registered to
                                  -- dev_table_abbreviations.
                                  ------------------------------------
    select count(*) into l_count
        from dev_table_abbreviations
       where schema_name = l_schema_name
         and table_name  = r_cons.table_name;

    if l_count = 0
    then
      process_error('Table, ' || l_schema_name || '.' || r_cons.table_name || ' is not registered to DEV_TABLE_ABBREVIATIONS table. [Cons: ' || l_constraint_name || ']');
    end if;

    apex_debug.message(c_debug_template, 'constraint_type', r_cons.constraint_type);

    if r_cons.constraint_type = 'P'
    then
      return expected_pk_name ( p_table_name          => r_cons.table_name
                              , p_current_constr_name => l_constraint_name
                              , p_option              => l_option
                              , p_schema_name         => l_schema_name);
    elsif r_cons.constraint_type = 'R'
    then
      return expected_fk_name ( p_table_name          => r_cons.table_name
                              , p_current_constr_name => l_constraint_name
                              , p_option              => l_option
                              , p_schema_name         => l_schema_name);
    elsif r_cons.constraint_type = 'U'
    then
      return expected_uk_name ( p_table_name          => r_cons.table_name
                              , p_current_constr_name => l_constraint_name
                              , p_option              => l_option
                              , p_schema_name         => l_schema_name);
    elsif r_cons.constraint_type = 'C'
    then
      return expected_ck_name ( p_table_name          => r_cons.table_name
                              , p_current_constr_name => l_constraint_name
                              , p_option              => l_option
                              , p_schema_name         => l_schema_name);
    else return null;
    end if;

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end valid_constr_name;

  function table_abbreviation ( p_table_name       in varchar2
                              , p_attribute        in varchar2 := 'TABLE_ABBREVIATION'
                              , p_schema_name      in varchar2 := sys_context( 'userenv', 'current_schema' )
                              , p_force_uniqueness in varchar2 := 'Y' )
  return varchar2
  as
    c_scope          constant varchar2(128)  := gc_scope_prefix || 'table_abbreviation';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    pragma udf;
    alias_len                constant number   := 6;
    l_table_name             varchar2(60)      := upper(p_table_name);
    l_attribute              varchar2(20)      := upper(p_attribute);
    l_schema_name            varchar2(60)      := upper(p_schema_name);
    l_force_uniqueness       varchar2(60)      := upper(p_force_uniqueness);
    l_base_table             varchar2(60);
    l_table_domain           varchar2(5);
    l_this_alias_len         number;
    l_alias                  varchar2(60)      := NULL;
    l_count                  number            := 0;
    l_segment_count          number;
    l_char_shortfall         number            := 0;
    l_seg_char_limit         number;
    l_segment                varchar2(30);
    l_prev_seg_short         boolean           := false;

    function alias_in_use ( p_table_domain     varchar2
                          , p_table_alias      varchar2
                          , p_schema_name      varchar2)
    return boolean result_cache 
    --relies_on (dev_table_abbreviations)
    is
      c_scope          constant varchar2(128)  := gc_scope_prefix || 'alias_in_use';
      c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
      l_schema_name        varchar2(60)  := upper(p_schema_name);
      l_table_domain       varchar2(30)  := upper(p_table_domain);
      l_table_alias        varchar2(30)  := p_table_alias;
      l_exists             boolean       := false;
      l_count              number;
    begin

      select count(*) into l_count
        from dev_table_abbreviations
        where schema_name = l_schema_name
         and table_domain = l_table_domain
         and table_alias  = l_table_alias;

      if l_count > 0
      then
        return true;
      else
        return false;
      end if;
    exception
      when others then
         apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
         raise;
    end alias_in_use;

  begin

    if l_attribute not in ( 'DOMAIN' , 'TABLE_DOMAIN'
                          , 'ALIAS' , 'TABLE_ALIAS'
                          , 'ABBREVIATION' , 'TABLE_ABBREVIATION' )
    then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      process_error ('Invalid parameter value, ' || p_attribute || ', passed for p_attribute!');
      return '';
    end if;

    if l_force_uniqueness not in ( 'Y' , 'N' )
    then
      process_error ('Invalid parameter value, ' || l_force_uniqueness || ', passed for p_force_uniqueness!');
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      return '';
    end if;


                                  --------------------------------------
                                  --  Check for a domain prefix (3
                                  -- alphanumerics followed by segment).
                                  --------------------------------------
    if regexp_instr(l_table_name, '^[0-9A-Z]{2,3}[_]') > 0
    then
      l_table_domain := regexp_substr(l_table_name, '^[0-9A-Z]{2,3}(_)', 1, 1);
      l_table_domain := replace(l_table_domain, '_', '');
    end if;

    if l_attribute in  ('DOMAIN', 'TABLE_DOMAIN')
    then
      return l_table_domain;
    end if;

    l_base_table :=  regexp_replace(l_table_name, '^' || l_table_domain || '[_]', '', 1, 1);
    -- return l_base_table;

    l_count := 0;
    l_segment_count := regexp_count(l_base_table, '_') + 1;
    if l_segment_count > 0
    then
      l_seg_char_limit := ceil(ALIAS_LEN / l_segment_count);
    else
      l_seg_char_limit := ALIAS_LEN;
    end if;

    -- dbms_output.put_line('l_base_table = ' || l_base_table);
    -- dbms_output.put_line('l_table_domain = ' || l_table_domain);
    -- dbms_output.put_line('l_segment_count = ' || l_segment_count);
    -- dbms_output.put_line('l_seg_char_limit = ' || l_seg_char_limit);
    -- dbms_output.put_line('Initial l_alias cut = ' || l_alias);

    for x in 1..l_segment_count
    loop

                                  ------------------------------------
                                  --  Here we prefix the base table
                                  -- with an underscore because our
                                  -- pattern matching is based on
                                  -- each segment starting with an
                                  -- underscore. Our base table
                                  -- doesn't have an undewrscore at
                                  -- the beginning and we don't want
                                  -- to miss the first segment
                                  -- because of this.
                                  ------------------------------------
      l_segment := regexp_substr('_' || l_base_table, '_[A-Z0-9]+', 1, x);
      -- dbms_output.put_line('Processing segment: ' || l_segment);



                                  ------------------------------------
                                  --  If the string is long enough
                                  -- after the vowels are removed,
                                  -- then we remove them.
                                  ------------------------------------
      if length(regexp_replace( substr(replace(l_segment, '_',''), 2), '(A|E|I|O|U)', '')) + 1 >= l_seg_char_limit + l_char_shortfall
      then
        -- dbms_output.put_line('Trimming vowels l_segment '|| l_segment);
        l_segment := substr(replace(l_segment, '_',''), 1,1) || regexp_replace(substr(replace(l_segment, '_',''), 2), '(A|E|I|O|U)', '');
        -- dbms_output.put_line('Trimmed l_segment to '|| l_segment);
      else
        -- dbms_output.put_line('No trimming vowels of l_segment:  '|| l_segment);
        l_segment := replace(l_segment, '_', '');
      end if;

      -- dbms_output.put_line('Augmenting l_alias (' || l_alias|| ') with ' || substr(l_segment, 1, l_seg_char_limit) || ' taken from l_segment = ' || l_segment);

      l_alias := l_alias || substr(l_segment, 1, l_seg_char_limit + l_char_shortfall);


      if length(l_alias) < l_seg_char_limit * x
      then
        l_char_shortfall := l_seg_char_limit * x - length(l_alias);
        l_prev_seg_short := true;
      else
        l_char_shortfall := 0;
        l_prev_seg_short := false;
      end if;

    end loop;
                                  ------------------------------------
                                  --  Now if we have exceeded the
                                  -- alias length limit, ALIAS_LEN,
                                  -- we need to trim back. We will
                                  -- remove every other character,
                                  -- starting from the end.
                                  ------------------------------------
    l_this_alias_len := length(l_alias);
    if l_this_alias_len > ALIAS_LEN
    then
      -- dbms_output.put_line('Trimming alias: ' || l_alias);
      l_count := l_this_alias_len;
      loop
        exit when  length(l_alias) <= ALIAS_LEN;
        l_alias := substr(l_alias, 1, l_count - 1 ) ||  substr(l_alias, l_count + 1 );
        l_count := l_count - 2;
      end loop;
    end if;

    if l_force_uniqueness = 'Y'
    then
                                  ------------------------------------
                                  --  Now we need to check to see if
                                  -- our alias is unique, if not we
                                  -- will modify the LAST character,
                                  -- by implementing an index.
                                  ------------------------------------
      if alias_in_use ( p_table_domain => l_table_domain
                      , p_table_alias  => l_alias
                      , p_schema_name  => l_schema_name )
      then
        l_count := 1;
        loop
          exit when not alias_in_use ( p_table_domain => l_table_domain
                                     , p_table_alias  => l_alias
                                     , p_schema_name  => l_schema_name );
          if length(l_alias) = ALIAS_LEN
          then
            l_alias := substr(l_alias, 1, length(l_alias) - 1);
          end if;
          l_count := l_count + 1;
          l_alias := l_alias || l_count;
        end loop;
      end if;
    end if;



    if l_attribute in ( 'ALIAS', 'TABLE_ALIAS')
    then
      return l_alias;
    elsif  l_attribute in ( 'ABBREVIATION', 'TABLE_ABBREVIATION')
    then
      if l_table_domain is not null
      then
        return l_table_domain || '_' || l_alias;
      else
        return l_alias;
      end if;
    end if;

    return l_alias;
  exception
    when others then
       apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
       raise;

  end table_abbreviation;

  function table_referenced ( p_table_name    in varchar2
                            , p_mode          in varchar2 := 'SHALLOW' )
  return varchar2 deterministic
  is
    pragma udf;
    l_count            number          := 0;
    l_table_name       varchar2(4000)  := p_table_name;

    function check_obj_reference ( p_object_name     in varchar2 )
    return boolean
    is
    begin
       for r in ( 
                select 'x'
                from table(dev_support_utils.object_references(p_object_name => p_object_name, p_first_row_only => 'Y'))
                )
       loop
         return true;
       end loop;

       return false;

    end check_obj_reference;

  begin

                                  ------------------------------------ 
                                  -- First check for direct            
                                  -- references.                       
                                  ------------------------------------ 
    if check_obj_reference( p_object_name => l_table_name)
    then
      return 'Y';
    end if;

    if p_mode = 'SHALLOW'
    then
      return 'N';
    end if;
                                  ------------------------------------ 
                                  --  Now we check for indirect        
                                  -- references via views.             
                                  ------------------------------------ 
     for r in ( 
              select referenced_by_name
              from table(dev_support_utils.object_references(p_object_name => l_table_name))
              where referenced_by_type in ('VIEW')
              )
     loop
       if check_obj_reference( p_object_name => r.referenced_by_name )
       then 
         return 'Y';
       end if;
     end loop;

     return 'N';

  end table_referenced;


  function transform_sc ( p_search_condition   varchar2
                        , p_option             varchar2)
  return varchar2
  as
    v_search_condition   varchar2(4000) := upper(p_search_condition);
  begin
    if p_option not in ('TRANSFORM_IN', 'SQUEEZE', 'CHOMP', 'COLUMN_NAME')
    then
      raise_application_error(-20001, 'Invalid value for p_option, ' || p_option || q'[. Valid options: 'COLUMN_NAME', 'TRANSFORM_IN', 'SQUEEZE' or 'CHOMP' ]');
    end if;

    if p_option = 'COLUMN_NAME'
    then 
        return replace(regexp_replace(upper(v_search_condition), '^([ ]*)(["_a-zA-Z\S]*).*', '\2'), '"','');
    elsif p_option = 'TRANSFORM_IN'
    then 
                                  ------------------------------------ 
                                  -- Transform IN operator to an       
                                  -- equality test. E.g. COLNAME IN    
                                  -- ('XYZ') is transformed to         
                                  -- COLNAME = 'XYZ'.                  
                                  ------------------------------------ 
     return regexp_replace(v_search_condition, '^([ ]*)(["_a-zA-Z\S]*).*IN.*([(]([''a-zA-Z0-9_]*)([)]))', '\2 = \4', 1, 1, 'i');
    elsif p_option = 'SQUEEZE'
    then
                                  ------------------------------------ 
                                  -- Get rid of spaces and convert     
                                  -- to upper case.                    
                                  ------------------------------------ 
      return upper(replace(v_search_condition, ' ',''));
    elsif p_option = 'CHOMP'
    then
                                  ------------------------------------ 
                                  -- Then transform INs and then do    
                                  -- a chomp.                          
                                  ------------------------------------ 
      return transform_sc(transform_sc(v_search_condition, 'TRANSFORM_IN'), 'SQUEEZE');
    else 
      return null;
    end if;
  end transform_sc;  

  function valid_index_name  ( p_index_name       in varchar2
                             , p_option           in varchar2
                             , p_schema_name      in varchar2 := sys_context( 'userenv', 'current_schema' ))
  return varchar2
  is
    c_scope constant varchar2(128) := gc_scope_prefix || 'valid_index_name';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    pragma udf;
    l_index_name             varchar2(60)                           := upper(p_index_name);
    l_option                 varchar2(20)                           := upper(p_option);
    l_compliant_ix_name      all_indexes.index_name%type;
    l_table_name             all_indexes.table_name%type;
    l_constraint_name        all_constraints.constraint_name%type;
    l_constraint_type        all_constraints.constraint_type%type;
    l_table_abbreviation     dev_table_abbreviations.table_abbreviation%type;
    l_schema_name            varchar2(60)                           := upper(p_schema_name);
    r_cons                   all_constraints%rowtype;
    l_count                  number;

    function expected_ix_name ( p_table_name          in varchar2
                              , p_current_index_name  in varchar2
                              , p_table_abbreviation  in varchar2
                              , p_schema_name         in varchar2 := sys_context( 'userenv', 'current_schema' ))
    return varchar2 result_cache 
    --relies_on (all_indexes) 
    is
      l_table_name           varchar2(60)                                     := p_table_name;
      l_current_index_name   varchar2(60)                                     := p_current_index_name;
      l_option               varchar2(20)                                     := p_option;
      l_schema_name          varchar2(60)                                     := p_schema_name;
      l_table_abbreviation   dev_table_abbreviations.table_abbreviation%type;
      l_constraint_name      varchar2(60);
      l_base_ix_name         varchar2(60);
      l_name_index           number;
      l_index_posn           number;
    begin
      apex_debug.message(c_debug_template,'START expected_ix_name'
                                         , 'p_table_name', p_table_name          
                                         , 'p_current_index_name', p_current_index_name  
                                         , 'p_table_abbreviation', p_table_abbreviation  
                                         , 'p_schema_name', p_schema_name         
                              );

      l_table_abbreviation := p_table_abbreviation;

      l_base_ix_name := l_table_abbreviation || '_IDX';

                                  ------------------------------------
                                  -- If the passed index has
                                  -- the correct format, just return
                                  -- it back.
                                  ------------------------------------
      if regexp_like(l_current_index_name, l_base_ix_name || '[0-9]+')
      then
        return l_current_index_name;
      END IF;
                                  ------------------------------------
                                  --  First we need to find any
                                  -- existing indexes for
                                  -- the table, which comply with the
                                  -- naming standard. Any such FKs
                                  -- will have a numeric subscript.
                                  -- We need to get the maximum
                                  -- subscript value + 1, as a
                                  -- startpoint for renaming non
                                  -- compliant foreign keys.
                                  ------------------------------------
      select nvl(substr(max(index_name), length(max(index_name))),0) into l_name_index
        from all_indexes
       where regexp_like(index_name, l_base_ix_name || '[0-9]+')
         and owner      = l_schema_name
         and table_name = l_table_name;

                                  ------------------------------------
                                  -- We now need to scan the sibling
                                  -- indexes for this 
                                  -- table, which are non
                                  -- compliant, in alphabetical
                                  -- order of index_name. The
                                  -- position of our index in
                                  -- the list marks plus our
                                  -- l_name_index value, will be
                                  -- used to generate the new name.
                                  ------------------------------------

      select index_posn  into l_index_posn
        from
          ( select table_name,  index_name,
                   row_number() over (partition by table_name order by index_name desc) index_posn
                from all_indexes
               where index_type = 'NORMAL'
                 and not regexp_like(index_name, l_base_ix_name || '[0-9]+') -- exclude compliant names
                 and table_name        = l_table_name
                 and owner             = l_schema_name
                 and index_name not in (select index_name
                                          from all_constraints
                                         where table_name      = l_table_name
                                           and owner           = l_schema_name
                                           and constraint_type in ('U','P'))
            )
       where upper(index_name) = l_current_index_name; /* indexes can be mixed-case */

      -- process_error('Index now ' || l_name_index || ' index_posn: ' || l_index_posn);
      l_name_index := l_name_index + l_index_posn;

      l_index_name := l_base_ix_name || l_name_index;

      return l_index_name;

    exception
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;

    end expected_ix_name;


  begin
    apex_debug.message(c_debug_template,'START'
                                       , 'p_index_name' , p_index_name
                                       , 'p_option' , p_option
                                       , 'p_schema_name' , p_schema_name
                                       );

    if l_option not in ('COMPLIANT_NAME', 'DDL')
    then
      process_error('Invalid option, ' || l_option || ', supplied. Expected "COMPLIANT_NAME" or "DDL"');
      return 'Invalid option, ' || l_option || ', supplied. Expected "COMPLIANT_NAME" or "DDL"';
    end if;


    begin
      select i.table_name, c.constraint_name, nvl(c.constraint_type, 'O'), a.table_abbreviation
        into l_table_name, l_constraint_name, l_constraint_type, l_table_abbreviation 
        from all_indexes             i
           , all_constraints         c
           , dev_table_abbreviations a
       where i.table_name        = c.table_name   (+)
         and i.owner             = c.owner        (+)
         and upper(i.index_name) = l_index_name /* indeces are not single-case*/
         and i.table_owner       = l_schema_name
         and a.schema_name       = l_schema_name
         and a.table_name        = i.table_name
         and i.index_name        = c.index_name   (+);

    exception
      when no_data_found then
        -- process_error('Invalid index name ' || l_index_name);
        return 'Invalid/non registered index name ' || l_index_name;
    end;

    if l_constraint_type in ('P')
    then
      l_compliant_ix_name := l_table_abbreviation || '_PK_IDX';
    elsif l_constraint_type in ('U')
    then
      l_compliant_ix_name := expected_uk_name ( p_table_name            => l_table_name         
                                              , p_current_constr_name   => l_constraint_name
                                              , p_option                => 'COMPLIANT_NAME'
                                              , p_schema_name           => l_schema_name) || '_IDX';


    elsif l_constraint_type = 'O'
    then
      l_compliant_ix_name := expected_ix_name ( p_table_name         => l_table_name
                                              , p_current_index_name => l_index_name
                                              , p_table_abbreviation => l_table_abbreviation
                                              , p_schema_name        => l_schema_name );

    end if;

    if l_option = 'COMPLIANT_NAME'
    then
      return l_compliant_ix_name;
    else
      return 'ALTER INDEX ' || l_index_name || ' RENAME TO ' ||  l_compliant_ix_name || ';';
    end if;

  end valid_index_name;

  function object_references ( p_object_name    in varchar2
                             , p_all_apps       in varchar2     := 'N' 
                             , p_first_row_only in varchar2     := 'N')
  return t_object_references pipelined deterministic
  is
    c_scope          constant varchar2(128)  := gc_scope_prefix || 'object_references';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    pragma udf;
    l_count            number           := 0;
    l_object_name       varchar2(4000)  := upper(p_object_name);
    c_object_ref_row   t_object_ref_row;
    l_via_object       user_objects.object_name%type;
    l_prev_level       number; 
    l_all_apps         varchar2(1)      := upper(p_all_apps);
    l_first_row_only   varchar2(1)      := upper(p_first_row_only);
    l_select_pattern   varchar2(250)    := '^.*[[:space:][:blank:]]*update[[:space:][:blank:]]+(["\.a-z_0-9]*).*';
    l_update_pattern   varchar2(250)    := '^.*[[:space:][:blank:]]*update[[:space:][:blank:]]+(["\.a-z_0-9]*).*';
  begin
    c_object_ref_row.search_object := l_object_name;

    for r in
      ( select  object_name, application_id, application_name, page_id, region_name, command_type
            from  v_dev_apex_table_references
        where ((to_number(application_id) between MIN_PROD_APP_ID and MAX_PROD_APP_ID and l_all_apps = 'N')  
                  or l_all_apps = 'Y')
        and   object_name = l_object_name)
    loop
      c_object_ref_row.referenced_by_name := r.application_name;
      c_object_ref_row.referenced_by_type := 'APEX';
      c_object_ref_row.application_id     := r.application_id;
      c_object_ref_row.command_type       := r.command_type;
      c_object_ref_row.supplementary      := 'Page id: ' || r.page_id || '; Region: ' || r.region_name;
      pipe row (c_object_ref_row);
      if l_first_row_only = 'Y'
      then
        raise no_data_needed;
      end if;
    end loop;

    for r in ( SELECT distinct a.referenced_owner, a.name AS referenced_object,
                      a.type,
                      a.referenced_link_name, level - 1  as separation
               FROM   all_dependencies a
               WHERE  a.owner NOT IN ('SYS','SYSTEM','PUBLIC')
               AND    a.referenced_owner NOT IN ('SYS','SYSTEM','PUBLIC')
               AND    a.referenced_type != 'NON-EXISTENT'
               START WITH a.referenced_owner = sys_context('userenv', 'current_schema')
               AND        a.referenced_name  = l_object_name
               CONNECT BY a.referenced_owner = PRIOR a.owner
               AND        a.referenced_name  = PRIOR a.name
               AND        a.referenced_type  = PRIOR a.type
             )
    loop
        c_object_ref_row.referenced_by_name := r.referenced_object;
        c_object_ref_row.referenced_by_type := r.type;
        c_object_ref_row.application_id     := null;
        c_object_ref_row.supplementary      := 'Level of separation: ' || r.separation;
        c_object_ref_row.command_type       := null;
        pipe row (c_object_ref_row);
        if l_first_row_only = 'Y'
        then
          raise no_data_needed;
        end if;
    end loop;
    exception
      when no_data_needed then raise;
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
  end object_references;

  function parse_sql ( p_sql_text         in clob )
  return varchar2
  is
    c_scope          constant varchar2(128)  := gc_scope_prefix || 'parse_sql';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_sql                 varchar2(32767)     := p_sql_text;
    l_feedback            clob                := null; 
    l_sqlcode             number;

  begin

    parse_sql ( p_sql_text => l_sql
              , p_feedback => l_feedback
              , p_sqlcode  => l_sqlcode );

    return l_feedback;

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;

  end parse_sql;

  procedure parse_sql(
                        p_sql_text     in clob
                      , p_feedback     out nocopy clob
                      , p_sqlcode      out number
                     )
  is
  c_scope          constant varchar2(128)  := gc_scope_prefix || 'parse_sql';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  value_error           exception;
  pragma exception_init(value_error, -6502);
  invalid_sql_stmt      exception;
  pragma exception_init(invalid_sql_stmt, -900);

  c_curs                number;
  n_ret_val             number;
  l_sql                 varchar2(32767);
  n_sql_error_pos       integer := 0;
  c_feedback            clob    := null;
  newln                 varchar2(2) := CHR(10); 

  begin

    l_sql := p_sql_text;
    c_curs := dbms_sql.open_cursor;

    begin 
        execute immediate 'alter session set cursor_sharing=force';
        dbms_sql.parse(c_curs, l_sql, dbms_sql.native);
        c_feedback := 'Parse succeeded!';
        execute immediate 'alter session set cursor_sharing=exact';
        p_sqlcode := 0;
    exception
      when invalid_sql_stmt then
          apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
          c_feedback := c_feedback || newln || 'Invalid SQL / DDL statement';
          p_sqlcode  := sqlcode;
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        n_sql_error_pos := dbms_sql.LAST_error_position;
        if n_sql_error_pos > 1
        then
          c_feedback := 'SQL error at character position ' || n_sql_error_pos;
          c_feedback := newln || c_feedback || newln || 'Parse error in SQL near:';
          c_feedback := c_feedback || newln || '=================================================';
          c_feedback := newln || newln || c_feedback || 
                                 substr(l_sql, n_sql_error_pos) || ' ';
          c_feedback := c_feedback ||  newln || '=================================================';
          c_feedback := newln || c_feedback || newln || sqlerrm;
        else
          c_feedback := c_feedback || newln || 'ERROR: ' 
                 || SQLCODE;
          c_feedback := newln || c_feedback || newln || sqlerrm;
        end if;
        p_sqlcode := sqlcode;
        raise;
    end;

    p_feedback := c_feedback;

    dbms_sql.close_cursor(c_curs);
  exception
    when others then
      c_feedback := sqlerrm;
  --    dbms_output.put_line(l_sql);
      dbms_sql.close_cursor(c_curs);
      p_sqlcode := sqlcode;
     apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;

  end parse_sql;

end dev_support_utils;
/