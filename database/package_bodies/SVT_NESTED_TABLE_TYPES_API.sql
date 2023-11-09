--liquibase formatted sql
--changeset package_body_script:svt_nested_table_types_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body svt_nested_table_types_api as
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
  gc_sysdate constant svt_nested_table_types.created%type := sysdate;
  gc_user    constant svt_nested_table_types.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);

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
      gc_sysdate,
      gc_user,
      gc_sysdate,
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
        updated       = gc_sysdate,
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

  function issue_category (p_test_code in eba_stds_standard_tests.test_code%type)
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
    from v_eba_stds_standard_tests
    where test_code = p_test_code;

    return l_issue_category;
  
   exception
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end issue_category;


end svt_nested_table_types_api;
/
--rollback drop package body svt_nested_table_types_api;