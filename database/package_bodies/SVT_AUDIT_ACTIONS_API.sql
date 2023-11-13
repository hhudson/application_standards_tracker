--liquibase formatted sql
--changeset package_body_script:SVT_AUDIT_ACTIONS_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_AUDIT_ACTIONS_API as
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
--rollback drop package body SVT_AUDIT_ACTIONS_API;