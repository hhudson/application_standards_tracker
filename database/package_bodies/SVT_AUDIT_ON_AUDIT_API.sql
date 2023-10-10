--liquibase formatted sql
--changeset package_body_script:SVT_AUDIT_ON_AUDIT_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_AUDIT_ON_AUDIT_API as
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
        p_validation_failure_message in svt_audit_on_audit.validation_failure_message%type
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
               created,
               created_by)
       values (p_unqid,
               c_action_name,
               p_test_code,
               p_audit_id,
               p_validation_failure_message,
               sysdate,
               coalesce(sys_context('APEX$SESSION','APP_USER'),user)
               );

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_rec;


end SVT_AUDIT_ON_AUDIT_API;
/
--rollback drop package body SVT_AUDIT_ON_AUDIT_API;