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
--rollback drop package body svt_nested_table_types_api;