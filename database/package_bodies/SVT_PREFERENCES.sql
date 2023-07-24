--liquibase formatted sql
--changeset package_body_script:SVT_PREFERENCES_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_PREFERENCES as
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
  gc_ast          constant varchar2(3) := 'AST';

  function get_preference (p_preference_name in apex_workspace_preferences.preference_name%type)
  return apex_workspace_preferences.preference_value%type deterministic
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_preference';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_preference_name constant apex_workspace_preferences.preference_name%type := upper(p_preference_name);
  l_pref_value      apex_workspace_preferences.preference_value%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_preference_name', p_preference_name);
    
    select preference_value 
    into l_pref_value
    from v_apex_workspace_preferences
    where preference_name = c_preference_name
    and user_name = gc_svt
    ;

    return l_pref_value;
  exception 
    when no_data_found then 
      return case when p_preference_name = 'SVT_DEFAULT_SCHEMA'
                  then gc_ast
                  else null
                  end;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_preference;

  procedure set_preference (p_preference_name in apex_workspace_preferences.preference_name%type,
                            p_value           in apex_workspace_preferences.preference_value%type)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'set_preference';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_preference_name', p_preference_name,
                                        'p_value', p_value);
    if p_value is not null then
      apex_util.set_preference(        
          p_preference => p_preference_name,
          p_value      => p_value,      
          p_user       => gc_svt); 
    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end set_preference;


end SVT_PREFERENCES;
/
--rollback drop package body SVT_PREFERENCES;