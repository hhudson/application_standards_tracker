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
  gc_y            constant varchar2(1) := 'Y';
  gc_n            constant varchar2(1) := 'N';

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
  c_ignore_legacy  constant svt_audit_actions.id%type := 2;
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
    c_limit         constant pls_integer := 100;

    type r_issues is record (
        unqid                      svt_plsql_apex_audit.unqid%type,
        issue_category             svt_plsql_apex_audit.issue_category%type,
        application_id             svt_plsql_apex_audit.application_id%type,
        page_id                    svt_plsql_apex_audit.page_id%type,
        pass_yn                    svt_plsql_apex_audit.pass_yn%type,
        line                       svt_plsql_apex_audit.line%type,
        object_name                svt_plsql_apex_audit.object_name%type,
        object_type                svt_plsql_apex_audit.object_type%type,
        code                       svt_plsql_apex_audit.code%type,
        validation_failure_message svt_plsql_apex_audit.validation_failure_message%type,
        issue_title                svt_plsql_apex_audit.issue_title%type,
        test_code                  svt_plsql_apex_audit.test_code%type,
        apex_created_by            svt_plsql_apex_audit.apex_created_by%type,
        apex_created_on            svt_plsql_apex_audit.apex_created_on%type,
        apex_last_updated_by       svt_plsql_apex_audit.apex_last_updated_by%type,
        apex_last_updated_on       svt_plsql_apex_audit.apex_last_updated_on%type,
        owner                      svt_plsql_apex_audit.owner%type,
        component_id               svt_plsql_apex_audit.component_id%type,
        parent_component_id        svt_plsql_apex_audit.parent_component_id%type
    );
    type t_issue_rec is table of r_issues index by svt_plsql_apex_audit.unqid%type; 
    l_issues_t            t_issue_rec;
    type t_unqid_rec is table of svt_plsql_apex_audit.unqid%type; 
    l_current_issues_t    t_unqid_rec := t_unqid_rec();
    c_legacy_yn  constant svt_plsql_apex_audit.legacy_yn%type := case when upper(p_legacy_yn) = gc_y
                                                                      then gc_y
                                                                      else gc_n
                                                                      end;
    l_svt_plsql_apex_audit_rec svt_plsql_apex_audit%rowtype;
    c_user constant varchar2(100) := coalesce(sys_context('APEX$SESSION','APP_USER'),user,'nobody');
    c_sysdate constant svt_plsql_apex_audit.updated%type := sysdate;
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
                    a.pass_yn,
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
          l_issues_t(rec.unqid) := r_issues(rec.unqid,
                                            rec.issue_category,
                                            rec.application_id,
                                            rec.page_id,
                                            rec.pass_yn,
                                            rec.line,
                                            rec.object_name,
                                            rec.object_type,
                                            rec.code,
                                            rec.validation_failure_message,
                                            rec.issue_title,
                                            rec.test_code,
                                            rec.apex_created_by,
                                            rec.apex_created_on,
                                            rec.apex_last_updated_by,
                                            rec.apex_last_updated_on,
                                            rec.owner,
                                            rec.component_id,
                                            rec.parent_component_id 
                                          );
          l_current_issues_t.extend;
          l_current_issues_t(l_current_issues_t.LAST) := rec.unqid;
        end loop;

        apex_debug.message(c_debug_template, 'l_issues_t.count', l_issues_t.count);
        apex_debug.message(c_debug_template, 'l_current_issues_t.count', l_current_issues_t.count);

        <<mrg>>
        declare
        l_unqid svt_plsql_apex_audit.unqid%type;
        begin
          l_unqid := l_issues_t.first;

          loop
            exit when l_unqid is null;

            merge into svt_plsql_apex_audit aa
            using (select l_issues_t(l_unqid).issue_category             issue_category,
                          l_issues_t(l_unqid).application_id             application_id,
                          l_issues_t(l_unqid).page_id                    page_id,
                          l_issues_t(l_unqid).pass_yn                    pass_yn,
                          l_issues_t(l_unqid).line                       line,
                          l_issues_t(l_unqid).object_name                object_name,
                          l_issues_t(l_unqid).object_type                object_type,
                          l_issues_t(l_unqid).code                       code,
                          l_issues_t(l_unqid).validation_failure_message validation_failure_message,
                          l_issues_t(l_unqid).issue_title                issue_title,
                          l_issues_t(l_unqid).test_code                  test_code,
                          l_issues_t(l_unqid).apex_created_by            apex_created_by,
                          l_issues_t(l_unqid).apex_created_on            apex_created_on,
                          l_issues_t(l_unqid).apex_last_updated_by       apex_last_updated_by,
                          l_issues_t(l_unqid).apex_last_updated_on       apex_last_updated_on,
                          l_issues_t(l_unqid).owner                      owner,
                          l_issues_t(l_unqid).component_id               component_id,
                          l_issues_t(l_unqid).parent_component_id        parent_component_id
                  from dual) lit
            on (aa.unqid    = l_unqid)
            when matched then
            update set aa.issue_category             = lit.issue_category,
                       aa.application_id             = lit.application_id,
                       aa.page_id                    = lit.page_id,
                       aa.pass_yn                    = lit.pass_yn,
                       aa.line                       = lit.line,
                       aa.object_name                = lit.object_name,
                       aa.object_type                = lit.object_type,
                       aa.code                       = lit.code,
                       aa.validation_failure_message = lit.validation_failure_message,
                       aa.issue_title                = lit.issue_title,
                       aa.test_code                  = lit.test_code,
                       aa.legacy_yn                  = coalesce(aa.legacy_yn, c_legacy_yn),
                       aa.apex_created_by            = lit.apex_created_by,
                       aa.apex_created_on            = lit.apex_created_on,
                       aa.apex_last_updated_by       = lit.apex_last_updated_by,
                       aa.apex_last_updated_on       = lit.apex_last_updated_on,
                       aa.owner                      = lit.owner,
                       aa.component_id               = lit.component_id,
                       aa.parent_component_id        = lit.parent_component_id,
                       updated                       = c_sysdate,
                       updated_by                    = c_user
            when not matched then
            insert (aa.unqid, 
                    aa.issue_category, 
                    aa.application_id, 
                    aa.page_id, 
                    aa.pass_yn, 
                    aa.line, 
                    aa.object_name, 
                    aa.object_type, 
                    aa.code, 
                    aa.validation_failure_message, 
                    aa.issue_title, 
                    aa.test_code, 
                    aa.legacy_yn, 
                    aa.apex_created_by, 
                    aa.apex_created_on, 
                    aa.apex_last_updated_by, 
                    aa.apex_last_updated_on, 
                    aa.owner,
                    aa.component_id,
                    aa.parent_component_id,
                    created,
                    created_by,
                    updated,
                    updated_by
                    )
            values (l_unqid,
                    lit.issue_category,
                    lit.application_id,
                    lit.page_id,
                    lit.pass_yn,
                    lit.line,
                    lit.object_name,
                    lit.object_type,
                    lit.code,
                    lit.validation_failure_message,
                    lit.issue_title,
                    lit.test_code,
                    c_legacy_yn,
                    lit.apex_created_by,
                    lit.apex_created_on,
                    lit.apex_last_updated_by,
                    lit.apex_last_updated_on,
                    lit.owner,
                    lit.component_id,
                    lit.parent_component_id,
                    c_sysdate,
                    c_user,
                    c_sysdate,
                    c_user);

            l_unqid := l_issues_t.next(l_unqid);
          end loop;
        end mrg;

        -- <<dlt>>
        -- declare
        --  l_recorded_issues_t   t_unqid_rec;
        --  l_obsolete_issues_t   t_unqid_rec;
        -- begin
        --   select aap.unqid
        --     bulk collect into l_recorded_issues_t
        --     from svt_plsql_apex_audit aap
        --     where (aap.test_code = c_test_code or c_test_code is null)
        --     and   (aap.application_id  = p_application_id or p_application_id is null)
        --     and   (aap.page_id  = p_page_id or p_page_id is null)
        --     and   (aap.id = p_audit_id or p_audit_id is null);

        --   apex_debug.message(c_debug_template, 'l_recorded_issues_t.count', l_recorded_issues_t.count);

        --   l_obsolete_issues_t := l_recorded_issues_t multiset except l_current_issues_t;
        --   apex_debug.message(c_debug_template, 'l_obsolete_issues_t.count', l_obsolete_issues_t.count);

        --   forall i in 1 .. l_obsolete_issues_t.count
        --     delete from svt_plsql_apex_audit
        --     where unqid = l_obsolete_issues_t(i);
        -- exception when e_deadlock then 
        --   apex_debug.error(p_message => c_debug_template, p0 =>'Deadlock encountered in merge_audit_tbl.dtl', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        --   raise;
        -- end dlt;


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