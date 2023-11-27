--liquibase formatted sql
--changeset package_body_script:SVT_PLSQL_APEX_AUDIT_API_BODY stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_PLSQL_APEX_AUDIT_API as
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
        p_assignee                   => null,
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
      from v_apex_workspace_developers
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
                    left join v_apex_workspace_developers awd on coalesce(paa.apex_last_updated_by, paa.apex_created_by) = awd.user_name
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
                  := eba_stds.get_mv_dependency(p_test_code => p_test_code);
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
                  p_standard_id    in eba_stds_standards.id%type default null)
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
                          p_standard_id    in eba_stds_standards.id%type default null)
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
--rollback drop package body svt_plsql_apex_audit_api;