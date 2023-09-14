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


  function issue_category (p_nt_name in svt_nested_table_types.nt_name%type)
  return svt_plsql_apex_audit.issue_category%type
  deterministic
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || 'issue_category 1';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_nt_name        constant svt_nested_table_types.nt_name%type := upper (p_nt_name);
  begin
    apex_debug.message(c_debug_template,'START', 'p_nt_name', p_nt_name);

    return case c_nt_name
                when 'V_SVT_APEX__0_NT'    then 'APEX'
                when 'V_SVT_DB_TBL__0_NT'  then 'TABLE'
                when 'V_SVT_DB_VIEW__0_NT' then 'VIEW'
                when 'V_SVT_DB_PLSQL_NT'   then 'DB_PLSQL'
                when 'V_SVT_SERT__0_NT'    then 'SERT'
                else null
                end;

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

    select issue_category (p_nt_name => nt_name)
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