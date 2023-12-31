--liquibase formatted sql
--changeset package_body_script:SVT_STANDARD_VIEW stripComments:false endDelimiter:/ runOnChange:true
create or replace package body SVT_STANDARD_VIEW as
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

--rollback drop package SVT_STANDARD_VIEW;
