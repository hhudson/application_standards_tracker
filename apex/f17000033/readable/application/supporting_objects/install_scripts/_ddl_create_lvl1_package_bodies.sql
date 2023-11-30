  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STANDARDS_URGENCY_LEVEL_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STANDARDS_URGENCY_LEVEL_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-9 created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_standards_urgency_level.created%type := systimestamp;
  gc_user         constant svt_standards_urgency_level.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  function insert_ul (
        p_id            in svt_standards_urgency_level.id%type default null,
        p_urgency_level in svt_standards_urgency_level.urgency_level%type,
        p_urgency_name  in svt_standards_urgency_level.urgency_name%type
    ) return svt_standards_urgency_level.id%type
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'insert_ul';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    c_id constant svt_standards_urgency_level.id%type 
                  := coalesce(p_id, 
                              to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
    begin
      apex_debug.message(c_debug_template,'START',
                        'p_urgency_level', p_urgency_level,
                        'p_urgency_name', p_urgency_name
                        );
      insert into svt_standards_urgency_level
      (
        id,
        urgency_level,
        urgency_name,
        created,
        created_by,
        updated,
        updated_by
      )
      values 
      (
        c_id,
        p_urgency_level,
        p_urgency_name,
        gc_systimestamp,
        gc_user,
        gc_systimestamp,
        gc_user
      );
      apex_debug.message(c_debug_template,'c_id', c_id);
      return c_id;
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end insert_ul;
    procedure update_ul (
        p_id            in svt_standards_urgency_level.id%type,
        p_urgency_level in svt_standards_urgency_level.urgency_level%type,
        p_urgency_name  in svt_standards_urgency_level.urgency_name%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'update_ul';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id,
                                         'p_urgency_level', p_urgency_level,
                                         'p_urgency_name', p_urgency_name
                       );
      update svt_standards_urgency_level
      set urgency_level = p_urgency_level,
          urgency_name = p_urgency_name
      where id = p_id;
      apex_debug.info(c_debug_template, 'updated urgency_level', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end update_ul;
    procedure delete_ul (
        p_id in svt_standards_urgency_level.id%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'delete_ul';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );
     delete from svt_standards_urgency_level
     where id = p_id;
     apex_debug.info(c_debug_template, 'deleted urgency_level', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end delete_ul;
end SVT_STANDARDS_URGENCY_LEVEL_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STANDARD_VIEW" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_standard_view
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jan-24 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_y            constant varchar2(1) := 'Y';
  gc_n            constant varchar2(1) := 'N';
  ------------------------------------------------------------------------------
  -- v_svt_db_plsql identifiers
  ------------------------------------------------------------------------------
  type r_v_svt_db_plsql is record (
    pass_yn        varchar2(1 char),
    object_name    varchar2(128 char),
    schema         varchar2(128 char),
    code           varchar2(5000 char),
    object_type    varchar2(19 char),
    line           number,
    unqid          varchar2(5000 char)
  );
  type t_v_svt_db_plsql is table of r_v_svt_db_plsql index by pls_integer;
  l_v_svt_db_plsql t_v_svt_db_plsql;
  gc_db_plsql_select_stmt constant varchar2(100) := 'select pass_yn, schema, object_name, code, object_type, line, unqid from (';
  gc_v_svt_db_plsql_nt constant svt_nested_table_types.nt_name%type:= 'v_svt_db_plsql_nt';
  
  ------------------------------------------------------------------------------
  -- v_svt_apex identifiers
  ------------------------------------------------------------------------------
  type r_v_svt_apex is record (
    pass_yn                    varchar2(1 char),
    application_id             number,
    page_id                    number,
    created_by                 varchar2(1020 char),
    created_on                 date,
    last_updated_by            varchar2(1020 char),
    last_updated_on            date,
    validation_failure_message varchar2(15000 char),
    issue_title                varchar2(5000 char),
    component_id               number,
    parent_component_id        number,
    workspace                  varchar2(255)
  );
  type t_v_svt_apex is table of r_v_svt_apex index by pls_integer;
  l_v_svt_apex t_v_svt_apex;
  gc_apex_select_stmt constant varchar2(255) 
    := 'select pass_yn, application_id, page_id, created_by, created_on, last_updated_by, last_updated_on, validation_failure_message, issue_title, component_id, parent_component_id, workspace from (';
  gc_v_svt_apex_nt  constant svt_nested_table_types.nt_name%type:= 'v_svt_apex__0_nt';
  ------------------------------------------------------------------------------
  -- v_svt_db_view__0 identifiers
  ------------------------------------------------------------------------------
  type r_v_svt_db_view__0 is record (
    pass_yn    varchar2(1),
    schema     varchar2(128),
    view_name  varchar2(128),
    code       varchar2(1000 char),
    unqid      varchar2(5000 char)
  );
  type t_v_svt_db_view__0 is table of r_v_svt_db_view__0 index by pls_integer;
  l_v_svt_db_view__0 t_v_svt_db_view__0;
  gc_view_select_stmt constant varchar2(255) := 'select pass_yn, schema, view_name, code, unqid from (';
  gc_v_svt_db_view__0_nt  constant svt_nested_table_types.nt_name%type:= 'v_svt_db_view__0_nt';
  
  ------------------------------------------------------------------------------
  -- v_svt_db_mv__0 identifiers
  ------------------------------------------------------------------------------
  type r_v_svt_db_mv__0 is record (
    pass_yn    varchar2(1),
    schema     varchar2(128),
    mv_name    varchar2(128),
    code       varchar2(1000 char),
    unqid      varchar2(5000 char)
  );
  type t_v_svt_db_mv__0 is table of r_v_svt_db_mv__0 index by pls_integer;
  l_v_svt_db_mv__0 t_v_svt_db_mv__0;
  gc_mv_select_stmt constant varchar2(255) := 'select pass_yn, schema, mv_name, code, unqid from (';
  gc_v_svt_db_mv__0_nt  constant svt_nested_table_types.nt_name%type:= 'v_svt_db_mv__0_nt';
  
  ------------------------------------------------------------------------------
  -- v_svt_db_trigger__0 identifiers
  ------------------------------------------------------------------------------
  type r_v_svt_db_trigger__0 is record (
    pass_yn         varchar2(1),
    schema          varchar2(128),
    trigger_name    varchar2(128),
    code            varchar2(1000 char),
    unqid           varchar2(5000 char)
  );
  type t_v_svt_db_trigger__0 is table of r_v_svt_db_trigger__0 index by pls_integer;
  l_v_svt_db_trigger__0 t_v_svt_db_trigger__0;
  gc_trigger_select_stmt constant varchar2(255) := 'select pass_yn, schema, trigger_name, code, unqid from (';
  gc_v_svt_db_trigger__0_nt  constant svt_nested_table_types.nt_name%type:= 'v_svt_db_trigger__0_nt';
  ------------------------------------------------------------------------------
  -- v_svt_db_tbl__0 identifiers
  ------------------------------------------------------------------------------
  type r_v_svt_db_tbl__0 is record (
    pass_yn     varchar2(1 char),
    schema      varchar2(128 char),
    table_name  varchar2(128 char),
    unqid       varchar2(250 char),
    code        varchar2(1000 char),
    object_id   number
  );
  type t_v_svt_db_tbl__0 is table of r_v_svt_db_tbl__0 index by pls_integer;
  l_v_svt_db_tbl__0 t_v_svt_db_tbl__0;
  gc_tbl_select_stmt constant varchar2(255) := 'select pass_yn, schema, table_name, unqid, code, object_id from (';
  gc_v_svt_db_tbl__0_nt  constant svt_nested_table_types.nt_name%type:= 'v_svt_db_tbl__0_nt';
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 30, 2023
-- Synopsis:
--
-- private function to determine whether a function is urgent
--
------------------------------------------------------------------------------
    function standard_is_urgent (p_test_code in svt_stds_standard_tests.test_code%type) 
    return boolean 
    deterministic 
    result_cache
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'standard_is_urgent';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_max_urgency constant number := 40;
    l_is_urgent_yn varchar2(1) := gc_y;
    begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
      select case when count(*) = 1
                        then gc_y
                        else gc_n
                        end into l_is_urgent_yn
                from sys.dual where exists (
                    select * 
                    from svt_stds_standard_tests rc 
                    inner join svt_standards_urgency_level ul on ul.id = rc.level_id
                                                              and ul.urgency_level <= c_max_urgency
                    where rc.test_code = upper(p_test_code)
                );
      apex_debug.message(c_debug_template, 'l_is_urgent_yn', l_is_urgent_yn);
      return case when l_is_urgent_yn = gc_y
                  then true 
                  else false 
                  end;
    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end standard_is_urgent;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 25, 2023
-- Synopsis:
--
-- private function to get the query clob for a given test code 
--
------------------------------------------------------------------------------
  function get_query_clob (p_test_code     in svt_stds_standard_tests.test_code%type,
                           p_nt_name       in svt_nested_table_types.nt_name%type,
                           p_select_stmt   in varchar2
  ) return svt_stds_standard_tests.query_clob%type 
  deterministic
  is
  c_scope          constant varchar2(128)  := gc_scope_prefix || 'get_query_clob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_query_clob svt_stds_standard_tests.query_clob%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_code', p_test_code,
                                        'p_nt_name', p_nt_name,
                                        'p_select_stmt', p_select_stmt);
    select p_select_stmt||esst.query_clob||') mydata'
    into l_query_clob
    from svt_stds_standard_tests esst
    inner join svt_component_types act on esst.svt_component_type_id = act.id
    inner join svt_nested_table_types antt on act.nt_type_id = antt.id 
                                           and lower(antt.nt_name) = p_nt_name
    where esst.test_code = p_test_code
    and esst.query_clob is not null
    --and esst.active_yn = gc_y
    ;
    return l_query_clob;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_query_clob;
  function v_svt_db_plsql(p_test_code     in svt_stds_standard_tests.test_code%type,
                          p_failures_only in varchar2 default 'N',
                          p_object_name   in svt_plsql_apex_audit.object_name%type default null)
  return v_svt_db_plsql_ref_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_db_plsql';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cur_v_svt_db_plsql sys_refcursor;
  l_query_clob svt_stds_standard_tests.query_clob%type;
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_code', p_test_code,
                                        'p_failures_only', p_failures_only,
                                        'p_object_name', p_object_name,
                                        'current_user', sys_context('userenv', 'current_user'));
    l_query_clob := get_query_clob (p_test_code   => p_test_code,
                                    p_nt_name     => gc_v_svt_db_plsql_nt,
                                    p_select_stmt => gc_db_plsql_select_stmt);
    l_query_clob := l_query_clob||q'[ where 1=1]';
    l_query_clob := case when p_failures_only = gc_y
                         then l_query_clob||q'[ and pass_yn = 'N']'
                         else l_query_clob 
                         end;
    l_query_clob := case when p_object_name is not null
                         then l_query_clob||apex_string.format(q'[ and object_name = '%s']', p_object_name)
                         else l_query_clob 
                         end;
    open cur_v_svt_db_plsql for l_query_clob;
    loop
      fetch cur_v_svt_db_plsql bulk collect into l_v_svt_db_plsql limit 1000;
      exit when l_v_svt_db_plsql.count = 0;
      for rec in 1 .. l_v_svt_db_plsql.count
      loop
        pipe row (v_svt_db_plsql_ref_ot (
                      l_v_svt_db_plsql (rec).pass_yn,
                      l_v_svt_db_plsql (rec).schema,
                      l_v_svt_db_plsql (rec).object_name,
                      l_v_svt_db_plsql (rec).object_type,
                      l_v_svt_db_plsql (rec).line,
                      l_v_svt_db_plsql (rec).code,
                      l_v_svt_db_plsql (rec).unqid,
                      c_test_code
                    )
                );
      end loop;
    end loop;  
  exception 
    when e_missing_field then
      apex_debug.error(p_message => c_debug_template, p0 =>'Missing field in SQL Query: ', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise_application_error(-20904, 'Missing field in SQL Query: '||sqlerrm);
    when no_data_found then
      apex_debug.error(c_debug_template, 'no data found for test code', p_test_code);
      raise;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt_db_plsql;
  function v_svt_apex(p_test_code            in svt_stds_standard_tests.test_code%type,
                      p_failures_only        in varchar2 default 'N',
                      p_production_apps_only in varchar2 default 'N',
                      p_application_id       in svt_plsql_apex_audit.application_id%type default null,
                      p_page_id              in svt_plsql_apex_audit.page_id%type default null)
  return v_svt_apex_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_apex';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cur_v_svt_apex sys_refcursor;
  l_query_clob svt_stds_standard_tests.query_clob%type;
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_code', p_test_code,
                                        'p_failures_only', p_failures_only,
                                        'p_application_id', p_application_id,
                                        'p_page_id', p_page_id,
                                        'p_production_apps_only', p_production_apps_only);
    l_query_clob := get_query_clob (p_test_code   => c_test_code,
                                    p_nt_name     => gc_v_svt_apex_nt,
                                    p_select_stmt => gc_apex_select_stmt);
    l_query_clob := case when p_production_apps_only = gc_y
                         then l_query_clob||q'[ inner join v_svt_stds_applications esa on mydata.application_id  = esa.apex_app_id ]'
                         else l_query_clob 
                         end;
    l_query_clob := case when p_failures_only = gc_y
                         then l_query_clob||q'[ where pass_yn = 'N']'
                         else l_query_clob||' where 1=1 '
                         end;
    
    l_query_clob := case when p_application_id is not null
                         then l_query_clob||' and application_id = '||p_application_id
                         else l_query_clob 
                         end;
    l_query_clob := case when p_page_id is not null
                         then l_query_clob||' and page_id = '||p_page_id
                         else l_query_clob 
                         end;
    open cur_v_svt_apex for l_query_clob;
    loop
      fetch cur_v_svt_apex bulk collect into l_v_svt_apex limit 1000;
      exit when l_v_svt_apex.count = 0;
      for rec in 1 .. l_v_svt_apex.count
      loop
        pipe row (v_svt_apex_ot (
                      l_v_svt_apex (rec).pass_yn,
                      l_v_svt_apex (rec).application_id||
                      case when l_v_svt_apex (rec).parent_component_id is not null 
                           then ':'||l_v_svt_apex (rec).parent_component_id||':'||l_v_svt_apex (rec).component_id
                           else case when  l_v_svt_apex (rec).component_id != l_v_svt_apex (rec).application_id
                                     then ':'||l_v_svt_apex (rec).component_id
                                     end
                           end,
                      l_v_svt_apex (rec).application_id,
                      l_v_svt_apex (rec).page_id,
                      l_v_svt_apex (rec).created_by,
                      l_v_svt_apex (rec).created_on,
                      l_v_svt_apex (rec).last_updated_by,
                      l_v_svt_apex (rec).last_updated_on,
                      l_v_svt_apex (rec).validation_failure_message,
                      l_v_svt_apex (rec).issue_title,
                      c_test_code,
                      l_v_svt_apex (rec).component_id,
                      l_v_svt_apex (rec).parent_component_id,
                      l_v_svt_apex (rec).workspace
                    )
                );
      end loop;
    end loop;  
  exception 
    when no_data_needed then
      apex_debug.message(c_debug_template, 'No data needed');
    when e_missing_field then
      apex_debug.error(p_message => c_debug_template, p0 =>'Missing field in SQL Query: ', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise_application_error(-20904, 'Missing field in SQL Query: '||sqlerrm);
    when no_data_found then
      apex_debug.error(c_debug_template, 'no data found for test code', p_test_code);
      raise;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt_apex;
  function v_svt_db_view__0(p_test_code     in svt_stds_standard_tests.test_code%type,
                            p_failures_only in varchar2 default 'N')
  return v_svt_db_view__0_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_db_view__0';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cur_v_svt_db_view__0 sys_refcursor;
  l_query_clob svt_stds_standard_tests.query_clob%type;
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_code', p_test_code,
                                        'p_failures_only', p_failures_only);
    l_query_clob := get_query_clob (p_test_code   => c_test_code,
                                    p_nt_name     => gc_v_svt_db_view__0_nt,
                                    p_select_stmt => gc_view_select_stmt);
    l_query_clob := case when p_failures_only = gc_y
                         then l_query_clob||q'[ where pass_yn = 'N']'
                         else l_query_clob 
                         end;  
    open cur_v_svt_db_view__0 for l_query_clob;
    loop
      fetch cur_v_svt_db_view__0 bulk collect into l_v_svt_db_view__0 limit 1000;
      exit when l_v_svt_db_view__0.count = 0;
      for rec in 1 .. l_v_svt_db_view__0.count
      loop
        pipe row (v_svt_db_view__0_ot (
                      l_v_svt_db_view__0 (rec).pass_yn,
                      l_v_svt_db_view__0 (rec).schema,
                      l_v_svt_db_view__0 (rec).view_name,
                      l_v_svt_db_view__0 (rec).code,
                      l_v_svt_db_view__0 (rec).unqid
                    )
                );
      end loop;
    end loop;  
  exception 
    when e_missing_field then
      apex_debug.error(p_message => c_debug_template, p0 =>'Missing field in SQL Query: ', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise_application_error(-20904, 'Missing field in SQL Query: '||sqlerrm);
    when no_data_found then
      apex_debug.error(c_debug_template, 'no data found for test code', p_test_code);
      raise;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt_db_view__0;
  function v_svt_db_tbl__0(p_test_code     in svt_stds_standard_tests.test_code%type,
                           p_failures_only in varchar2 default 'N')
  return v_svt_db_tbl__0_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_db_tbl__0';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cur_v_svt_db_tbl__0 sys_refcursor;
  l_query_clob svt_stds_standard_tests.query_clob%type;
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_code', p_test_code,
                                        'p_failures_only', p_failures_only);
    l_query_clob := get_query_clob (p_test_code   => c_test_code,
                                    p_nt_name     => gc_v_svt_db_tbl__0_nt,
                                    p_select_stmt => gc_tbl_select_stmt);
    l_query_clob := case when p_failures_only = gc_y
                         then l_query_clob||q'[ where pass_yn = 'N']'
                         else l_query_clob 
                         end;  
    open cur_v_svt_db_tbl__0 for l_query_clob;
    loop
      fetch cur_v_svt_db_tbl__0 bulk collect into l_v_svt_db_tbl__0 limit 1000;
      exit when l_v_svt_db_tbl__0.count = 0;
      for rec in 1 .. l_v_svt_db_tbl__0.count
      loop
        pipe row (v_svt_db_tbl__0_ot (
                      l_v_svt_db_tbl__0 (rec).pass_yn,
                      l_v_svt_db_tbl__0 (rec).schema,
                      l_v_svt_db_tbl__0 (rec).table_name,
                      l_v_svt_db_tbl__0 (rec).unqid,
                      l_v_svt_db_tbl__0 (rec).code,
                      l_v_svt_db_tbl__0 (rec).object_id
                    )
                );
      end loop;
    end loop;  
  exception 
    when e_missing_field then
      apex_debug.error(p_message => c_debug_template, p0 =>'Missing field in SQL Query: ', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise_application_error(-20904, 'Missing field in SQL Query: '||sqlerrm);
    when no_data_found then
      apex_debug.error(c_debug_template, 'no data found for test code', p_test_code);
      raise;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt_db_tbl__0;
  function v_svt(p_test_code            in svt_stds_standard_tests.test_code%type,
                 p_failures_only        in varchar2 default 'N',
                 p_urgent_only          in varchar2 default 'N',
                 p_production_apps_only in varchar2 default 'N',
                 p_unqid                in svt_plsql_apex_audit.unqid%type default null,
                 p_audit_id             in svt_plsql_apex_audit.id%type default null,
                 p_application_id       in svt_plsql_apex_audit.application_id%type default null,
                 p_page_id              in svt_plsql_apex_audit.page_id%type default null
                 )
  return v_svt_plsql_apex__0_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  
  cur_v_svt sys_refcursor;
  l_query_clob svt_stds_standard_tests.query_clob%type;
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  c_apex      constant varchar2(4) := 'APEX';
  ------------------------------------------------------------------------------
  -- v_svt_plsql_apex__0 identifiers
  ------------------------------------------------------------------------------
  type r_v_svt_plsql_apex__0 is record (
    unqid                      varchar2(1000 char),
    issue_category             varchar2(8),
    application_id             number,
    page_id                    number,
    pass_yn                    varchar2(1 char),
    line                       number,
    schema                     varchar2(128 char),
    object_name                varchar2(128 char),
    object_type                varchar2(76),
    code                       varchar2(5000 char),
    validation_failure_message varchar2(32767),
    issue_title                varchar2(32767),
    apex_created_by            varchar2(1020 char),
    apex_created_on            date,
    apex_last_updated_by       varchar2(4080),
    apex_last_updated_on       date,
    test_code                  varchar2(100),
    component_id               number,
    parent_component_id        number
  );
  type t_v_svt_plsql_apex__0 is table of r_v_svt_plsql_apex__0 index by pls_integer;
  l_v_svt_plsql_apex__0 t_v_svt_plsql_apex__0;
  c_failure_predicate constant varchar2(31) := q'[ and pass_yn = 'N']';
  c_unqid constant svt_plsql_apex_audit.unqid%type := 
                                             case when p_unqid is not null 
                                                  then p_unqid 
                                                  when p_audit_id is not null 
                                                  then svt_plsql_apex_audit_api.get_unqid(p_audit_id => p_audit_id)
                                                  end;
  l_unqid_predicate varchar2(1200) := apex_string.format(q'^ and unqid = '%s' ^', c_unqid);
  c_nt_name        constant svt_nested_table_types.nt_name%type
                   :=  svt_stds_standard_tests_api.nt_name(p_test_code => c_test_code);
  c_issue_category constant svt_plsql_apex_audit.issue_category%type 
                   :=  svt_nested_table_types_api.issue_category(p_nt_name => c_nt_name);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'current_user', sys_context('userenv', 'current_user'),
                                        'p_test_code', p_test_code,
                                        'p_failures_only', p_failures_only,
                                        'p_urgent_only', p_urgent_only,
                                        'p_production_apps_only', p_production_apps_only,
                                        'p_unqid', p_unqid,
                                        'p_audit_id', p_audit_id,
                                        'p_application_id', p_application_id,
                                        'p_page_id',p_page_id);
    apex_debug.message(c_debug_template, 'l_unqid_predicate :', l_unqid_predicate);
    if c_nt_name = gc_v_svt_db_plsql_nt then
      l_query_clob := get_query_clob (
        p_test_code => c_test_code,
        p_nt_name => c_nt_name,
        p_select_stmt => apex_string.format(
                          q'[select unqid,
                                   '%0' issue_category,
                                   null application_id,
                                   null page_id,
                                   pass_yn,
                                   line,
                                   schema,
                                   object_name,
                                   object_type,
                                   code,
                                   code validation_failure_message,
                                   case when code is not null 
                                        then object_name||': '||code 
                                        else object_name 
                                        end issue_title,
                                   null apex_created_by,
                                   null apex_created_on,
                                   null apex_last_updated_by,
                                   null apex_last_updated_on,
                                   null test_code,
                                   null component_id,
                                   null parent_component_id
                          from (]',
                          p0 => c_issue_category)
      );
    elsif c_nt_name = gc_v_svt_db_view__0_nt then 
      l_query_clob := get_query_clob (
        p_test_code => c_test_code,
        p_nt_name => c_nt_name,
        p_select_stmt => apex_string.format(
                          q'[select unqid,
                                   '%0' issue_category,
                                   null application_id,
                                   null page_id,
                                   pass_yn,
                                   1 line,
                                   schema,
                                   view_name object_name,
                                   'VIEW' object_type,
                                   code,
                                   code validation_failure_message,
                                   view_name issue_title,
                                   null apex_created_by,
                                   null apex_created_on,
                                   null apex_last_updated_by,
                                   null apex_last_updated_on,
                                   null test_code,
                                   null component_id,
                                   null parent_component_id
                          from (]',
                          p0 => c_issue_category)
      );
      l_unqid_predicate := apex_string.format(q'^ and '%0:'||unqid = '%1' ^', c_test_code, c_unqid);
    elsif c_nt_name = gc_v_svt_db_mv__0_nt then 
      l_query_clob := get_query_clob (
        p_test_code => c_test_code,
        p_nt_name => c_nt_name,
        p_select_stmt => apex_string.format(
                          q'[select unqid,
                                   '%0' issue_category,
                                   null application_id,
                                   null page_id,
                                   pass_yn,
                                   1 line,
                                   schema,
                                   mv_name object_name,
                                   'MATERIALIZED VIEW' object_type,
                                   code,
                                   code validation_failure_message,
                                   mv_name issue_title,
                                   null apex_created_by,
                                   null apex_created_on,
                                   null apex_last_updated_by,
                                   null apex_last_updated_on,
                                   null test_code,
                                   null component_id,
                                   null parent_component_id
                          from (]',
                          p0 => c_issue_category)
      );
      l_unqid_predicate := apex_string.format(q'^ and '%0:'||unqid = '%1' ^', c_test_code, c_unqid);
    elsif c_nt_name = gc_v_svt_db_trigger__0_nt then 
      l_query_clob := get_query_clob (
        p_test_code => c_test_code,
        p_nt_name => c_nt_name,
        p_select_stmt => apex_string.format(
                          q'[select unqid,
                                   '%0' issue_category,
                                   null application_id,
                                   null page_id,
                                   pass_yn,
                                   1 line,
                                   schema,
                                   trigger_name object_name,
                                   'TRIGGER' object_type,
                                   code,
                                   code validation_failure_message,
                                   trigger_name issue_title,
                                   null apex_created_by,
                                   null apex_created_on,
                                   null apex_last_updated_by,
                                   null apex_last_updated_on,
                                   null test_code,
                                   null component_id,
                                   null parent_component_id
                          from (]',
                          p0 => c_issue_category)
      );
      l_unqid_predicate := apex_string.format(q'^ and '%0:'||unqid = '%1' ^', c_test_code, c_unqid);
    elsif c_nt_name = gc_v_svt_db_tbl__0_nt then 
      l_query_clob := get_query_clob (
        p_test_code => c_test_code,
        p_nt_name => c_nt_name,
        p_select_stmt => apex_string.format(
                          q'[select unqid,
                                   '%0' issue_category,
                                   null application_id,
                                   null page_id,
                                   pass_yn,
                                   1 line,
                                   schema,
                                   table_name object_name,
                                   'TABLE' object_type,
                                   code,
                                   code validation_failure_message,
                                   code issue_title,
                                   null apex_created_by,
                                   null apex_created_on,
                                   null apex_last_updated_by,
                                   null apex_last_updated_on,
                                   null test_code,
                                   object_id component_id,
                                   null parent_component_id
                          from (]',
                          p0 => c_issue_category)
      );
      l_unqid_predicate := apex_string.format(q'^ and '%0:'||unqid = '%1' ^', c_test_code, c_unqid);
    elsif c_nt_name = gc_v_svt_apex_nt then
      l_query_clob := get_query_clob (
        p_test_code => c_test_code,
        p_nt_name => c_nt_name,
        p_select_stmt => apex_string.format(
                          q'[select application_id||
                                   case when parent_component_id is not null 
                                        then ':'||parent_component_id||':'||component_id
                                        else case when  component_id != application_id
                                                  then ':'||component_id
                                                  end
                                        end unqid,
                                   '%0' issue_category,
                                   application_id,
                                   page_id,
                                   pass_yn,
                                   0 line,
                                   null schema,
                                   null object_name,
                                   null object_type,
                                   null code,
                                   validation_failure_message,
                                   issue_title,
                                   case when created_by not in ('ORDS_PUBLIC_USER',svt_preferences.get('SVT_DEFAULT_SCHEMA'))
                                        then created_by
                                        end apex_created_by,
                                   created_on apex_created_on,
                                   case when last_updated_by not in ('ORDS_PUBLIC_USER',svt_preferences.get('SVT_DEFAULT_SCHEMA'))
                                        then last_updated_by
                                        end apex_last_updated_by,
                                   last_updated_on apex_last_updated_on,
                                   null test_code,
                                   component_id,
                                   parent_component_id
                          from (]',
                          p0 => c_issue_category)
      );
      l_query_clob := case when p_production_apps_only = gc_y
                           then l_query_clob||q'[ inner join v_svt_stds_applications esa on mydata.application_id  = esa.apex_app_id ]'
                           else l_query_clob 
                           end;
      -- l_unqid_predicate := apex_string.format(q'^ and application_id||case when parent_component_id is not null then ':'||parent_component_id||':'||component_id else case when  component_id != application_id then ':'||component_id end end = '%s' ^', c_unqid);
      l_unqid_predicate := apex_string.format(q'^ and '%0:'||application_id||
                                                      case when parent_component_id is not null 
                                                           then ':'||parent_component_id||':'||component_id
                                                           else case when  component_id != application_id
                                                                     then ':'||component_id
                                                                     end
                                                           end = '%1' ^', c_test_code, c_unqid);
    else 
      raise_application_error(-20123,'unknown nt type');
    end if;
    apex_debug.message(c_debug_template, 'l_unqid_predicate :', l_unqid_predicate);
    
    <<addl_predicates>>
    declare
    l_addl_predicates varchar2(2000);
    begin
      l_addl_predicates :=' where 1=1 '
                          ||case  when p_urgent_only = gc_y
                                  then case when not standard_is_urgent(c_test_code)
                                            then ' and 1=2 '
                                            end 
                                  end
                          || case when p_failures_only = gc_y
                                  then c_failure_predicate
                                  end
                          || case when c_unqid is not null
                                  then l_unqid_predicate
                                  end
                          || case when c_issue_category = c_apex 
                                  and p_application_id is not null 
                                  then ' and application_id = '||p_application_id
                                  end
                          || case when c_issue_category = c_apex 
                                  and  p_page_id is not null 
                                  then ' and page_id = '||p_page_id
                                  end;
      apex_debug.message(c_debug_template, 'l_addl_predicates :', l_addl_predicates);
      l_query_clob := l_query_clob||l_addl_predicates;
      for rec in (
        select column_value query_segment
        from table(apex_string.split( l_query_clob, chr(10)))
      )
      loop
        apex_debug.message(c_debug_template, 'l_query_clob :', rec.query_segment);
      end loop;
    end addl_predicates;
    open cur_v_svt for l_query_clob;
    loop
      fetch cur_v_svt bulk collect into l_v_svt_plsql_apex__0 limit 1000;
      apex_debug.message(c_debug_template, 'l_v_svt_plsql_apex__0.count', l_v_svt_plsql_apex__0.count);
      exit when l_v_svt_plsql_apex__0.count = 0;
      for rec in 1 .. l_v_svt_plsql_apex__0.count
      loop
        pipe row (v_svt_plsql_apex__0_ot (
                    c_test_code||':'||l_v_svt_plsql_apex__0 (rec).unqid,
                    l_v_svt_plsql_apex__0 (rec).issue_category,
                    l_v_svt_plsql_apex__0 (rec).application_id,
                    l_v_svt_plsql_apex__0 (rec).page_id,
                    l_v_svt_plsql_apex__0 (rec).pass_yn,
                    l_v_svt_plsql_apex__0 (rec).line,
                    l_v_svt_plsql_apex__0 (rec).schema,
                    l_v_svt_plsql_apex__0 (rec).object_name,
                    l_v_svt_plsql_apex__0 (rec).object_type,
                    l_v_svt_plsql_apex__0 (rec).code,
                    case when l_v_svt_plsql_apex__0 (rec).pass_yn = gc_n
                         then l_v_svt_plsql_apex__0 (rec).validation_failure_message
                         end,
                    case when l_v_svt_plsql_apex__0 (rec).pass_yn = gc_n
                         then l_v_svt_plsql_apex__0 (rec).issue_title
                         end,
                    l_v_svt_plsql_apex__0 (rec).apex_created_by,
                    l_v_svt_plsql_apex__0 (rec).apex_created_on,
                    l_v_svt_plsql_apex__0 (rec).apex_last_updated_by,
                    l_v_svt_plsql_apex__0 (rec).apex_last_updated_on,
                    c_test_code,
                    l_v_svt_plsql_apex__0 (rec).component_id,
                    l_v_svt_plsql_apex__0 (rec).parent_component_id
                  )
                );
      end loop;
    end loop;  
    close cur_v_svt;
  exception 
    when e_table_or_view_does_not_exist then 
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'Unknown table or view: ', 
                       p1 => sqlerrm, 
                       p2 => c_test_code,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
      raise_application_error(-20904, 'Error processing ' ||c_test_code|| ': '||sqlerrm);
    when no_data_needed then 
      close cur_v_svt;
    when e_missing_field then
      apex_debug.error(p_message => c_debug_template, p0 =>'Missing field in SQL Query: ', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise_application_error(-20904, 'Missing field in SQL Query: '||sqlerrm||' ['||p_test_code||']');
    when e_buffer2small then
      apex_debug.error(p_message => c_debug_template, p0 =>'Buffer 2 small for SQL Query: ', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise_application_error(-20905, 'Buffer 2 small for SQL Query: '||sqlerrm||' ['||p_test_code||']');
    when no_data_found then
      apex_debug.warn(c_debug_template,'no data found for test code', p_test_code);
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- private function to return the name of a nest table type id
--
------------------------------------------------------------------------------
  function get_nt_type_name (p_nt_type_id in svt_nested_table_types.id%type) return svt_nested_table_types.nt_name%type
  is
  c_scope          constant varchar2(128)  := gc_scope_prefix || 'get_nt_type_name';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 
  l_nt_name svt_nested_table_types.nt_name%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_nt_type_id', p_nt_type_id);
    select lower(nt_name)
    into l_nt_name
    from svt_nested_table_types
    where id = p_nt_type_id;
    return l_nt_name;
  exception 
    when no_data_found then
      apex_debug.error(c_debug_template, 'p_nt_type_id no_data_found', p_nt_type_id);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_nt_type_name;
  function get_nt_type_id (p_nt_name in svt_nested_table_types.nt_name%type) return svt_nested_table_types.id%type
  is
  c_scope          constant varchar2(128)  := gc_scope_prefix || 'get_nt_type_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 
  l_id svt_nested_table_types.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_nt_name', p_nt_name);
    select id
    into l_id
    from svt_nested_table_types
    where lower(nt_name) = lower(p_nt_name);
    return l_id;
  exception 
    when no_data_found then
      apex_debug.error(c_debug_template, 'p_nt_name no_data_found', p_nt_name);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_nt_type_id;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 22, 2023
-- Synopsis:
--
-- Function to improve the human-readability of error messages
--
------------------------------------------------------------------------------
  function improve_error_msg (
                      p_sqlcode in number,
                      p_sqlerrm in varchar2) 
  return varchar2
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'improve_error_msg';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_code_excerpt varchar2(100);
  l_error_explanation varchar2(400);
  l_better_error_msg varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_sqlcode', p_sqlcode,
                                        'p_sqlerrm', p_sqlerrm);
    l_code_excerpt := replace(replace(p_sqlerrm, 'ORA-00'||gc_missing_field*-1||': "'), '": invalid identifier');
    l_error_explanation := case when l_code_excerpt = 'PASS_YN'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[The PASS_YN field should return 'N' or 'Y' to indicate the existence of a violation]')
                                when l_code_excerpt = 'APPLICATION_ID'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[This field specifies the application id where the violation occurs]')
                                when l_code_excerpt = 'PAGE_ID'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[This field specifies the page id where the violation occurs]')
                                when l_code_excerpt like '%_BY'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[This field, when available, audits the author of the violation. Provide `null` if unavailable.]')
                                when l_code_excerpt like '%_ON'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[This field, when available, audits the date of the violation. Provide `null` if unavailable.]')
                                when l_code_excerpt = 'ISSUE_TITLE'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[This field is used as a succinct summary. It is referenced in the Audit email and as the title of the APEX Issue (if turned on). Try to make it as unique as possible.]')
                                when l_code_excerpt = 'VALIDATION_FAILURE_MESSAGE'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[This field provides a detailed description of the error.]')
                                when l_code_excerpt = 'COMPONENT_ID'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[This field provides the Primary Key of the underlying component type. Many things depend on this being provided.]')
                                when l_code_excerpt = 'PARENT_COMPONENT_ID'
                                then apex_string.format('<ul><li>%s</li></ul>', q'[This field provides the parent primary key of the underlying component type]')
                                end;
    l_better_error_msg := case when p_sqlcode = gc_missing_field
                               then case when l_code_excerpt like '%.%'
                                         then 'Your query has an error: '||p_sqlerrm
                                         else 'Your query is missing a required field : '||l_code_excerpt
                                         end
                               when p_sqlcode = gc_inconsistent_data_types
                               then 'Your query has inconsistent data types : '|| p_sqlerrm
                               when p_sqlcode = gc_table_or_view_does_not_exist
                               then 'A table/view in your query does not exist : '||p_sqlerrm
                               else p_sqlerrm
                               end
                          ||l_error_explanation;
    return l_better_error_msg;
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end improve_error_msg;
  function query_feedback (p_query_code            in svt_stds_standard_tests.query_clob%type,
                           p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type)
  return varchar2
  is 
  c_scope          constant varchar2(128)  := gc_scope_prefix || 'query_feedback';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_nt_type_id svt_nested_table_types.id%type;
  cur_query sys_refcursor;
  l_error   varchar2(100);
  begin
    apex_debug.message(c_debug_template,'START', 'p_svt_component_type_id', p_svt_component_type_id);
    select nt_type_id
    into l_nt_type_id
    from svt_component_types
    where id = p_svt_component_type_id;
    if p_query_code is not null  and l_nt_type_id is not null then
      if get_nt_type_name (l_nt_type_id) =  gc_v_svt_db_plsql_nt then
        open cur_query for gc_db_plsql_select_stmt||p_query_code||')';
        fetch cur_query bulk collect into l_v_svt_db_plsql limit 1;
      elsif get_nt_type_name (l_nt_type_id) =  gc_v_svt_apex_nt then
        open cur_query for gc_apex_select_stmt||p_query_code||')';
        fetch cur_query bulk collect into l_v_svt_apex limit 1;
      elsif get_nt_type_name (l_nt_type_id) =  gc_v_svt_db_view__0_nt then
        open cur_query for gc_view_select_stmt||p_query_code||')';
        fetch cur_query bulk collect into l_v_svt_db_view__0 limit 1;
      elsif get_nt_type_name (l_nt_type_id) =  gc_v_svt_db_mv__0_nt then
        open cur_query for gc_mv_select_stmt||p_query_code||')';
        fetch cur_query bulk collect into l_v_svt_db_mv__0 limit 1;
      elsif get_nt_type_name (l_nt_type_id) =  gc_v_svt_db_trigger__0_nt then
        open cur_query for gc_trigger_select_stmt||p_query_code||')';
        fetch cur_query bulk collect into l_v_svt_db_trigger__0 limit 1;
      elsif get_nt_type_name (l_nt_type_id) =  gc_v_svt_db_tbl__0_nt then
        open cur_query for gc_tbl_select_stmt||p_query_code||')';
        fetch cur_query bulk collect into l_v_svt_db_tbl__0 limit 1;
      else 
        l_error := 'Unrecognized nested table type';
      end if;
    end if;
    return l_error;
  exception 
    when e_inconsistent_data_types 
      or e_table_or_view_does_not_exist 
      or e_missing_field
      or e_missing_expression
      or e_ambiguous_column               
    then return improve_error_msg (p_sqlcode => sqlcode,
                                   p_sqlerrm => sqlerrm);
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end query_feedback;
end SVT_STANDARD_VIEW;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_TEST_TIMING_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_test_timing_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-9 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  procedure insert_timing(p_test_code in svt_test_timing.test_code%type,
                          p_seconds   in svt_test_timing.elapsed_seconds%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_timing';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    insert into svt_test_timing (test_code, elapsed_seconds, created) 
    values(p_test_code, p_seconds, localtimestamp);
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_timing;
  procedure purge_old
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'purge_old';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');
    delete from svt_test_timing
    where created < add_months(trunc(sysdate,'mm'),-1);
    apex_debug.message(c_debug_template, 'deleted :', sql%rowcount);
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end purge_old;
end svt_test_timing_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_URGENCY_LEVEL_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_URGENCY_LEVEL_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-14- created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  function get_default_level_id return svt_standards_urgency_level.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_default_level_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_level_id svt_standards_urgency_level.id%type;
  begin
    apex_debug.message(c_debug_template,'START');
    begin <<attempt1>>
    select id 
    into l_level_id
    from svt_standards_urgency_level
    where urgency_level = 30;
    exception when no_data_found then
      select id 
      into l_level_id
      from svt_standards_urgency_level
      order by urgency_level
      fetch first 1 rows only;
    end attempt1;
    return l_level_id;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_default_level_id;
end SVT_URGENCY_LEVEL_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_ACL" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_ACL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-28 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_y constant varchar2(1) := 'Y';
  gc_n constant varchar2(1) := 'N';
  gc_admin constant varchar2(50) := 'ADMINISTRATOR';
  procedure add_admin (p_user_name      in apex_workspace_developers.user_name%type,
                       p_application_id in apex_applications.application_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'add_admin';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_user_name', p_user_name,
                                       'p_application_id', p_application_id
                     );
   apex_acl.add_user_role (
            p_application_id => p_application_id,
            p_user_name      => p_user_name,
            p_role_static_id => gc_admin);
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end add_admin;
  procedure add_contributor (p_user_name      in apex_workspace_developers.user_name%type,
                             p_application_id in apex_applications.application_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'add_contributor';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_user_name', p_user_name,
                                       'p_application_id', p_application_id
                     );
   apex_acl.add_user_role (
            p_application_id => p_application_id,
            p_user_name      => p_user_name,
            p_role_static_id => 'CONTRIBUTOR');
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end add_contributor;
  procedure add_reader (p_user_name      in apex_workspace_developers.user_name%type,
                        p_application_id in apex_applications.application_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'add_reader';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_user_name', p_user_name,
                                       'p_application_id', p_application_id
                     );
   apex_acl.add_user_role (
            p_application_id => p_application_id,
            p_user_name      => p_user_name,
            p_role_static_id => 'READER');
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end add_reader;
  procedure add_awd_users (p_application_id in apex_applications.application_id%type default null)
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || 'add_awd_users';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_application_id constant apex_applications.application_id%type
                   := coalesce(p_application_id, svt_apex_view.gc_svt_app_id);
  begin
    apex_debug.message(c_debug_template,'START');
    for rec in (select user_name
                from apex_workspace_developers
                where workspace_name = svt_preferences.get('SVT_WORKSPACE')
                )
    loop
      add_reader (p_user_name  => rec.user_name,
                  p_application_id => c_application_id);
    end loop;
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end add_awd_users;
  procedure add_default_admin(p_user_name      in apex_workspace_developers.user_name%type,
                              p_application_id in apex_applications.application_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'add_default_admin';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_admin_exists_yn varchar2(1) := gc_y;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_user_name', p_user_name,
                                       'p_application_id', p_application_id
                     );
    select case when count(*) = 1
                then gc_y
                else gc_n
                end into l_admin_exists_yn
        from sys.dual where exists (
            select 1
            from apex_appl_acl_users
            where application_id = p_application_id
            and upper(role_names) like '%'||gc_admin||'%'
        );
   if l_admin_exists_yn = gc_n then
      add_reader (p_user_name       => p_user_name,
                  p_application_id  => p_application_id);
      add_contributor (p_user_name       => p_user_name,
                        p_application_id  => p_application_id);
      add_admin (p_user_name       => p_user_name,
                 p_application_id  => p_application_id);
   end if;
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end add_default_admin;
end SVT_ACL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_APEX_ISSUE_LINK" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_apex_issue_link
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jan-27 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix      constant varchar2(31) := lower($$plsql_unit) || '.';
  function build_link_to_apex_issue (
      p_app_id in apex_applications.application_id%type,
      p_id     in apex_issues.issue_id%type  
    )
  return varchar2
  deterministic
  result_cache
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'build_link_to_apex_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_builder_session constant number := v('APX_BLDR_SESSION'); 
  c_team_dev_app    constant number := 4600;
  c_issue_page      constant number := 100;
  l_link            varchar2(2000); 
  begin
    apex_debug.message(c_debug_template,'START', 'p_app_id', p_app_id, 'p_id', p_id);
    l_link := case when p_app_id is null 
                   then 'p_app_id_is_null'
                   when p_id is null 
                   then 'p_id_is_null'
                   when svt_stds_parser.is_logged_into_builder() = false
                   then 'not_logged_into_builder'
                   when svt_stds_parser.app_in_current_workspace(p_app_id) = false 
                   then 'app_not_in_current_workspace'
                   else apex_string.format(
                          p_message => '%0f?p=%1:%2:%3:::RP:P100_ISSUE_ID:%4',
                          p0 => svt_stds_parser.get_base_url(),
                          p1 => c_team_dev_app,
                          p2 => c_issue_page,
                          p3 => c_builder_session,
                          p4 => p_id
                        )
                   end;
    apex_debug.info(c_debug_template, 'l_link', l_link);
    return l_link;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end build_link_to_apex_issue;
end SVT_APEX_ISSUE_LINK;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_APEX_ISSUE_UTIL" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_apex_issue_util
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Sep-28 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix      constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_false_positive_id constant svt_audit_actions.id%type := 2;
  gc_title_max         constant number := 250; --limit is 255
  gc_n                 constant varchar2(1) := 'N';
  gc_y                 constant varchar2(1) := 'Y';
  -- https://docs.oracle.com/en/database/oracle/application-express/21.2/aeapi/SUBMIT_FEEDBACK_FOLLOWUP-Procedure.html#GUID-C6F4E4A8-7E40-498F-8E8F-7D99D98527B0
function apex_issue_access_yn return varchar2
as
c_scope constant varchar2(128) := gc_scope_prefix || 'apex_issue_access_yn';
c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
begin
 apex_debug.message(c_debug_template,'START'
                   );
 return case when oracle_apex_version.c_apex_issue_access
             then gc_y
             else gc_n
             end;
exception
 when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
   raise;
end apex_issue_access_yn;
$if oracle_apex_version.c_apex_issue_access $then
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 3, 2022
-- Synopsis:
--
-- Private function to return security group id
--
------------------------------------------------------------------------------
  function get_security_group_id return apex_issues.workspace_id%type
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_security_group_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_security_groupd_id apex_issues.workspace_id%type;
  begin
     apex_debug.message(c_debug_template,'START');
    select workspace_id
    into l_security_groupd_id
    from apex_workspaces
    where workspace = svt_preferences.get('SVT_WORKSPACE');
    apex_debug.message(c_debug_template, 'l_security_groupd_id', l_security_groupd_id);
    return l_security_groupd_id;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_security_group_id;
  procedure create_issue (p_id             out apex_issues.issue_id%type, 
                          p_title          in  varchar2, 
                          p_issue_text     in  apex_issues.issue_text%type, 
                          p_application_id in  apex_issues.related_application_id%type, 
                          p_page_id        in  apex_issues.related_page_id%type,
                          p_audit_id       in  svt_plsql_apex_audit.id%type
                        )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'create_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_security_groupd_id constant apex_issues.workspace_id%type := get_security_group_id;
  c_title              constant apex_issues.issue_title%type := substr(p_title, 1, gc_title_max); 
  begin
    apex_debug.message(c_debug_template,'START',
                                        'p_audit_id', p_audit_id,
                                        'p_title', p_title,
                                        'p_issue_text', p_issue_text,
                                        'p_application_id', p_application_id,
                                        'p_page_id', p_page_id
                      );
    if v('APP_ID') is null then
      apex_debug.message(c_debug_template, 'setting security group');
      apex_util.set_security_group_id( c_security_groupd_id );
    else 
      apex_debug.message(c_debug_template, 'apex session is active');
    end if;
    insert into svt_flow_issues
    (
    --  security_group_id,
     title, 
     slug,  
     issue_text, 
     application_id, 
     page_id
    ) 
    values (
      -- c_security_groupd_id,
      c_title,
      $if oracle_apex_version.version >= 21
      $then
      apex_string_util.get_slug(c_title),
      $else 
      apex_string_util.to_slug(c_title),
      $end
      p_issue_text,
      p_application_id,
      p_page_id
    ) return id into p_id;
    apex_debug.message(c_debug_template, 'p_id', p_id);
  exception 
    when dup_val_on_index then
      p_id := null;
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'dup_val_on_indexn', 
                       p1 => sqlerrm, 
                       p2 => c_title,
                       p3 => p_application_id,
                       p4 => p_audit_id,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
    when others then
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'Unhandled Exception', 
                       p1 => sqlerrm, 
                       p2 => c_title,
                       p3 => p_application_id,
                       p4 => p_audit_id,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
      raise;  
  end create_issue;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 3, 2022
-- Synopsis:
--
-- Private procedure to update an apex issue 
--
------------------------------------------------------------------------------
  procedure update_issue (p_id             in  apex_issues.issue_id%type, 
                          p_title          in  varchar2, 
                          p_issue_text     in  apex_issues.issue_text%type, 
                          p_application_id in  apex_issues.related_application_id%type, 
                          p_page_id        in  apex_issues.related_page_id%type,
                          p_title_suffix   in  svt_plsql_apex_audit.apex_issue_title_suffix%type
                        )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12';
  c_title constant apex_issues.issue_title%type := substr(p_title, 1, gc_title_max); 
  begin
    apex_debug.enable(p_level => apex_debug.c_log_level_info); --temporary
    apex_debug.message(c_debug_template,'START',
                                        'p_id', p_id,
                                        'p_title', p_title,
                                        'p_application_id', p_application_id,
                                        'p_page_id', p_page_id,
                                        'p_title_suffix', p_title_suffix,
                                        'p_issue_text', p_issue_text
                      );
    update svt_flow_issues
    set title = c_title||p_title_suffix,
        slug  = apex_string_util.get_slug(c_title||p_title_suffix),
        issue_text = p_issue_text,
        application_id = p_application_id, 
        page_id = p_page_id
    where id = p_id;
    apex_debug.message(c_debug_template, 'udpate apex_issues :', sql%rowcount);
  exception 
    when dup_val_on_index then
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'dup_val_on_index', 
                       p1 => sqlerrm, 
                       p2 => p_id,
                       p3 => c_title,
                       p4 => p_title_suffix,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
      -- drop_issue (p_id => p_id);
      raise_application_error(-20126, 'Duplicate issue title:'||p_title||' '||p_title_suffix);
    when others then 
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'Unhandled Exception', 
                       p1 => sqlerrm, 
                       p2 => p_id,
                       p3 => c_title,
                       p4 => p_title_suffix,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
      raise;
  end update_issue;
  procedure drop_issue (p_id in  apex_issues.issue_id%type)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'drop_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START',
                                        'p_id', p_id
                      );
    delete from svt_flow_issues
    where id = p_id;
    apex_debug.message(c_debug_template, 'deleted from apex_issues :', sql%rowcount);
    svt_plsql_apex_audit_api.null_out_apex_issue (p_audit_id  => p_id);
    apex_debug.message(c_debug_template, 'updated svt_plsql_apex_audit :', sql%rowcount);
  exception when others then 
    apex_debug.error(p_message => c_debug_template, 
                     p0 =>'Unhandled Exception', 
                     p1 => sqlerrm, 
                     p2 => 'p_id',
                     p3 => p_id,
                     p5 => sqlcode, 
                     p6 => dbms_utility.format_error_stack, 
                     p7 => dbms_utility.format_error_backtrace, 
                     p_max_length => 4096);
    raise;
  end drop_issue;
  procedure drop_irrelevant_issues (p_message out nocopy varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'drop_irrelevant_issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_security_groupd_id constant apex_issues.workspace_id%type := get_security_group_id;
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START');
    if v('APP_ID') is null then
      apex_debug.message(c_debug_template, 'setting security group');
      apex_util.set_security_group_id( c_security_groupd_id );
    else 
      apex_debug.message(c_debug_template, 'apex session active');
    end if;
    delete from svt_flow_issues
    -- where title like '[SVT]%'
    where title like '[%'
    and id not in (select apex_issue_id
                   from svt_plsql_apex_audit
                   where apex_issue_id is not null);
    apex_debug.message(c_debug_template, 'deleted expired issues in svt_flow_issues:', sql%rowcount);
    delete from svt_flow_issues
    -- where title like '[SVT]%'
    where title like '[%'
    and id in (select apex_issue_id
               from svt_plsql_apex_audit
               where action_id = gc_false_positive_id);
    apex_debug.message(c_debug_template, 'deleted valid exceptions in svt_flow_issues:', sql%rowcount);
    p_message := l_message;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end drop_irrelevant_issues;
  procedure merge_from_audit_tbl(p_issue_category in svt_plsql_apex_audit.issue_category%type default null,
                                 p_application_id in svt_plsql_apex_audit.application_id%type default null,
                                 p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                                 p_audit_id       in svt_plsql_apex_audit.id%type default null,
                                 p_test_code      in svt_stds_standard_tests.test_code%type default null,
                                 p_message        out nocopy varchar2
                                )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'merge_from_audit_tbl';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_limit    constant pls_integer := 100;
  c_apex     constant varchar2(4) := 'APEX';
  cursor cur_issues
    is
    select audit_id, application_id, page_id, issue_title, issue_text, unqid, apex_issue_id, apex_issue_title_suffix
      from v_svt_plsql_apex_audit
      where application_id != 0
      and issue_category in (c_apex,'SERT')
      and (issue_category = upper(p_issue_category) or p_issue_category is null)
      and (application_id = upper(p_application_id) or p_application_id is null)
      and (page_id = upper(p_page_id) or p_page_id is null)
      and (audit_id = upper(p_audit_id) or p_audit_id is null)
      and (test_code = upper(p_test_code) or p_test_code is null)
      and page_id is not null
      and issue_title is not null
      and issue_text is not null
      order by audit_id
      ;
  type r_issues is record (
    audit_id           svt_plsql_apex_audit.id%type, 
    application_id     svt_plsql_apex_audit.application_id%type, 
    page_id            svt_plsql_apex_audit.page_id%type, 
    issue_title        svt_plsql_apex_audit.issue_title%type, 
    issue_text         svt_plsql_apex_audit.validation_failure_message%type,
    unqid              svt_plsql_apex_audit.unqid%type,
    apex_issue_id      svt_plsql_apex_audit.apex_issue_id%type,
    issue_title_suffix svt_plsql_apex_audit.apex_issue_title_suffix%type
  );
  type t_issue_rec is table of r_issues; 
  l_issues_t   t_issue_rec;
  l_issue_id    apex_issues.issue_id%type;
  l_issue_title_suffix svt_plsql_apex_audit.apex_issue_title_suffix%type := null;
  l_counter pls_integer := 2;
  l_inserted_count pls_integer := 0;
  l_updated_count  pls_integer := 0;
  begin
    apex_debug.message(c_debug_template,'START',
                                          'p_issue_category',p_issue_category,
                                          'p_application_id', p_application_id,
                                          'p_page_id', p_page_id,
                                          'p_audit_id', p_audit_id,
                                          'p_test_code', p_test_code
                                          );
    if v('APP_ID') is null then
      apex_debug.message(c_debug_template, 'creating apex session');
      apex_session.create_session(p_app_id=>svt_apex_view.gc_svt_app_id,p_page_id=>1,p_username=>'HAYHUDSO');   
      apex_debug.enable(p_level => apex_debug.c_log_level_engine_trace);
    else
      apex_debug.message(c_debug_template, 'apex session already active');
    end if;
    open cur_issues;
        loop
            fetch cur_issues
            bulk collect into l_issues_t
            limit c_limit;
            for i in 1..l_issues_t.count
            loop
              case when l_issues_t(i).apex_issue_id is null 
                   then 
                        begin <<insert_section>>
                          apex_debug.message(c_debug_template, 'unqid', l_issues_t(i).unqid);
                          create_issue (p_id             => l_issue_id,
                                        p_title          => l_issues_t(i).issue_title,
                                        p_issue_text     => l_issues_t(i).issue_text,
                                        p_application_id => l_issues_t(i).application_id,
                                        p_page_id        => l_issues_t(i).page_id,
                                        p_audit_id       => l_issues_t(i).audit_id
                                      );
                          apex_debug.message(c_debug_template, 'l_issue_id', l_issue_id);
                          if l_issue_id is null then 
                            l_counter := 2;
                            while l_issue_id is null
                            loop
                              apex_debug.message(c_debug_template, 'l_counter', l_counter);
                              l_issue_title_suffix := ' #'||l_counter;
                              create_issue (
                                        p_id             => l_issue_id,
                                        p_title          => l_issues_t(i).issue_title||l_issue_title_suffix,
                                        p_issue_text     => l_issues_t(i).issue_text,
                                        p_application_id => l_issues_t(i).application_id,
                                        p_page_id        => l_issues_t(i).page_id,
                                        p_audit_id       => l_issues_t(i).audit_id
                                      );
                              l_counter := l_counter+ 1;
                              exit when l_counter > 15;
                            end loop;
                          apex_debug.message(c_debug_template, 'l_issue_title_suffix', l_issue_title_suffix);
                          apex_debug.message(c_debug_template, 'l_issue_id after loop', l_issue_id);
                          end if;
                          if l_issue_id is not null then
                            update svt_plsql_apex_audit
                            set apex_issue_id = l_issue_id,
                                apex_issue_title_suffix = l_issue_title_suffix
                            where id = l_issues_t(i).audit_id;
                          end if;
                          l_inserted_count := l_inserted_count + 1;
                        exception when others then
                          apex_debug.error(p_message => c_debug_template, p0 =>'Duplicate value!', p1 => sqlerrm, p2=> l_issues_t(i).issue_title, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
                          raise;
                        end insert_section;
                   else 
                      begin <<svt_upd>>
                        update_issue (
                            p_id             => l_issues_t(i).apex_issue_id,
                            p_title          => l_issues_t(i).issue_title,
                            p_issue_text     => l_issues_t(i).issue_text,
                            p_application_id => l_issues_t(i).application_id,
                            p_page_id        => l_issues_t(i).page_id,
                            p_title_suffix   => l_issues_t(i).issue_title_suffix
                          );
                      exception when dup_val_on_index then
                        l_issue_title_suffix := null;
                        update svt_plsql_apex_audit
                        set apex_issue_title_suffix = ' #'||to_number(
                                                              to_number(replace(apex_issue_title_suffix,' #')
                                                                        ) + 10)
                        where id = l_issues_t(i).audit_id
                        returning apex_issue_title_suffix into l_issue_title_suffix;
                        apex_debug.message(c_debug_template, 'l_issue_title_suffix',l_issue_title_suffix);
                        update_issue (
                          p_id             => l_issues_t(i).apex_issue_id,
                          p_title          => l_issues_t(i).issue_title,
                          p_issue_text     => l_issues_t(i).issue_text,
                          p_application_id => l_issues_t(i).application_id,
                          p_page_id        => l_issues_t(i).page_id,
                          p_title_suffix   => l_issue_title_suffix
                        );
                        l_updated_count := l_updated_count + 1;
                      end svt_upd;
              end case;
            end loop;
            exit when cur_issues%notfound;
        end loop;
    p_message := apex_string.format('Updated %0 issue(s) and created %1 new issues',
                  p0 => l_updated_count,
                  p1 => l_inserted_count
                );
  exception when others then 
    apex_debug.error(p_message => c_debug_template, 
                    p0 =>'Unhandled Exception', 
                    p1 => sqlerrm, 
                    p2 => p_page_id,
                    p3 => p_issue_category,
                    p4 => p_application_id,
                    p5 => sqlcode, p6 => dbms_utility.format_error_stack, 
                    p7 => dbms_utility.format_error_backtrace, 
                    p_max_length => 4096);
    raise;
  end merge_from_audit_tbl;
  procedure update_audit_tbl_from_apex_issues
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_audit_tbl_from_apex_issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');
    merge into svt_plsql_apex_audit dest
      using (
        select issue_id apex_issue_id
        from apex_issues
        where issue_status = 'CLOSED'
      ) src
      on (1=1
        and dest.apex_issue_id = src.apex_issue_id
        and (dest.action_id is null or dest.action_id != gc_false_positive_id)
      )
    when matched then
      update
        set
          dest.action_id = gc_false_positive_id,
          dest.notes = 'Automatically updated from apex_issues';
    apex_debug.message(c_debug_template, 'udpated svt_plsql_apex_audit:', sql%rowcount);
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end update_audit_tbl_from_apex_issues;
  procedure drop_all_svt_issues
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'drop_all_svt_issues'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');
    delete from svt_flow_issues
    where title like '[SVT]%';
    apex_debug.message(c_debug_template, 'deleted from apex_issues:', sql%rowcount);
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end drop_all_svt_issues;
  procedure hard_correct_svt_issues 
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'hard_correct_svt_issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START');
    delete
    from svt_flow_issues
    where security_group_id = 0;
    for rec in (select paa.id audit_id
                  from svt_plsql_apex_audit paa 
                  left outer join apex_issues ai on paa.apex_issue_id = ai.issue_id
                  where paa.apex_issue_id is not null
                  -- and ai.issue_id is null
                  )
    loop 
      svt_plsql_apex_audit_api.null_out_apex_issue (p_audit_id  => rec.audit_id);
    end loop;
    drop_irrelevant_issues(p_message => l_message);
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end hard_correct_svt_issues;
$end
  procedure refresh_for_test_code (p_test_code in svt_plsql_apex_audit.test_code%type)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'refresh_for_test_code';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    svt_plsql_apex_audit_api.refresh_for_test_code (p_test_code => p_test_code);
    $if oracle_apex_version.c_apex_issue_access $then
    <<dii>>
    declare
    l_dii_message varchar2(500);
    begin
      svt_apex_issue_util.drop_irrelevant_issues(p_message => l_dii_message);
      l_message := l_message || l_dii_message;
      commit; -- necessary for succinctness / user friendliness (hayhudso 2023-Feb-6)
    end dii;
    $end
    svt_audit_util.assign_violations;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end refresh_for_test_code;
  procedure refresh_for_audit_id (p_audit_id in svt_plsql_apex_audit.id%type)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'refresh_for_audit_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_svt_plsql_apex_audit_rec1 constant svt_plsql_apex_audit%rowtype 
                             := svt_plsql_apex_audit_api.get_audit_record (p_audit_id);
  l_svt_plsql_apex_audit_rec2 svt_plsql_apex_audit%rowtype;
  l_apex_issue_id svt_plsql_apex_audit.apex_issue_id%type;
  c_mv_dependency constant svt_stds_standard_tests.mv_dependency%type 
                    := svt_stds.get_mv_dependency(p_test_code => c_svt_plsql_apex_audit_rec1.test_code);
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);
    if c_svt_plsql_apex_audit_rec1.id is not null then
      if c_mv_dependency is not null then
        svt_mv_util.refresh_mv(c_mv_dependency); --refresh the dependent materialized view
      end if;
      l_apex_issue_id := c_svt_plsql_apex_audit_rec1.apex_issue_id;
      svt_plsql_apex_audit_api.merge_audit_tbl (
                        p_test_code      => c_svt_plsql_apex_audit_rec1.test_code,
                        p_application_id => c_svt_plsql_apex_audit_rec1.application_id,
                        p_page_id        => c_svt_plsql_apex_audit_rec1.page_id,
                        p_audit_id       => p_audit_id
                    );
      l_svt_plsql_apex_audit_rec2 := svt_plsql_apex_audit_api.get_audit_record (p_audit_id);
      if c_svt_plsql_apex_audit_rec1.updated < l_svt_plsql_apex_audit_rec2.updated then
        apex_debug.message(c_debug_template, 'violation has not been fixed');
        $if oracle_apex_version.c_apex_issue_access $then
        <<mfat>>
        declare
        l_mfat_message varchar2(500);
        begin
          svt_apex_issue_util.merge_from_audit_tbl(p_audit_id => p_audit_id,
                                                  p_message  => l_mfat_message);
          l_message := l_message||l_mfat_message;
        end mfat;
        svt_apex_issue_util.update_audit_tbl_from_apex_issues;
        $end
      else
        -- the audit record was unaffected by the merge, so it must not longer exist
        apex_debug.message(c_debug_template, 'violation has been fixed so the issue and associated apex issue must be dropped');
        svt_plsql_apex_audit_api.delete_audit (
              p_unqid                      => l_svt_plsql_apex_audit_rec2.unqid,
              p_audit_id                   => l_svt_plsql_apex_audit_rec2.id,
              p_test_code                  => l_svt_plsql_apex_audit_rec2.test_code,
              p_validation_failure_message => l_svt_plsql_apex_audit_rec2.validation_failure_message,
              p_application_id             => l_svt_plsql_apex_audit_rec2.application_id,
              p_page_id                    => l_svt_plsql_apex_audit_rec2.page_id,
              p_component_id               => l_svt_plsql_apex_audit_rec2.component_id,
              p_assignee                   => c_svt_plsql_apex_audit_rec1.assignee,
              p_line                       => l_svt_plsql_apex_audit_rec2.line,
              p_object_name                => l_svt_plsql_apex_audit_rec2.object_name,
              p_object_type                => l_svt_plsql_apex_audit_rec2.object_type,
              p_code                       => l_svt_plsql_apex_audit_rec2.code,
              p_delete_reason              => 'REFRESH_FOR_AUDIT_ID'
            );
        $if oracle_apex_version.c_apex_issue_access $then
        drop_issue (l_apex_issue_id);
        $end
      end if;
      commit; -- necessary for succinctness (hayhudso 2023-Feb-6)
    else 
      apex_debug.error(c_debug_template, 'p_audit_id not found', p_audit_id);
      $if oracle_apex_version.c_apex_issue_access $then
      <<dii>>
      declare
      l_dii_message varchar2(500);
      begin
        svt_apex_issue_util.drop_irrelevant_issues(p_message => l_dii_message);
        l_message := l_message||l_dii_message;
      end dii;
      $end
      commit; -- necessary for succinctness (hayhudso 2023-Feb-6)
      raise_application_error(-20123,'Unknown audit_id :'||p_audit_id);
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end refresh_for_audit_id;
  procedure manage_apex_issues (p_message out nocopy varchar2)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'manage_apex_issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START');
    check_apex_version_up2date;
    $if oracle_apex_version.c_apex_issue_access $then
    <<mfat>>
    declare 
    l_mfat_message varchar2(500);
    begin
      merge_from_audit_tbl(p_message  => l_mfat_message);
      l_message := l_message || l_mfat_message;
    end mfat;
    <<dii>>
    declare 
    l_dii_message varchar2(500);
    begin
      drop_irrelevant_issues(p_message => l_dii_message);
      l_message := l_message || l_dii_message;
    end dii;
    update_audit_tbl_from_apex_issues;
    $end
    p_message := l_message;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end manage_apex_issues;
  procedure check_apex_version_up2date 
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'check_apex_version_up2date';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 
  c_current_version constant varchar2(25) := orclapex_version;
  l_first_period integer;
  l_version   number;
  l_release   number;
  l_is_match  boolean;
  begin
    apex_debug.message(c_debug_template,'START');
    l_first_period := instr(c_current_version, '.', 1, 1);
    l_version      := to_number(substr(c_current_version, 1, l_first_period - 1));
    l_release      := to_number(substr(c_current_version, l_first_period + 1, l_first_period - 2));
    l_is_match := case when l_version = oracle_apex_version.version
                       then case when l_release = oracle_apex_version.release
                                 then true
                                 else false
                                 end
                       else false 
                       end;
    if l_is_match then
      apex_debug.message(c_debug_template, 'APEX Version is correct');
    else 
      raise_application_error(-20123, 
              apex_string.format('APEX version out-of-date. Version is now %0 but the version in oracle_apex_version is %1.%2',
                                 p0 => c_current_version,
                                 p1 => oracle_apex_version.version,
                                 p2 => oracle_apex_version.release
                                )
      );
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end check_apex_version_up2date;
  procedure mark_as_exception (p_audit_id in svt_plsql_apex_audit.id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'mark_as_exception';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_svt_plsql_apex_audit_rec svt_plsql_apex_audit%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);
    if p_audit_id is not null then
      svt_plsql_apex_audit_api.mark_as_exception (p_audit_id  => p_audit_id);
      $if oracle_apex_version.c_apex_issue_access $then
      l_svt_plsql_apex_audit_rec := svt_plsql_apex_audit_api.get_audit_record (p_audit_id);
      svt_apex_issue_util.drop_issue (p_id => l_svt_plsql_apex_audit_rec.apex_issue_id);
      svt_plsql_apex_audit_api.null_out_apex_issue (p_audit_id  => p_audit_id);
      $end
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end mark_as_exception;
  procedure bulk_mark_as_exception (p_audit_ids in varchar2)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_mark_as_exception';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_ids', p_audit_ids);
    for rec in (select column_value audit_id
                  from table(apex_string.split(p_audit_ids, ','))
                )
    loop
      mark_as_exception (p_audit_id => rec.audit_id);
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end bulk_mark_as_exception;
end svt_apex_issue_util;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_APEX_VIEW" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_apex_view
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Sep-16 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  function apex_applications (p_user in all_users.username%type default null)
  return svt_apex_applications_nt pipelined
  as
    c_scope          constant varchar2(128) := gc_scope_prefix || 'apex_applications';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_userenv_current_user constant varchar2(100) :=  sys_context('userenv', 'current_user');
    c_user constant all_users.username%type := coalesce(p_user, 
                                                        case when c_userenv_current_user = 'SVT'
                                                             then svt_ctx_util.get_default_user
                                                             else c_userenv_current_user
                                                             end
                                                        );
    cursor cur_aa
    is
        select  
        workspace,
        application_id, 
        application_name, 
        application_group, 
        availability_status, 
        authorization_scheme, 
        $if oracle_apex_version.version >= 21
        $then 
          created_by, 
          created_on, 
        $else 
          null created_by, 
          null created_on, 
        $end
        last_updated_by, 
        last_updated_on
        from apex_applications
        where owner = c_user;
    type r_aa is record (
      workspace      varchar2(255),
      application_id number,
      application_name varchar2(255 char),
      application_group varchar2(255 char),
      availability_status varchar2(38 char),
      authorization_scheme varchar2(259 char),
      created_by varchar2(255 char),
      created_on date,
      last_updated_by varchar2(255 char),
      last_updated_on date
    );
    type t_aa is table of r_aa index by pls_integer;
    l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START', 'c_user', c_user);
    open cur_aa;
    loop
      fetch cur_aa bulk collect into l_aat limit 1000;
      exit when l_aat.count = 0;
      for rec in 1 .. l_aat.count
      loop
        pipe row (svt_apex_applications_ot (
                      l_aat (rec).application_id, 
                      l_aat (rec).application_name, 
                      l_aat (rec).application_group, 
                      l_aat (rec).availability_status, 
                      l_aat (rec).authorization_scheme, 
                      l_aat (rec).created_by, 
                      l_aat (rec).created_on, 
                      l_aat (rec).last_updated_by, 
                      l_aat (rec).last_updated_on,
                      l_aat (rec).workspace
                    )
                );
      end loop;
    end loop;  
  exception
    when no_data_needed then
      apex_debug.message(c_debug_template, 'No data needed');
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end apex_applications;
  function apex_application_page_ir_col
  return apex_application_page_rpt_cols_nt pipelined
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'apex_application_page_ir_col';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    cursor cur_ir
    is select 
       application_id, 
       page_id, 
       region_name, 
       $if oracle_apex_version.version >= 21
       $then 
         use_as_row_header,
       $else 
         'Yes' use_as_row_header,
       $end
       region_id, 
       created_by,
       created_on,
       updated_by,
       updated_on,
       column_id,
       workspace,
       build_option
    from apex_application_page_ir_col;
    type r_ir is record (
      application_id number,
      page_id number, 
      region_name varchar2(255), 
      use_as_row_header varchar2(3),
      region_id    number, 
      created_by   varchar2(255 char),
      created_on   date,
      updated_by   varchar2(255 char),
      updated_on   date,
      column_id    number,
      workspace    varchar2(255 char),
      build_option varchar2(255 char)
    );
    type t_ir is table of r_ir index by pls_integer;
    l_irt t_ir;
  begin
    apex_debug.message(c_debug_template,'START');
    open cur_ir;
    loop
      fetch cur_ir bulk collect into l_irt limit 1000;
      exit when l_irt.count = 0;
      for rec in 1 .. l_irt.count
      loop
        pipe row (apex_application_page_rpt_cols_ot (
                      l_irt (rec).application_id,
                      l_irt (rec).page_id,
                      l_irt (rec).region_name,
                      l_irt (rec).use_as_row_header,
                      l_irt (rec).region_id,
                      l_irt (rec).created_by,
                      l_irt (rec).created_on,
                      l_irt (rec).updated_by,
                      l_irt (rec).updated_on,
                      l_irt (rec).column_id,
                      l_irt (rec).workspace,
                      l_irt (rec).build_option
                    )
                );
      end loop;
    end loop;  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end apex_application_page_ir_col;
  function apex_appl_page_ig_columns
  return apex_application_page_rpt_cols_nt pipelined
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'apex_appl_page_ig_columns';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    cursor cur_ig
    is select 
       application_id, 
       page_id, 
       region_name, 
       $if oracle_apex_version.version >= 21
       $then 
         use_as_row_header,
       $else 
         'Yes' use_as_row_header,
       $end
       region_id, 
       null created_by,
       null created_on,
       last_updated_by updated_by,
       last_updated_on updated_on,
       column_id,
       workspace,
       build_option
    from apex_appl_page_ig_columns;
    type r_ig is record (
      application_id number,
      page_id number, 
      region_name varchar2(255), 
      use_as_row_header varchar2(3),
      region_id number, 
      created_by   varchar2(255 char),
      created_on   date,
      updated_by   varchar2(255 char),
      updated_on   date,
      column_id    number,
      workspace    varchar2(255 char),
      build_option varchar2(255 char)
    );
    type t_ig is table of r_ig index by pls_integer;
    l_igt t_ig;
  begin
    apex_debug.message(c_debug_template,'START');
    open cur_ig;
    loop
      fetch cur_ig bulk collect into l_igt limit 1000;
      exit when l_igt.count = 0;
      for rec in 1 .. l_igt.count
      loop
        pipe row (apex_application_page_rpt_cols_ot (
                      l_igt (rec).application_id,
                      l_igt (rec).page_id,
                      l_igt (rec).region_name,
                      l_igt (rec).use_as_row_header,
                      l_igt (rec).region_id,
                      l_igt (rec).created_by,
                      l_igt (rec).created_on,
                      l_igt (rec).updated_by,
                      l_igt (rec).updated_on,
                      l_igt (rec).column_id,
                      l_igt (rec).workspace,
                      l_igt (rec).build_option
                    )
                );
      end loop;
    end loop;  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end apex_appl_page_ig_columns;
  function apex_workspace_preferences
  return svt_apex_preferences_nt pipelined
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'apex_workspace_preferences';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cursor cur_awp
    is select 
       $if oracle_apex_version.version >= 21
       $then 
        workspace_id,
        workspace_name,
        workspace_display_name,
        user_name,
        preference_id,
        preference_name,
        preference_value,
        preference_type,
        preference_comment
        from apex_workspace_preferences
        where preference_name like 'SVT%'
        -- and user_name = 'SVT' --doesn't work with SVT_EMAIL_SUBSCRIPTION
       $else 
        null workspace_id,
        null workspace_name,
        null workspace_display_name,
        'HAYHUDSO' user_name,
        null preference_id,
        'SVT_EMAIL_SUBSCRIPTION' preference_name,
        null preference_value,
        null preference_type,
        null preference_comment
        from dual
       $end
       ;
    type r_awp is record (
      workspace_id           number,      
      workspace_name         varchar2(255),
      workspace_display_name varchar2(4000),
      user_name              varchar2(255),
      preference_id          number, 
      preference_name        varchar2(255),
      preference_value       varchar2(4000),
      preference_type        varchar2(23),
      preference_comment     varchar2(55)
    );
    type t_awp is table of r_awp index by pls_integer;
    l_awp t_awp;
  begin
    apex_debug.message(c_debug_template,'START');
    open cur_awp;
    loop
      fetch cur_awp bulk collect into l_awp limit 1000;
      exit when l_awp.count = 0;
      for rec in 1 .. l_awp.count
      loop
        pipe row (svt_apex_preferences_ot (
                      l_awp (rec).workspace_id,
                      l_awp (rec).workspace_name,
                      l_awp (rec).workspace_display_name,
                      l_awp (rec).user_name,
                      l_awp (rec).preference_id,
                      l_awp (rec).preference_name,
                      l_awp (rec).preference_value,
                      l_awp (rec).preference_type,
                      l_awp (rec).preference_comment
                    )
                );
      end loop;
    end loop;  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end apex_workspace_preferences;
  function display_position_is_violation (
                p_display_position_code in apex_application_page_buttons.display_position_code%type,
                p_template_id           in apex_application_page_regions.template_id%type,
                p_application_id        in apex_application_temp_region.application_id%type
  ) return varchar2 deterministic
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'display_position_is_violation';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  
  l_template  apex_application_temp_region.template%type;
  l_tags      apex_t_varchar2;
  c_display_position_code constant apex_application_page_buttons.display_position_code%type := upper(p_display_position_code);
  l_exists_in_template_yn varchar2(1) := 'N';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_display_position_code', p_display_position_code,
                                        'p_template_id',p_template_id);
    
    select atr.template
    into l_template
    from apex_application_temp_region atr 
    where atr.region_template_id = p_template_id
    and atr.application_id = p_application_id;
    l_tags := apex_string_util.find_tags(l_template,'#');
    select case when count(*) = 1
                then 'Y'
                else 'N'
                end into l_exists_in_template_yn
    from sys.dual where exists (
       select 1
       from (select column_value sgmts
            from table(l_tags)) a
            join table(apex_string.split(a.sgmts,'#')) b on b.column_value = c_display_position_code
    );
    
    return case when l_exists_in_template_yn = 'N'
                then case when c_display_position_code in ('RIGHT_OF_IR_SEARCH_BAR',
                                                           'SUB_REGIONS',
                                                           'BODY') -- hard-coded in wwv_flow_property_dev.plb 
                          then 'N'
                          else 'Y'
                          end
                else 'N'
                end;
  exception 
    when no_data_found then
      apex_debug.error(p_message => c_debug_template, p0 =>'Template not found!', p1 => sqlerrm, p2 => p_template_id, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end display_position_is_violation;
  function rpt_link_request(
              p_issue_category   in svt_plsql_apex_audit.issue_category%type,
              p_report_type      in varchar2 default 'IR',
              p_dest_region_name in apex_appl_page_ig_rpts.region_name%type    default null,
              p_dest_page_id     in apex_appl_page_ig_rpts.page_id%type        default null,
              p_application_id   in apex_appl_page_ig_rpts.application_id%type default null
        )
  return varchar2
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'rpt_link_request';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_dest_region_name constant apex_appl_page_ig_rpts.region_name%type
                     := coalesce(p_dest_region_name,'Tracking issues report');
  c_dest_page_id     constant apex_appl_page_ig_rpts.page_id%type
                     := coalesce(p_dest_page_id,1);
  c_ir constant varchar2(2) := 'IR';
  c_ig constant varchar2(2) := 'IG';
  c_application_id constant apex_appl_page_ig_rpts.application_id%type
                   := coalesce(p_application_id, svt_apex_view.gc_svt_app_id);
  l_link_request varchar2(50);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_issue_category', p_issue_category,
                                        'p_dest_region_name', p_dest_region_name,
                                        'p_dest_page_id', p_dest_page_id,
                                        'p_report_type', p_report_type);
    if p_report_type = c_ig then
      apex_debug.message(c_debug_template, 'IG Report');
    
      select apex_string.format('%2[%0]_%1', apr.static_id, pir.static_id, c_ig) link_request
      into l_link_request
      from apex_application_page_regions apr
      inner join apex_appl_page_ig_rpts pir on apr.application_id = pir.application_id
                                            and apr.page_id = pir.page_id
                                            and apr.region_id = pir.region_id
      where pir.region_name = c_dest_region_name
      and pir.name is not null
      and pir.type = 'ALTERNATIVE'
      and pir.application_id = c_application_id
      and pir.page_id = c_dest_page_id
      and pir.static_id = p_issue_category
      fetch first 1 rows only;
    else 
      apex_debug.message(c_debug_template, 'IR Report');
      select apex_string.format('%2[%0]_%1', apr.static_id, pir.report_alias, c_ir) link_request
      into l_link_request
      from apex_application_page_regions apr
      inner join apex_application_page_ir_rpt pir on  apr.application_id = pir.application_id
                                                  and apr.page_id = pir.page_id
                                                  and apr.region_id = pir.region_id
      where apr.region_name = c_dest_region_name
      and pir.status = 'PUBLIC'
      and pir.report_name is not null
      and pir.application_id = c_application_id
      and pir.page_id = c_dest_page_id
      and pir.report_alias = p_issue_category
      fetch first 1 rows only;
    end if;
    return l_link_request;
  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end rpt_link_request;
end SVT_APEX_VIEW;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_AUDIT_ACTIONS_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_ACTIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_audit_actions.created%type := systimestamp;
  gc_user         constant svt_audit_actions.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  function insert_aua (
        p_action_name          in svt_audit_actions.action_name%type,
        p_include_in_report_yn in svt_audit_actions.include_in_report_yn%type
    ) return svt_audit_actions.id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_aua';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_id svt_audit_actions.id%type;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_action_name', p_action_name,
                                       'p_include_in_report_yn', p_include_in_report_yn
                     );
    
    insert into svt_audit_actions
    (
      action_name,
      include_in_report_yn,
      created,
      created_by,
      updated,
      updated_by
    )
    values
    (
      p_action_name,
      p_include_in_report_yn,
      gc_systimestamp,
      gc_user,
      gc_systimestamp,
      gc_user
    ) returning id into l_id;
    return l_id;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end insert_aua;
  procedure update_aua (
        p_id                   in svt_audit_actions.id%type,
        p_action_name          in svt_audit_actions.action_name%type,
        p_include_in_report_yn in svt_audit_actions.include_in_report_yn%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_aua';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id,
                                       'p_action_name', p_action_name,
                                       'p_include_in_report_yn', p_include_in_report_yn
                     );
    update svt_audit_actions
    set action_name          = p_action_name,
        include_in_report_yn = p_include_in_report_yn,
        updated              = gc_systimestamp,
        updated_by           = gc_user
    where id = p_id;
    apex_debug.info(c_debug_template, 'updated : ', sql%rowcount);
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end update_aua;
  procedure delete_aua (
        p_id in svt_audit_actions.id%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_aua';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
    delete svt_audit_actions
    where id = p_id;
    apex_debug.info(c_debug_template, 'deleted : ', sql%rowcount);
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end delete_aua;
end SVT_AUDIT_ACTIONS_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_AUDIT_ON_AUDIT_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_ON_AUDIT_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Sep-28 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  procedure insert_rec (
        p_unqid                      in svt_audit_on_audit.unqid%type,
        p_action_name                in svt_audit_on_audit.action_name%type,
        p_test_code                  in svt_audit_on_audit.test_code%type,
        p_audit_id                   in svt_audit_on_audit.audit_id%type,
        p_validation_failure_message in svt_audit_on_audit.validation_failure_message%type,
        p_app_id                     in svt_audit_on_audit.app_id%type default null,
        p_page_id                    in svt_audit_on_audit.page_id%type default null,
        p_component_id               in svt_audit_on_audit.component_id%type default null,
        p_assignee                   in svt_audit_on_audit.assignee%type default null,
        p_line                       in svt_audit_on_audit.line%type default null,
        p_object_name                in svt_audit_on_audit.object_name%type default null,
        p_object_type                in svt_audit_on_audit.object_type%type default null,
        p_code                       in svt_audit_on_audit.code%type default null,
        p_delete_reason              in varchar2 default null
    )
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || 'insert_rec';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_action_name    constant svt_audit_on_audit.action_name%type := upper(p_action_name);
  begin
    apex_debug.message(c_debug_template,'START', 'p_unqid', p_unqid);
    insert into svt_audit_on_audit 
              (unqid,
               action_name,
               test_code,
               audit_id,
               validation_failure_message,
               app_id,
               page_id,
               component_id,
               assignee,
               line,
               object_name,
               object_type,
               code,
               delete_reason,
               created,
               created_by)
       values (p_unqid,
               c_action_name,
               p_test_code,
               p_audit_id,
               p_validation_failure_message,
               p_app_id,
               p_page_id,
               p_component_id,
               p_assignee,
               p_line,
               p_object_name,
               p_object_type,
               p_code,
               p_delete_reason,
               sysdate,
               coalesce(sys_context('APEX$SESSION','APP_USER'),user)
               );
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_rec;
  procedure delete_extra
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_extra';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START');
   delete from svt_audit_on_audit
   where id not in (select id
                    from v_svt_audit_on_audit_keep_these);
   
   apex_debug.info(c_debug_template, 'deleted : ', sql%rowcount);
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end delete_extra;
  function overall_violation_count (
                        p_app_id      in svt_audit_on_audit.app_id%type default null,
                        p_standard_id in svt_stds_standards.id%type default null)
    return pls_integer 
    result_cache
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'overall_violation_count';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_count pls_integer := 0;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_app_id', p_app_id,
                                       'p_standard_id', p_standard_id
                     );
    select count (distinct aoa.unqid)
    into l_count
    from svt_audit_on_audit aoa
    inner join svt_stds_standard_tests esst on esst.test_code = aoa.test_code
    where aoa.action_name = 'INSERT'
    and (aoa.app_id = p_app_id or p_app_id is null)
    and (esst.standard_id = p_standard_id or p_standard_id is null);
   
    return l_count;
  exception
   when no_data_found then 
    return 0;
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end overall_violation_count;
end SVT_AUDIT_ON_AUDIT_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_AUDIT_UTIL" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-9 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_y            constant varchar2(1) := 'Y';
  gc_n            constant varchar2(1) := 'N';
  function v_svt_scm_object_assignee
  return v_svt_scm_object_assignee_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_scm_object_assignee';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cursor cur_aa
  is
      $if oracle_apex_version.c_scm_access
      $then 
        with scm as (select case when cfo.folder_name = 'Bodies'
                         then replace(upper(cfi.file_name),'.PKB')
                         when cfo.folder_name = 'SQL Views'
                         then replace(upper(cfi.file_name),'.VW')
                         when cfo.folder_name = 'Triggers'
                         then replace(upper(cfi.file_name),'.TRG')
                         end object_name,
                    upper(cfo.folder_name) folder_name,
                    cfi.checked_out_by,
                    case when cfi.created_by not in ('UT_CARS', 'CARS', 'APEX_SCM', svt_preferences.get('SVT_DEFAULT_SCHEMA'))
                         then cfi.created_by
                         end created_by, 
                    case when cfi.updated_by not in ('UT_CARS', 'CARS', 'APEX_SCM', svt_preferences.get('SVT_DEFAULT_SCHEMA'))
                         then cfi.updated_by
                         end updated_by
               from apex_scm.ccs_files_vw cfi
               inner join apex_scm.ccs_folders cfo on cfi.pfl_id = cfo.pfl_id
               where cfo.folder_name in ('Bodies', 'SQL Views', 'Triggers')
            ),
            scm2 as (
                  select scm.object_name, coalesce(scm.checked_out_by, scm.updated_by, scm.created_by) assignee, folder_name
                  from scm
            )
        select scm2.object_name, coalesce(upper(awd.email), upper(scm2.assignee)) email, folder_name, null lock_rank
        from scm2 
        left outer join v_svt_apex_workspace_developers awd on scm2.assignee = awd.user_name
      $else 
        select 
          null object_name,
          null email,
          null folder_name,
          null lock_rank
        from dual
      $end
      ;
  type r_aa is record (
    object_name       varchar2(256),
    email             varchar2(240),
    folder_name       varchar2(256),
    lock_rank         number
  );
  type t_aa is table of r_aa index by pls_integer;
  l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START');
    open cur_aa;
    loop
      fetch cur_aa bulk collect into l_aat limit 1000;
      exit when l_aat.count = 0;
      for rec in 1 .. l_aat.count
      loop
        pipe row (v_svt_scm_object_assignee_ot (
                      l_aat (rec).object_name,
                      l_aat (rec).email,
                      l_aat (rec).folder_name,
                      l_aat (rec).lock_rank
                    )
                );
      end loop;
    end loop;  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end v_svt_scm_object_assignee;
  function v_loki_object_assignee
  return v_svt_scm_object_assignee_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_loki_object_assignee';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cursor cur_aa
  is
      $if oracle_apex_version.c_loki_access
      $then 
        with loki as (select ll.object_type, 
                     ll.object_name, 
                     ll.locked, 
                     lsc.schema_name,
                     lu.full_name,
                     lu.apex_username,
                     lu.db_username,
                     dense_rank() over (partition by ll.object_type, ll.object_name order by ll.locked desc) lock_rank
                from loki.loki_locks_log ll 
                inner join loki.loki_schemas lsc on ll.schema_id = lsc.schema_id
                inner join loki.loki_users lu on ll.user_id = lu.user_id)
          select 
                object_name, 
                apex_username email,
                object_type folder_name,
                lock_rank
          from loki
      $else 
        select 
          null object_name,
          null email,
          null folder_name,
          null lock_rank
        from dual
      $end
      ;
  type r_aa is record (
    object_name       varchar2(256),
    email             varchar2(240),
    folder_name       varchar2(256),
    lock_rank         number
  );
  type t_aa is table of r_aa index by pls_integer;
  l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START');
    open cur_aa;
    loop
      fetch cur_aa bulk collect into l_aat limit 1000;
      exit when l_aat.count = 0;
      for rec in 1 .. l_aat.count
      loop
        pipe row (v_svt_scm_object_assignee_ot (
                      l_aat (rec).object_name,
                      l_aat (rec).email,
                      l_aat (rec).folder_name,
                      l_aat (rec).lock_rank
                    )
                );
      end loop;
    end loop;  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end v_loki_object_assignee;
  procedure recompile_w_plscope is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'recompile_w_plscope';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_compile_stmt         varchar2(512);
    begin
      apex_debug.message(c_debug_template,'recompile_w_plscope');
      execute immediate q'[ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL, STATEMENTS:ALL']';
      for rec in (select distinct 
                    case when upos.type = 'PACKAGE BODY'
                         then 'PACKAGE'
                         when upos.type = 'TYPE BODY'
                         then 'TYPE'
                         else upos.type
                         end object_type, 
                    upos.name object_name,
                    upos.owner
                    from v_user_plsql_object_settings upos 
                    inner join v_user_objects uo on uo.object_name = upos.name 
                    -- left outer join v$locked_object vlo on uo.object_id = vlo.object_id
                    where (upos.plscope_settings != 'IDENTIFIERS:ALL, STATEMENTS:ALL' or plscope_settings is null)
                    and upos.name not like 'BIN$%'
                    and upos.name not like 'XXX%'
                    -- and name not in ('SVT_STDS_DATA', 'SCH_ESI_LISTEN_QUEUES')
                    and upos.type  = 'PACKAGE BODY'
                    -- and vlo.object_id is null --eliminate locked objects
                    order by 1, 2
                  )
      loop
        begin <<recompltn>>
          l_compile_stmt := apex_string.format(p_message => 'ALTER %0 %1.%2 COMPILE',
                                               p0 => dbms_assert.simple_sql_name(rec.object_type),
                                               p1 => rec.owner,
                                               p2 => dbms_assert.noop(rec.object_name)
                                              );
          apex_debug.message(c_debug_template, 'l_compile_stmt', l_compile_stmt);
          execute immediate l_compile_stmt;
        exception 
          when e_deadlock then
            apex_debug.warn(c_debug_template,'Deadlock waiting for resource:', l_compile_stmt);
          when e_compilation_error then
            apex_debug.warn(c_debug_template,'Compilation error for:', l_compile_stmt);
          when e_dependent_error then
            apex_debug.warn(c_debug_template,'Dependent error for:', l_compile_stmt);
          when e_object_not_exist then
            apex_debug.warn(c_debug_template,'object does not exist', l_compile_stmt);
          when e_timeout then
            apex_debug.warn(c_debug_template,'timeout occurred', l_compile_stmt);
        end recompltn;
      end loop;
    exception 
      when e_deadlock then
        apex_debug.error(p_message => c_debug_template, p0 =>'Deadlock waiting for resource in recompile_w_plscope', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end recompile_w_plscope;
    procedure recompile_all_schemas_w_plscope
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'recompile_all_schemas_w_plscope';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START');
      for rec in (
        select column_value review_schema
        from table(
              apex_string.split(
                svt_preferences.get('SVT_REVIEW_SCHEMAS'), ':'
                )
              )
      )
      loop
        svt_ctx_util.set_review_schema(p_schema => rec.review_schema);
        recompile_w_plscope;
      end loop;
    exception 
      when e_insufficient_privs then
        apex_debug.error(p_message => c_debug_template, p0 =>'Insufficient privileges', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end recompile_all_schemas_w_plscope;
    procedure set_workspace (p_workspace in apex_workspaces.workspace%type default null)
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'set_workspace';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_workspace constant apex_workspaces.workspace%type := case when p_workspace is not null 
                                                                then upper(p_workspace)
                                                                else svt_preferences.get('SVT_WORKSPACE')
                                                                end;
    begin
      apex_debug.message(c_debug_template,'START');
      apex_util.set_workspace(c_workspace);
    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end set_workspace;
    procedure assign_violations
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'assign_violations';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START');
      -- svt_plsql_apex_audit_api.assign_from_scm;
      svt_plsql_apex_audit_api.assign_from_apex_audit;
      svt_plsql_apex_audit_api.assign_from_apex_parent_audit;
      $if oracle_apex_version.c_loki_access $then
        svt_plsql_apex_audit_api.assign_from_loki;
      $end
      svt_plsql_apex_audit_api.assign_from_default;
    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end assign_violations;
    procedure record_daily_issue_snapshot(p_application_id in svt_plsql_apex_audit.application_id%type default null,
                                          p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                                          p_test_code      in svt_stds_standard_tests.test_code%type default null,
                                          p_standard_id    in svt_stds_standard_tests.standard_id%type default null,
                                          p_schema         in all_users.username%type default null,
                                          p_issue_category in svt_plsql_apex_audit.issue_category%type default null,
                                          p_message        out nocopy varchar2
                                         )
     is
     c_scope constant varchar2(128) := gc_scope_prefix || 'record_daily_issue_snapshot'; 
     c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
     c_apex constant svt_plsql_apex_audit.issue_category%type := 'APEX';
     l_message varchar2(500);
     begin
        apex_debug.message(c_debug_template,'START',
                                            'p_application_id', p_application_id,
                                            'p_page_id', p_page_id,
                                            'p_test_code', p_test_code,
                                            'p_standard_id', p_standard_id,
                                            'p_issue_category', p_issue_category
                                            );
        set_workspace;
        <<nonapex>>
        declare
        l_na_test_count pls_integer := 0;
        begin 
          apex_debug.message(c_debug_template, '1. Non-APEX Tests');
          for rec in (
            select column_value review_schema
            from table(
                  apex_string.split(
                    svt_preferences.get('SVT_REVIEW_SCHEMAS'), ':'
                    )
                  )
            where column_value = p_schema or  p_schema is null
          )
          loop
            apex_debug.message(c_debug_template, 'rec.review_schema', rec.review_schema);
            svt_ctx_util.set_review_schema(p_schema => rec.review_schema);
            for ic_rec in (select issue_category, test_code
                            from v_svt_stds_standard_tests
                            where issue_category != c_apex
                            and (issue_category = p_issue_category or p_issue_category is null)
                            and (test_code = p_test_code or p_test_code is null)
                            and (standard_id = p_standard_id or p_standard_id is null)
                            and active_yn = gc_y
                            and standard_active_yn  = gc_y
                            order by test_code)
            loop
              <<tstlp>>
              declare 
                t1 timestamp; 
                t2 timestamp; 
              begin 
                t1 := systimestamp; 
                apex_debug.message(c_debug_template, 'Start: '||t1, ic_rec.test_code);
                svt_plsql_apex_audit_api.merge_audit_tbl (
                                p_application_id => p_application_id,
                                p_page_id        => p_page_id,
                                p_test_code      => ic_rec.test_code,
                                p_issue_category => coalesce(p_issue_category, ic_rec.issue_category)
                                );
                t2 := systimestamp; 
                apex_debug.message(c_debug_template, 'End: '||t2, ic_rec.test_code);
                svt_test_timing_api.insert_timing(ic_rec.test_code, extract( second from (t2-t1) ));
                l_na_test_count := l_na_test_count + 1;
              end tstlp; 
            end loop;
          end loop;
          l_message := 'Ran '||l_na_test_count||' non-APEX tests.';
        end nonapex;
        <<apex_issues>>
        declare
        l_apx_test_count pls_integer := 0;
        begin 
          apex_debug.message(c_debug_template, '2. APEX Tests');
          for apx_rec in (select issue_category, test_code
                          from v_svt_stds_standard_tests
                          where issue_category = c_apex
                          and (issue_category = p_issue_category or p_issue_category is null)
                          and (test_code = p_test_code or p_test_code is null)
                          and (standard_id = p_standard_id or p_standard_id is null)
                          and active_yn = gc_y
                          and standard_active_yn  = gc_y
                          order by test_code)
          loop
            <<apxtstlp>>
            declare 
              t1 timestamp; 
              t2 timestamp; 
            begin 
              t1 := systimestamp; 
              apex_debug.message(c_debug_template, 'Start: '||t1, apx_rec.test_code);
              svt_plsql_apex_audit_api.merge_audit_tbl ( 
                                p_application_id => p_application_id,
                                p_page_id        => p_page_id,
                                p_test_code      => apx_rec.test_code,
                                p_issue_category => coalesce(p_issue_category, c_apex)
                              );
              t2 := systimestamp; 
              apex_debug.message(c_debug_template, 'End: '||t2, apx_rec.test_code);
              svt_test_timing_api.insert_timing(apx_rec.test_code, extract( second from (t2-t1) ));
              l_apx_test_count := l_apx_test_count + 1;
            end apxtstlp; 
          end loop;
          l_message := l_message || ' Ran '||l_apx_test_count||' APEX tests.';
        end apex_issues;
        assign_violations;
        p_message := l_message;
    exception 
      when e_deadlock then
        apex_debug.error(p_message => c_debug_template, p0 =>'Deadlock waiting for resource in record_daily_issue_snapshot', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
      when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end record_daily_issue_snapshot;
    procedure initialize_standard(p_test_code  in svt_stds_standard_tests.test_code%type)
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'initialize_standard';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
      svt_plsql_apex_audit_api.merge_audit_tbl ( 
                        p_test_code  => p_test_code,
                        p_legacy_yn  => gc_y
                      );
      svt_audit_util.assign_violations;
    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end initialize_standard;
    function min_not_met_error_msg return varchar2
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'min_not_met_error_msg';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START'
                       );
      return case when svt_stds_applications_api.active_app_count = 0
                  then 'No violations found because no apps have been registered.'
                  when svt_stds_standard_tests_api.active_test_count = 0
                  then 'No violations found because no active tests have been registered.'
                  end;
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end min_not_met_error_msg;
end SVT_AUDIT_UTIL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_COMPATIBILITY_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_compatibility_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_nested_table_types.created%type := systimestamp;
  gc_user         constant svt_nested_table_types.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  function insert_cmp (
        p_display_order      in svt_compatibility.display_order%type,
        p_compatibility_mode in svt_compatibility.compatibility_mode%type,
        p_compatibility_desc in svt_compatibility.compatibility_desc%type,
        p_type_name          in svt_compatibility.type_name%type
    ) return svt_compatibility.id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_id svt_compatibility.id%type;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_display_order', p_display_order,
                                       'p_compatibility_mode', p_compatibility_mode,
                                       'p_compatibility_desc', p_compatibility_desc,
                                       'p_type_name', p_type_name
                     );
   
   insert into svt_compatibility
   (
    display_order,
    compatibility_mode,
    compatibility_desc,
    type_name,
    created,
    created_by,
    updated,
    updated_by
   )
   values (
    p_display_order,
    p_compatibility_mode,
    p_compatibility_desc,
    p_type_name,
    gc_systimestamp,
    gc_user,
    gc_systimestamp,
    gc_user
   ) returning id into l_id;
   apex_debug.info(c_debug_template, 'l_id', l_id);
   return l_id;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end insert_cmp;
  procedure update_cmp (
        p_id                 in svt_compatibility.id%type,
        p_display_order      in svt_compatibility.display_order%type,
        p_compatibility_mode in svt_compatibility.compatibility_mode%type,
        p_compatibility_desc in svt_compatibility.compatibility_desc%type,
        p_type_name          in svt_compatibility.type_name%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   
   update svt_compatibility
   set display_order      = p_display_order,
       compatibility_mode = p_compatibility_mode,
       compatibility_desc = p_compatibility_desc,
       type_name          = p_type_name
    where id = p_id;
    apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end update_cmp;
  procedure delete_cmp (
        p_id in svt_compatibility.id%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   delete from svt_compatibility
    where id = p_id;
    apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end delete_cmp;
end svt_compatibility_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_COMPONENT_TYPES_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_COMPONENT_TYPES_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_nested_table_types.created%type := systimestamp;
  gc_user         constant svt_nested_table_types.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  function insert_cmp (
       p_component_name    in svt_component_types.component_name%type,
       p_available_yn      in svt_component_types.available_yn%type,
       p_nt_type_id        in svt_component_types.nt_type_id%type,
       p_pk_value          in svt_component_types.pk_value%type,
       p_parent_pk_value   in svt_component_types.parent_pk_value%type,
       p_template_url      in svt_component_types.template_url%type,
       p_friendly_name     in svt_component_types.friendly_name%type,
       p_name_column       in svt_component_types.name_column%type,
       p_addl_cols         in svt_component_types.addl_cols%type
    ) return svt_component_types.id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_id svt_component_types.id%type;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_component_name', p_component_name
                     );
   
   insert into svt_component_types
   (
    component_name,
    available_yn,
    nt_type_id,
    pk_value,
    parent_pk_value,
    template_url,
    friendly_name,
    name_column,
    addl_cols,
    created,
    created_by,
    updated,
    updated_by
   ) values (
    p_component_name,
    p_available_yn,
    p_nt_type_id,
    p_pk_value,
    p_parent_pk_value,
    p_template_url,
    p_friendly_name,
    p_name_column,
    p_addl_cols,
    gc_systimestamp,
    gc_user,
    gc_systimestamp,
    gc_user
   ) returning id into l_id;
   return l_id;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end insert_cmp;
  procedure update_cmp (
       p_id                in svt_component_types.id%type,
       p_component_name    in svt_component_types.component_name%type,
       p_available_yn      in svt_component_types.available_yn%type,
       p_nt_type_id        in svt_component_types.nt_type_id%type,
       p_pk_value          in svt_component_types.pk_value%type,
       p_parent_pk_value   in svt_component_types.parent_pk_value%type,
       p_template_url      in svt_component_types.template_url%type,
       p_friendly_name     in svt_component_types.friendly_name%type,
       p_name_column       in svt_component_types.name_column%type,
       p_addl_cols         in svt_component_types.addl_cols%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   
   update svt_component_types
   set component_name  = p_component_name,
       available_yn    = p_available_yn,
       nt_type_id      = p_nt_type_id,
       pk_value        = p_pk_value,
       parent_pk_value = p_parent_pk_value,
       template_url    = p_template_url,
       friendly_name   = p_friendly_name,
       name_column     = p_name_column,
       addl_cols       = p_addl_cols,
       updated         = gc_systimestamp,
       updated_by      = gc_user
   where id = p_id;
   apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end update_cmp;
  procedure delete_cmp (
        p_id in svt_component_types.id%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   
   delete from svt_component_types
   where id = p_id;
   apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end delete_cmp;
end SVT_COMPONENT_TYPES_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_CTX_UTIL" 
as
    gc_scope_prefix constant varchar2(32) := lower($$plsql_unit) || '.';
    gc_default_schema constant all_users.username%type := svt_preferences.get('SVT_DEFAULT_SCHEMA');
    procedure set_review_schema (p_schema in all_users.username%type default null)
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'set_review_schema';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_schema constant all_users.username%type := 
                                        case when p_schema is not null
                                             then p_schema
                                             else gc_default_schema
                                             end;
    begin
        apex_debug.message(c_debug_template,'START', 'p_schema', p_schema);
        if coalesce(sys_context('svt_ctx', 'review_schema'),'NA') = c_schema then
            apex_debug.message(c_debug_template, 'schema already set to :'||c_schema);
        else 
            dbms_session.set_context('svt_ctx',
                                    'review_schema', 
                                    c_schema
                                    );
        end if;
    exception when e_insufficient_privs then
        apex_debug.error(p_message => c_debug_template, p0 =>'Insufficient privileges', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
    end set_review_schema;
    function get_default_user 
    return all_users.username%type 
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_default_user';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_set_schema constant all_users.username%type := sys_context('svt_ctx', 'review_schema');
    begin
        -- apex_debug.message(c_debug_template,'START');
        return case when c_set_schema is null
                    then gc_default_schema
                    else c_set_schema
                    end;
    exception when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end get_default_user;
end SVT_CTX_UTIL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_DEPLOYMENT" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_DEPLOYMENT
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_y constant varchar2(1) := 'Y';
  gc_n constant varchar2(1) := 'N';
  gc_blob constant varchar2(4) := 'blob';
  gc_clob constant varchar2(4) := 'clob';
  function assemble_json_query (
                p_table_name    in user_tables.table_name%type,
                p_row_limit     in number default null,
                p_test_code     in svt_stds_standard_tests.test_code%type default null,
                p_standard_id   in svt_stds_standards.id%type default null,
                p_datatype      in varchar2 default 'blob')
  return clob 
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assemble_json_query';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_table_name constant varchar2(500)
              := case when upper(p_table_name) = 'SVT_STDS_STANDARD_TESTS'
                      then 'V_SVT_STDS_STANDARD_TESTS'
                      when upper(p_table_name) = 'V_SVT_STDS_STANDARD_TESTS_EXPORT'
                      then apex_string.format(
                              q'[svt_stds_standard_tests_api.v_svt_stds_standard_tests(%0p_published_yn => 'Y', p_active_yn => 'Y')]',
                              p0 => case when p_standard_id is not null 
                                         then 'p_standard_id => '||p_standard_id||', '
                                         end
                        )
                      else upper(p_table_name)
                      end;
  c_query_template constant varchar2(1000) := 
  'select json_arrayagg(json_object (jn.* returning %6) returning %6)
   from (select %7asrc.* %4
        from   except_cols (  
          %0,  
          columns ( %1 )  
        ) asrc
        %3
        %2) jn';
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  l_query clob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name,
                                        'p_row_limit', p_row_limit,
                                        'p_test_code', p_test_code,
                                        'p_standard_id', p_standard_id);
    l_query := apex_string.format(
      p_message =>   c_query_template,
      p0 => c_table_name,
      p1 =>  'avg_execution_seconds, date_started, row_version_number, account_locked, '
           ||'download, file_blob, mime_type, file_name, character_set, record_md5, estl_md5, '
           ||'publish_button_html, dlclss, publish_clss, publish_text, vsn, imported_version_number, '
           ||'standard_active_yn, urgency, std_creation_date, owner, '
          --  ||'updated, updated_by '
          --  ||' urgency_level, display_sequence, ' --need to export for SVT_STANDARDS_URGENCY_LEVEL
           ||' full_standard_name'
           || case when c_table_name = 'V_SVT_STDS_STANDARD_TESTS' and p_standard_id is not null
                   then ', standard_id'
                   end,
      p2 => case when p_row_limit is not null
                 then 'fetch first '||p_row_limit||' rows only'
                 end,
      p3 => case when c_table_name = 'V_SVT_STDS_STANDARD_TESTS' and c_test_code is not null
                 then apex_string.format(q'[where test_code = '%s']', c_test_code)
                 when c_table_name = 'SVT_STDS_STANDARDS' and p_standard_id is not null
                 then apex_string.format(q'[where id = '%s']', p_standard_id)
                 when c_table_name = 'SVT_STDS_STANDARDS' and p_standard_id is null
                 then q'[where active_yn = 'Y']'
                 end,
      p4 => case when c_table_name in ('V_SVT_STDS_STANDARD_TESTS','V_SVT_STDS_STANDARD_TESTS_EXPORT')
                 then apex_string.format(q'[, '%s' workspace]', svt_preferences.get('SVT_WORKSPACE'))
                 end,
      p6 => p_datatype,
      p7 => case when c_table_name = 'V_SVT_STDS_STANDARD_TESTS' and p_standard_id is not null
                 then p_standard_id||' standard_id, '
                 end
    );
    
    return l_query;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assemble_json_query;
  function assemble_json_std_tsts_qry (
                  p_standard_id   in svt_stds_standards.id%type,
                  p_test_code     in svt_stds_standard_tests.test_code%type default null,
                  p_datatype      in varchar2 default 'blob')
  return clob 
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assemble_json_std_tsts_qry';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_query clob;
  c_datatype constant varchar2(4) := case when lower(p_datatype) = gc_blob
                                          then gc_blob
                                          else gc_clob
                                          end;
  c_standard_id constant svt_stds_standards.id%type 
               := case when p_test_code is null 
                       then p_standard_id
                       else svt_stds_standard_tests_api.get_standard_id (p_test_code => p_test_code)
                       end;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'c_standard_id', c_standard_id,
                                        'p_test_code', p_test_code,
                                        'p_datatype', p_datatype);
    l_query := 
    apex_string.format(
    q'[
      select  json_object ( 
         'std_test' value json_object (
           'standard' value json_object(
             'standard_id'           value ess.id, 
             'standard_name'         value ess.standard_name,
             'description'           value ess.description,
             'compatibility_mode_id' value ess.compatibility_mode_id,
             'created'               value ess.created,
             'created_by'            value ess.created_by,
             'updated'               value ess.created,
             'updated_by'            value ess.created_by
           )
         ), 'test' value json_arrayagg (
           json_object (
             'test_id'               value esst.test_id, 
             'test_name'             value esst.test_name,
             'standard_id'           value esst.standard_id,
             'display_sequence'      value esst.display_sequence,
             'query_clob'            value esst.query_clob,
             'test_code'             value esst.test_code,
             'level_id'              value esst.level_id,
             'mv_dependency'         value esst.mv_dependency,
             'svt_component_type_id' value esst.svt_component_type_id,
             'explanation'           value esst.explanation,
             'fix'                   value esst.fix,
             'version_number'        value esst.version_number,
             'version_db'            value esst.version_db
             returning %1
           )  
           returning %1
         )
         returning %1
        ) thejson
    from svt_stds_standards ess
    inner join v_svt_stds_standard_tests_w_inherited esst on ess.id = esst.standard_id
    where ess.active_yn = 'Y'
    and esst.active_yn = 'Y'
    and ess.id = %0
    and (esst.test_code = '%2' or '%2' is null)
    group by ess.id, 
             ess.standard_name, 
             ess.description, 
             ess.compatibility_mode_id,
             ess.created,
             ess.created_by,
             ess.updated,
             ess.updated_by
    ]',
    p0 => c_standard_id,
    p1 => c_datatype,
    p2 => p_test_code
    );
    return l_query;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assemble_json_std_tsts_qry;
  function json_standard_tests_clob (
                  p_standard_id in svt_stds_standards.id%type,
                  p_test_code   in svt_stds_standard_tests.test_code%type default null
   ) return clob
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_standard_tests_clob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_query     clob;
  l_file_clob clob;
  c_test_code constant svt_stds_standard_tests.test_code%type := dbms_assert.noop(upper(p_test_code));
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_test_code', p_test_code
                                        );
    l_query := assemble_json_std_tsts_qry (
                    p_standard_id   => p_standard_id,
                    p_test_code     => c_test_code,
                    p_datatype      => gc_clob);
    execute immediate l_query into l_file_clob;
    return l_file_clob;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end json_standard_tests_clob;
  
  function json_standard_tests_blob (
                  p_standard_id in svt_stds_standards.id%type,
                  p_test_code   in svt_stds_standard_tests.test_code%type default null
  ) return blob
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_standard_tests_blob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant svt_stds_standard_tests.test_code%type := dbms_assert.noop(upper(p_test_code));
  l_query     clob;
  l_file_blob blob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_test_code', p_test_code
                                        );
    l_query := assemble_json_std_tsts_qry (
                    p_standard_id   => p_standard_id,
                    p_test_code     => c_test_code,
                    p_datatype      => gc_blob);
    execute immediate l_query into l_file_blob;
    return l_file_blob;
  exception 
    when no_data_found then
      apex_debug.message(c_debug_template,' no data found');
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end json_standard_tests_blob;
  function json_content_blob (p_table_name    in user_tables.table_name%type,
                              p_row_limit     in number default null,
                              p_test_code     in svt_stds_standard_tests.test_code%type default null,
                              p_standard_id   in svt_stds_standards.id%type default null,
                              p_zip_yn        in varchar2 default null)
  return blob
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_content_blob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_table_name constant user_tables.table_name%type 
              := dbms_assert.sql_object_name (upper(p_table_name));
  l_query     clob;
  l_file_blob blob;
  c_zip_yn    constant varchar2(1) := case when upper(p_zip_yn) = gc_y
                               then gc_y
                               else gc_n
                               end;
  l_zip_file blob;
  l_final_blob blob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name,
                                        'p_row_limit', p_row_limit,
                                        'p_test_code', p_test_code,
                                        'p_standard_id', p_standard_id,
                                        'p_zip_yn', p_zip_yn);
    l_query := assemble_json_query (
                    p_table_name    => c_table_name,
                    p_row_limit     => p_row_limit,
                    p_test_code     => p_test_code,
                    p_standard_id   => p_standard_id,
                    p_datatype      => gc_blob);
    execute immediate l_query into l_file_blob;
    if c_zip_yn = gc_y then
      apex_zip.add_file (
              p_zipped_blob => l_zip_file,
              p_file_name   => 'hayden',
              p_content     => l_file_blob );
      l_final_blob := l_zip_file;
    else 
      l_final_blob := l_file_blob;
    end if;
    return l_final_blob;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end json_content_blob;
  function json_content_clob (p_table_name    in user_tables.table_name%type,
                              p_row_limit     in number default null,
                              p_test_code     in svt_stds_standard_tests.test_code%type default null,
                              p_standard_id   in svt_stds_standards.id%type default null)
  return clob
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_content_clob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_table_name constant user_tables.table_name%type 
              := dbms_assert.sql_object_name (upper(p_table_name));
  l_query     clob;
  l_file_clob clob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name,
                                        'p_row_limit', p_row_limit,
                                        'p_test_code', p_test_code,
                                        'p_standard_id', p_standard_id);
    l_query := assemble_json_query (
                    p_table_name    => c_table_name,
                    p_row_limit     => p_row_limit,
                    p_test_code     => p_test_code,
                    p_standard_id   => p_standard_id,
                    p_datatype      => gc_clob);
    execute immediate l_query into l_file_clob;
    return l_file_clob;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end json_content_clob;
  function sample_template_file (p_table_name in user_tables.table_name%type)
  return blob
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'sample_template_file'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_table_name', p_table_name);
    return json_content_blob (p_table_name => p_table_name,
                              p_row_limit => 5);
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end sample_template_file;
  procedure upsert_static_file(p_table_name in user_tables.table_name%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'upsert_static_file';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_zip_file blob;
  c_base_file_name constant user_tables.table_name%type := lower(p_table_name);
  c_json_file_name constant user_tables.table_name%type := c_base_file_name||'.json';
  c_zip_file_name  constant user_tables.table_name%type := 'data/'||c_base_file_name||'.zip';
  l_content_blob blob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name);
    l_content_blob := json_content_blob (p_table_name => p_table_name);
    
    apex_zip.add_file (
            p_zipped_blob => l_zip_file,
            p_file_name   => c_json_file_name,
            p_content     => l_content_blob );
    apex_zip.finish (
        p_zipped_blob => l_zip_file );
    
    wwv_flow_imp_shared.create_app_static_file (
       p_flow_id      => svt_apex_view.gc_svt_app_id,
       p_file_name    => c_zip_file_name,
       p_mime_type    => 'application/zip',
       p_file_charset =>' utf-8',
       p_file_content => l_zip_file
    );
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end upsert_static_file;
  procedure merge_from_zip (p_table_name in user_tables.table_name%type)
  as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'merge_from_zip';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_table_name constant user_tables.table_name%type := upper(p_table_name);
    l_content_blob blob;
    l_static_id apex_appl_data_loads.static_id%type;
    l_content_clob clob;
    l_load_result apex_data_loading.t_data_load_result;
  begin
    apex_debug.message(c_debug_template,'START');
    select apex_zip.get_file_content (
                    p_zipped_blob => aasf.file_content,
                    p_file_name   => lower(aadl.table_name)||'.json'
            ) thejson, aadl.static_id
    into l_content_blob, l_static_id
    from apex_appl_data_loads aadl
    inner join apex_application_static_files aasf on aasf.file_name = 'data/'||lower(aadl.table_name)||'.zip'
    where aadl.application_id = v('APP_ID')
    and aadl.table_name = c_table_name;
    l_content_clob := to_clob(utl_raw.cast_to_varchar2(dbms_lob.substr(l_content_blob,dbms_lob.getlength(l_content_blob)))); 
    
    -- 
    l_load_result := apex_data_loading.load_data (
                       p_static_id    => l_static_id,
                       p_data_to_load => l_content_clob );
    apex_debug.message(c_debug_template, 'Processed ' || l_load_result.processed_rows || ' rows.');
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end merge_from_zip;
  function table_last_updated_on (p_table_name in user_tables.table_name%type) return apex_application_static_files.created_on%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'table_last_updated_on';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_most_recent_date apex_application_static_files.created_on%type;
  c_query_template constant varchar2(1000) := 'select updated from %s order by updated desc fetch first 1 rows only';
  c_table_name constant user_tables.table_name%type 
              := dbms_assert.sql_object_name (upper(p_table_name));
  begin
    apex_debug.message(c_debug_template,'START', 'p_table_name', p_table_name);
    execute immediate apex_string.format(c_query_template, c_table_name) into l_most_recent_date;
    
    return l_most_recent_date;
  exception 
    when no_data_found then 
      apex_debug.message(c_debug_template, 'no data found for table : ', p_table_name);
      return null;
    when e_missing_field then
      apex_debug.message(c_debug_template, 'error for table : ', p_table_name);
      return null;
    when e_non_existent_tbl then
      apex_debug.message(c_debug_template, 'non-existent table : ', p_table_name);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end table_last_updated_on;
  function v_svt_table_data_load_def (p_application_id in apex_applications.application_id%type)
  return v_svt_table_data_load_def_nt pipelined
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_table_data_load_def';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  
  cursor cur_aa
    is
  with std as (
    select ut.table_name, 
           'application/json' mime_type,
           apex_string.format('%s.json', lower(ut.table_name)) file_name,
           'UTF-8' character_set
    from user_tables ut
    where ut.table_name not like 'DATABASECHANGELOG%'
    and ut.table_name not like 'DEV%'
    and ut.table_name not like 'MV%'
    and ut.table_name not in ('SVT_STDS_STANDARD_TESTS','SVT_STDS_TESTS_LIB')
  )
    select std.table_name, 
          std.mime_type,
          std.file_name,
          aasf.file_name static_file_name,
          std.character_set,
          aadl.name data_load_definition_name,
          aasf.file_name static_application_file_name,
          case when aasf.file_name is not null 
                and aadl.name is not null
                then '<span aria-hidden="true" class="t-Icon fa fa-search-plus"></span>'
                end inspect_static_file_icon,
          aap.page_id,
          case when aap.page_id is not null
                then '<span aria-hidden="true" class="t-Icon fa fa-map-marker-o"></span>'
                end page_id_icon,
          aasf.application_file_id,
          aasf.file_content zip_blob,
          aasf.mime_type zip_mime_type, 
          aasf.file_charset zip_charset, 
          aasf.last_updated_on zip_updated_on,
          aasf.created_on static_file_created_on
    from std
    left outer join apex_appl_data_loads aadl on aadl.table_name = std.table_name
                                              and aadl.application_id = p_application_id
                                              and aadl.static_id = lower(std.table_name)
    left outer join apex_application_static_files aasf on  aasf.application_id = p_application_id
                                                      and aasf.file_name like 'data/%'
                                                      and aasf.file_name = 'data/'||lower(std.table_name)||'.zip'
    left outer join apex_application_pages aap on aap.application_id = p_application_id
                                              and aap.page_comment = std.table_name;
    type r_aa is record (
      table_name                   varchar2(128),
      mime_type                    char(16),
      file_name                    varchar2(4000), 
      static_file_name             varchar2(255),  
      character_set                char(5),        
      data_load_definition_name    varchar2(255),  
      static_application_file_name varchar2(255),  
      inspect_static_file_icon     char(65),       
      page_id                      number,
      page_id_icon                 char(66),       
      application_file_id          number,
      zip_blob                     blob,
      zip_mime_type                varchar2(255),  
      zip_charset                  varchar2(128),  
      zip_updated_on               date,
      static_file_created_on       date
    );
    type t_aa is table of r_aa index by pls_integer;
    l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START', 'p_application_id', p_application_id);
    open cur_aa;
    loop
      fetch cur_aa bulk collect into l_aat limit 1000;
      exit when l_aat.count = 0;
      for rec in 1 .. l_aat.count
      loop
        <<load_block>>
        declare
        c_overwrite_table_name constant varchar2(255) := l_aat (rec).table_name;
              -- := case when l_aat (rec).table_name = 'SVT_STDS_TESTS_LIB'
              --         then 'SVT_STDS_STANDARD_TESTS'
              --         else l_aat (rec).table_name
              --         end;
        c_file_blob constant blob := sample_template_file (p_table_name => l_aat (rec).table_name);
        c_file_size constant pls_integer := sys.dbms_lob.getlength(c_file_blob);
        c_zip_size  constant pls_integer := sys.dbms_lob.getlength(l_aat (rec).zip_blob);
        c_table_last_updated_on constant date := svt_deployment.table_last_updated_on(c_overwrite_table_name);
        begin
        pipe row (v_svt_table_data_load_def_ot (
                      c_overwrite_table_name,
                      l_aat (rec).table_name,
                      c_file_blob, --file_blob
                      l_aat (rec).mime_type,
                      l_aat (rec).file_name,
                      l_aat (rec).static_file_name,
                      l_aat (rec).character_set,
                      c_file_size, -- file_size
                      c_file_size, -- download
                      l_aat (rec).data_load_definition_name,
                      l_aat (rec).static_application_file_name,
                      l_aat (rec).inspect_static_file_icon,
                      l_aat (rec).page_id,
                      l_aat (rec).page_id_icon,
                      l_aat (rec).application_file_id,
                      l_aat (rec).zip_blob,
                      c_zip_size, --zip_file_size
                      c_zip_size, --zip_download
                      l_aat (rec).zip_mime_type,
                      l_aat (rec).zip_charset,
                      l_aat (rec).zip_updated_on,
                      c_table_last_updated_on,
                      l_aat (rec).static_file_created_on,
                      case when c_table_last_updated_on is not null 
                           and l_aat (rec).zip_updated_on is not null
                           then case when c_table_last_updated_on > l_aat (rec).zip_updated_on
                                     then gc_y
                                     else gc_n
                                     end
                           else gc_n
                           end --stale_yn
                    )
                );
          end load_block;
      end loop;
    end loop;  
  
  exception 
    when no_data_needed then
      apex_debug.message(c_debug_template, 'No data needed');
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt_table_data_load_def;
  function markdown_summary return clob
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'markdown_summary';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_md_clob clob;
  c_intro constant clob :=
  '# Standards and Tests available for download and import'
  ||chr(10)
  ||chr(10);
  c_summary constant clob :=
  '## Summary and instructions' 
  ||chr(10)
  || apex_string.format(q'[This page lists %0 published tests distributed across %1 standards (*%2*) and %3 issue categories (*%4*).]',
                          p0 => svt_stds_standard_tests_api.active_test_count,
                          p1 => svt_stds_standards_api.active_standard_count,
                          p2 => svt_stds_standards_api.active_standard_list,
                          p3 => svt_nested_table_types_api.nt_count,
                          p4 => svt_nested_table_types_api.nt_list)                
  ||' Download either the "consolidated test exports" or the individual tests for import into your Standard Violation Tracker instance.'
  ||chr(10)
  ||chr(10);
  c_headers_md constant clob := chr(10)||
   '| Test Code | Test Name | Version* | Component Type |'||
   chr(10)||
   '|-----------|-----------|---------|----------------|'||
   chr(10);
  c_addendum constant clob :=
  chr(10)
  ||'* Test versions are idenfied by an incrementing number and the name of the database on which they were developed.'
  ||' The addition of the database name allows us to distinguish between tests that have been imported and untouched and ones that have been modified locally after import.';
  begin
    apex_debug.message(c_debug_template,'START');
    l_md_clob := c_intro || c_summary;
    for srec in (select id, standard_name, svt_stds.file_name(full_standard_name) file_name, description, compatibility_text
                 from v_svt_stds_standards
                 where active_yn = gc_y
                 order by standard_name, display_order)
    loop 
      apex_debug.message(c_debug_template, 'file_name', srec.file_name);
      
      l_md_clob := l_md_clob
                   ||apex_string.format(
                      '## %0 (%2)',
                      p0 => srec.standard_name,
                      p2 => srec.compatibility_text)
                   ||chr(10)
                   ||srec.description
                   ||chr(10)
                   ||chr(10);
      l_md_clob := l_md_clob
                   ||apex_string.format(
                      ' - [Consolidated tests export for %0](%1/ALL_TESTS-%1.json)',
                      p0 => srec.standard_name,
                      p1 => srec.file_name,
                      p2 => srec.compatibility_text)
                   ||chr(10)
                   ||c_headers_md;
      <<test_sec>>
      declare
      l_test_md clob;
      begin
        
        for trec in (select test_code, test_name, vsn, component_name, file_name, version_db
                      from svt_stds_standard_tests_api.v_svt_stds_standard_tests(
                          p_standard_id => srec.id,
                          p_active_yn => gc_y,
                          p_standard_active_yn => gc_y,
                          p_published_yn => gc_y
                      ) order by test_code
                    )
        loop 
          apex_debug.message(c_debug_template, 'test_code', trec.test_code);
          l_test_md := l_test_md
          ||apex_string.format(
            '| [%1](%3/tests/%0) |  %4 | %2 [%6] | %5 |',
            p0 => trec.file_name,
            p1 => trec.test_code,
            p2 => trec.vsn,
            p3 => srec.file_name,
            p4 => trec.test_name,
            p5 => trec.component_name,
            p6 => trec.version_db
            )
          ||chr(10);
        end loop;
        l_md_clob := l_md_clob || l_test_md || chr(10);
      end test_sec;
    end loop;
      l_md_clob := l_md_clob || c_addendum;
    return l_md_clob;
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end markdown_summary;
  
end SVT_DEPLOYMENT;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_ERROR_HANDLER_API" is
/* Create a message using apex_lang. This message can be managed using Shared Components -> Text Messages in APEX 
   Autonomous Transaction to not commit any other transactions that may happen in page
*/
function create_and_return_text_message 
   (p_constraint_name varchar2
   ) return varchar2 is
    PRAGMA AUTONOMOUS_TRANSACTION;  
    c_developer_todo_message constant varchar2(100) := 'DEVELOPER TODO: Provide better message in APEX Shared Components Text Messages for ';
    c_message constant varchar2(4000) :=  c_developer_todo_message || p_constraint_name ;
begin
   apex_lang.create_message
      (p_application_id  => v('APP_ID'), /* This could be a common text library application */
       p_name            => p_constraint_name,
       p_language        => coalesce(apex_util.get_preference('FSP_LANGUAGE_PREFERENCE'), 'en'),
       p_message_text    => c_message 
       );
       commit;
       return c_message;
end create_and_return_text_message;
function error_handler 
   (p_error in apex_error.t_error
   ) return apex_error.t_error_result is
    l_result          apex_error.t_error_result;
    l_reference_id    number;
    l_constraint_name varchar2(255);
begin
    l_result := apex_error.init_error_result (
                    p_error => p_error );
    -- If it's an internal error raised by APEX, like an invalid statement or
    -- code which can't be executed, the error text might contain security sensitive
    -- information. To avoid this security problem we can rewrite the error to
    -- a generic error message and log the original error message for further
    -- investigation by the help desk.
    if p_error.is_internal_error then
        -- mask all errors that are not common runtime errors (Access Denied
        -- errors raised by application / page authorization and all errors
        -- regarding session and session state)
        if not p_error.is_common_runtime_error then
            -- log error for example with an autonomous transaction and return
            -- l_reference_id as reference#
            -- l_reference_id := log_error (
            --                       p_error => p_error );
            --
            -- Change the message to the generic error message which doesn't expose
            -- any sensitive information.
            l_result.message         := 'An unexpected internal application error has occurred. '||
                                        'Please get in contact with XXX and provide '||
                                        'reference# '||to_char(l_reference_id, '999G999G999G990')||
                                        ' for further investigation.';
            l_result.additional_info := null;
        end if;
    else
        -- Always show the error as inline error
        -- Note: If you have created manual tabular forms (using the package
        --       apex_item/htmldb_item in the SQL statement) you should still
        --       use "On error page" on that pages to avoid loosing entered data
        l_result.display_location := case
                                       when l_result.display_location = apex_error.c_on_error_page then apex_error.c_inline_in_notification
                                       else l_result.display_location
                                     end;
        --
        -- Note: If you want to have friendlier ORA error messages, you can also define
        --       a text message with the name pattern APEX.ERROR.ORA-number
        --       There is no need to implement custom code for that.
        --
        -- If it's a constraint violation like
        --
        --   -) ORA-00001: unique constraint violated
        --   -) ORA-02091: transaction rolled back (-> can hide a deferred constraint)
        --   -) ORA-02290: check constraint violated
        --   -) ORA-02291: integrity constraint violated - parent key not found
        --   -) ORA-02292: integrity constraint violated - child record found
        --
        -- we try to get a friendly error message from our constraint lookup configuration.
        -- If we don't find the constraint in our lookup table we fallback to
        -- the original ORA error message.
        if p_error.ora_sqlcode in (-1, -2091, -2290, -2291, -2292) then
            l_constraint_name := apex_error.extract_constraint_name (
                                     p_error => p_error );
            /*
            begin
                select message
                  into l_result.message
                  from constraint_lookup
                 where constraint_name = l_constraint_name;
            exception when no_data_found then null; -- not every constraint has to be in our lookup table
            end;
            */
            -- Instant Tip - Error handler function 
            -- Hat tip to Roel https://roelhartman.blogspot.com/2021/02/stop-using-validations-for-checking.html
            l_result.message := apex_lang.message(l_constraint_name); /* This could be from a common text library application */
                        
            if l_result.message = l_constraint_name then
               l_result.message := create_and_return_text_message (p_constraint_name => l_constraint_name);
            end if;   
            -- Random Thoughts: Every pizza is a personal pizza if you try hard and believe in yourself.. - Demetri Martin
            -- Instant Tip - Error handler function End      
        end if;
        -- If an ORA error has been raised, for example a raise_application_error(-20xxx, '...')
        -- in a table trigger or in a PL/SQL package called by a process and we
        -- haven't found the error in our lookup table, then we just want to see
        -- the actual error text and not the full error stack with all the ORA error numbers.
        if p_error.ora_sqlcode is not null and l_result.message = p_error.message then
            l_result.message := apex_error.get_first_ora_error_text (
                                    p_error => p_error );
        end if;
        -- If no associated page item/tabular form column has been set, we can use
        -- apex_error.auto_set_associated_item to automatically guess the affected
        -- error field by examine the ORA error for constraint names or column names.
        if l_result.page_item_name is null and l_result.column_alias is null then
            apex_error.auto_set_associated_item (
                p_error        => p_error,
                p_error_result => l_result );
        end if;
    end if;
    return l_result;
end error_handler;
end SVT_ERROR_HANDLER_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_MENU_UTIL" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_menu_util
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  function is_component_used_yn (
                  p_build_option_id           IN NUMBER   DEFAULT NULL,
                  p_authorization_scheme_id   IN VARCHAR2,
                  p_condition_type            IN VARCHAR2,
                  p_condition_expression1     IN VARCHAR2,
                  p_condition_expression2     IN VARCHAR2,
                  p_component                 IN VARCHAR2 DEFAULT NULL )
              return varchar2 is
  begin
    return case when 
      apex_plugin_util.is_component_used (
      p_build_option_id           => p_build_option_id,
      p_authorization_scheme_id   => p_authorization_scheme_id,
      p_condition_type            => p_condition_type,
      p_condition_expression1     => p_condition_expression1,
      p_condition_expression2     => p_condition_expression2,
      p_component                 =>  p_component)
      then 'Y'
      else 'N'
      end;
  end is_component_used_yn;
  function is_authorized_yn (
    p_authorization_name in apex_application_list_entries.authorization_scheme%type
  ) return varchar2
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'is_authorized_yn';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_authorization_name', p_authorization_name);
    
    return case apex_authorization.is_authorized (
                       p_authorization_name => p_authorization_name )
              when true then 'Y'
              else 'N'
              end;
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end is_authorized_yn;
end SVT_MENU_UTIL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_MONITORING" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_MONITORING
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso   2022-Dec-16 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_fetch_rows   constant number := 1;
  gc_table_start constant varchar2(250):= 
      '<table width="600" border="5px solid black">
          <tr>
            <th align="left">%0 violations</th>
          </tr>';
  gc_table_end   constant varchar2(50) := '</table>';
  gc_apex        constant varchar2(4)  := 'APEX';
  gc_max_urgency constant number := 99;
  gc_max_title_length constant number := 100;
  gc_max_row_count constant pls_integer := 9;
  function app_url (p_application_id in apex_applications.application_id%type default null) 
  return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'app_url';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_application_id constant apex_applications.application_id%type
                   := coalesce(p_application_id, svt_apex_view.gc_svt_app_id);
  begin
    apex_debug.message(c_debug_template,'START');
    return apex_string.format(
            p_message => '%0f?p=%1',
            p0 => svt_stds_parser.get_base_url(),
            p1 => c_application_id
    );
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end app_url;
  function db_unique_name return varchar2
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'db_unique_name';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');
    return ora_database_name;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end db_unique_name;
  function unassigned_src_html 
    (p_test_code  in svt_stds_standard_tests.test_code%type,
     p_days_since in number default 1,
     p_fetch_rows in number default null
    ) return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'unassigned_src_html';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_limit     constant pls_integer := 110;
  c_fetch_rows constant number :=coalesce(p_fetch_rows, gc_fetch_rows);
  cursor cur_SVT (p_test_code varchar2) is 
  select  case when length(pad.issue_title) > gc_max_title_length 
               then substr(pad.issue_title, 1,gc_max_title_length)||'...'
               else pad.issue_title
               end issue_title, 
         pad.audit_id
  from v_svt_plsql_apex_audit pad
  where pad.test_code = p_test_code
  and created > 
      case when to_char(sysdate, 'fmdy') not in ('mon')
          then sysdate - p_days_since
          else sysdate - (p_days_since + 2)
          end
  and pad.assignee is null
  and pad.recent_yn = 'Y'
  order by urgency_level, audit_id
  fetch first c_fetch_rows rows only;
  type r_issues is record (
    issue_title svt_plsql_apex_audit.issue_title%type,
    audit_id    svt_plsql_apex_audit.id%type
  ); 
  type t_issue_rec is table of r_issues; 
  l_issues_t   t_issue_rec;
    ------------------------------------------------------------------------------
    -- nested function to add html rows
    ------------------------------------------------------------------------------
    function html_rows(p_test_code in svt_stds_standard_tests.test_code%type) 
    return varchar2
    is 
    l_row_count pls_integer := 0;
    l_row_html varchar2(4000);
    begin
      open cur_SVT (p_test_code);
      loop
        fetch cur_SVT
        bulk collect into l_issues_t
        limit c_limit;
        for i in 1..l_issues_t.count
        loop
          l_row_count := l_row_count + 1;
          l_row_html := l_row_html ||
          apex_string.format(
            p_message => 
            '<tr>
              <td>• %0 [Audit id : %1]</td>
            </tr>',
            p0 => l_issues_t(i).issue_title,
            p1 => l_issues_t(i).audit_id
          );
        end loop;
        exit when cur_SVT%notfound;
      end loop;
      return 
        case when l_row_count > 0
             then l_row_html 
             end;
    end html_rows;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    return html_rows(p_test_code);
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end unassigned_src_html;
  function get_db_name return varchar2
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_db_name'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');
    return case 
           when svt_preferences.get(p_preference_name => 'SVT_DB_NAME') is not null 
           then svt_preferences.get(p_preference_name => 'SVT_DB_NAME')
           else 'Unspecified DB Name'
           end;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_db_name;
  ------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 11, 2023
-- Synopsis:
--
-- Private procedure to get email html 
--
------------------------------------------------------------------------------
  procedure get_email_html (
    p_unassigned_html in varchar2,
    p_assigned_html   in varchar2,
    p_days_since      in number,
    p_application_id  in apex_applications.application_id%type default null,
    p_subject         out nocopy varchar2,
    p_html            out nocopy clob,
    p_text            out nocopy clob
  )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_email_html';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_html        clob;
  l_subscriber_list varchar2(4000);
  c_application_id  constant apex_applications.application_id%type :=
                    coalesce(p_application_id, svt_apex_view.gc_svt_app_id);
  begin
    apex_debug.message(c_debug_template,'START');
    begin <<subs_lst>>
      select listagg(user_name, ', ') within group (order by user_name) mylist
      into l_subscriber_list
      from v_svt_email_subscriptions;
    exception when no_data_found then
      apex_debug.error(p_message => c_debug_template, p0 =>'No subscribers!', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end subs_lst;
    apex_mail.prepare_template (
      p_static_id         => 'STANDARD_VIOLATION_DAILY_ALERT',
      p_placeholders      => 
      apex_string.format(
        p_message => q'~
          {
              "ENVIRONMENT" : "%0",
              "DAY_COUNT": "%1",
              "REPORT_LINK": "%2",
              "WORKSPACE_LINK": "%3",
              "MAX_URGENCY" : "%4",
              "SUBSCRIBER_LIST" :"%5",
              "DBNAME" : "%6"
          }~',
        p0 => get_db_name(),
        p1 => p_days_since,
        p2 => app_url(),
        p3 => svt_stds_parser.get_base_url(),
        p4 => gc_max_urgency,
        p5 => 'This email is subscribed to by : '||l_subscriber_list,
        p6 => db_unique_name
      ),
      p_application_id    => c_application_id, 
      p_subject           => p_subject,
      p_html              => l_html,
      p_text              => p_text
    );
    l_html := replace(l_html, 'UNASSIGNED_REPORT_HTML', p_unassigned_html); 
    l_html := replace(l_html, 'ASSIGNED_REPORT_HTML', p_assigned_html); 
    p_html := l_html;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_email_html;
  function unassigned_html_by_src (p_days_since in number) return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'unassigned_html_by_src';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_unassigned_report_html clob;
  l_row_count pls_integer := 0;
  begin
    apex_debug.message(c_debug_template,'START', 'p_days_since', p_days_since);
    for rec in (select src.test_code
                from v_svt_stds_standard_tests src
                where src.urgency_level <= gc_max_urgency
                order by src.urgency_level, src.test_code
                -- fetch first gc_max_row_count rows only
                )
    loop
      l_row_count := 1 + l_row_count;
      exit when l_row_count > gc_max_row_count;
      l_unassigned_report_html := l_unassigned_report_html||
                                   unassigned_src_html (
                                            p_test_code => rec.test_code,
                                            p_days_since    => p_days_since);
    end loop;     
    return case when l_unassigned_report_html is not null 
                then apex_string.format(gc_table_start, 'Unassigned')||l_unassigned_report_html||gc_table_end
                end;
  exception when others then 
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end unassigned_html_by_src;
  procedure assigned_html (
        p_days_since           in number,
        p_assigned_report_html out nocopy clob,
        p_list_of_assignees    out nocopy varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assigned_html';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_assigned_report_html clob;
  type t_aa_email is table of integer index by varchar2(101);
  l_aa_emails  t_aa_email;
  l_list_of_assignees varchar2(4000);
  l_email varchar2(101);
  l_row_count pls_integer := 0;
  begin
    apex_debug.message(c_debug_template,'START', 'p_days_since', p_days_since);
    for rec in (
      select case when length(pad.issue_title) > gc_max_title_length 
                  then substr(pad.issue_title, 1,gc_max_title_length)||'...'
                  else pad.issue_title
                  end issue_title, 
         pad.audit_id,
         pad.assignee,
         pad.test_code,
         dense_rank() over ( partition by assignee, test_code order by audit_id desc) print_rank
      from v_svt_plsql_apex_audit pad
      where coalesce(apex_created_on, created) > 
              case when to_char(sysdate, 'fmdy') not in ('mon')
                  then sysdate - p_days_since
                  else sysdate - (p_days_since + 2)
                  end
      and assignee is not null
      and recent_yn = 'Y'
      and urgency_level <= gc_max_urgency
      order by urgency_level, audit_id
    ) loop
      l_row_count := case when rec.print_rank <= gc_fetch_rows
                          then 1 + l_row_count
                          else l_row_count
                          end;
      exit when l_row_count > gc_max_row_count;
      -- dbms_output.put_line('l_row_count :'||l_row_count);
      l_aa_emails(rec.assignee) := rec.audit_id;
      l_assigned_report_html := l_assigned_report_html || 
                                case when rec.print_rank <= gc_fetch_rows
                                     then apex_string.format(
                                          p_message => 
                                          '<tr>
                                            <td>• %0 [Assigned to : %2] [Audit id : %1]</td>
                                          </tr>',
                                          p0 => rec.issue_title,
                                          p1 => rec.audit_id,
                                          p2 => rec.assignee,
                                          p3 => l_row_count
                                        )
                                      end;
    end loop;
    p_assigned_report_html := 
    case when l_assigned_report_html is not null 
         then apex_string.format(gc_table_start, 'Assigned')||l_assigned_report_html||gc_table_end
         end;
    if l_aa_emails.count > 1
    then
      l_email := l_aa_emails.first;
      loop
        exit when l_email is null;
        l_list_of_assignees := l_list_of_assignees||':'||l_email;
        l_email := l_aa_emails.next(l_email);
      end loop;
    else 
      l_list_of_assignees := l_aa_emails.first;
    end if;
    p_list_of_assignees := l_list_of_assignees;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assigned_html;
  procedure send_email (
              p_to        in varchar2,
              p_from      in varchar2,
              p_subj      in varchar2,
              p_body      in clob,
              p_body_html in clob
  )
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'send_email';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_to', p_to,
                                        'p_from', p_from,
                                        'p_subj', p_subj
                                        );
    $if oracle_apex_version.c_email_na
    $then
      raise_application_error(-20123, 'No email api configured!'); 
    $end
    $if oracle_apex_version.c_email_afw 
    $then 
      afw_messaging.send (
                p_to           => p_to,
                p_from         => p_from,
                p_subj         => p_subj,
                p_body         => p_body,
                p_body_html    => p_body_html,
                p_message_guid => null
              );
    $end
    
    if svt_preferences.get('SVT_EMAIL_API') = gc_apex then
      <<apx_ml>>
      declare 
      l_id number;
      begin
        l_id   := apex_mail.send(
          p_to        => p_to,
          p_from      => p_from,
          p_body      => p_body,
          p_body_html => p_body_html,
          p_subj      => p_subj);
      end apx_ml;
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end send_email;
  procedure push_email
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'push_email';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    
    $if oracle_apex_version.c_email_na
    $then
      raise_application_error(-20123, 'No email api configured!'); 
    $end
    $if oracle_apex_version.c_email_afw 
    $then 
      afw_messaging.push (p_type => 'EMAIL');
    $end
    
    if svt_preferences.get('SVT_EMAIL_API') = gc_apex then
      apex_mail.push_queue;
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end push_email;
  procedure send_update(p_days_since  in number default 1,
                        p_override_email in varchar2 default null)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'send_update';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_from_email constant varchar2(50) := svt_preferences.get('SVT_FROM_EMAIL');
  l_subject     varchar2(4000);
  l_html        clob;
  l_text        clob;
  l_unassigned_report_html clob;
  l_assigned_report_html   clob;
  l_assignees              varchar2(4000);
  begin
    apex_debug.message(c_debug_template,'START',
                                        'p_days_since', p_days_since,
                                        'p_override_email', p_override_email);
    l_unassigned_report_html := unassigned_html_by_src (p_days_since  => p_days_since);
    assigned_html (
        p_days_since           => p_days_since,
        p_assigned_report_html => l_assigned_report_html,
        p_list_of_assignees    => l_assignees);
    case when l_unassigned_report_html||l_assigned_report_html is not null
         then 
          get_email_html (
            p_unassigned_html => l_unassigned_report_html,
            p_assigned_html   => l_assigned_report_html,
            p_days_since      => p_days_since, 
            p_subject         => l_subject,
            p_html            => l_html,
            p_text            => l_text
          );
          for rec in (
                select distinct coalesce(p_override_email, email) email
                from v_svt_email_subscriptions
                union
                select coalesce(p_override_email, column_value) email
                from table(apex_string.split(l_assignees, ':'))
                where column_value is not null
              )
          loop
            apex_debug.warn(c_debug_template, 'rec.email', rec.email);
            send_email (
              p_to           => rec.email,
              p_from         => c_from_email,
              p_subj         => l_subject,
              p_body         => l_text,
              p_body_html    => l_html
            );
          end loop;
          svt_monitoring.push_email;
        else 
          apex_debug.message(c_debug_template, 'No standard violations found', p_days_since);
    end case; 
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end send_update;
  procedure enable_automations (p_application_id in apex_applications.application_id%type default null)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'enable_automations';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_disabled constant apex_appl_automations.polling_status_code%type := 'DISABLED';
  c_application_id constant apex_applications.application_id%type 
                   := coalesce(p_application_id, svt_apex_view.gc_svt_app_id);
  begin
    apex_debug.message(c_debug_template,'START');
    for rec in (select application_id, static_id
                from apex_appl_automations
                where polling_status_code = c_disabled
                and application_id = c_application_id)
    loop
      apex_automation.enable(
          p_application_id  => rec.application_id,
          p_static_id       => rec.static_id );
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end enable_automations;
end SVT_MONITORING;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_NESTED_TABLE_TYPES_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_nested_table_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-23 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_nested_table_types.created%type := systimestamp;
  gc_user         constant svt_nested_table_types.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  function insert_nt (
        p_nt_name       in svt_nested_table_types.nt_name%type,
        p_example_query in svt_nested_table_types.example_query%type,
        p_object_type   in svt_nested_table_types.object_type%type
    ) return svt_nested_table_types.id%type
  as 
  c_scope          constant varchar2(128) := gc_scope_prefix || 'insert_nt';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_id svt_nested_table_types.id%type;
  c_nt_name     constant svt_nested_table_types.nt_name%type := upper(p_nt_name);
  c_object_type constant svt_nested_table_types.object_type%type := upper(p_object_type);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_nt_name', p_nt_name,
                                        'p_object_type', p_object_type);
    insert into svt_nested_table_types
    (
      nt_name,
      example_query,
      object_type,
      created,
      created_by,
      updated,
      updated_by
    )
    values 
    (
      c_nt_name,
      p_example_query,
      c_object_type,
      gc_systimestamp,
      gc_user,
      gc_systimestamp,
      gc_user
    ) returning id into l_id;
    apex_debug.message(c_debug_template,'l_id', l_id);
    return l_id;
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_nt;
  procedure update_nt (
      p_id            in svt_nested_table_types.id%type,
      p_nt_name       in svt_nested_table_types.nt_name%type,
      p_example_query in svt_nested_table_types.example_query%type,
      p_object_type   in svt_nested_table_types.object_type%type
  )
  as 
  c_scope          constant varchar2(128) := gc_scope_prefix || 'update_nt';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_nt_name', p_nt_name);
    update svt_nested_table_types
    set nt_name       = p_nt_name,
        example_query = p_example_query,
        object_type   = p_object_type,
        updated       = gc_systimestamp,
        updated_by    = gc_user
    where id = p_id;
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end update_nt;
  procedure delete_nt (
        p_id in svt_nested_table_types.id%type
    )
  as 
  c_scope          constant varchar2(128) := gc_scope_prefix || 'delete_nt';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_id', p_id);
    delete from svt_nested_table_types
    where id = p_id;
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_nt;
  function issue_category (p_nt_name in svt_nested_table_types.nt_name%type)
  return svt_plsql_apex_audit.issue_category%type
  deterministic
  result_cache
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || 'issue_category 1';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_nt_name        constant svt_nested_table_types.nt_name%type := upper (p_nt_name);
  l_issue_category svt_plsql_apex_audit.issue_category%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_nt_name', p_nt_name);
    select object_type 
    into l_issue_category
    from svt_nested_table_types
    where nt_name = c_nt_name;
    return l_issue_category;
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end issue_category;
  function issue_category (p_test_code in svt_stds_standard_tests.test_code%type)
  return svt_plsql_apex_audit.issue_category%type
  deterministic
  as 
  c_scope          constant varchar2(128) := gc_scope_prefix || 'issue_category 2';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_issue_category svt_plsql_apex_audit.issue_category%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    select issue_category
    into l_issue_category
    from v_svt_stds_standard_tests
    where test_code = p_test_code;
    return l_issue_category;
  
   exception
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end issue_category;
  function nt_name (p_object_type in svt_nested_table_types.object_type%type)
  return svt_nested_table_types.nt_name%type
  deterministic
  result_cache
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'nt_name';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_nt_name svt_nested_table_types.nt_name%type;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_object_type', p_object_type
                     );
   
   select nt_name 
   into l_nt_name 
   from svt_nested_table_types
   where object_type = p_object_type;
   
   return l_nt_name;
   
  exception
   when no_data_found then return null;
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end nt_name;
  function nt_count 
  return pls_integer result_cache
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'nt_count';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_count pls_integer;
  begin
   apex_debug.message(c_debug_template,'START'
                     );
   select count(*)
   into l_count
   from svt_nested_table_types;
   
   return l_count;
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end nt_count;
  function nt_list 
  return varchar2 result_cache
  as
  c_scope constant varchar2(128) := gc_scope_prefix || ' nt_list';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_list varchar2(4000);
  begin
   apex_debug.message(c_debug_template,'START'
                     );
    select 'APEX, '
          ||listagg(sct.friendly_name, ', ' on overflow truncate) within group (order by sct.friendly_name)
    into l_list
    from svt_component_types sct
    inner join svt_nested_table_types ntt on ntt.id = sct.nt_type_id
                                          and ntt.object_type != 'APEX';
   return l_list;
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end  nt_list;
end svt_nested_table_types_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_ONE_REPORT_MACRO" as
-- SQL Macro
function user_tab_col_macro(p_table_name    in  varchar2,
                            p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2 SQL_MACRO is
begin
    return q'~with cols as (
            select row_number() over (order by ct.column_value desc, nums.column_value asc) alias_rn,
                    ct.column_value ct_val, nums.column_value nums_val,
                    case ct.column_value
                        when 'VARCHAR2' then 'vc' || nums.column_value
                        when 'NUMBER' then 'n' || nums.column_value
                        when 'DATE' then 'd' || nums.column_value
                        end column_alias
            from apex_string.split_numbers('1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20',',') nums
               , apex_string.split('VARCHAR2,NUMBER,DATE',',') ct
            order by ct.column_value desc, nums.column_value 
            )
            select utc.table_name, utc.column_name, utc.data_type, utc.column_id, utc.rn,
                   cols.alias_rn, cols.ct_val, cols.nums_val, cols.column_alias
            from cols
            left outer join (
                            select table_name, column_name, data_type, column_id,
                                row_number() over (partition by table_name, data_type order by column_id) rn
                            from all_tab_cols
                            where table_name = user_tab_col_macro.p_table_name 
                              and owner = user_tab_col_macro.p_schema_name 
                            ) utc 
                on utc.rn = cols.nums_val
                and utc.data_type = cols.ct_val ~';
                           
                              -- and column_name not in ('CREATED','CREATED_BY','UPDATED','UPDATED_BY')
end user_tab_col_macro;
                   
end svt_one_report_macro;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_PLSQL_APEX_AUDIT_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_plsql_apex_audit_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-29 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_sysdate      constant svt_plsql_apex_audit.updated%type := sysdate;
  gc_user         constant varchar2(100) := coalesce(sys_context('APEX$SESSION','APP_USER'),user,'nobody');
  gc_y            constant varchar2(1) := 'Y';
  gc_n            constant varchar2(1) := 'N';
  gc_apex         constant varchar2(4) := 'APEX'; 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- Private Procedure to update svt_plsql_apex_audit
--
------------------------------------------------------------------------------
  procedure update_audit (
    p_unqid                      in svt_plsql_apex_audit.unqid%type, 
    p_issue_category             in svt_plsql_apex_audit.issue_category%type, 
    p_application_id             in svt_plsql_apex_audit.application_id%type, 
    p_page_id                    in svt_plsql_apex_audit.page_id%type, 
    p_line                       in svt_plsql_apex_audit.line%type, 
    p_object_name                in svt_plsql_apex_audit.object_name%type, 
    p_object_type                in svt_plsql_apex_audit.object_type%type, 
    p_code                       in svt_plsql_apex_audit.code%type, 
    p_validation_failure_message in svt_plsql_apex_audit.validation_failure_message%type, 
    p_issue_title                in svt_plsql_apex_audit.issue_title%type, 
    p_test_code                  in svt_plsql_apex_audit.test_code%type, 
    p_legacy_yn                  in svt_plsql_apex_audit.legacy_yn%type, 
    p_apex_created_by            in svt_plsql_apex_audit.apex_created_by%type, 
    p_apex_created_on            in svt_plsql_apex_audit.apex_created_on%type, 
    p_apex_last_updated_by       in svt_plsql_apex_audit.apex_last_updated_by%type, 
    p_apex_last_updated_on       in svt_plsql_apex_audit.apex_last_updated_on%type, 
    p_owner                      in svt_plsql_apex_audit.owner%type,
    p_component_id               in svt_plsql_apex_audit.component_id%type,
    p_parent_component_id        in svt_plsql_apex_audit.parent_component_id%type
  )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_audit 1';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  BEGIN
    -- apex_debug.message(c_debug_template,'START', 'p_unqid', p_unqid);
    update svt_plsql_apex_audit
    set issue_category             = p_issue_category,
        application_id             = p_application_id,
        page_id                    = p_page_id,
        line                       = p_line,
        object_name                = p_object_name,
        object_type                = p_object_type,
        code                       = p_code,
        validation_failure_message = p_validation_failure_message,
        issue_title                = p_issue_title,
        test_code                  = p_test_code,
        legacy_yn                  = p_legacy_yn,
        apex_created_by            = p_apex_created_by,
        apex_created_on            = p_apex_created_on,
        apex_last_updated_by       = p_apex_last_updated_by,
        apex_last_updated_on       = p_apex_last_updated_on,
        owner                      = p_owner,
        component_id               = p_component_id,
        parent_component_id        = p_parent_component_id,
        updated                    = gc_sysdate,
        updated_by                 = gc_user
    where unqid = p_unqid;
    apex_debug.message(c_debug_template, 'updated :', sql%rowcount);
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end update_audit;
  procedure updated_audit  (
    p_audit_id  in svt_plsql_apex_audit.id%type,
    p_assignee  in svt_plsql_apex_audit.assignee%type,
    p_notes     in svt_plsql_apex_audit.notes%type,
    p_action_id in svt_plsql_apex_audit.action_id%type,
    p_legacy_yn in svt_plsql_apex_audit.legacy_yn%type
  )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_audit 2';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);
    assert.is_not_null (  
      p_val_in => p_assignee
    , p_msg_in => 'Assignee cannot be null');
    assert.is_email (  
      p_val_in => p_assignee
    , p_msg_in => 'Assignee value must be an email address');
    update svt_plsql_apex_audit
    set assignee  = lower(p_assignee),
        notes     = p_notes,
        action_id = p_action_id,
        legacy_yn = p_legacy_yn
    where id = p_audit_id;
    apex_debug.message(c_debug_template, 'updated :', sql%rowcount);
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end updated_audit;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- Private Procedure to insert into svt_plsql_apex_audit
--
------------------------------------------------------------------------------
  procedure insert_audit (
    p_unqid                      in svt_plsql_apex_audit.unqid%type, 
    p_issue_category             in svt_plsql_apex_audit.issue_category%type, 
    p_application_id             in svt_plsql_apex_audit.application_id%type, 
    p_page_id                    in svt_plsql_apex_audit.page_id%type, 
    p_line                       in svt_plsql_apex_audit.line%type, 
    p_object_name                in svt_plsql_apex_audit.object_name%type, 
    p_object_type                in svt_plsql_apex_audit.object_type%type, 
    p_code                       in svt_plsql_apex_audit.code%type, 
    p_validation_failure_message in svt_plsql_apex_audit.validation_failure_message%type, 
    p_issue_title                in svt_plsql_apex_audit.issue_title%type, 
    p_test_code                  in svt_plsql_apex_audit.test_code%type, 
    p_legacy_yn                  in svt_plsql_apex_audit.legacy_yn%type, 
    p_apex_created_by            in svt_plsql_apex_audit.apex_created_by%type, 
    p_apex_created_on            in svt_plsql_apex_audit.apex_created_on%type, 
    p_apex_last_updated_by       in svt_plsql_apex_audit.apex_last_updated_by%type, 
    p_apex_last_updated_on       in svt_plsql_apex_audit.apex_last_updated_on%type, 
    p_owner                      in svt_plsql_apex_audit.owner%type,
    p_component_id               in svt_plsql_apex_audit.component_id%type,
    p_parent_component_id        in svt_plsql_apex_audit.parent_component_id%type
  )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_audit';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_audit_id svt_plsql_apex_audit.id%type;
  BEGIN
    apex_debug.message(c_debug_template,'START', 'p_unqid', p_unqid);
    insert into svt_plsql_apex_audit (
      unqid,
      issue_category,
      application_id,
      page_id,
      line,
      object_name,
      object_type,
      code,
      validation_failure_message,
      issue_title,
      test_code,
      legacy_yn,
      apex_created_by,
      apex_created_on,
      apex_last_updated_by,
      apex_last_updated_on,
      owner,
      component_id,
      parent_component_id,
      created,
      created_by,
      updated,
      updated_by
    ) values 
    (
      p_unqid,
      p_issue_category,
      p_application_id,
      p_page_id,
      p_line,
      p_object_name,
      p_object_type,
      p_code,
      p_validation_failure_message,
      p_issue_title,
      p_test_code,
      p_legacy_yn,
      p_apex_created_by,
      p_apex_created_on,
      p_apex_last_updated_by,
      p_apex_last_updated_on,
      p_owner,
      p_component_id,
      p_parent_component_id,
      gc_sysdate,
      gc_user,
      gc_sysdate,
      gc_user
    ) returning id into l_audit_id;
    apex_debug.message(c_debug_template, 'l_audit_id', l_audit_id);
    svt_audit_on_audit_api.insert_rec (
        p_unqid                      => p_unqid,
        p_action_name                => 'INSERT',
        p_test_code                  => p_test_code,
        p_audit_id                   => l_audit_id,
        p_validation_failure_message => p_validation_failure_message,
        p_app_id                     => p_application_id,
        p_page_id                    => p_page_id,
        p_component_id               => p_component_id,
        p_assignee                   => null,
        p_line                       => p_line,
        p_object_name                => p_object_name,
        p_object_type                => p_object_type,
        p_code                       => substr(p_code,1,255)
    );
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_audit;
  procedure delete_audit (
              p_unqid                      in svt_plsql_apex_audit.unqid%type,
              p_audit_id                   in svt_plsql_apex_audit.id%type,
              p_test_code                  in svt_plsql_apex_audit.test_code%type,
              p_validation_failure_message in svt_plsql_apex_audit.validation_failure_message%type,
              p_application_id             in svt_plsql_apex_audit.application_id%type,
              p_page_id                    in svt_plsql_apex_audit.page_id%type,
              p_component_id               in svt_plsql_apex_audit.component_id%type,
              p_assignee                   in svt_plsql_apex_audit.assignee%type,
              p_line                       in svt_plsql_apex_audit.line%type,
              p_object_name                in svt_plsql_apex_audit.object_name%type,
              p_object_type                in svt_plsql_apex_audit.object_type%type,
              p_code                       in svt_plsql_apex_audit.code%type,
              p_delete_reason              in varchar2
        )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_audit';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_delete constant varchar2(10) := 'DELETE';
  BEGIN
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);
    delete from svt_plsql_apex_audit
    where id = p_audit_id;
    apex_debug.message(c_debug_template, 'p_audit_id', p_audit_id);
    svt_audit_on_audit_api.insert_rec (
        p_unqid                      => p_unqid,
        p_action_name                => c_delete,
        p_test_code                  => p_test_code,
        p_audit_id                   => p_audit_id,
        p_validation_failure_message => p_validation_failure_message,
        p_app_id                     => p_application_id,
        p_page_id                    => p_page_id,
        p_component_id               => p_component_id,
        p_assignee                   => p_assignee,
        p_line                       => p_line,
	      p_object_name                => p_object_name,
	      p_object_type                => p_object_type,
	      p_code                       => substr(p_code,1,255),
        p_delete_reason              => p_delete_reason
    );
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_audit;
  procedure delete_stale (p_deleted_count out nocopy pls_integer)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_stale';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 
  l_count pls_integer := 0;
  c_sysdate constant date := sysdate;
  BEGIN
    apex_debug.message(c_debug_template,'START');
    for rec in (
      select unqid, 
             id audit_id, 
             test_code, 
             validation_failure_message,
             application_id,
             page_id,
             component_id,
             assignee,
             line,
             object_name,
             object_type,
             code
      from svt_plsql_apex_audit
      where updated < c_sysdate - interval '3' day
      and action_id is null --not sure when to delete exceptions
      and exists (select 1
                    from apex_automation_log aal
                    inner join apex_appl_automations aaa on aaa.automation_id = aal.automation_id
                    where aaa.static_id = 'big-job'
                    and aaa.polling_last_run_timestamp > systimestamp - interval '6' hour
                    and aal.status_code = 'SUCCESS' )
    ) loop 
      l_count := l_count + 1;
      delete_audit (
              p_unqid                      => rec.unqid,
              p_audit_id                   => rec.audit_id,
              p_test_code                  => rec.test_code,
              p_validation_failure_message => rec.validation_failure_message,
              p_application_id             => rec.application_id,
              p_page_id                    => rec.page_id,
              p_component_id               => rec.component_id,
              p_assignee                   => rec.assignee,
              p_line                       => rec.line,
              p_object_name                => rec.object_name,
              p_object_type                => rec.object_type,
              p_code                       => rec.code,
              p_delete_reason              => 'STALE'
            );
    end loop;
    p_deleted_count := l_count;
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_stale;
  procedure delete_inactive (p_deleted_count out nocopy pls_integer)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_inactive';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 
  l_count pls_integer := 0;
  BEGIN
    apex_debug.message(c_debug_template,'START');
    begin <<delete_inactive_apps>>
      for rec in (
        select unqid, 
               id audit_id, 
               test_code, 
               validation_failure_message,
               application_id,
               page_id,
               component_id,
               assignee,
               line,
               object_name,
               object_type,
               code
        from svt_plsql_apex_audit spad
        where application_id is not null
        and action_id is null --not sure when to delete exceptions
        and application_id not in (select apex_app_id
                                    from v_svt_stds_applications
                                    where app_active_yn = gc_y
                                    and type_active_yn = gc_y)
      ) loop 
        l_count := l_count + 1;
        delete_audit (
                p_unqid                      => rec.unqid,
                p_audit_id                   => rec.audit_id,
                p_test_code                  => rec.test_code,
                p_validation_failure_message => rec.validation_failure_message,
                p_application_id             => rec.application_id,
                p_page_id                    => rec.page_id,
                p_component_id               => rec.component_id,
                p_assignee                   => rec.assignee,
                p_line                       => rec.line,
                p_object_name                => rec.object_name,
                p_object_type                => rec.object_type,
                p_code                       => rec.code,
                p_delete_reason              => 'INACTIVE_APP'
              );
      end loop;
    end delete_inactive_apps;
    
    begin <<delete_inactive_tests>>
      for rec in (
        select unqid, 
               id audit_id, 
               test_code, 
               validation_failure_message,
               application_id,
               page_id,
               component_id,
               assignee,
               line,
               object_name,
               object_type,
               code
        from svt_plsql_apex_audit spad
        where test_code is not null
        and action_id is null --not sure when to delete exceptions
        and test_code not in (select test_code
                                from svt_stds_standard_tests
                                where active_yn = gc_y)
      ) loop 
        l_count := l_count + 1;
        delete_audit (
                p_unqid                      => rec.unqid,
                p_audit_id                   => rec.audit_id,
                p_test_code                  => rec.test_code,
                p_validation_failure_message => rec.validation_failure_message,
                p_application_id             => rec.application_id,
                p_page_id                    => rec.page_id,
                p_component_id               => rec.component_id,
                p_assignee                   => rec.assignee,
                p_line                       => rec.line,
                p_object_name                => rec.object_name,
                p_object_type                => rec.object_type,
                p_code                       => rec.code,
                p_delete_reason              => 'INACTIVE_TEST'
              );
      end loop;
    end delete_inactive_tests;
    p_deleted_count := l_count;
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_inactive;
  procedure mark_as_exception (p_audit_id in svt_plsql_apex_audit.id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'mark_as_exception';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_ignore_legacy  constant svt_audit_actions.id%type := 2;
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);
    update svt_plsql_apex_audit
    set action_id = c_ignore_legacy
    where id = p_audit_id;
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end mark_as_exception;
  procedure null_out_apex_issue (p_audit_id in svt_plsql_apex_audit.id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'null_out_apex_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);
    update svt_plsql_apex_audit
    set apex_issue_id = null, apex_issue_title_suffix = null
    where id = p_audit_id;
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end null_out_apex_issue;
  procedure assign_violation (p_audit_id in svt_plsql_apex_audit.id%type,
                              p_assignee in svt_plsql_apex_audit.assignee%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'assign_violation';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_assignee constant svt_plsql_apex_audit.assignee%type := lower(
                                                                coalesce(p_assignee,
                                                                         svt_preferences.get('SVT_DEFAULT_ASSIGNEE')
                                                                         )
                                                                 );
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_audit_id', p_audit_id,
                                        'p_assignee', p_assignee,
                                        'c_assignee', c_assignee);
    
    update svt_plsql_apex_audit
    set assignee = c_assignee
    where id = p_audit_id;
    apex_debug.message(c_debug_template, 'updated', sql%rowcount);
    
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end assign_violation;
  procedure bulk_reassign (p_audit_ids in varchar2,
                           p_assignee  in svt_plsql_apex_audit.assignee%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_reassign';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_assignee       constant svt_plsql_apex_audit.assignee%type := lower(p_assignee);
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_ids', p_audit_ids);
    for rec in (select column_value audit_id
                  from table(apex_string.split(p_audit_ids, ','))
                )
    loop
      assign_violation (p_audit_id => rec.audit_id,
                        p_assignee => c_assignee);
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end bulk_reassign;
  function get_audit_record (p_audit_id in svt_plsql_apex_audit.id%type) 
    return svt_plsql_apex_audit%rowtype
    is 
    c_scope          constant varchar2(128)  := gc_scope_prefix || 'get_audit_record';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_svt_plsql_apex_audit_rec svt_plsql_apex_audit%rowtype;
    begin
      apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);
      select *
      into l_svt_plsql_apex_audit_rec
      from svt_plsql_apex_audit
      where id = p_audit_id;
      return l_svt_plsql_apex_audit_rec;
    exception 
      when no_data_found then 
        return l_svt_plsql_apex_audit_rec;
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
  end get_audit_record;
  function get_unqid(p_audit_id in svt_plsql_apex_audit.id%type) 
  return svt_plsql_apex_audit.unqid%type
  deterministic 
  result_cache
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_unqid';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_unqid svt_plsql_apex_audit.unqid%type;
  begin
      apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);
      select unqid
      into l_unqid
      from svt_plsql_apex_audit
      where id = p_audit_id;
      return l_unqid;
    exception 
      when no_data_found then
        apex_debug.error(c_debug_template, 'Unknown p_audit_id: ',p_audit_id);
        raise;
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
  end get_unqid;
  procedure assign_from_default
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assign_from_default';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
      merge into (select application_id, assignee
                  from svt_plsql_apex_audit 
                  where assignee is null) e
      using (select apex_app_id, lower(default_developer) default_developer
             from v_svt_stds_applications
             where default_developer is not null) h
      on (e.application_id = h.apex_app_id)
      when matched then
      update set e.assignee = h.default_developer;
      if svt_preferences.get('SVT_DEFAULT_ASSIGNEE') is not null then 
        update svt_plsql_apex_audit
        set assignee = lower(svt_preferences.get('SVT_DEFAULT_ASSIGNEE'))
        where assignee is null;
      end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assign_from_default;
  function get_assignee_email (p_username in svt_plsql_apex_audit.apex_last_updated_by%type)
  return svt_plsql_apex_audit.assignee%type
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_assignee_email';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_username constant svt_plsql_apex_audit.apex_last_updated_by%type := lower(p_username);
    ------------------------------------------------------------------------------
    -- Nested function to query the email for a given username  
    ------------------------------------------------------------------------------
    function get_dev_email (p_username in svt_plsql_apex_audit.apex_last_updated_by%type)
    return svt_plsql_apex_audit.assignee%type
    is 
    l_email svt_plsql_apex_audit.assignee%type;
    begin
      select email
      into l_email
      from v_svt_apex_workspace_developers
      where lower(user_name) = p_username;
      return lower(l_email);
    exception when no_data_found then
      apex_debug.message(c_debug_template,'get_dev_email → no data found', p_username);
      return p_username;  
    end get_dev_email;
  begin 
      apex_debug.message(c_debug_template,'START');
      return case when (c_username is null 
                        or c_username like '%@%')
                  then c_username
                  else get_dev_email(c_username)
                  end;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_assignee_email;
  procedure assign_from_apex_audit 
  is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'assign_from_apex_audit';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    type t_auditid_email is table of svt_plsql_apex_audit.assignee%type index by pls_integer;
    l_auditid_email t_auditid_email;
    l_auditid svt_plsql_apex_audit.id%type;
    begin
      apex_debug.message(c_debug_template,'START');
      for rec in ( select paa.id audit_id, 
                          case when awd.email is not null 
                               then awd.email
                               when paa.apex_last_updated_by like '%@%'
                               then paa.apex_last_updated_by
                               when paa.apex_created_by like '%@%'
                               then paa.apex_created_by
                               end assignee
                    from svt_plsql_apex_audit paa
                    left join v_svt_apex_workspace_developers awd on coalesce(paa.apex_last_updated_by, paa.apex_created_by) = awd.user_name
                    where issue_category in (gc_apex)
                    and paa.assignee is null
                  )
      loop 
        l_auditid_email(rec.audit_id) := lower(rec.assignee);
      end loop;
      l_auditid := l_auditid_email.first;
      loop
        exit when l_auditid is null;
        update svt_plsql_apex_audit
        set assignee = lower(l_auditid_email(l_auditid))
        where id = l_auditid
        and issue_category in (gc_apex)
        -- and (assignee != l_auditid_email(l_auditid) or assignee is null)
        and assignee is null
        ;
        l_auditid := l_auditid_email.next(l_auditid);
      end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assign_from_apex_audit;
  procedure get_assignee_from_parent_apex_audit (
      p_application_id in svt_plsql_apex_audit.application_id%type,
      p_component_id   in svt_plsql_apex_audit.component_id%type,
      p_view_name      in svt_component_types.component_name%type,
      p_query1         out nocopy clob,
      p_query2         out nocopy clob,
      p_assignee       out nocopy svt_plsql_apex_audit.assignee%type,
      p_parent_pk_id   out nocopy svt_plsql_apex_audit.component_id%type,
      p_parent_view    out nocopy svt_component_types.component_name%type
  )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_assignee_from_parent_apex_audit';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_parent_view_name svt_component_types.component_name%type;
  l_pk_value         svt_component_types.pk_value%type;
  l_parent_pk_value  svt_component_types.parent_pk_value%type;
  l_query            clob;
  l_query2           clob;
  c_null            constant varchar2(25) := 'null';
  c_created_by      constant varchar2(25) := 'created_by';
  c_updated_by      constant varchar2(25) := 'updated_by';
  c_last_updated_by constant varchar2(25) := 'last_updated_by';
  c_view_name       constant svt_component_types.component_name%type 
                    := dbms_assert.noop (upper(p_view_name));
  BEGIN
    apex_debug.message(c_debug_template,'START', 
                                        'p_component_id', p_component_id,
                                        'p_view_name', p_view_name);
    if  p_component_id is not null 
    and c_view_name is not null
    and p_application_id is not null
    then 
      select act.pk_value, 
            act.parent_pk_value
      into l_pk_value,
           l_parent_pk_value
      from svt_component_types act
      where act.component_name = c_view_name;
      apex_debug.message(c_debug_template, 'l_pk_value', l_pk_value);
      apex_debug.message(c_debug_template, 'l_parent_pk_value', l_parent_pk_value);
      if l_parent_pk_value is not null 
      and l_pk_value is not null
      then 
        l_query := apex_string.format(
          'select %0 from %1 where %2 = %3 and application_id = %4',
          p0 => l_parent_pk_value,
          p1 => c_view_name,
          p2 => l_pk_value,
          p3 => p_component_id,
          p4 => p_application_id
        );
        apex_debug.message(c_debug_template, 'l_query', l_query);
        
        p_query1 := l_query;
        
        begin <<q1>>
          execute immediate l_query into p_parent_pk_id;
        exception when no_data_found then
          apex_debug.message(c_debug_template, 'no data found ', l_query);
        end q1;
        apex_debug.message(c_debug_template, 'p_parent_pk_id', p_parent_pk_id);
      else 
        apex_debug.message(c_debug_template, 'either l_parent_pk_value or l_pk_value is null');
      end if;
      if p_parent_pk_id is not null then
        begin <<viewname2>>
          select act.component_name view_name
          into l_parent_view_name
          from svt_component_types act 
          where pk_value = replace(l_parent_pk_value,'PARENT_')
          fetch first 1 rows only;
        exception when no_data_found then 
          apex_debug.message(c_debug_template, 'no view found for :', l_parent_pk_value);
        end viewname2;
        if l_parent_view_name is not null then
          p_parent_view := l_parent_view_name;
          l_parent_pk_value := case when l_parent_pk_value = 'PARENT_BREADCRUMB_ID'
                                    then 'BREADCRUMB_ID'
                                    else l_parent_pk_value
                                    end;
          apex_debug.message(c_debug_template, 'l_parent_pk_value', l_parent_pk_value);
                              
          l_query2 := apex_string.format(
              'select coalesce(%4, %5) assignee from %1 where %2 = %3 and application_id = %6 fetch first 1 rows only',
              p0 => l_parent_pk_value,
              p1 => l_parent_view_name,
              p2 => l_parent_pk_value,
              p3 => p_parent_pk_id,
              p4 => case when  svt_stds_parser.column_exists 
                                (p_column_name => c_updated_by,
                                p_table_name => l_parent_view_name
                                )
                          then c_updated_by
                          when  svt_stds_parser.column_exists 
                                (p_column_name => c_last_updated_by,
                                p_table_name => l_parent_view_name
                                )
                          then c_last_updated_by
                          else c_null 
                          end,
              p5 => case when  svt_stds_parser.column_exists 
                                (p_column_name => c_created_by,
                                p_table_name => l_parent_view_name
                                )
                          then c_created_by
                          else c_null 
                          end,
              p6 => p_application_id
          );
          apex_debug.message(c_debug_template, 'l_query2: ', l_query2);
          p_query2 := l_query2;
          
          begin <<assgn>>
            execute immediate l_query2 into p_assignee;
          exception 
            when e_invalid_id then 
              apex_debug.message(c_debug_template, 'invalid sql ', l_query2);
              p_assignee := null;
            when no_data_found then 
              apex_debug.message(c_debug_template, 'no_data_found', l_query2);
              p_assignee := null;
          end assgn;
        else 
          apex_debug.message(c_debug_template, 'l_parent_view_name is null');
        end if;
      else 
        apex_debug.message(c_debug_template, 'p_parent_pk_id is null');
      end if;
    
    else 
      apex_debug.message(c_debug_template, 'p_component_id or p_view_name or p_application_id is null');
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_assignee_from_parent_apex_audit;
  function get_assignee_from_parent_apex_audit (
    p_component_id   in svt_plsql_apex_audit.component_id%type,
    p_view_name      in svt_component_types.component_name%type,
    p_application_id in svt_plsql_apex_audit.application_id%type,
    p_page_id        in svt_plsql_apex_audit.page_id%type
  ) return svt_plsql_apex_audit.assignee%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_assignee_from_parent_apex_audit 2';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_query1        clob;
  l_query2        clob;
  l_parent_pk_id  svt_plsql_apex_audit.component_id%type;
  l_parent_view   svt_component_types.component_name%type;
  l_assignee      svt_plsql_apex_audit.assignee%type;
  c_view_name     constant svt_component_types.component_name%type 
                  := dbms_assert.noop (upper(p_view_name));
  BEGIN
    apex_debug.message(c_debug_template,'START', 
                                        'p_component_id', p_component_id,
                                        'p_view_name',p_view_name,
                                        'p_application_id',p_application_id,
                                        'p_page_id',p_page_id);
    
    get_assignee_from_parent_apex_audit (
        p_application_id => p_application_id,
        p_component_id   => p_component_id,
        p_view_name      => c_view_name,
        p_query1         => l_query1,
        p_query2         => l_query2,
        p_assignee       => l_assignee,
        p_parent_pk_id   => l_parent_pk_id,
        p_parent_view    => l_parent_view
    );
    if l_assignee is null then 
      <<take2>>
      declare 
      l_parent_pk_id2  svt_plsql_apex_audit.component_id%type;
      l_parent_view2   svt_component_types.component_name%type;
      begin
        apex_debug.message(c_debug_template,'START take 2', 
                                            'l_parent_pk_id', l_parent_pk_id,
                                            'l_parent_view',l_parent_view);
        get_assignee_from_parent_apex_audit (
            p_application_id => p_application_id,
            p_component_id   => l_parent_pk_id,
            p_view_name      => l_parent_view,
            p_query1         => l_query1,
            p_query2         => l_query2,
            p_assignee       => l_assignee,
            p_parent_pk_id   => l_parent_pk_id2,
            p_parent_view    => l_parent_view2
        );
        
        if l_assignee is null then 
          <<take3>>
          declare 
          l_parent_pk_id3  svt_plsql_apex_audit.component_id%type;
          l_parent_view3   svt_component_types.component_name%type;
          begin
            apex_debug.message(c_debug_template,'START take 3', 
                                                'l_parent_pk_id2', l_parent_pk_id2,
                                                'l_parent_view2',l_parent_view2);
            get_assignee_from_parent_apex_audit (
                p_application_id => p_application_id,
                p_component_id   => l_parent_pk_id2,
                p_view_name      => l_parent_view2,
                p_query1         => l_query1,
                p_query2         => l_query2,
                p_assignee       => l_assignee,
                p_parent_pk_id   => l_parent_pk_id3,
                p_parent_view    => l_parent_view3
            );
            if l_assignee is null then
              <<take4>>
              declare 
              l_parent_pk_id4  svt_plsql_apex_audit.component_id%type;
              l_parent_view4   svt_component_types.component_name%type;
              begin
                apex_debug.message(c_debug_template,'START take 4', 
                                                    'l_parent_pk_id3', l_parent_pk_id3,
                                                    'l_parent_view3',l_parent_view3);
                get_assignee_from_parent_apex_audit (
                    p_application_id => p_application_id,
                    p_component_id   => l_parent_pk_id3,
                    p_view_name      => l_parent_view3,
                    p_query1         => l_query1,
                    p_query2         => l_query2,
                    p_assignee       => l_assignee,
                    p_parent_pk_id   => l_parent_pk_id4,
                    p_parent_view    => l_parent_view4
                );
                  
                  begin <<finaltake_page>>
                    apex_debug.message(c_debug_template,'START final take (page)', 
                                                        'p_page_id', p_page_id,
                                                        'p_application_id',p_application_id);
                    if l_assignee is null 
                    and p_page_id is not null
                    then
                        select coalesce(last_updated_by, created_by) 
                        into l_assignee
                        from apex_application_pages 
                        where page_id = p_page_id 
                        and application_id = p_application_id;
                        
                    else 
                      apex_debug.message(c_debug_template, 'final take (page) not executed');
                    end if;
                  end finaltake_page;
                  begin <<finaltake_app>>
                    apex_debug.message(c_debug_template,'START final take (app)', 
                                                        'p_application_id',p_application_id);
                    if l_assignee is null 
                    then
                        select coalesce(last_updated_by, created_by) 
                        into l_assignee
                        from apex_applications 
                        where application_id = p_application_id;
                    else 
                      apex_debug.message(c_debug_template, 'final take (app) not executed');
                    end if;
                  end finaltake_app;
              end take4;
            end if;
          end take3;
        end if;
      end take2;
    end if;
    apex_debug.message(c_debug_template, 'l_assignee', l_assignee);
    return get_assignee_email (p_username => l_assignee);
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_assignee_from_parent_apex_audit;
  procedure assign_from_apex_parent_audit
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assign_from_apex_parent_audit';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  BEGIN
    apex_debug.message(c_debug_template,'START');
    for rec in (
      select paa.id audit_id, 
             paa.application_id,
             paa.page_id,
             paa.component_id, 
             act.component_name view_name
      from svt_plsql_apex_audit paa
      inner join svt_stds_standard_tests st on paa.test_code = st.test_code
      inner join svt_component_types act on act.id = st.svt_component_type_id 
      where paa.issue_category = gc_apex
      and paa.component_id is not null
      and paa.assignee is null
    )
    loop
      update svt_plsql_apex_audit 
      set assignee = get_assignee_from_parent_apex_audit (
                        p_application_id => rec.application_id,
                        p_component_id   => rec.component_id,
                        p_view_name      => rec.view_name,
                        p_page_id        => rec.page_id
                    )
      where id = rec.audit_id;
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assign_from_apex_parent_audit;
  procedure rerun_assignment_w_apex_audits
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'rerun_assignment_w_apex_audits';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');
    update svt_plsql_apex_audit
    set assignee = null 
    where issue_category = gc_apex;
    apex_debug.message(c_debug_template,'updated :', sql%rowcount);
    svt_plsql_apex_audit_api.assign_from_apex_audit;
    svt_plsql_apex_audit_api.assign_from_apex_parent_audit;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end rerun_assignment_w_apex_audits;
  $if oracle_apex_version.c_loki_access $then
  procedure assign_from_loki 
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assign_from_loki';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
      apex_debug.message(c_debug_template,'START');
      merge into (select object_type, object_name, assignee
                  from svt_plsql_apex_audit 
                  where issue_category in 'DB_PLSQL'
                  and assignee is null) e
      using (select object_type, object_name, apex_username
             from v_loki_object_assignee
             where apex_username is not null
             and lock_rank = 1) h
      on (e.object_name = h.object_name)
      when matched then
      update set e.assignee = lower(h.apex_username);
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assign_from_loki;
  $end
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- private function to determine whether a unqid already exists in svt_plsql_apex_audit
--
------------------------------------------------------------------------------
  function unqid_exists (p_unquid in svt_plsql_apex_audit.unqid%type) 
  return boolean deterministic 
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'unqid_exists';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_unquid_exists_yn varchar2(1);
  begin
      -- apex_debug.message(c_debug_template,'START', 'p_unquid', p_unquid);
      select case when count(*) = 1
                        then gc_y
                        else gc_n
                        end into l_unquid_exists_yn
                from sys.dual where exists (
                    select 1 
                    from svt_plsql_apex_audit 
                    where unqid = p_unquid
                );
      return case when l_unquid_exists_yn = gc_y 
                  then true 
                  else false 
                  end;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end unqid_exists;
  procedure merge_audit_tbl (p_application_id in svt_plsql_apex_audit.application_id%type default null,
                              p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                              p_test_code      in svt_stds_standard_tests.test_code%type,
                              p_legacy_yn      in svt_plsql_apex_audit.legacy_yn%type default 'N',
                              p_audit_id       in svt_plsql_apex_audit.id%type default null,
                              p_issue_category in svt_plsql_apex_audit.issue_category%type default null
                              )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'merge_audit_tbl';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  c_legacy_yn constant svt_plsql_apex_audit.legacy_yn%type := case when upper(p_legacy_yn) = gc_y
                                                                      then gc_y
                                                                      else gc_n
                                                                      end;
  l_svt_plsql_apex_audit_rec svt_plsql_apex_audit%rowtype;
  begin
      apex_debug.message(c_debug_template,'START',
                                          'p_application_id', p_application_id,
                                          'p_page_id', p_page_id,
                                          'p_test_code', p_test_code,
                                          'p_audit_id', p_audit_id,
                                          'p_issue_category', p_issue_category
                                          );
        l_svt_plsql_apex_audit_rec := case when p_audit_id is not null
                                           then svt_plsql_apex_audit_api.get_audit_record (p_audit_id)
                                           end;
        if l_svt_plsql_apex_audit_rec.owner is not null 
        and l_svt_plsql_apex_audit_rec.issue_category != gc_apex
        then
          svt_ctx_util.set_review_schema (p_schema => l_svt_plsql_apex_audit_rec.owner);
        end if;
                                           
        for rec in (select 
                    a.unqid,
                    esst.issue_category,
                    a.application_id,
                    a.page_id,
                    a.line,
                    a.object_name,
                    a.object_type,
                    a.code,
                    a.validation_failure_message,
                    a.issue_title,
                    a.test_code,
                    a.apex_created_by,
                    a.apex_created_on,
                    a.apex_last_updated_by,
                    a.apex_last_updated_on,
                    coalesce(a.schema, svt_ctx_util.get_default_user) owner,
                    a.component_id,
                    a.parent_component_id 
                  from v_svt_stds_standard_tests esst
                  join svt_standard_view.v_svt(p_test_code => esst.test_code, 
                                               p_failures_only => gc_y, 
                                               p_urgent_only => gc_y,
                                               p_production_apps_only => gc_y,
                                               p_unqid => l_svt_plsql_apex_audit_rec.unqid
                                               ) a
                          on  esst.query_clob is not null
                          and esst.active_yn = gc_y
                          and esst.standard_active_yn = gc_y
                          and (esst.test_code = c_test_code or c_test_code is null)
                          and (esst.issue_category = p_issue_category or p_issue_category is null)
                  where (a.application_id  = p_application_id or p_application_id is null)
                  and   (a.page_id  = p_page_id or p_page_id is null))
        loop
          if unqid_exists (p_unquid => rec.unqid) then
            update_audit (
                p_unqid                      => rec.unqid,
                p_issue_category             => rec.issue_category,
                p_application_id             => rec.application_id,
                p_page_id                    => rec.page_id,
                p_line                       => rec.line,
                p_object_name                => rec.object_name,
                p_object_type                => rec.object_type,
                p_code                       => rec.code,
                p_validation_failure_message => rec.validation_failure_message,
                p_issue_title                => rec.issue_title,
                p_test_code                  => rec.test_code,
                p_legacy_yn                  => c_legacy_yn,
                p_apex_created_by            => rec.apex_created_by,
                p_apex_created_on            => rec.apex_created_on,
                p_apex_last_updated_by       => rec.apex_last_updated_by,
                p_apex_last_updated_on       => rec.apex_last_updated_on,
                p_owner                      => rec.owner,
                p_component_id               => rec.component_id,
                p_parent_component_id        => rec.parent_component_id
              );
          else
            insert_audit (
                p_unqid                      => rec.unqid,
                p_issue_category             => rec.issue_category,
                p_application_id             => rec.application_id,
                p_page_id                    => rec.page_id,
                p_line                       => rec.line,
                p_object_name                => rec.object_name,
                p_object_type                => rec.object_type,
                p_code                       => rec.code,
                p_validation_failure_message => rec.validation_failure_message,
                p_issue_title                => rec.issue_title,
                p_test_code                  => rec.test_code,
                p_legacy_yn                  => c_legacy_yn,
                p_apex_created_by            => rec.apex_created_by,
                p_apex_created_on            => rec.apex_created_on,
                p_apex_last_updated_by       => rec.apex_last_updated_by,
                p_apex_last_updated_on       => rec.apex_last_updated_on,
                p_owner                      => rec.owner,
                p_component_id               => rec.component_id,
                p_parent_component_id        => rec.parent_component_id
              );
          end if;
        end loop;
  exception 
    when e_deadlock then 
      apex_debug.error(p_message => c_debug_template, p0 =>'Deadlock encountered in merge_audit_tbl', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    when others then 
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception in merge_audit_tbl', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end merge_audit_tbl;
  procedure refresh_for_test_code (p_test_code in svt_plsql_apex_audit.test_code%type)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'refresh_for_test_code';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code      constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  c_mv_dependency  constant svt_stds_standard_tests.mv_dependency%type 
                  := svt_stds.get_mv_dependency(p_test_code => p_test_code);
  c_sysdate        constant date := sysdate;
  begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
      
      if c_mv_dependency is not null then
        svt_mv_util.refresh_mv(c_mv_dependency); --refresh the dependent materialized view
      end if;
      if svt_nested_table_types_api.issue_category(p_test_code => c_test_code) = gc_apex then
        apex_debug.message(c_debug_template, 'apex issue');
        merge_audit_tbl (p_test_code => c_test_code);
      else 
        apex_debug.message(c_debug_template, 'db issue so we need to cycle through the appropriate schemas');
        for rec in (
              select column_value review_schema
              from table(apex_string.split(svt_preferences.get('SVT_REVIEW_SCHEMAS'), ':'))
            )
        loop
            svt_ctx_util.set_review_schema(p_schema => rec.review_schema);
            merge_audit_tbl (p_test_code => c_test_code);
        end loop;
      end if;
      delete from svt_plsql_apex_audit
      where test_code = c_test_code
      and updated < c_sysdate;
      apex_debug.message(c_debug_template, 'deleted', sql%rowcount);
    
  exception 
    when others then 
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception in merge_audit_tbl', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end refresh_for_test_code;
  function total_open_violations(
                  p_application_id in svt_plsql_apex_audit.application_id%type default null,
                  p_standard_id    in svt_stds_standards.id%type default null)
  return pls_integer
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'total_open_violations';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_count pls_integer;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_application_id', p_application_id,
                                       'p_standard_id', p_standard_id
                     );
    select count(*)
    into l_count
    from svt_plsql_apex_audit paa
    inner join svt_stds_standard_tests esst on esst.test_code = paa.test_code
    left outer join svt_audit_actions aaa on paa.action_id = aaa.id
    where coalesce(aaa.include_in_report_yn, 'Y') = 'Y'
    and (paa.application_id = p_application_id or p_application_id is null)
    and (esst.standard_id = p_standard_id or p_standard_id is null);
    return l_count;
   
  exception
   when no_data_found then
      return 0;
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end total_open_violations;
  function percent_solved(p_application_id in svt_plsql_apex_audit.application_id%type default null,
                          p_standard_id    in svt_stds_standards.id%type default null)
  return number
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'percent_solved';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  c_ttl_open_violations  constant pls_integer := total_open_violations(p_application_id => p_application_id,
                                                                       p_standard_id => p_standard_id);
  c_overall_count        constant pls_integer := svt_audit_on_audit_api.overall_violation_count(
                                                    p_app_id      => p_application_id,
                                                    p_standard_id => p_standard_id);
  c_solved_count         constant pls_integer := c_overall_count - c_ttl_open_violations;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_application_id', p_application_id,
                                       'p_standard_id', p_standard_id
                     );
    return case when c_ttl_open_violations = 0
                then 100
                when c_overall_count = 0
                then 100
                else round((c_solved_count / c_overall_count) * 100,0)
                end;
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end percent_solved;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 11, 2023
-- Synopsis:
--
-- assign violations to developers based on source code manager
-- called by assign_violations
--
------------------------------------------------------------------------------
    -- procedure assign_from_scm 
    -- is 
    -- c_scope constant varchar2(128) := gc_scope_prefix || 'assign_from_scm';
    -- c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    -- type t_object_assignee is table of svt_plsql_apex_audit.assignee%type index by svt_plsql_apex_audit.object_name%type;
    -- l_object_assignee t_object_assignee;
    -- l_object svt_plsql_apex_audit.object_name%type;
    -- begin
    --   apex_debug.message(c_debug_template,'START');
    --   for rec in (select object_name, email assignee 
    --               from v_svt_scm_object_assignee
    --               where email is not null)
    --   loop 
    --     l_object_assignee(rec.object_name) := rec.assignee;
    --   end loop;
    --   l_object := l_object_assignee.first;
    --   loop
    --     exit when l_object is null;
    --     update svt_plsql_apex_audit
    --     set assignee = l_object_assignee(l_object)
    --     where object_name = l_object
    --     and issue_category in ('DB_PLSQL','VIEW')
    --     and (assignee != l_object_assignee(l_object) or assignee is null);
    --     l_object := l_object_assignee.next(l_object);
    --   end loop;
    -- exception when others then
    --   apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    --   raise;
    -- end assign_from_scm;
    -- procedure delete_obsolete_violations (
    --               p_test_code      in svt_stds_standard_tests.test_code%type default null,
    --               p_application_id in svt_plsql_apex_audit.application_id%type default null,
    --               p_page_id        in svt_plsql_apex_audit.page_id%type default null)
    -- is
    -- c_scope constant varchar2(128) := gc_scope_prefix || 'delete_obsolete_violations';
    -- c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    -- begin
    --   apex_debug.message(c_debug_template,'START', 
    --                                       'p_test_code', p_test_code,
    --                                       'p_application_id', p_application_id,
    --                                       'p_page_id', p_page_id);
    --   delete from svt_plsql_apex_audit
    --   where 1=1
    --   and owner = case when sys_context('userenv', 'current_user') = svt_preferences.get('SVT_DEFAULT_SCHEMA')
    --                    then svt_ctx_util.get_default_user
    --                    else sys_context('userenv', 'current_user')
    --                    end
    --   and (test_code = p_test_code or p_test_code is null)
    --   and (application_id = p_application_id or p_application_id is null)
    --   and (page_id        = p_page_id or p_page_id is null)
    --   and unqid not in  (
    --             select unqid 
    --             from v_svt_plsql_apex__0
    --             where unqid is not null
    --         );
    --   apex_debug.error(c_debug_template, 'deleted from svt_plsql_apex_audit:',  sql%rowcount);
    -- exception when others then
    --   apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    --   raise;
    -- end delete_obsolete_violations;
end SVT_PLSQL_APEX_AUDIT_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_PLSQL_REVIEW" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_PLSQL_REVIEW
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso   2022-Dec-16 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_userenv_current_user constant varchar2(100) :=  sys_context('userenv', 'current_user');
  gc_package constant varchar2(20) := 'PACKAGE';
  gc_view    constant varchar2(20) := 'VIEW';
  gc_table   constant varchar2(20) := 'TABLE';
  gc_y       constant varchar2(1) := 'Y';
  gc_n       constant varchar2(1) := 'N';
  gc_svt     constant varchar2(3) := 'SVT';
  ------------------------------------------------------------------------------
  -- Procedure to check for contradiction between the current schema and the review schema
  ------------------------------------------------------------------------------
  procedure error_for_incorrect_schema (p_object_name in all_objects.object_name%type) is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'error_for_incorrect_schema';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_object_exists_yn varchar2(1);
  -- c_review_schema constant varchar2(32) 
  --                 := case when sys_context('userenv', 'current_user') = gc_svt
  --                         then svt_ctx_util.get_default_user
  --                         else sys_context('userenv', 'current_user')
  --                         end;
  begin
    apex_debug.message(c_debug_template,'START', 'p_object_name', p_object_name);
    if p_object_name is not null then
      select case when count(*) = 1
                  then gc_y
                  else gc_n
                  end into l_object_exists_yn
              from sys.dual where exists (
                  select 1
                  from v_user_objects
                  where object_name = p_object_name
              );
      if l_object_exists_yn = gc_n 
      and sys_context('userenv', 'current_user') = gc_svt 
      and svt_ctx_util.get_default_user != gc_svt /* we need to be able to run scripts that aren't ddl scripts */
      then 
        svt_ctx_util.set_review_schema (p_schema => sys_context('userenv', 'current_user'));
        -- raise_application_error(-20124, apex_string.format(
        --                                   p_message => q'[%0.%1 does not exist:
        -- • The review schema is currently set to : %2
        -- • You can change this by running the release/set_review_schema.sql script]',
        --                                   p0 => c_review_schema,
        --                                   p1 => p_object_name,
        --                                   p2 => svt_ctx_util.get_default_user,
        --                                   p3 => sys_context('userenv', 'current_user')
        --                                   )
        --                       );
      end if;
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end error_for_incorrect_schema;
  function get_object_type (p_object_name in user_objects.object_name%type) 
  return user_objects.object_type%type
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_object_type'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_object_name constant user_objects.object_name%type := upper(p_object_name);
  l_object_type user_objects.object_type%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_object_name', p_object_name);
    select object_type
    into l_object_type
    from v_user_objects
    where object_name = c_object_name
    order by object_type
    fetch first 1 rows only;
    apex_debug.message(c_debug_template, 'l_object_type', l_object_type);
    return l_object_type;
  exception 
    when no_data_found then
      apex_debug.error(p_message => c_debug_template, p0 =>'No data found', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_object_type;
  function issues (p_object_name             in user_plsql_object_settings.name%type default null,
                   p_object_type             in user_plsql_object_settings.type%type default null,
                   p_max_test_code_count     in number default null,
                   p_max_issue_count         in number default null,
                   p_file_dirname            in varchar2 default null
                   )
  return svt_db_plsql_issue_nt pipelined
  is 
  pragma autonomous_transaction;
  c_scope constant varchar2(128) := gc_scope_prefix || 'issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_object_name  constant all_procedures.object_name%type 
                 := case when p_object_name is not null 
                         then sys.dbms_assert.noop(upper(p_object_name)) --todo: figure out what dbms_assert function would work here
                         end;
  c_object_type  constant user_objects.object_type%type
                := case when p_object_type is not null 
                        then sys.dbms_assert.simple_sql_name(upper(p_object_type))
                        else case when p_file_dirname is not null
                                  then case upper(p_file_dirname)
                                        when 'PACKAGE_BODIES' then gc_package
                                        when 'PACKAGE_SPECS'  then gc_package
                                        else get_object_type(c_object_name)
                                        end
                                  else get_object_type(c_object_name)
                                  end
                        end;
  c_plsql_stmt      constant varchar2(512) := q'[ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL, STATEMENTS:ALL']';
  l_test_code       svt_stds_standard_tests.test_code%type := 'blank';
  c_max_test_code_count    constant pls_integer := coalesce(p_max_test_code_count, 50);
  c_max_issue_count        constant pls_integer := coalesce(p_max_issue_count, 999999);
  l_test_code_count        pls_integer   := 0;
  l_issue_count            pls_integer   := 0;
  l_issue_shown_count      pls_integer   := 0;
  l_not_shown_count_msg    varchar2(500) := '';
  cursor cur_pkg_issues
   is
      select  
        substr(esst.explanation,1,500) explanation,
        dp.object_name,
        dp.object_type,
        dp.line,
        dp.code,
        esst.urgency,
        esst.urgency_level,
        esst.test_code
      from v_svt_stds_standard_tests esst
      join svt_standard_view.v_svt_db_plsql(p_test_code => esst.test_code, 
                                            p_failures_only => gc_y,
                                            p_object_name => c_object_name) dp
        on  esst.nt_name = 'V_SVT_DB_PLSQL_NT'
        and esst.query_clob is not null
        and esst.active_yn = gc_y
      order by urgency_level, esst.explanation, object_name, line, code;
  type r_v_svt_db_plsql is record (
    test_name               varchar2(511   char),
    object_name             varchar2(128   char),  
    object_type             varchar2(23    char),   
    line                    number,
    code                    varchar2(1000 char),
    urgency                 varchar2(255   char),
    urgency_level           number,
    test_code           varchar2(100 char)
  );
  type t_SVT_db_plsql_issue is table of r_v_svt_db_plsql index by pls_integer;
  l_pkg_issue_t t_SVT_db_plsql_issue;
  cursor cur_vw_issues
   is
      select *
      from v_svt_db_view_all
      where (view_name = c_object_name or c_object_name is null)
      order by urgency_level, test_name, view_name;
  type t_svt_db_view_issue is table of v_svt_db_view_all%rowtype index by pls_integer;
  l_vw_issue_t t_svt_db_view_issue;
  cursor cur_tbl_issues
   is
      select *
      from v_svt_db_tbl_all
      where (table_name = c_object_name or c_object_name is null)
      order by urgency_level, test_name, table_name;
  type t_SVT_db_tbl_issue is table of v_svt_db_tbl_all%rowtype index by pls_integer;
  l_tbl_issue_t t_SVT_db_tbl_issue;
  e_incorrect_plscope_settings exception;
  pragma exception_init(e_incorrect_plscope_settings, -20123);
    ------------------------------------------------------------------------------
    -- Local Procedure to check that data has been deployed
    ------------------------------------------------------------------------------
    procedure verify_standards_exist_in_general is 
    l_count number := 0;
    begin
      select count(*) 
      into l_count
      from sys.dual where exists (
          select 1
          from v_svt_stds_standard_tests
      );
      if l_count = 0 then
        raise_application_error(-20123, 'Standards have not been defined in this environment');
      end if;
    end verify_standards_exist_in_general;
    ------------------------------------------------------------------------------
    -- Local Procedure to check that plscope can be used
    ------------------------------------------------------------------------------
    procedure verify_plscope_setting(p_object_name in all_objects.object_name%type) is 
    c_req_plscope_settings constant all_plsql_object_settings.plscope_settings%type := 'IDENTIFIERS:ALL, STATEMENTS:ALL';
    l_incorrect_plscope_yn varchar2(1) := gc_n;
    l_compile_stmt varchar2(512);
    begin
      if p_object_name is not null then 
        select case when count(*) > 0
                    then gc_y
                    else gc_n
                    end 
                    into l_incorrect_plscope_yn
        from v_user_plsql_object_settings
        where plscope_settings != c_req_plscope_settings
        and name = p_object_name
        and (type = c_object_type or c_object_type is null);
        if l_incorrect_plscope_yn = gc_y then 
          l_compile_stmt := apex_string.format(p_message => 'ALTER %2 %0.%1 COMPILE',
                                               p0 => gc_userenv_current_user,
                                               p1 => p_object_name,
                                               p2 => coalesce(c_object_type, gc_package)
                                              );
          raise_application_error(-20123, 
                                  apex_string.format(p_message =>
                                                        'This DB object has not been compiled with the required PL/Scope Settings.
                                                          • Step 1 : %0
                                                          • Step 2 : %1',
                                                      p0 => c_plsql_stmt,
                                                      p1 => l_compile_stmt)
                                  );
        end if;
      end if;
    end verify_plscope_setting;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_object_name', p_object_name,
                                        'p_object_type', p_object_type,
                                        'review_schema' , svt_ctx_util.get_default_user,
                                        'current_schema', gc_userenv_current_user,
                                        'p_file_dirname', p_file_dirname
                                        );
    verify_standards_exist_in_general;
    if c_object_name is not null then
      error_for_incorrect_schema(c_object_name);
      verify_plscope_setting(c_object_name);
    end if;
    case 
    when c_object_type = gc_package 
    then open cur_pkg_issues;
      loop
        fetch cur_pkg_issues bulk collect into l_pkg_issue_t limit 100;
        exit when l_pkg_issue_t.count = 0;
        for rec in 1 .. l_pkg_issue_t.count
        loop
        l_issue_count := l_issue_count + 1;
        case when l_issue_count <= c_max_issue_count then 
          case  when l_test_code = l_pkg_issue_t (rec).test_code then
            l_test_code_count := l_test_code_count + 1;
          else 
            l_test_code_count := 1;
          end case;
          l_test_code := l_pkg_issue_t (rec).test_code;
          case when l_test_code_count <= c_max_test_code_count then
            l_issue_shown_count := l_issue_shown_count + 1;
            pipe row (SVT_db_plsql_issue_ot (
                          l_pkg_issue_t (rec).test_name,
                          l_pkg_issue_t (rec).object_name,
                          l_pkg_issue_t (rec).object_type,
                          l_pkg_issue_t (rec).line,
                          l_pkg_issue_t (rec).code,
                          l_pkg_issue_t (rec).urgency,
                          l_pkg_issue_t (rec).urgency_level,
                          l_pkg_issue_t (rec).test_code
                        )
                    );
          else 
            apex_debug.message(c_debug_template, 'max test_code count / test_code has been exceeded');
          end case;
        else 
          apex_debug.message(c_debug_template, 'issue limit exceeded');       
        end case;
        end loop;
      end loop;  
      case when l_issue_count > l_issue_shown_count then 
        l_not_shown_count_msg := apex_string.format('Summary : %0 issue(s) total, %1 not shown.', 
                                                              l_issue_count, 
                                                              l_issue_count - l_issue_shown_count );
        pipe row (SVT_db_plsql_issue_ot (
                            null,
                            null,
                            null,
                            null,
                            l_not_shown_count_msg,
                            null,
                            null,
                            null
                          )
                      );
      else 
        apex_debug.message(c_debug_template, 'Not unshown issues');
      end case;
    when c_object_type = gc_view
    then open cur_vw_issues;
      loop
        fetch cur_vw_issues bulk collect into l_vw_issue_t limit 100;
        exit when l_vw_issue_t.count = 0;
        for rec in 1 .. l_vw_issue_t.count
        loop
            pipe row (SVT_db_plsql_issue_ot (
                          l_vw_issue_t (rec).test_name,
                          l_vw_issue_t (rec).view_name,
                          gc_view,
                          null,
                          null,
                          l_vw_issue_t (rec).urgency,
                          l_vw_issue_t (rec).urgency_level,
                          l_vw_issue_t (rec).test_code
                        )
                    );
        end loop;
      end loop;  
    when c_object_type = gc_table
    then open cur_tbl_issues;
      loop
        fetch cur_tbl_issues bulk collect into l_tbl_issue_t limit 100;
        exit when l_tbl_issue_t.count = 0;
        for rec in 1 .. l_tbl_issue_t.count
        loop
            pipe row (SVT_db_plsql_issue_ot (
                          l_tbl_issue_t (rec).test_name,
                          l_tbl_issue_t (rec).table_name,
                          gc_table,
                          null,
                          l_tbl_issue_t (rec).code,
                          l_tbl_issue_t (rec).urgency,
                          l_tbl_issue_t (rec).urgency_level,
                          l_tbl_issue_t (rec).test_code
                        )
                    );
        end loop;
      end loop;  
    else 
      pipe row (SVT_db_plsql_issue_ot (
                          null,
                          null,
                          null,
                          null,
                          apex_string.format('No standards defined for script type %s', 
                                              case when c_object_type is not null
                                                   then '('||c_object_type||')'
                                                   end),
                          null,
                          null,
                          null
                        )
                    );
    end case;
    return;
  exception 
    when e_incorrect_plscope_settings then
      apex_debug.error(p_message => c_debug_template, p0 =>'Incorrect PL/Scope Settings', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
    when others then 
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end issues;
end SVT_PLSQL_REVIEW;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_PREFERENCES" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_PREFERENCES
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Apr-3 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_svt          constant varchar2(3) := 'SVT';
  -- gc_ast          constant varchar2(3) := 'AST';
  function get(p_preference_name in apex_workspace_preferences.preference_name%type)
  return apex_workspace_preferences.preference_value%type 
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'get';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_preference_name constant apex_workspace_preferences.preference_name%type := upper(p_preference_name);
  l_pref_value      apex_workspace_preferences.preference_value%type;
  begin
    -- apex_debug.message(c_debug_template,'START', 'p_preference_name', p_preference_name);
    
    l_pref_value := apex_util.get_preference(      
                      p_preference => c_preference_name,
                      p_user       => gc_svt);
    
    return case when l_pref_value is not null 
                then l_pref_value
                when c_preference_name = 'SVT_DEFAULT_SCHEMA'
                then gc_svt
                else null
                end;
                
  exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get;
  procedure set_preference (p_preference_name in apex_workspace_preferences.preference_name%type,
                            p_value           in apex_workspace_preferences.preference_value%type)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'set_preference';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_preference_name constant apex_workspace_preferences.preference_name%type := upper(p_preference_name);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_preference_name', p_preference_name,
                                        'p_value', p_value);
    if p_value is not null then
      apex_util.set_preference(        
          p_preference => c_preference_name,
          p_value      => p_value,      
          p_user       => gc_svt); 
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end set_preference;
end SVT_PREFERENCES;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS" as
    gc_scope_prefix constant varchar2(32) := lower($$plsql_unit) || '.';
    gc_y constant varchar2(1) := 'Y';
    gc_n constant varchar2(1) := 'N';
    -------------------------------------------------------------------------
    -- Generates a unique Identifier
    -------------------------------------------------------------------------
    function gen_id return number is
    begin
        return to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end gen_id;
    -------------------------------------------------------------------------
    -- Handle the process of registering the scheduled job.
    -------------------------------------------------------------------------
    procedure register_job is
        l_app_id number;
        l_stmt varchar2(1000);
    begin
        l_app_id := coalesce(wwv_flow_application_install.get_application_id,v('FB_FLOW_ID'));
        l_stmt := q'[begin #PKG#.create_job( job_name => 'SVT_STDS_TEST_UPD_JOB', ]'
            ||q'[job_type => 'PLSQL_BLOCK', job_action => 'svt_stds_parser.update_standard_status;', ]'
            ||q'[repeat_interval => 'FREQ=DAILY;interval=1', enabled => TRUE); end;]';
        for c1 in ( select object_name
                    from sys.all_objects
                    where object_name in ('DBMS_SCHEDULER', 'CLOUD_SCHEDULER')
                        and object_type = 'PACKAGE'
                    order by object_name desc ) loop
            execute immediate replace(l_stmt, '#PKG#',
                sys.dbms_assert.enquote_name(c1.object_name, false));
            return;
        end loop;
    end register_job;
    function get_standard_id (p_standard_name in svt_stds_standards.standard_name%type)
    return svt_stds_standards.id%type
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_standard_id';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_id svt_stds_standards.id%type;
    begin
        apex_debug.message(c_debug_template,'START', 'p_standard_name', p_standard_name);
        select id
        into l_id 
        from svt_stds_standards
        where upper(standard_name) =  upper(p_standard_name);
        return l_id;
    exception when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end get_standard_id;
    function get_mv_dependency(p_test_code in svt_stds_standard_tests.test_code%type) 
    return svt_stds_standard_tests.mv_dependency%type
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_mv_dependency';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_mv_dependency svt_stds_standard_tests.mv_dependency%type;
    begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
      select mv_dependency 
      into l_mv_dependency
      from svt_stds_standard_tests
      where test_code = p_test_code;
      return l_mv_dependency;
    
    exception
        when no_data_found then
            return null;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end get_mv_dependency;
    function display_initialize_button (
        p_test_code     in svt_plsql_apex_audit.test_code%type,
        p_level_id      in svt_standards_urgency_level.id%type
    ) return boolean
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'display_initialize_button';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_display boolean := false;
    l_issue_count pls_integer;
    l_standard_count pls_integer;
    l_urgent_yn varchar2(1);
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_test_code', p_test_code,
                                            'p_level_id', p_level_id
                                            );
        select count(1)
        into l_issue_count
        from svt_plsql_apex_audit
        where test_code = p_test_code;
        select count(1)
        into l_standard_count
        from svt_stds_standard_tests
        where test_code = p_test_code
        and active_yn = gc_y;
        select case when urgency_level <= 100
                then gc_y
                else gc_n
                end 
        into l_urgent_yn
        from svt_standards_urgency_level
        where id = p_level_id;
        if l_issue_count = 0 
        and l_standard_count  = 1 
        and l_urgent_yn = gc_y
        then
            l_display := true;
        else 
            l_display := false;
        end if;
        
        return l_display;
    
    exception
        when no_data_found then
            l_display := false;
            return l_display;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end display_initialize_button;
    function close_test_modal (p_request   in varchar2,
                               p_test_code in svt_plsql_apex_audit.test_code%type,
                               p_level_id  in svt_standards_urgency_level.id%type
    ) return boolean
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'close_test_modal';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_request', p_request,
                                            'p_test_code', p_test_code,
                                            'p_level_id', p_level_id);
    
        return case when p_request in ('DELETE')
                    then true
                    when p_request in ('CREATE')
                    then false
                    when p_request in ('SAVE') 
                    and display_initialize_button (
                            p_test_code  => p_test_code,
                            p_level_id   => p_level_id
                        )
                    then false
                    else false
                    end;
    exception
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end close_test_modal;
    function file_name (p_standard_name in svt_stds_standards.standard_name%type)
    return svt_stds_standards.standard_name%type
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'file_name';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START', 'p_standard_name', p_standard_name);
        return upper(
                     replace(
                        regexp_replace(p_standard_name,'[[:punct:]]')
                                                , ' ', '_'
                            )
                    );
    exception when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end file_name;
end svt_stds;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_APPLICATIONS_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_APPLICATIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-9 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_standards_urgency_level.created%type := systimestamp;
  gc_user         constant svt_standards_urgency_level.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  gc_y            constant varchar2(1) := 'Y';
  function insert_app (
        p_id                in svt_stds_applications.pk_id%type default null,
        p_apex_app_id       in svt_stds_applications.apex_app_id%type,
        p_default_developer in svt_stds_applications.default_developer%type,
        p_type_id           in svt_stds_applications.type_id%type,
        p_notes             in svt_stds_applications.notes%type,
        p_active_yn         in svt_stds_applications.active_yn%type default 'Y'
    ) return svt_stds_applications.pk_id%type
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'insert_app';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    c_id constant svt_stds_applications.pk_id%type 
                  := coalesce(p_id, 
                              to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id,
                                         'p_apex_app_id', p_apex_app_id,
                                         'p_default_developer', p_default_developer,
                                         'p_type_id', p_type_id,
                                         'p_notes', p_notes,
                                         'p_active_yn', p_active_yn
                       );
      insert into svt_stds_applications
      (
        pk_id,
        apex_app_id,
        default_developer,
        type_id,
        notes,
        active_yn,
        esa_created,
        esa_created_by,
        esa_updated,
        esa_updated_by
      )
      values 
      (
        c_id,
        p_apex_app_id,
        lower(p_default_developer),
        p_type_id,
        p_notes,
        p_active_yn,
        gc_systimestamp,
        gc_user,
        gc_systimestamp,
        gc_user
      );
      apex_debug.message(c_debug_template,'c_id', c_id);
      return c_id;
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end insert_app;
    procedure update_app ( 
        p_id                in svt_stds_applications.pk_id%type,
        p_apex_app_id       in svt_stds_applications.apex_app_id%type,
        p_default_developer in svt_stds_applications.default_developer%type,
        p_type_id           in svt_stds_applications.type_id%type,
        p_notes             in svt_stds_applications.notes%type,
        p_active_yn         in svt_stds_applications.active_yn%type default 'Y'
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'update_app';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );
     update svt_stds_applications
     set apex_app_id       = p_apex_app_id,
         default_developer = p_default_developer,
         type_id           = p_type_id,
         notes             = p_notes,
         active_yn         = p_active_yn
     where pk_id = p_id;
     apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end update_app;
    procedure delete_app (
        p_id in svt_stds_applications.pk_id%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'delete_app';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );
     delete from  svt_stds_applications
     where pk_id = p_id;
     apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end delete_app;
    function active_app_count return pls_integer
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'active_app_count';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    l_count pls_integer;
    begin
     apex_debug.message(c_debug_template,'START'
                       );
     
     select count(*)
     into l_count
     from v_svt_stds_applications
     where app_active_yn = gc_y
     and type_active_yn = gc_y;
     return l_count;
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end active_app_count;
end SVT_STDS_APPLICATIONS_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_DATA" is
    gc_scope_prefix constant varchar2(32) := lower($$plsql_unit) || '.';
    procedure load_initial_data is
    c_scope constant varchar2(128) := gc_scope_prefix || 'load_initial_data';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';
    type rec_data is varray(3) of varchar2(4000);
    type tab_data is table of rec_data index by pls_integer;
        procedure load_svt_stds_types is 
        l_data tab_data;
        l_row svt_stds_types%rowtype;
        begin
            l_data(l_data.count + 1) := rec_data('Default'               , '10', 1);
            l_data(l_data.count + 1) := rec_data('Information Technology', '20', 2);
            l_data(l_data.count + 1) := rec_data('Engineering'           , '30', 3);
            l_data(l_data.count + 1) := rec_data('Test Application'      , '40', 4);
            l_data(l_data.count + 1) := rec_data('Initial development'   , '50', 5);
            l_data(l_data.count + 1) := rec_data('Releasable'            , '60', 6);
            l_data(l_data.count + 1) := rec_data('Production'            , '70', 7);
            l_data(l_data.count + 1) := rec_data('DB Supporting Objects' , '80', 8);
            for i in 1..l_data.count loop
                l_row.type_name := l_data(i)(1);
                l_row.id := l_data(i)(2);
                l_row.display_sequence := l_data(i)(3);
                merge into svt_stds_types dest
                using (
                    select
                    l_row.type_name type_name
                    from dual
                ) src
                on (1=1
                    and dest.type_name = src.type_name
                )
                when matched then
                update
                    set
                    dest.id = l_row.id,
                    dest.display_sequence = l_row.display_sequence
                when not matched then
                insert (
                    type_name,
                    id,
                    display_sequence)
                values(
                    l_row.type_name,
                    l_row.id,
                    l_row.display_sequence)
                ;
            end loop;
        end load_svt_stds_types;
    begin
        apex_debug.message(c_debug_template,'START');
        if not is_initial_data_loaded() then
            load_svt_stds_types;
        end if;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end load_initial_data;
    function is_initial_data_loaded return boolean is
    c_scope          constant varchar2(128) := gc_scope_prefix || 'is_initial_data_loaded';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';
    begin
        apex_debug.message(c_debug_template,'START');
        for c1 in ( select 1
                    from svt_stds_types
                    where id < 100
                     ) loop
            return true;
        end loop;
        return false;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end is_initial_data_loaded;
    procedure load_sample_data is
    c_scope          constant varchar2(128) := gc_scope_prefix || 'load_sample_data';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';
    begin
        apex_debug.message(c_debug_template,'START');
        -- if not is_sample_data_loaded() then
        --     load_svt_stds_standards;
        --     -- Create a few sample tests.
        --     load_svt_stds_standard_tests;
        -- end if;
    end load_sample_data;
    procedure remove_sample_data is
    begin
        delete from svt_stds_standards
        where id < 100;
    end remove_sample_data;
end svt_stds_data;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_INHERITED_TESTS_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_inherited_tests_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  procedure inherit_test (
    p_test_id            in svt_stds_inherited_tests.test_id%type,
    p_standard_id        in svt_stds_inherited_tests.standard_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'inherit_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_parent_standard_id svt_stds_standard_tests.standard_id%type;
  c_sysdate constant svt_stds_inherited_tests.updated%type := sysdate;
  c_user    constant svt_stds_inherited_tests.updated_by%type 
                     := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_id', p_test_id,
                                        'p_standard_id', p_standard_id
                                        );
    l_parent_standard_id := svt_stds_standard_tests_api.get_standard_id (p_test_id => p_test_id);
    insert into svt_stds_inherited_tests 
           (parent_standard_id,
           test_id,
           standard_id,
           created,
           created_by,
           updated,
           updated_by)
    values (l_parent_standard_id, 
            p_test_id, 
            p_standard_id,
            c_sysdate,
            c_user,
            c_sysdate,
            c_user
            );
    apex_debug.message(c_debug_template, 'inserted : ', sql%rowcount);
  exception
    when dup_val_on_index then
      apex_debug.message(c_debug_template, 'dup_val_on_index : ', p_test_id, p_standard_id);
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end inherit_test;
  procedure disinherit (
    p_test_id            in svt_stds_inherited_tests.test_id%type,
    p_standard_id        in svt_stds_inherited_tests.standard_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'disinherit';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_id', p_test_id,
                                        'p_standard_id', p_standard_id);
    
    delete from svt_stds_inherited_tests
    where test_id = p_test_id
    and standard_id = p_standard_id;
    apex_debug.message(c_debug_template, 'deleted : ', sql%rowcount);
  
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end disinherit;
  procedure delete_std (p_standard_id  in svt_stds_inherited_tests.standard_id%type,
                        p_former_parent_standard_id in svt_stds_inherited_tests.parent_standard_id%type default null)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_std';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_former_parent_standard_id', p_former_parent_standard_id);
    delete from svt_stds_inherited_tests
    where standard_id = p_standard_id
    and (parent_standard_id = p_former_parent_standard_id or p_former_parent_standard_id is null);
    apex_debug.message(c_debug_template, 'deleted records : ', sql%rowcount);
  
  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_std;
  procedure delete_test (p_test_id  in svt_stds_inherited_tests.test_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_id', p_test_id);
    delete from svt_stds_inherited_tests
    where test_id = p_test_id;
    apex_debug.message(c_debug_template, 'deleted records : ', sql%rowcount);
  
  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_test;
  procedure bulk_add(p_test_ids    in varchar2,
                     p_standard_id in svt_stds_inherited_tests.standard_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_add';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_ids',p_test_ids,
                                        'p_standard_id', p_standard_id);
     for rec in (select column_value test_id
                  from table(apex_string.split(p_test_ids, ','))
                )
    loop
      inherit_test (
          p_test_id            => rec.test_id,
          p_standard_id        => p_standard_id
      );
    end loop;
  
  exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end bulk_add;
  procedure bulk_remove(p_test_ids    in varchar2,
                        p_standard_id in svt_stds_inherited_tests.standard_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_remove';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_ids',p_test_ids,
                                        'p_standard_id', p_standard_id);
     for rec in (select column_value test_id
                  from table(apex_string.split(p_test_ids, ','))
                )
    loop
      disinherit (
          p_test_id            => rec.test_id,
          p_standard_id        => p_standard_id
      );
    end loop;
  
  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end bulk_remove;
  procedure inherit_all(
                p_parent_standard_id in svt_stds_inherited_tests.parent_standard_id%type,
                p_standard_id        in svt_stds_inherited_tests.standard_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'inherit_all';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_parent_standard_id', p_parent_standard_id,
                                        'p_standard_id', p_standard_id);
    if p_parent_standard_id is null then 
      apex_debug.message(c_debug_template,'p_parent_standard_id is null');
    elsif p_standard_id is null then 
      apex_debug.message(c_debug_template,'p_standard_id is null');
    else 
      for rec in (select test_id
                  from svt_stds_standard_tests_api.v_svt_stds_standard_tests(
                            p_standard_id => p_parent_standard_id
                        ) 
                  )
      loop
        inherit_test (
            p_test_id            => rec.test_id,
            p_standard_id        => p_standard_id
        );
      end loop;
    end if;
  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end inherit_all;
end svt_stds_inherited_tests_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_NOTIFICATIONS_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_NOTIFICATIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-10 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_standards_urgency_level.created%type := systimestamp;
  gc_user         constant svt_standards_urgency_level.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    function insert_ntf (
       p_id                       in svt_stds_notifications.id%type default null,
       p_notification_name        in svt_stds_notifications.notification_name%type,
       p_notification_description in svt_stds_notifications.notification_description%type,
       p_notification_type        in svt_stds_notifications.notification_type%type,
       p_display_sequence         in svt_stds_notifications.display_sequence%type,
       p_display_from             in svt_stds_notifications.display_from%type,
       p_display_until            in svt_stds_notifications.display_until%type
    ) return svt_stds_notifications.id%type
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'insert_ntf';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    c_id constant svt_stds_notifications.id%type 
                  := coalesce(p_id, 
                              to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id,
                                         'p_notification_name', p_notification_name,
                                         'p_notification_description', p_notification_description,
                                         'p_notification_type', p_notification_type,
                                         'p_display_sequence', p_display_sequence,
                                         'p_display_from', p_display_from,
                                         'p_display_until', p_display_until
                       );
                       
     insert into svt_stds_notifications
      (
        id,
        notification_name,
        notification_description,
        notification_type,
        display_sequence,
        display_from,
        display_until,
        row_version_number,
        created,
        created_by,
        updated,
        updated_by
      )
      values 
      (
        c_id,
        p_notification_name,
        p_notification_description,
        p_notification_type,
        p_display_sequence,
        p_display_from,
        p_display_until,
        1,
        gc_systimestamp,
        gc_user,
        gc_systimestamp,
        gc_user
      );
      apex_debug.message(c_debug_template,'c_id', c_id);
      return c_id;
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end insert_ntf;
    procedure update_ntf (
       p_id                       in svt_stds_notifications.id%type,
       p_notification_name        in svt_stds_notifications.notification_name%type,
       p_notification_description in svt_stds_notifications.notification_description%type,
       p_notification_type        in svt_stds_notifications.notification_type%type,
       p_display_sequence         in svt_stds_notifications.display_sequence%type,
       p_display_from             in svt_stds_notifications.display_from%type,
       p_display_until            in svt_stds_notifications.display_until%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'update_ntf';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );
     update svt_stds_notifications
     set notification_name        = p_notification_name,
         notification_description = p_notification_description,
         notification_type        = p_notification_type,
         display_sequence         = p_display_sequence,
         display_from             = p_display_from,
         display_until            = p_display_until,
         row_version_number       = row_version_number + 1
     where id = p_id;
     apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end update_ntf;
    procedure delete_ntf (
        p_id in svt_stds_notifications.id%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'delete_ntf';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );
     
     delete from svt_stds_notifications
     where id = p_id;
     apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end delete_ntf;
end SVT_STDS_NOTIFICATIONS_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_PARSER" 
is
    gc_scope_prefix         constant varchar2(31) := lower($$plsql_unit) || '.';
    gc_y                    constant varchar2(1) := 'Y';
    gc_n                    constant varchar2(1) := 'N';
    function is_logged_into_builder (p_override_value in number default null) return boolean
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'is_logged_into_builder';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_builder_session constant number := v('APX_BLDR_SESSION');
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'c_builder_session', c_builder_session,
                                            'p_override_value', p_override_value
                                            );
        return case when p_override_value is not null
                    then true 
                    when c_builder_session is null 
                    then false
                    else true
                    end;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end is_logged_into_builder;
    function app_in_current_workspace (p_app_id in apex_applications.application_id%type) 
    return boolean
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'app_in_current_workspace'; 
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_dummy number;
    begin
        apex_debug.message(c_debug_template,'START', 'p_app_id', p_app_id);
         assert.is_not_null (  
              p_val_in => p_app_id
            , p_msg_in => 'App id cannot be null');
        select 1
            into l_dummy
            from apex_applications aa 
            where aa.application_id = p_app_id
            and aa.workspace = (select workspace
                                from apex_applications
                                where application_id =  v('APP_ID'));
        return true;
    exception 
        when no_data_found then
            apex_debug.message(p_message => c_debug_template, p0 =>'wrong workspace', 
                                                            p1 => sqlerrm, 
                                                            p2 => 'vappid   : '||v('APP_ID'), 
                                                            p3 => 'p_app_id : '||p_app_id);
            return false;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end app_in_current_workspace;
    function get_base_url return varchar2 deterministic
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_base_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START');
        return svt_preferences.get('SVT_BASE_URL');
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end get_base_url;
    function app_from_url ( p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return apex_applications.application_id%type
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'app_from_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';
    l_url_params         apex_t_varchar2;
        ------------------------------------------------------------------------------
        -- Nested function to get the app id from a given app alias
        ------------------------------------------------------------------------------
        function app_id_from_alias(p_app_alias in apex_applications.alias%type) 
                 return apex_applications.application_id%type
        is 
        l_application_id apex_applications.application_id%type; 
        begin
            select application_id
            into l_application_id
            from apex_applications 
            where alias = upper(p_app_alias);
            return l_application_id;
        exception 
            when no_data_found then 
            return null;
            when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
        end app_id_from_alias;
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_origin_app_id', p_origin_app_id, 
                                            'p_url', p_url);
        l_url_params := apex_string.split(upper(p_url),':',2);
        return case when p_url is null 
                    then null
                    when l_url_params(1) like 'F?P=%'
                    then case when l_url_params(1) like 'F?P=&APP_ID.%'
                              then p_origin_app_id
                              when l_url_params(1) like 'F?P=&%'
                              then null
                              when l_url_params(1) like 'F?P=#%'
                              then null
                              when (validate_conversion(substr(l_url_params(1),5) as number) = 1)
                              then substr(l_url_params(1),5)
                              else app_id_from_alias(p_app_alias => substr(l_url_params(1),5))
                              end
                    else null
                    end;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end app_from_url;
    function page_from_url (p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return apex_application_pages.page_id%type deterministic
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'page_from_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';
    l_url_params          apex_t_varchar2;
        ------------------------------------------------------------------------------
        -- Nested Function to get the page id from a given page alias
        ------------------------------------------------------------------------------
        function page_id_from_alias (p_app_id     in apex_applications.application_id%type,
                                     p_page_alias in apex_application_pages.page_alias%type) return apex_application_pages.page_id%type
        is 
        l_destination_page_id apex_application_pages.page_id%type;
        begin
          select page_id 
                into l_destination_page_id
                from apex_application_pages 
                where application_id = p_app_id
                and page_alias = upper(p_page_alias);
          return l_destination_page_id;
        exception when no_data_found then return null;
        end page_id_from_alias;
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_origin_app_id', p_origin_app_id, 
                                            'p_url', p_url);
        l_url_params := apex_string.split(upper(p_url),':',3);
        return case when p_url is null 
                    then null
                    when l_url_params(1) like 'F?P=%'
                    then case when (validate_conversion(l_url_params(2) as number) = 1)
                              then l_url_params(2)
                              else case when (validate_conversion(substr(l_url_params(1),5) as number) = 1)
                                        then page_id_from_alias(p_app_id     => substr(l_url_params(1),5),
                                                                p_page_alias => l_url_params(2))
                                        else case when l_url_params(2) = '#'
                                                  then 0 --it needs to return not null
                                                  when l_url_params(2) = '&APP_PAGE_ID.'
                                                  then 0 --it needs to return not null
                                                  when l_url_params(2) like '&%'
                                                  then 0 --it needs to return not null
                                                  else page_id_from_alias(
                                                                p_app_id     => app_from_url (p_origin_app_id,p_url),
                                                                p_page_alias => l_url_params(2)
                                                        )
                                                  end
                                        end
                              end
                    when validate_conversion(p_url as number) = 1
                    then p_url
                    else null
                    end;
    exception 
        when e_subscript_beyond_count then 
            apex_debug.message(c_debug_template, 'Subscript beyond count');
            return null;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end page_from_url;
    function is_valid_url (p_origin_app_id in apex_applications.application_id%type,
                           p_url in varchar2) return varchar2 deterministic
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'is_valid_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';
    c_url constant varchar2(1026) := upper(p_url);
    l_valid_app_and_page_yn varchar2(1) := gc_y;
    l_application_id apex_applications.application_id%type;
    l_page_id apex_application_pages.page_id%type;                                                               
    begin
        apex_debug.message(c_debug_template,'START', 'p_origin_app_id', p_origin_app_id,
                                                     'p_url', p_url
                                                     );
        case when c_url is null 
             then return gc_y;
             when c_url = 'SEPARATOR'
             then return gc_y;
             when c_url = '#' 
             then return gc_y;
             when c_url = '/SIGNOUT' 
             then return gc_y;
             when c_url like '&%.'
             then return gc_y;
             when c_url like '&LOGOUT_URL%' 
             then return gc_y;
             when c_url like '#%#' 
             then return gc_y;
             when c_url like '#ACTION$%' -- eg #action$a-pwa-install
             then return gc_y;
             when c_url like 'F?P=&REPORTING_APP_ID.%' 
             then return gc_y;
             when c_url like 'F?P=&LAST_APP.%' 
             then return gc_y;
             when c_url like 'F?P=&G_CALLED_FROM_APP.%' 
             then return gc_y;
             when c_url like 'F?P=&P%' 
             then return gc_y;
             when c_url like 'JAVASCRIPT%' 
             then return gc_y;
             when c_url like 'TEL:%' 
             then return gc_y;
             when c_url like 'HTTPS://%' 
             then return gc_y;
             else 
                l_application_id := app_from_url ( p_origin_app_id => p_origin_app_id,
                                                   p_url => c_url);
                l_page_id := page_from_url ( p_origin_app_id => p_origin_app_id,
                                             p_url => c_url);
                select case when count(*) = 1
                                then gc_y
                                else gc_n
                                end into l_valid_app_and_page_yn
                from sys.dual where exists (
                    select aap.page_id 
                    from apex_application_pages aap
                    inner join apex_applications aa on aa.application_id = aap.application_id 
                    where aap.page_access_protection != 'No URL Access'
                    and aa.availability_status != 'Unavailable'
                    and aap.application_id = l_application_id
                    and (aap.page_id  = l_page_id or l_page_id = 0)
                );
        end case;
        return l_valid_app_and_page_yn;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end is_valid_url;
    function adapt_url (p_template_url in svt_component_types.template_url%type)
    return svt_component_types.template_url%type
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'adapt_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    cursor cur_params 
    is select column_value
       from table(apex_string.split(p_template_url, ':'))
       where column_value is not null
       and column_value not in ('NO','YES')
       and column_value not like 'RP%';
    type t_params is table of varchar2(100) index by pls_integer;
    l_params t_params;
    begin
        apex_debug.message(c_debug_template,'START', 'p_template_url', p_template_url);
        open cur_params;
        fetch cur_params bulk collect into l_params;
        
        apex_debug.message(c_debug_template,'l_params.count', l_params.count,
                                            'p_application', replace(l_params(1), 'f?p='),
                                            'p_page'       , l_params(2),
                                            'p_session'    , l_params(3),
                                            'p_items'      , l_params(4));
        apex_debug.message(c_debug_template,'p_values'     , l_params(5));
        return case when l_params.count >= 5
                    then apex_page.get_url (
                            p_application => replace(l_params(1), 'f?p='),
                            p_page        => l_params(2),
                            p_session     => l_params(3),
                            p_items       => l_params(4),
                            p_values      => l_params(5)
                            )
                    else p_template_url
                    end;
    exception 
        when no_data_found then
            apex_debug.message(c_debug_template,'no_data_found', 'p_template_url', p_template_url);
            return p_template_url;
        when e_not_a_number then 
            apex_debug.message(c_debug_template,'e_not_a_number', 'p_template_url', p_template_url);
            return p_template_url;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end adapt_url;
    procedure get_component_type_rec (
                        p_svt_component_type_id in svt_component_types.id%type,
                        p_component_name        out nocopy svt_component_types.component_name%type,
                        p_component_type_id     out nocopy svt_component_types.component_type_id%type,
                        p_template_url          out nocopy svt_component_types.template_url%type
                    ) deterministic
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_component_type_rec';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START', 'p_svt_component_type_id', p_svt_component_type_id);
        select act.component_name, 
               act.component_type_id, 
               act.template_url link_url
        into   p_component_name, 
               p_component_type_id, 
               p_template_url
        from  svt_component_types act
        where act.id = p_svt_component_type_id;
    exception 
        when no_data_found then
            apex_debug.message(c_debug_template, 'No data found', p_svt_component_type_id);
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end get_component_type_rec;
    function build_url( p_template_url          in svt_component_types.template_url%type,
                        p_app_id                in svt_plsql_apex_audit.application_id%type,
                        p_page_id               in svt_plsql_apex_audit.page_id%type,
                        p_pk_value              in svt_plsql_apex_audit.component_id%type,
                        p_parent_pk_value       in svt_plsql_apex_audit.object_name%type,
                        p_issue_category        in svt_plsql_apex_audit.issue_category%type,
                        p_opt_parent_pk_value   in svt_plsql_apex_audit.object_type%type default null,
                        p_line                  in svt_plsql_apex_audit.line%type default null, 
                        p_object_name           in svt_plsql_apex_audit.object_name%type default null,
                        p_object_type           in svt_plsql_apex_audit.object_type%type default null,
                        p_schema                in svt_plsql_apex_audit.owner%type default null,
                        p_builder_session       in number default null
                        )
    return varchar2 deterministic result_cache
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'build_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
    c_app_id constant svt_plsql_apex_audit.application_id%type := p_app_id;
    c_page_id constant svt_plsql_apex_audit.page_id%type := p_page_id;
    c_pk_value constant svt_plsql_apex_audit.component_id%type := p_pk_value;
    c_parent_pk_value constant varchar2(100) := p_parent_pk_value;
    c_opt_parent_pk_value constant varchar2(100) := p_opt_parent_pk_value;
    c_builder_session constant number := coalesce(v('APX_BLDR_SESSION'),p_builder_session);
    c_template_url  constant svt_component_types.template_url%type := p_template_url;
    l_url varchar2(2000);
    c_schema      constant svt_plsql_apex_audit.owner%type := 
                            coalesce(p_schema, svt_preferences.get(p_preference_name  => 'SVT_DEFAULT_SCHEMA'));
    c_object_name constant svt_plsql_apex_audit.object_name%type := upper(p_object_name);
    c_object_type constant svt_plsql_apex_audit.object_type%type := upper(p_object_type);
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_template_url', p_template_url,
                                            'p_app_id', p_app_id,
                                            'p_page_id', p_page_id,
                                            'p_pk_value', p_pk_value,
                                            'p_parent_pk_value', p_parent_pk_value,
                                            'p_opt_parent_pk_value', p_opt_parent_pk_value,
                                            'p_builder_session', p_builder_session,
                                            'p_issue_category', p_issue_category,
                                            'p_schema', p_schema
                           );
        
        l_url := case when c_template_url is not null 
                      then  replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            c_template_url
                            , '%session%', case when p_issue_category = 'APEX'
                                                then c_builder_session
                                                else v('APP_SESSION')
                                                end)
                            , '%application_id%', c_app_id)
                            , '%page_id%', c_page_id)
                            , '%pk_value%', c_pk_value)
                            , '%parent_pk_value%', c_parent_pk_value)
                            , '%opt_parent_pk_value%', c_opt_parent_pk_value)
                            , '%line%', p_line)
                            , '%schema%'     , c_schema)
                            , '%object_name%', c_object_name)
                            , '%object_type%', c_object_type)
                      end;
        
        apex_debug.message(c_debug_template, 'l_url', l_url);
        -- l_url := apex_util.prepare_url(l_url);
        l_url := adapt_url(l_url);
        apex_debug.message(c_debug_template, 'prepared l_url', l_url);
        return l_url;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end build_url;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 29, 2023
-- Synopsis:
--
-- Private function to assemble the additional columns
--
------------------------------------------------------------------------------
    function assemble_addlcols( p_initials              in varchar2,
                                p_svt_component_type_id in svt_component_types.id%type) 
    return svt_component_types.addl_cols%type
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'assemble_addlcols';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_addl_cols        svt_component_types.addl_cols%type;
    l_addl_cols_final  svt_component_types.addl_cols%type;
    l_name_column      svt_component_types.name_column%type;
    l_count pls_integer := 0;
    c_padding constant varchar2(20) := '       ';
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_initials', p_initials, 
                                            'p_svt_component_type_id', p_svt_component_type_id);
        select lower(act.addl_cols), lower(act.name_column)
        into l_addl_cols, l_name_column
        from svt_nested_table_types antt
        inner join svt_component_types act on act.nt_type_id = antt.id
        where act.id = p_svt_component_type_id;
        
        l_addl_cols_final := chr(10)||c_padding||p_initials||'.'||l_name_column; --||','||chr(10);
        for rec in (select column_value extra_col
                    from table(apex_string.split(l_addl_cols,':'))
        ) loop
            l_addl_cols_final := l_addl_cols_final||
                                 ','||chr(10)||
                                 c_padding||p_initials||'.'||rec.extra_col;
            l_count := l_count + 1;
        end loop;
        return l_addl_cols_final;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end assemble_addlcols;
    ------------------------------------------------------------------------------
    -- Nested function to determine whether a given column exists in a given table 
    ------------------------------------------------------------------------------
    function column_exists (p_column_name in all_tab_cols.column_name%type,
                            p_table_name  in all_tab_cols.table_name%type) 
    return boolean
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'column_exists';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
    l_column_exists_yn varchar2(1) := gc_n;
    c_column_name constant all_tab_cols.column_name%type := lower(p_column_name);
    c_table_name  constant all_tab_cols.table_name%type := lower(p_table_name);
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_column_name', p_column_name, 
                                            'p_table_name', p_table_name);
        select case when count(*) = 1
                        then gc_y
                        else gc_n
                        end into l_column_exists_yn
                from sys.dual where exists (
                    select 1
                        from all_tab_cols 
                        where lower(table_name) = c_table_name
                        and lower(column_name) = c_column_name
                );
        return case when l_column_exists_yn = gc_y
                    then true 
                    else false
                    end;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end column_exists; 
    function seed_default_query(p_svt_component_type_id in svt_component_types.id%type)
    return varchar2
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'seed_default_query';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
    l_example_query svt_nested_table_types.example_query%type;
    l_view             svt_component_types.component_name%type;
    l_pk_value         svt_component_types.pk_value%type;
    l_parent_pk_value  svt_component_types.parent_pk_value%type;
    l_friendly_name    svt_component_types.friendly_name%type;
    l_name_column      svt_component_types.name_column%type;
    l_opt_parent_pk_value  all_objects.object_type%type;
    l_initials varchar2(5);
    c_application_id  constant varchar2(25) := 'application_id';
    c_page_id         constant varchar2(25) := 'page_id';
    c_created_by      constant varchar2(25) := 'created_by';
    c_created_on      constant varchar2(25) := 'created_on';
    c_updated_by      constant varchar2(25) := 'updated_by';
    c_updated_on      constant varchar2(25) := 'updated_on';
    c_last_updated_by constant varchar2(25) := 'last_updated_by';
    c_last_updated_on constant varchar2(25) := 'last_updated_on';
    c_build_option    constant varchar2(25) := 'build_option';
    c_workspace       constant varchar2(25) := 'workspace';
    c_3_spaces        constant varchar2(100) := chr(32)||chr(32)||chr(32);
    c_7_spaces        constant varchar2(100) := c_3_spaces||c_3_spaces||chr(32);
    c_10_spaces       constant varchar2(100) := c_7_spaces||chr(32)||chr(32)||chr(32);
    c_20_spaces       constant varchar2(100) := c_10_spaces||c_10_spaces;
    c_30_spaces       constant varchar2(100) := c_20_spaces||c_10_spaces;
    c_50_spaces       constant varchar2(100) := c_20_spaces||c_20_spaces||c_10_spaces;
    c_object_name     constant varchar2(25)  := 'object_name';
    begin
        apex_debug.message(c_debug_template,'START', 'p_svt_component_type_id', p_svt_component_type_id);
        select antt.example_query, 
               lower(act.component_name), 
               lower(act.pk_value), 
               lower(act.parent_pk_value), 
               upper(antt.object_type),
               initcap(act.friendly_name),
               lower(act.name_column)
        into l_example_query, 
             l_view, 
             l_pk_value, 
             l_parent_pk_value, 
             l_opt_parent_pk_value,
             l_friendly_name,
             l_name_column
        from svt_nested_table_types antt
        inner join svt_component_types act on act.nt_type_id = antt.id
        where act.id = p_svt_component_type_id;
        l_initials := case when l_name_column = c_object_name
                           then 'ao' --for all_objects
                           when l_view is not null
                           then lower(apex_string.get_initials(l_view,5))
                           else 'st'
                           end;
        
        l_example_query := replace(l_example_query, '%svtview%', coalesce(l_view, 'dual')||' '||l_initials);
        l_example_query := replace(l_example_query, '%pk_value%', case when l_pk_value is not null 
                                                                       then l_initials||'.'||l_pk_value
                                                                       else 'null'
                                                                       end
                                  );
        l_example_query := replace(l_example_query, '%parent_pk_value%', case when l_parent_pk_value is not null
                                                                              then l_initials||'.'||l_parent_pk_value
                                                                              else 'null'
                                                                              end
                                  );
        
        l_example_query := replace(l_example_query, '%appid%', case when column_exists (c_application_id,l_view)
                                                                    then l_initials||'.'
                                                                    else 'null '
                                                                    end
                                  );
        l_example_query := replace(l_example_query, '%pageid%', case when column_exists (c_page_id,l_view)
                                                                     then l_initials||'.'
                                                                     else 'null '
                                                                     end
                                  );
        l_example_query := replace(l_example_query, '%createdby%', case when column_exists (c_created_by,l_view)
                                                                        then l_initials||'.'
                                                                        else 'null '
                                                                        end
                                                                        ||c_created_by
                                  );
        l_example_query := replace(l_example_query, '%createdon%', case when column_exists (c_created_on,l_view)
                                                                        then l_initials||'.'
                                                                        else 'null '
                                                                        end
                                                                        ||c_created_on
                                  );
        l_example_query := replace(l_example_query, '%updatedby%', case when column_exists (c_last_updated_by,l_view)
                                                                        then l_initials||'.'
                                                                        when column_exists (c_updated_by,l_view)
                                                                        then l_initials||'.'||c_updated_by||' '
                                                                        else 'null '
                                                                        end
                                                                        ||c_last_updated_by
                                  );
        l_example_query := replace(l_example_query, '%updatedon%', case when column_exists (c_last_updated_on,l_view)
                                                                        then l_initials||'.'
                                                                        when column_exists (c_updated_on,l_view)
                                                                        then l_initials||'.'||c_updated_on||' '
                                                                        else 'null '
                                                                        end
                                                                        ||c_last_updated_on
                                  );
        l_example_query := replace(l_example_query, '%wrkspc%', case when column_exists (c_workspace,l_view)
                                                                     then l_initials||'.'
                                                                     else 'null '
                                                                     end
                                                                     ||c_workspace
                                  );
        l_example_query := case when column_exists (c_application_id,l_view)
                                then replace(l_example_query, '%issuedesc%', apex_string.format(q'['%1 `%2` (app %3%5) REPLACEME', 
        p0 => %0.%4, 
        p1 => %0.application_id%6]',
                                                                        p0 => l_initials,
                                                                        p1 => l_friendly_name,
                                                                        p2 => '%0',
                                                                        p3 => '%1',
                                                                        p4 => l_name_column,
                                                                        p5 => case when column_exists (c_page_id,l_view)
                                                                                   then ', page %2'
                                                                                   end,
                                                                        p6 => case when column_exists (c_page_id,l_view)
                                                                                   then',
        p2 => '||l_initials||'.page_id'
                                                                                   end
                                                                    )
                                    )
                                 else replace(l_example_query, '%issuedesc%', apex_string.format(q'['%1 `%2` REPLACEME', 
        p0 => %0.%4]',
                                                                        p0 => l_initials,
                                                                        p1 => l_friendly_name,
                                                                        p2 => '%0',
                                                                        p3 => '%1',
                                                                        p4 => l_name_column)
                                            )
                                 end;
        l_example_query := replace(l_example_query, '%addl_cols%', 
                                    assemble_addlcols(p_initials              => l_initials,
                                                      p_svt_component_type_id => p_svt_component_type_id));
        l_example_query := l_example_query||case when column_exists (c_page_id,l_view) and l_view != 'apex_application_pages'
                                                 then chr(10)||'inner join apex_application_pages aap on aap.page_id = '||l_initials||'.'||c_page_id
                                                    ||chr(10)||c_30_spaces||c_7_spaces||' and aap.application_id = '||l_initials||'.'||c_application_id
                                                    ||chr(10)||'left outer join apex_application_build_options aabo1 on  aabo1.build_option_name = aap.'||c_build_option
                                                    ||chr(10)||c_50_spaces||c_3_spaces||'and aabo1.application_id = aap.application_id'
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_build_option,l_view)
                                                 then chr(10)||'left outer join apex_application_build_options aabo2 on  aabo2.build_option_name = '||l_initials||'.'||c_build_option
                                                    ||chr(10)||c_50_spaces||c_3_spaces||'and aabo2.application_id = '||l_initials||'.application_id'
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_workspace,l_view)
                                                 then chr(10)||apex_string.format(q'[where %0.workspace = svt_preferences.get('SVT_WORKSPACE')]', l_initials)
                                                 else chr(10)||apex_string.format(q'[where 1=1]', l_initials)
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_page_id,l_view) and l_view != 'apex_application_pages'
                                                 then chr(10)||q'[and coalesce(aabo1.status_on_export,'NA') != 'Exclude']'
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_build_option,l_view)
                                                 then chr(10)||q'[and coalesce(aabo2.status_on_export,'NA') != 'Exclude']'
                                                 end;
        l_example_query := l_example_query||case when l_opt_parent_pk_value in ('TABLE','VIEW')
                                                 then chr(10)||apex_string.format(q'[and ao.object_type = '%s']',l_opt_parent_pk_value)
                                                 end;
        
        return l_example_query;
    exception 
        when no_data_found then 
            apex_debug.message(c_debug_template, 'no data found', p_svt_component_type_id);
            return null;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end seed_default_query;
    function valid_html_yn (p_html in clob) 
    return varchar2 
    deterministic
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'valid_html_yn';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_html constant clob := replace(
                            replace(
                            lower(trim(p_html))
                            , '&')
                            , '<br>');
    l_xml xmltype;
    e_malformed_xml exception;
    pragma exception_init(e_malformed_xml, -31011);
    l_skip_parse_yn varchar2(1) := gc_n;
    begin
        -- apex_debug.message(c_debug_template,'START', 'p_html', p_html);
        l_skip_parse_yn := case when c_html is null 
                                then gc_y
                                when c_html like '<input%'
                                then gc_y
                                when c_html like '<img%'
                                then gc_y
                                when c_html like '%{if%'
                                then gc_y
                                when c_html like '%autoplay%'
                                then gc_y
                                else gc_n
                                end;
        if l_skip_parse_yn = gc_n then
            select xmlparse(content c_html) as po
            into l_xml 
            from dual;
        end if;
        return gc_y;
    exception 
        when e_malformed_xml then 
            return gc_n;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end valid_html_yn;
end SVT_STDS_PARSER;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_STANDARDS_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_standards_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-17 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_localtimestamp constant svt_stds_standards.created%type := localtimestamp;
  gc_user constant svt_stds_standards.created_by%type := coalesce(wwv_flow.g_user,user);
  gc_y constant varchar2(1) := 'Y';
  gc_n constant varchar2(1) := 'N';
  function insert_std (
    p_standard_name         in svt_stds_standards.standard_name%type,
    p_description           in svt_stds_standards.description%type,
    p_primary_developer     in svt_stds_standards.primary_developer%type,
    p_implementation        in svt_stds_standards.implementation%type,
    p_date_started          in svt_stds_standards.date_started%type,
    p_standard_group        in svt_stds_standards.standard_group%type,
    p_active_yn             in svt_stds_standards.active_yn%type,
    p_compatibility_mode_id in svt_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in svt_stds_standards.parent_standard_id%type
  ) return svt_stds_standards.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_std';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_id constant svt_stds_standards.id%type := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  c_active_yn constant svt_stds_standards.active_yn%type := coalesce(p_active_yn, 'N');
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_name', p_standard_name);
    insert into svt_stds_standards
    (
      id,
      standard_name,
      description,
      primary_developer,
      implementation,
      date_started,
      standard_group,
      active_yn,
      compatibility_mode_id,
      parent_standard_id,
      created,
      created_by,
      updated,
      updated_by
    )
    values (
      c_id,
      p_standard_name,
      p_description,
      p_primary_developer,
      p_implementation,
      p_date_started,
      p_standard_group,
      c_active_yn,
      p_compatibility_mode_id,
      p_parent_standard_id,
      gc_localtimestamp,
      gc_user,
      gc_localtimestamp,
      gc_user
    );
    svt_stds_inherited_tests_api.inherit_all(
                    p_parent_standard_id => p_parent_standard_id,
                    p_standard_id => c_id
                );
    return c_id;
  exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end insert_std;
  procedure updated_std (
    p_id                    in svt_stds_standards.id%type,
    p_standard_name         in svt_stds_standards.standard_name%type,
    p_description           in svt_stds_standards.description%type,
    p_primary_developer     in svt_stds_standards.primary_developer%type,
    p_implementation        in svt_stds_standards.implementation%type,
    p_date_started          in svt_stds_standards.date_started%type,
    p_standard_group        in svt_stds_standards.standard_group%type,
    p_active_yn             in svt_stds_standards.active_yn%type,
    p_compatibility_mode_id in svt_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in svt_stds_standards.parent_standard_id%type
  ) as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'updated_std';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_current_rec svt_stds_standards%rowtype;
  begin
    l_current_rec := svt_stds_standards_api.get_rec (p_standard_id => p_id);
    update svt_stds_standards
    set standard_name         = p_standard_name,
        description           = p_description,
        primary_developer     = p_primary_developer,
        implementation        = p_implementation,
        date_started          = p_date_started,
        standard_group        = p_standard_group,
        active_yn             = p_active_yn,
        compatibility_mode_id = p_compatibility_mode_id,
        parent_standard_id    = p_parent_standard_id,
        updated               = gc_localtimestamp,
        updated_by            = gc_user
    where id = p_id;
    apex_debug.message(c_debug_template, 'updated : ', sql%rowcount);
    if p_parent_standard_id is null 
    and l_current_rec.parent_standard_id is not null 
    then
      svt_stds_inherited_tests_api.delete_std (
                    p_standard_id => p_id,
                    p_former_parent_standard_id => l_current_rec.parent_standard_id);
    end if;
  exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end updated_std;
  function get_rec (p_standard_id in svt_stds_standards.id%type)
  return svt_stds_standards%rowtype
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_rec';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec svt_stds_standards%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);
    
    select *
    into l_rec
    from svt_stds_standards
    where id = p_standard_id;
    return l_rec;
  exception 
    when no_data_found then
      apex_debug.message(c_debug_template, 'no data found');
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_rec;
  procedure delete_std (p_standard_id in svt_stds_standards.id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_std';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);
    svt_stds_inherited_tests_api.delete_std (p_standard_id => p_standard_id);
    delete from svt_stds_standards
    where id = p_standard_id;
    apex_debug.message(c_debug_template, 'deleted row : ', sql%rowcount);
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end delete_std;
  function get_full_name (p_standard_id in svt_stds_standards.id%type)
  return svt_stds_standards.standard_name%type
  deterministic
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_full_name';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_full_name svt_stds_standards.standard_name%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);
    select full_standard_name
    into l_full_name
    from v_svt_stds_standards
    where id = p_standard_id;
    return l_full_name;
  exception 
    when no_data_found then 
      apex_debug.message(c_debug_template, 'no data found ', p_standard_id);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_full_name;
  procedure update_test_avg_time
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_test_avg_time';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');
    
    merge into svt_stds_standard_tests e
    using (select test_code, avg_seconds from v_svt_test_timing) h
    on (e.test_code = h.test_code)
    when matched then
    update set e.avg_exctn_scnds = h.avg_seconds;
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end update_test_avg_time;
  function hex_color(p_standard_id in svt_stds_standards.id%type)
  return varchar2
  deterministic 
  result_cache
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'hex_color';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_hex varchar2(7);
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_standard_id', p_standard_id
                     );
    select '#'
       || to_char(
              dbms_random.value(0, to_number('FFFFFF','XXXXXX'))
              ,'fm0XXXXX')
    into l_hex
    from dual;
    return l_hex;
    
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end hex_color;
  function active_standard_count return pls_integer
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'active_standard_count';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_count pls_integer;
  begin
   apex_debug.message(c_debug_template,'START'
                     );
   
   select count(*)
   into l_count
   from svt_stds_standards
   where active_yn = gc_y;
   return l_count;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end active_standard_count;
  function active_standard_list return varchar2
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'active_standard_list';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_list varchar2(4000);
  begin
   apex_debug.message(c_debug_template,'START'
                     );
   
   select listagg(distinct standard_name, ', ' on overflow truncate) within group (order by standard_name) thelist
   into l_list
   from svt_stds_standards
   where active_yn = gc_y;
   
   return l_list;
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end active_standard_list;
end svt_stds_standards_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_STANDARD_TESTS_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_standard_tests_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_n constant varchar2(1) := 'N';
  gc_y constant varchar2(1) := 'Y';
  gc_default_version_number constant number := 0;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 20, 2023
-- Synopsis:
--
-- Private function to uppercase and handle spaces in test codes  
--
------------------------------------------------------------------------------
    function format_test_code (p_test_code in svt_stds_standard_tests.test_code%type)
    return svt_stds_standard_tests.test_code%type
    deterministic
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'format_test_code';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
      return upper(replace(p_test_code, ' ', '_'));
      
   exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end format_test_code;
    
    function insert_test(p_id                    in svt_stds_standard_tests.id%type default null,
                         p_standard_id           in svt_stds_standard_tests.standard_id%type,
                         p_test_name             in svt_stds_standard_tests.test_name%type,
                         p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                         p_query_clob            in svt_stds_standard_tests.query_clob%type,
                         p_owner                 in svt_stds_standard_tests.owner%type,
                         p_test_code             in svt_stds_standard_tests.test_code%type,
                         p_active_yn             in svt_stds_standard_tests.active_yn%type,
                         p_level_id              in svt_stds_standard_tests.level_id%type,
                         p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                         p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                         p_explanation           in svt_stds_standard_tests.explanation%type,
                         p_fix                   in svt_stds_standard_tests.fix%type,
                         p_version_number        in svt_stds_standard_tests.version_number%type default null,
                         p_version_db            in svt_stds_standard_tests.version_db%type default null
                         )
   return svt_stds_standard_tests.id%type 
   as 
   c_scope constant varchar2(128) := gc_scope_prefix || 'insert_test';
   c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
   c_test_code constant svt_stds_standard_tests.test_code%type := format_test_code(p_test_code);
   c_id constant svt_stds_standard_tests.id%type := coalesce(p_id, 
                                                            to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
   begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    insert into svt_stds_standard_tests 
    (
      id,
      standard_id,
      test_name,
      display_sequence,
      query_clob,
      owner,
      test_code,
      active_yn,
      level_id,
      mv_dependency,
      svt_component_type_id,
      explanation,
      fix,
      version_number,
      version_db,
      created,
      created_by,
      updated,
      updated_by
    )
    values (
      c_id,
      p_standard_id,
      p_test_name,
      p_display_sequence,
      p_query_clob,
      p_owner,
      c_test_code,
      p_active_yn,
      p_level_id,
      p_mv_dependency,
      p_svt_component_type_id,
      p_explanation,
      p_fix,
      coalesce(p_version_number,gc_default_version_number),
      coalesce(p_version_db,svt_preferences.get('SVT_DB_NAME')),
      localtimestamp,
      coalesce(wwv_flow.g_user,user),
      localtimestamp,
      coalesce(wwv_flow.g_user,user)
    );
    return c_id;
   
   exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
   end insert_test;
   procedure insert_test(p_id                    in svt_stds_standard_tests.id%type default null,
                         p_standard_id           in svt_stds_standard_tests.standard_id%type,
                         p_test_name             in svt_stds_standard_tests.test_name%type,
                         p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                         p_query_clob            in svt_stds_standard_tests.query_clob%type,
                         p_owner                 in svt_stds_standard_tests.owner%type,
                         p_test_code             in svt_stds_standard_tests.test_code%type,
                         p_active_yn             in svt_stds_standard_tests.active_yn%type,
                         p_level_id              in svt_stds_standard_tests.level_id%type,
                         p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                         p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                         p_explanation           in svt_stds_standard_tests.explanation%type,
                         p_fix                   in svt_stds_standard_tests.fix%type,
                         p_version_number        in svt_stds_standard_tests.version_number%type default null,
                         p_version_db            in svt_stds_standard_tests.version_db%type default null
                         )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_id svt_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_standard_id', p_standard_id,
                                        'p_test_name', p_test_name,
                                        'p_display_sequence', p_display_sequence,
                                        'p_test_code', p_test_code,
                                        'p_active_yn', p_active_yn,
                                        'p_level_id', p_level_id,
                                        'p_mv_dependency', p_mv_dependency,
                                        'p_svt_component_type_id', p_svt_component_type_id
                                        );
    l_id := insert_test(p_id                    => p_id,
                        p_standard_id           => p_standard_id,
                        p_test_name             => p_test_name,
                        p_display_sequence      => p_display_sequence,
                        p_query_clob            => p_query_clob,
                        p_owner                 => p_owner,
                        p_test_code             => p_test_code,
                        p_active_yn             => p_active_yn,
                        p_level_id              => p_level_id,
                        p_mv_dependency         => p_mv_dependency,
                        p_svt_component_type_id => p_svt_component_type_id,
                        p_explanation           => p_explanation,
                        p_fix                   => p_fix,
                        p_version_number        => p_version_number,
                        p_version_db            => p_version_db
                        );
    apex_debug.message(c_debug_template, 'l_id', l_id);
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end insert_test;
  -- build md5 function for table svt_stds_standard_tests
  function build_test_md5 (
      p_test_name             in svt_stds_standard_tests.test_name%type,
      p_query_clob            in svt_stds_standard_tests.query_clob%type,
      p_test_code             in svt_stds_standard_tests.test_code%type,
      p_level_id              in svt_stds_standard_tests.level_id%type,
      p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
      p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
      p_explanation           in svt_stds_standard_tests.explanation%type,
      p_fix                   in svt_stds_standard_tests.fix%type,
      p_version_number        in svt_stds_standard_tests.version_number%type,
      p_version_db            in svt_stds_standard_tests.version_db%type
  ) return varchar2 deterministic
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'build_test_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
      apex_debug.message(c_debug_template,'build_test_md5', 'p_test_code', p_test_code);
      
      return apex_util.get_hash(apex_t_varchar2(
        p_test_name,
        p_query_clob,
        p_test_code,
        p_level_id,
        p_mv_dependency,
        p_svt_component_type_id,
        p_explanation,
        p_fix,
        p_version_number,
        p_version_db ));
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end build_test_md5;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 13, 2023
-- Synopsis:
--
-- Private function to get the md5 for a given test_code
--
------------------------------------------------------------------------------ 
  function current_md5(p_test_code in svt_stds_standard_tests.test_code%type)
  return varchar2
  as 
  l_test_rec svt_stds_standard_tests%rowtype;
  c_scope constant varchar2(128) := gc_scope_prefix || 'current_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    l_test_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => p_test_code);
    return build_test_md5(
                      -- l_test_rec.standard_id,
                      l_test_rec.test_name,
                      l_test_rec.query_clob,
                      l_test_rec.test_code,
                      -- l_test_rec.active_yn,
                      l_test_rec.level_id,
                      l_test_rec.mv_dependency,
                      l_test_rec.svt_component_type_id,
                      l_test_rec.explanation,
                      l_test_rec.fix,
                      l_test_rec.version_number,
                      l_test_rec.version_db
                  );
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end current_md5;
  procedure publish_test(p_test_code in svt_stds_standard_tests.test_code%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'publish_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_lib_md5      varchar2(32767) := null;
  l_something_to_publish_yn varchar2(1) := gc_n;
  l_test_rec svt_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    l_test_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => p_test_code);
    if l_test_rec.active_yn = gc_y then
      l_lib_md5 := coalesce(svt_stds_tests_lib_api.current_md5(p_test_code => p_test_code),'NA');
      l_something_to_publish_yn := case when p_test_code is null
                                        then gc_n
                                        when l_lib_md5 = 'NA'
                                        then gc_y
                                        when l_lib_md5 != current_md5(p_test_code => p_test_code)
                                        then gc_y
                                        else gc_n
                                        end;
      if l_something_to_publish_yn = gc_y then
        <<publish_block>>
        declare
        l_version_number svt_stds_standard_tests.version_number%type;
        c_minor_version_increment constant number := 0.1;
        c_db_name constant svt_stds_standard_tests.version_db%type := svt_preferences.get('SVT_DB_NAME');
        begin
          l_version_number := case when l_test_rec.version_db != c_db_name
                                  then 1
                                  when l_test_rec.version_number = 0
                                  then 1
                                  else l_test_rec.version_number + c_minor_version_increment
                                  end;
        
          update svt_stds_standard_tests
          set version_number = l_version_number,
              version_db = c_db_name,
              updated = localtimestamp,
              updated_by = coalesce(wwv_flow.g_user,user)
          where test_code = p_test_code;
          svt_stds_tests_lib_api.upsert (
            p_standard_id           => l_test_rec.standard_id,
            p_test_name             => l_test_rec.test_name,
            p_test_id               => l_test_rec.id,
            p_query_clob            => l_test_rec.query_clob,
            p_test_code             => l_test_rec.test_code,
            p_active_yn             => l_test_rec.active_yn,
            p_mv_dependency         => l_test_rec.mv_dependency,
            p_svt_component_type_id => l_test_rec.svt_component_type_id,
            p_explanation           => l_test_rec.explanation,
            p_fix                   => l_test_rec.fix,
            p_level_id              => l_test_rec.level_id,
            p_version_number        => l_version_number,
            p_version_db            => c_db_name
          );
        end publish_block;
      else 
            apex_debug.message(c_debug_template, '. Nothing to upsert');
      end if;
    else 
      apex_debug.message(c_debug_template, '. Test is not active');
    end if;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end publish_test;
  procedure bulk_publish(p_selected_ids in varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_publish';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_selected_ids', p_selected_ids);
    for rec in (select column_value test_code
                from table(apex_string.split(p_selected_ids, ','))
    )
    loop
      publish_test(p_test_code => rec.test_code);
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end bulk_publish;
  
  
  procedure update_test(p_id                    in svt_stds_standard_tests.id%type,
                        p_standard_id           in svt_stds_standard_tests.standard_id%type,
                        p_test_name             in svt_stds_standard_tests.test_name%type,
                        p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                        p_query_clob            in svt_stds_standard_tests.query_clob%type,
                        p_owner                 in svt_stds_standard_tests.owner%type,
                        p_test_code             in svt_stds_standard_tests.test_code%type,
                        p_active_yn             in svt_stds_standard_tests.active_yn%type,
                        p_level_id              in svt_stds_standard_tests.level_id%type,
                        p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                        p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                        p_explanation           in svt_stds_standard_tests.explanation%type,
                        p_fix                   in svt_stds_standard_tests.fix%type,
                        p_version_number        in svt_stds_standard_tests.version_number%type default null,
                        p_version_db            in svt_stds_standard_tests.version_db%type default null
                        )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant svt_stds_standard_tests.test_code%type := format_test_code(p_test_code);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_test_code', p_test_code,
                                        'p_standard_id', p_standard_id,
                                        'p_test_name', p_test_name,
                                        'p_active_yn', p_active_yn,
                                        'p_level_id', p_level_id,
                                        'p_svt_component_type_id', p_svt_component_type_id,
                                        'p_version_number', p_version_number,
                                        'p_version_db', p_version_db
                                        );
      update svt_stds_standard_tests set
        standard_id           = p_standard_id,
        test_name             = p_test_name,
        display_sequence      = coalesce(p_display_sequence, display_sequence),
        query_clob            = p_query_clob,
        owner                 = p_owner,
        test_code             = c_test_code,
        active_yn             = p_active_yn,
        level_id              = p_level_id,
        mv_dependency         = p_mv_dependency,
        svt_component_type_id = p_svt_component_type_id,
        explanation           = p_explanation,
        fix                   = p_fix,
        version_number        = coalesce(p_version_number, version_number, gc_default_version_number),
        version_db            = coalesce(p_version_db, version_db, svt_preferences.get('SVT_DB_NAME')),
        updated               = localtimestamp,
        updated_by            = coalesce(wwv_flow.g_user,user)
      where id = p_id;
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end update_test;
  procedure bulk_inactivate(p_selected_ids in varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_inactivate';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec svt_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_selected_ids', p_selected_ids);
    for rec in (select column_value test_code
                from table(apex_string.split(p_selected_ids, ','))
    )
    loop
      l_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => rec.test_code);
      update_test(p_id                    => l_rec.id,
                  p_standard_id           => l_rec.standard_id,
                  p_test_name             => l_rec.test_name,
                  p_display_sequence      => l_rec.display_sequence,
                  p_query_clob            => l_rec.query_clob,
                  p_owner                 => l_rec.owner,
                  p_test_code             => l_rec.test_code,
                  p_active_yn             => gc_n,
                  p_level_id              => l_rec.level_id,
                  p_mv_dependency         => l_rec.mv_dependency,
                  p_svt_component_type_id => l_rec.svt_component_type_id,
                  p_explanation           => l_rec.explanation,
                  p_fix                   => l_rec.fix,
                  p_version_number        => l_rec.version_number
                );
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end bulk_inactivate;
  
  procedure bulk_delete(p_selected_ids in varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_delete';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec svt_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_selected_ids', p_selected_ids);
    for rec in (select column_value test_code
                from table(apex_string.split(p_selected_ids, ','))
    )
    loop
      l_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => rec.test_code);
      delete_test(p_id        => l_rec.id,
                  p_test_code => l_rec.test_code);
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end bulk_delete;
  procedure bulk_activate(p_selected_ids in varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_activate';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec svt_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_selected_ids', p_selected_ids);
    for rec in (select column_value test_code
                from table(apex_string.split(p_selected_ids, ','))
    )
    loop
      l_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => rec.test_code);
      update_test(p_id                    => l_rec.id,
                  p_standard_id           => l_rec.standard_id,
                  p_test_name             => l_rec.test_name,
                  p_display_sequence      => l_rec.display_sequence,
                  p_query_clob            => l_rec.query_clob,
                  p_owner                 => l_rec.owner,
                  p_test_code             => l_rec.test_code,
                  p_active_yn             => gc_y,
                  p_level_id              => l_rec.level_id,
                  p_mv_dependency         => l_rec.mv_dependency,
                  p_svt_component_type_id => l_rec.svt_component_type_id,
                  p_explanation           => l_rec.explanation,
                  p_fix                   => l_rec.fix,
                  p_version_number        => l_rec.version_number
                );
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end bulk_activate;
  procedure delete_test(p_id        in svt_stds_standard_tests.id%type,
                        p_test_code in svt_stds_standard_tests.test_code%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_test_code', p_test_code);
    svt_stds_inherited_tests_api.delete_test (p_test_id => p_id);
    
    delete from svt_stds_standard_tests
    where id = p_id;
    svt_stds_tests_lib_api.delete_test_from_lib (p_test_code => p_test_code);
    apex_debug.message(c_debug_template, 'sql%rowcount', sql%rowcount);
    
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end delete_test;
  function get_test_rec(p_test_code in svt_stds_standard_tests.test_code%type) 
  return svt_stds_standard_tests%rowtype
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_rec 1';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  l_test_rec svt_stds_standard_tests%rowtype;
  begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
      select *
      into l_test_rec
      from svt_stds_standard_tests
      where test_code = c_test_code;
      return l_test_rec;
      
  exception
      when no_data_found then
          return null;
      when others then
          apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
          raise;
  end get_test_rec;
  function get_test_rec(p_test_id in svt_stds_standard_tests.id%type) 
  return svt_stds_standard_tests%rowtype
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_rec 2';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_test_rec svt_stds_standard_tests%rowtype;
  begin
      apex_debug.message(c_debug_template,'START', 'p_test_id', p_test_id);
      select *
      into l_test_rec
      from svt_stds_standard_tests
      where id = p_test_id;
      return l_test_rec;
      
  exception
      when no_data_found then
          return null;
      when others then
          apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
          raise;
  end get_test_rec;
  procedure duplicate_standard (
                                    p_from_test_code in svt_stds_standard_tests.test_code%type,
                                    p_to_test_code   in svt_stds_standard_tests.test_code%type
                                )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'duplicate_standard';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_test_rec svt_stds_standard_tests%rowtype;
  c_new_test_code constant svt_stds_standard_tests.test_code%type := upper(p_to_test_code);
  l_new_test_id svt_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_from_test_code', p_from_test_code,
                                        'p_to_test_code', p_to_test_code);
    l_test_rec := get_test_rec(p_test_code => p_from_test_code);
    l_new_test_id := insert_test(
                        p_standard_id           => l_test_rec.standard_id,
                        p_test_name             => substr(l_test_rec.test_name,1,57)||' [COPY]',
                        p_display_sequence      => l_test_rec.display_sequence,
                        p_query_clob            => l_test_rec.query_clob,
                        p_owner                 => l_test_rec.owner,
                        p_test_code             => c_new_test_code,
                        p_active_yn             => gc_n,
                        p_level_id              => l_test_rec.level_id,
                        p_mv_dependency         => l_test_rec.mv_dependency,
                        p_svt_component_type_id => l_test_rec.svt_component_type_id,
                        p_explanation           => l_test_rec.explanation,
                        p_fix                   => l_test_rec.fix
                      );
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end duplicate_standard;
  function get_test_id (p_test_code in svt_stds_standard_tests.test_code%type)
  return svt_stds_standard_tests.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(replace(p_test_code, ' ', '_'));
  l_rec svt_stds_standard_tests%rowtype;
begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    
    l_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => c_test_code);
    
    return l_rec.id;
  
  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_test_id;
  function get_standard_id (p_test_id in svt_stds_standard_tests.id%type)
  return svt_stds_standard_tests.standard_id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_standard_id'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec svt_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_id', p_test_id);
    l_rec := get_test_rec(p_test_id => p_test_id);
    
    return l_rec.standard_id;
  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_standard_id;
  function get_standard_id (p_test_code in svt_stds_standard_tests.test_code%type)
  return svt_stds_standard_tests.standard_id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_standard_id 2'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec svt_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    l_rec := get_test_rec(p_test_code => p_test_code);
    
    return l_rec.standard_id;
  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_standard_id;
  function v_svt_stds_standard_tests (
                p_standard_id        in svt_stds_standard_tests.standard_id%type default null,
                p_active_yn          in svt_stds_standard_tests.active_yn%type default null,
                p_published_yn       in varchar2 default null,
                p_standard_active_yn in varchar2 default null,
                p_issue_category     in svt_nested_table_types.nt_name%type default null,
                p_inherited_yn       in varchar2 default null
            )
  return v_svt_stds_standard_tests_nt pipelined
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_stds_standard_tests';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 
  cursor cur_aa (p_std_id          in number,
                 p_active          in varchar2,
                 p_standard_active in varchar2,
                 p_calling_std     in varchar2,
                 p_category        in varchar2,
                 p_inherited       in varchar2)
  is 
  select o.standard_id,
         o.test_id,
         o.level_id,
         o.urgency, 
         o.urgency_level,
         o.test_name,
         o.test_code,
         o.full_standard_name,
         o.active_yn,
         o.nt_name,
         o.query_clob,
         o.std_creation_date,
         o.mv_dependency,
         o.svt_component_type_id,
         o.component_name,
         o.standard_active_yn,
         o.explanation,
         o.fix,
         o.version_number,
         o.version_db,
         o.inherited_yn,
         o.full_standard_name,
         o.display_sequence
  from v_svt_stds_standard_tests_w_inherited o
  where (o.standard_id = p_std_id or p_std_id is null)
  and   (o.active_yn = p_active or p_active is null)
  and   (o.standard_active_yn = p_standard_active or p_standard_active is null)
  and   (o.issue_category = p_category or p_category is null)
  and   o.inherited_yn = case when p_inherited is not null
                              then p_inherited
                              when p_std_id is null
                              then gc_n 
                              else o.inherited_yn
                              end;
  type r_aa is record (
    standard_id             number,
    test_id                 number,
    level_id                number,
    urgency                 varchar2(255),
    urgency_level           number,
    test_name               varchar2(64),
    test_code               varchar2(100),
    standard_name           varchar2(64),
    active_yn               varchar2(1),
    nt_name                 varchar2(255 char),
    query_clob              clob,
    std_creation_date       timestamp(6) with local time zone,
    mv_dependency           varchar2(100),
    svt_component_type_id   number,
    component_name          varchar2(50),
    standard_active_yn      varchar2(1),
    explanation             varchar2(4000 char),
    fix                     clob,
    version_number          number,
    version_db              varchar2(55),
    inherited_yn            varchar2(1),
    calling_std_name        varchar2(64),
    display_sequence        number
  );
  type t_aa is table of r_aa index by pls_integer;
  l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_active_yn', p_active_yn,
                                        'p_published_yn', p_published_yn,
                                        'p_standard_active_yn', p_standard_active_yn,
                                        'p_issue_category', p_issue_category,
                                        'p_inherited_yn', p_inherited_yn
                                        );
    open cur_aa (p_std_id          => p_standard_id,
                 p_active          => p_active_yn,
                 p_standard_active => p_standard_active_yn,
                 p_calling_std     => svt_stds_standards_api.get_full_name (p_standard_id => p_standard_id),
                 p_category        => p_issue_category,
                 p_inherited       => p_inherited_yn
                 );
    loop
      fetch cur_aa bulk collect into l_aat limit 1000;
      exit when l_aat.count = 0;
      for rec in 1 .. l_aat.count
      loop
        <<load_block>>
        declare
        c_file_blob constant blob := svt_deployment.json_standard_tests_blob (
                                                        p_standard_id => l_aat (rec).standard_id, 
                                                        p_test_code   => l_aat (rec).test_code);
        c_file_size constant pls_integer := sys.dbms_lob.getlength(c_file_blob);
        c_mime_type constant varchar2(25) := 'application/json';
        c_character_set constant varchar2(10) := 'UTF-8';
        c_md5 constant varchar2(250) := build_test_md5 (
                                          p_test_name             => l_aat (rec).test_name,
                                          p_query_clob            => l_aat (rec).query_clob,
                                          p_test_code             => l_aat (rec).test_code,
                                          p_level_id              => l_aat (rec).level_id,
                                          p_mv_dependency         => l_aat (rec).mv_dependency,
                                          p_svt_component_type_id => l_aat (rec).svt_component_type_id,
                                          p_explanation           => l_aat (rec).explanation,
                                          p_fix                   => l_aat (rec).fix,
                                          p_version_number        => l_aat (rec).version_number,
                                          p_version_db            => l_aat (rec).version_db
                                      );
        l_lib_md5 varchar2(250);
        l_lib_version_number svt_stds_tests_lib.version_number%type;
        l_published_yn varchar2(1) := gc_n;
        l_piperow_yn varchar2(1) := gc_y;
        begin
        svt_stds_tests_lib_api.md5_imported_vsn_num (
                p_test_code      => l_aat (rec).test_code,
                p_md5            => l_lib_md5,
                p_version_number => l_lib_version_number
        );
        l_published_yn := case  when l_aat (rec).active_yn = gc_n
                                then gc_n
                                when l_lib_md5 is null 
                                then gc_n
                                when c_md5 = l_lib_md5
                                then gc_y
                                else gc_n
                                end;
        l_piperow_yn := case when p_published_yn is null 
                             then gc_y 
                             when p_published_yn = gc_n
                             then case when l_published_yn = gc_n
                                       then gc_y
                                       else gc_n
                                       end
                             when p_published_yn = gc_y
                             then l_published_yn
                             else gc_y 
                             end;
        if l_piperow_yn = gc_y then 
          pipe row (v_svt_stds_standard_tests_ot (
                      l_aat (rec).standard_id,
                      l_aat (rec).test_id,
                      l_aat (rec).level_id,
                      l_aat (rec).urgency, 
                      l_aat (rec).urgency_level, --5
                      l_aat (rec).test_name,
                      l_aat (rec).test_code,
                      l_aat (rec).standard_name,
                      l_aat (rec).active_yn,
                      l_aat (rec).nt_name, --10
                      l_aat (rec).query_clob,
                      l_aat (rec).std_creation_date,
                      l_aat (rec).mv_dependency,
                      l_aat (rec).svt_component_type_id,
                      l_aat (rec).component_name,
                      l_aat (rec).standard_active_yn,
                      l_aat (rec).explanation,
                      l_aat (rec).fix,
                      c_file_size,  --download
                      c_file_blob,
                      c_mime_type,
                      apex_string.format('%s-%s.json',l_aat (rec).test_code, l_aat (rec).version_db), --file_name
                      c_character_set,
                      l_aat (rec).version_number,
                      l_aat (rec).version_db,
                      'v'||l_aat (rec).version_number, --vsn
                      c_md5, --  record_md5
                      l_lib_md5, --lib_md5
                      l_lib_version_number, --lib_imported_version
                      l_published_yn, --published_yn
                      case when l_published_yn = gc_n
                           then 'hide'
                           else 'show t-Button t-Button--icon t-Button--simple'
                           end, --download_css
                      l_aat (rec).inherited_yn, --inherited_yn,
                      l_aat (rec).calling_std_name, --calling standard
                      l_aat (rec).display_sequence
                    )
                );
              end if;
          end load_block;
      end loop;
    end loop;  
  exception 
    when no_data_needed then
      apex_debug.message(c_debug_template, 'No data needed');
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt_stds_standard_tests;
  function nt_name(p_test_code in svt_stds_standard_tests.test_code%type)
  return svt_nested_table_types.nt_name%type
  deterministic 
  result_cache
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'nt_name';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_nt_name svt_nested_table_types.nt_name%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
       select lower(nt_name)
        into l_nt_name
        from v_svt_stds_standard_tests
        where test_code = p_test_code;
      return l_nt_name;
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end nt_name;
  function active_test_count (
              p_published_yn   in varchar2 default null,
              p_issue_category in svt_nested_table_types.object_type%type default null) 
  return pls_integer
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'active_test_count';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_count pls_integer;
  begin
   apex_debug.message(c_debug_template,'START',
                                        'p_issue_category', p_issue_category
                     );
   
   select count(*) 
   into l_count
   from v_svt_stds_standard_tests(
          p_active_yn => gc_y,
          p_standard_active_yn => gc_y,
          p_published_yn => p_published_yn,
          p_issue_category => p_issue_category);
    return l_count;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end active_test_count;
end svt_stds_standard_tests_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_TESTS_LIB_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_TESTS_LIB_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-8 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(51) := lower($$plsql_unit) || '.';
  procedure upsert (
        p_standard_id           in svt_stds_tests_lib.standard_id%type,
        p_test_name             in svt_stds_tests_lib.test_name%type,
        p_test_id               in svt_stds_tests_lib.test_id%type,
        p_query_clob            in svt_stds_tests_lib.query_clob%type,
        p_test_code             in svt_stds_tests_lib.test_code%type,
        p_active_yn             in svt_stds_tests_lib.active_yn%type,
        p_mv_dependency         in svt_stds_tests_lib.mv_dependency%type,
        p_svt_component_type_id in svt_stds_tests_lib.svt_component_type_id%type,
        p_explanation           in svt_stds_tests_lib.explanation%type,
        p_fix                   in svt_stds_tests_lib.fix%type,
        p_level_id              in svt_stds_tests_lib.level_id%type,
        p_version_number        in svt_stds_tests_lib.version_number%type,
        p_version_db            in svt_stds_tests_lib.version_db%type
    )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'upsert';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_version_number constant svt_stds_tests_lib.version_number%type
                           := case when p_version_number = 0
                                   then null -- you cannot import an unpublished test
                                   else p_version_number
                                   end;
  c_version_db     constant svt_stds_tests_lib.version_db%type 
                          := coalesce(p_version_db, svt_preferences.get('SVT_DB_NAME'));
  c_id constant svt_stds_tests_lib.id%type := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_test_name', p_test_name,
                                        'p_test_code', p_test_code,
                                        'p_mv_dependency', p_mv_dependency,
                                        'p_svt_component_type_id', p_svt_component_type_id,
                                        'p_version_number',p_version_number,
                                        'p_version_db',p_version_db
                                        );
    merge into svt_stds_tests_lib e
    using (select p_standard_id           standard_id,
                  p_test_name             test_name,
                  p_test_id               test_id,
                  p_query_clob            query_clob,
                  p_test_code             test_code,
                  p_active_yn             active_yn,
                  p_mv_dependency         mv_dependency,
                  p_svt_component_type_id svt_component_type_id,
                  p_explanation           explanation,
                  p_fix                   fix,
                  p_level_id              level_id,
                  c_version_number        version_number,
                  c_version_db            version_db
           from dual) h
    on (e.test_code = h.test_code)
    when matched then
    update set e.standard_id           = h.standard_id,
               e.test_name             = h.test_name,
               e.test_id               = h.test_id,
               e.query_clob            = h.query_clob,
               e.active_yn             = h.active_yn,
               e.mv_dependency         = h.mv_dependency,
               e.svt_component_type_id = h.svt_component_type_id,
               e.explanation           = h.explanation,
               e.fix                   = h.fix,
               e.level_id              = h.level_id,
               e.version_number        = h.version_number,
               e.version_db            = h.version_db
    when not matched then
    insert (id,
            test_code,
            standard_id,
            test_name,
            test_id,
            query_clob,
            active_yn,
            mv_dependency,
            svt_component_type_id,
            explanation,
            fix,
            level_id,
            version_number,
            version_db
            )
    values (c_id,
            h.test_code,
            h.standard_id,
            h.test_name,
            h.test_id,
            h.query_clob,
            h.active_yn,
            h.mv_dependency,
            h.svt_component_type_id,
            h.explanation,
            h.fix,
            h.level_id,
            h.version_number,
            h.version_db
            );
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end upsert;
  -- procedure take_snapshot
  -- as 
  -- c_scope constant varchar2(128) := gc_scope_prefix || 'take_snapshot';
  -- c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  -- c_workspace constant apex_workspace_preferences.preference_value%type := svt_preferences.get('SVT_WORKSPACE');
  -- begin
  --   apex_debug.message(c_debug_template,'START');
  --   for rec in (
  --     select id test_id,
  --            standard_id,
  --            test_name,
  --            query_clob,
  --            test_code,
  --            active_yn,
  --            mv_dependency,
  --            svt_component_type_id,
  --            explanation,
  --            fix,
  --            level_id,
  --            version_number
  --     from svt_stds_standard_tests
  --     order by 1
  --   ) loop
  --     upsert (
  --       p_standard_id           => rec.standard_id,
  --       p_test_name             => rec.test_name,
  --       p_workspace             => c_workspace,
  --       p_test_id               => rec.test_id,
  --       p_query_clob            => rec.query_clob,
  --       p_test_code             => rec.test_code,
  --       p_active_yn             => rec.active_yn,
  --       p_mv_dependency         => rec.mv_dependency,
  --       p_svt_component_type_id => rec.svt_component_type_id,
  --       p_explanation           => rec.explanation,
  --       p_fix                   => rec.fix,
  --       p_level_id              => rec.level_id,
  --       p_version_number        => rec.version_number
  --     );
  --   end loop;
  -- exception when others then
  --   apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
  --   raise;
  -- end take_snapshot;
  procedure install_standard_test(p_id               in svt_stds_tests_lib.id%type,
                                  p_standard_id      in svt_stds_standard_tests.standard_id%type,
                                  p_urgency_level_id in svt_stds_standard_tests.level_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'install_standard_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_lib_rec svt_stds_tests_lib%rowtype;
  l_existing_rec svt_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_urgency_level_id', p_urgency_level_id,
                                        'p_standard_id', p_standard_id);
    select *
    into l_lib_rec
    from svt_stds_tests_lib
    where id = p_id;
    l_existing_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => l_lib_rec.test_code);
    if l_existing_rec.test_code is null then
      svt_stds_standard_tests_api.insert_test(
                  p_id                    => l_lib_rec.test_id,
                  p_standard_id           => coalesce(p_standard_id, l_lib_rec.standard_id),
                  p_test_name             => l_lib_rec.test_name,
                  p_query_clob            => l_lib_rec.query_clob,
                  p_owner                 => svt_preferences.get('SVT_DEFAULT_SCHEMA'),
                  p_test_code             => l_lib_rec.test_code,
                  p_active_yn             => 'Y',
                  p_level_id              => coalesce(p_urgency_level_id, svt_urgency_level_api.get_default_level_id),
                  p_mv_dependency         => l_lib_rec.mv_dependency,
                  p_svt_component_type_id => l_lib_rec.svt_component_type_id,
                  p_explanation           => l_lib_rec.explanation,
                  p_fix                   => l_lib_rec.fix,
                  p_version_number        => l_lib_rec.version_number,
                  p_version_db            => l_lib_rec.version_db
                  );
    
    else 
      svt_stds_standard_tests_api.update_test(
                          p_id                    => l_existing_rec.id,
                          p_standard_id           => coalesce(p_standard_id, l_lib_rec.standard_id),
                          p_test_name             => l_lib_rec.test_name,
                          p_display_sequence      => l_existing_rec.display_sequence,
                          p_query_clob            => l_lib_rec.query_clob,
                          p_owner                 => l_existing_rec.owner,
                          p_test_code             => l_existing_rec.test_code,
                          p_active_yn             => l_existing_rec.active_yn,
                          p_level_id              => l_lib_rec.level_id,
                          p_mv_dependency         => l_lib_rec.mv_dependency,
                          p_svt_component_type_id => l_lib_rec.svt_component_type_id,
                          p_explanation           => l_lib_rec.explanation,
                          p_fix                   => l_lib_rec.fix,
                          p_version_number        => l_lib_rec.version_number,
                          p_version_db            => l_lib_rec.version_db
                      );
    end if;
    
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end install_standard_test;
  procedure auto_install_standard_test (
                      p_standard_id in svt_stds_standard_tests.standard_id%type,
                      p_test_code   in svt_stds_standard_tests.test_code%type default null)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'auto_install_standard_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_test_code', p_test_code);
    
    for rec in (select id, standard_id, level_id
                from svt_stds_tests_lib
                where standard_id = p_standard_id
                and (test_code = p_test_code or p_test_code is null)
                )
    loop
      install_standard_test(p_id               => rec.id,
                            p_standard_id      => rec.standard_id,
                            p_urgency_level_id => rec.level_id);
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end auto_install_standard_test;
  procedure delete_test_from_lib (p_id in svt_stds_tests_lib.id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test_from_lib 1';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_id', p_id);
    delete from svt_stds_tests_lib
    where id = p_id;
    
    apex_debug.message(c_debug_template, 'sql%rowcount', sql%rowcount);
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end delete_test_from_lib;
  procedure delete_test_from_lib (p_test_code in svt_stds_tests_lib.test_code%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test_from_lib 2';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    delete from svt_stds_tests_lib
    where test_code = p_test_code;
    
    apex_debug.message(c_debug_template, 'sql%rowcount', sql%rowcount);
  
  exception when others then
  apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
  raise;
  end delete_test_from_lib;
  function get_id(p_test_code in svt_stds_tests_lib.test_code%type)
  return svt_stds_tests_lib.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_space_index constant number := instr(p_test_code,' ');
  c_test_code constant svt_stds_tests_lib.test_code%type 
                  := case when c_space_index = 0
                          then upper(p_test_code)
                          else substr (upper(p_test_code), 1,c_space_index - 1)
                          end;
  l_id svt_stds_tests_lib.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    
    select id
    into l_id
    from svt_stds_tests_lib
    where test_code = c_test_code;
    return l_id;
  
  exception 
  when no_data_found then
    return null;
  when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_id;
  procedure md5_imported_vsn_num (
                p_test_code      in  svt_stds_tests_lib.test_code%type,
                p_md5            out nocopy varchar2,
                p_version_number out nocopy svt_stds_tests_lib.version_number%type
              )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'md5_imported_vsn_num';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_lib_rec svt_stds_tests_lib%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
  
    select *
    into l_lib_rec
    from svt_stds_tests_lib
    where test_code = p_test_code;
    p_md5 := svt_stds_standard_tests_api.build_test_md5(
                      l_lib_rec.test_name,
                      l_lib_rec.query_clob,
                      l_lib_rec.test_code,
                      l_lib_rec.level_id,
                      l_lib_rec.mv_dependency,
                      l_lib_rec.svt_component_type_id,
                      l_lib_rec.explanation,
                      l_lib_rec.fix,
                      l_lib_rec.version_number,
                      l_lib_rec.version_db
                  );
    p_version_number := l_lib_rec.version_number;
  
  exception 
    when no_data_found then
      apex_debug.message(c_debug_template, 'no data found', p_test_code);
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end md5_imported_vsn_num;
  function current_md5(p_test_code in svt_stds_tests_lib.test_code%type)
  return varchar2
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'current_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_md5 varchar2(250);
  l_version_number svt_stds_tests_lib.version_number%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    md5_imported_vsn_num (
                p_test_code      => p_test_code,
                p_md5            => l_md5,
                p_version_number => l_version_number
              );
    
    return l_md5;
  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end current_md5;
end SVT_STDS_TESTS_LIB_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_STDS_TYPES_API" as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-10 - created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  function insert_typ (
       p_id               in svt_stds_types.id%type default null,
       p_display_sequence in svt_stds_types.display_sequence%type,
       p_type_name        in svt_stds_types.type_name%type,
       p_type_code        in svt_stds_types.type_code%type,
       p_description      in svt_stds_types.description%type,
       p_active_yn        in svt_stds_types.active_yn%type
    ) return svt_stds_types.id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_typ';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  c_id constant svt_stds_types.id%type 
                  := coalesce(p_id, 
                              to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   
   insert into svt_stds_types
      (
        id,
        display_sequence,
        type_name,
        type_code,
        description,
        active_yn
      )
      values 
      (
        c_id,
        p_display_sequence,
        p_type_name,
        p_type_code,
        p_description,
        p_active_yn
      );
    apex_debug.message(c_debug_template,'c_id', c_id);
    return c_id;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end insert_typ;
  procedure update_typ (
       p_id               in svt_stds_types.id%type,
       p_display_sequence in svt_stds_types.display_sequence%type,
       p_type_name        in svt_stds_types.type_name%type,
       p_type_code        in svt_stds_types.type_code%type,
       p_description      in svt_stds_types.description%type,
       p_active_yn        in svt_stds_types.active_yn%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_typ';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
    update svt_stds_types
    set display_sequence = p_display_sequence,
        type_name        = p_type_name,
        type_code        = p_type_code,
        description      = p_description,
        active_yn        = p_active_yn
    where id = p_id;
    apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end update_typ;
  procedure delete_typ (
        p_id in svt_stds_types.id%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_typ';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
    delete from  svt_stds_types
    where id = p_id;
    apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end delete_typ;
  function get_type_id (p_type_code in svt_stds_types.type_code%type)
  return svt_stds_types.id%type
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || 'get_type_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_id svt_stds_types.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_type_code', p_type_code);
    select id 
    into l_id
    from svt_stds_types
    where type_code = p_type_code;
    return l_id;
  exception
    when no_data_found then
      apex_debug.message(c_debug_template,'no_data_found', 'p_type_code', p_type_code);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end get_type_id;
end svt_stds_types_api;
/ 