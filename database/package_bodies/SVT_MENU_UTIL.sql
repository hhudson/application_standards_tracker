--liquibase formatted sql
--changeset package_body_script:SVT_MENU_UTIL_BODY stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_MENU_UTIL as
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
--rollback drop package body SVT_MENU_UTIL;