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
                        p_standard_id in eba_stds_standards.id%type default null)
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
    inner join eba_stds_standard_tests esst on esst.test_code = aoa.test_code
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
--rollback drop package body SVT_AUDIT_ON_AUDIT_API;