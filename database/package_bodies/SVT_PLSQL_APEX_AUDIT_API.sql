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
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_audit';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  BEGIN
    apex_debug.message(c_debug_template,'START', 'p_unqid', p_unqid);

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
    apex_debug.message(c_debug_template, 'sql%rowcount :', sql%rowcount);
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end update_audit;

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
        p_validation_failure_message => p_validation_failure_message
    );
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_audit;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- Procedure to delete a record of  svt_plsql_apex_audit
--
/*
begin
  delete_audit (
              p_unqid                      => p_unqid,
              p_audit_id                   => p_audit_id,
              p_test_code                  => p_test_code,
              p_validation_failure_message => p_validation_failure_message
            );
end;
*/
------------------------------------------------------------------------------
  procedure delete_audit (
              p_unqid                      in svt_plsql_apex_audit.unqid%type,
              p_audit_id                   in svt_plsql_apex_audit.id%type,
              p_test_code                  in svt_plsql_apex_audit.test_code%type,
              p_validation_failure_message in svt_plsql_apex_audit.validation_failure_message%type)
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
        p_validation_failure_message => p_validation_failure_message
    );

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_audit;

  procedure delete_stale
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_stale';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 
  BEGIN
    apex_debug.message(c_debug_template,'START');

    for rec in (
      select unqid, audit_id, test_code, validation_failure_message
      from v_svt_plsql_apex_audit
      where stale_yn = gc_y
    ) loop 
      delete_audit (
              p_unqid                      => rec.unqid,
              p_audit_id                   => rec.audit_id,
              p_test_code                  => rec.test_code,
              p_validation_failure_message => rec.validation_failure_message
            );
    end loop;
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_stale;

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
                                                                         svt_preferences.get_preference ('SVT_DEFAULT_ASSIGNEE')
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
                  from table(apex_string.split(p_audit_ids, ':'))
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
             from v_eba_stds_applications
             where default_developer is not null) h
      on (e.application_id = h.apex_app_id)
      when matched then
      update set e.assignee = h.default_developer;

      if svt_preferences.get_preference ('SVT_DEFAULT_ASSIGNEE') is not null then 
        update svt_plsql_apex_audit
        set assignee = lower(svt_preferences.get_preference ('SVT_DEFAULT_ASSIGNEE'))
        where assignee is null;
      end if;

    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end assign_from_default;

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
                    where issue_category in ('APEX', 'SERT')
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
        and issue_category in ('APEX','SERT')
        and (assignee != l_auditid_email(l_auditid) or assignee is null);

        l_auditid := l_auditid_email.next(l_auditid);
      end loop;

    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end assign_from_apex_audit;

    $if oracle_apex_version.c_loki_access $then
    procedure assign_from_loki 
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'assign_from_loki';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START');

      merge into (select object_type, object_name, assignee
                  from svt_plsql_apex_audit 
                  where issue_category in 'DB_PLSQL') e
      using (select object_type, object_name, apex_username
             from v_loki_object_assignee
             where apex_username is not null) h
      on (    e.object_type = h.object_type
          and e.object_name = h.object_name)
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
      apex_debug.message(c_debug_template,'START', 'p_unquid', p_unquid);

      select case when count(*) = 1
                        then 'Y'
                        else 'N'
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
                               p_test_code      in eba_stds_standard_tests.test_code%type,
                               p_legacy_yn      in svt_plsql_apex_audit.legacy_yn%type default 'N',
                               p_audit_id       in svt_plsql_apex_audit.id%type default null,
                               p_issue_category in svt_plsql_apex_audit.issue_category%type default null
                               )
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'merge_audit_tbl';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_test_code constant eba_stds_standard_tests.test_code%type := upper(p_test_code);
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
                    svt_ctx_util.get_default_user owner,
                    a.component_id,
                    a.parent_component_id 
                  from v_eba_stds_standard_tests esst
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
    --               p_test_code      in eba_stds_standard_tests.test_code%type default null,
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
    --   and owner = case when sys_context('userenv', 'current_user') = svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA')
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