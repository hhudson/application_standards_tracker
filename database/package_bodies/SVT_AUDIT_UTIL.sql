--liquibase formatted sql
--changeset package_body_script:SVT_AUDIT_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package body SVT_AUDIT_UTIL as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-9 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_y            constant varchar2(1) := 'Y';
  gc_n            constant varchar2(1) := 'N';

  function v_svt_scm_object_assignee
  return v_svt_scm_object_assignee_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_scm_object_assignee';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cursor cur_aa
  is
      $if oracle_apex_version.c_scm_access
      $then 
        with scm as (select case when cfo.folder_name = 'Bodies'
                         then replace(upper(cfi.file_name),'.PKB')
                         when cfo.folder_name = 'SQL Views'
                         then replace(upper(cfi.file_name),'.VW')
                         when cfo.folder_name = 'Triggers'
                         then replace(upper(cfi.file_name),'.TRG')
                         end object_name,
                    upper(cfo.folder_name) folder_name,
                    cfi.checked_out_by,
                    case when cfi.created_by not in ('UT_CARS', 'CARS', 'APEX_SCM', svt_preferences.get('SVT_DEFAULT_SCHEMA'))
                         then cfi.created_by
                         end created_by, 
                    case when cfi.updated_by not in ('UT_CARS', 'CARS', 'APEX_SCM', svt_preferences.get('SVT_DEFAULT_SCHEMA'))
                         then cfi.updated_by
                         end updated_by
               from apex_scm.ccs_files_vw cfi
               inner join apex_scm.ccs_folders cfo on cfi.pfl_id = cfo.pfl_id
               where cfo.folder_name in ('Bodies', 'SQL Views', 'Triggers')
            ),
            scm2 as (
                  select scm.object_name, coalesce(scm.checked_out_by, scm.updated_by, scm.created_by) assignee, folder_name
                  from scm
            )
        select scm2.object_name, coalesce(upper(awd.email), upper(scm2.assignee)) email, folder_name, null lock_rank
        from scm2 
        left outer join v_apex_workspace_developers awd on scm2.assignee = awd.user_name
      $else 
        select 
          null object_name,
          null email,
          null folder_name,
          null lock_rank
        from dual
      $end
      ;

  type r_aa is record (
    object_name       varchar2(256),
    email             varchar2(240),
    folder_name       varchar2(256),
    lock_rank         number
  );
  type t_aa is table of r_aa index by pls_integer;
  l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START');
    open cur_aa;

    loop
      fetch cur_aa bulk collect into l_aat limit 1000;

      exit when l_aat.count = 0;

      for rec in 1 .. l_aat.count
      loop
        pipe row (v_svt_scm_object_assignee_ot (
                      l_aat (rec).object_name,
                      l_aat (rec).email,
                      l_aat (rec).folder_name,
                      l_aat (rec).lock_rank
                    )
                );
      end loop;
    end loop;  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end v_svt_scm_object_assignee;

  function v_loki_object_assignee
  return v_svt_scm_object_assignee_nt pipelined
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_loki_object_assignee';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  cursor cur_aa
  is
      $if oracle_apex_version.c_loki_access
      $then 
        with loki as (select ll.object_type, 
                     ll.object_name, 
                     ll.locked, 
                     lsc.schema_name,
                     lu.full_name,
                     lu.apex_username,
                     lu.db_username,
                     dense_rank() over (partition by ll.object_type, ll.object_name order by ll.locked desc) lock_rank
                from loki.loki_locks_log ll 
                inner join loki.loki_schemas lsc on ll.schema_id = lsc.schema_id
                inner join loki.loki_users lu on ll.user_id = lu.user_id)
          select 
                object_name, 
                apex_username email,
                object_type folder_name,
                lock_rank
          from loki
      $else 
        select 
          null object_name,
          null email,
          null folder_name,
          null lock_rank
        from dual
      $end
      ;

  type r_aa is record (
    object_name       varchar2(256),
    email             varchar2(240),
    folder_name       varchar2(256),
    lock_rank         number
  );
  type t_aa is table of r_aa index by pls_integer;
  l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START');
    open cur_aa;

    loop
      fetch cur_aa bulk collect into l_aat limit 1000;

      exit when l_aat.count = 0;

      for rec in 1 .. l_aat.count
      loop
        pipe row (v_svt_scm_object_assignee_ot (
                      l_aat (rec).object_name,
                      l_aat (rec).email,
                      l_aat (rec).folder_name,
                      l_aat (rec).lock_rank
                    )
                );
      end loop;
    end loop;  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end v_loki_object_assignee;
  
  procedure recompile_w_plscope is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'recompile_w_plscope';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    l_compile_stmt         varchar2(512);
    begin
      apex_debug.message(c_debug_template,'recompile_w_plscope');
      execute immediate q'[ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL, STATEMENTS:ALL']';

      for rec in (select distinct 
                    case when upos.type = 'PACKAGE BODY'
                         then 'PACKAGE'
                         when upos.type = 'TYPE BODY'
                         then 'TYPE'
                         else upos.type
                         end object_type, 
                    upos.name object_name,
                    upos.owner
                    from v_user_plsql_object_settings upos 
                    inner join v_user_objects uo on uo.object_name = upos.name 
                    -- left outer join v$locked_object vlo on uo.object_id = vlo.object_id
                    where (upos.plscope_settings != 'IDENTIFIERS:ALL, STATEMENTS:ALL' or plscope_settings is null)
                    and upos.name not like 'BIN$%'
                    and upos.name not like 'XXX%'
                    -- and name not in ('EBA_STDS_DATA', 'SCH_ESI_LISTEN_QUEUES')
                    and upos.type  = 'PACKAGE BODY'
                    -- and vlo.object_id is null --eliminate locked objects
                    order by 1, 2
                  )
      loop
        begin <<recompltn>>
          l_compile_stmt := apex_string.format(p_message => 'ALTER %0 %1.%2 COMPILE',
                                               p0 => dbms_assert.simple_sql_name(rec.object_type),
                                               p1 => rec.owner,
                                               p2 => dbms_assert.noop(rec.object_name)
                                              );
          apex_debug.message(c_debug_template, 'l_compile_stmt', l_compile_stmt);
          execute immediate l_compile_stmt;
        exception 
          when e_deadlock then
            apex_debug.warn(c_debug_template,'Deadlock waiting for resource:', l_compile_stmt);
          when e_compilation_error then
            apex_debug.warn(c_debug_template,'Compilation error for:', l_compile_stmt);
          when e_dependent_error then
            apex_debug.warn(c_debug_template,'Dependent error for:', l_compile_stmt);
          when e_object_not_exist then
            apex_debug.warn(c_debug_template,'object does not exist', l_compile_stmt);
          when e_timeout then
            apex_debug.warn(c_debug_template,'timeout occurred', l_compile_stmt);
        end recompltn;
      end loop;

    exception 
      when e_deadlock then
        apex_debug.error(p_message => c_debug_template, p0 =>'Deadlock waiting for resource in recompile_w_plscope', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end recompile_w_plscope;

    procedure recompile_all_schemas_w_plscope
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'recompile_all_schemas_w_plscope';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START');
      for rec in (
        select column_value review_schema
        from table(
              apex_string.split(
                svt_preferences.get('SVT_REVIEW_SCHEMAS'), ':'
                )
              )
      )
      loop

        svt_ctx_util.set_review_schema(p_schema => rec.review_schema);
        recompile_w_plscope;

      end loop;
  
    exception 
      when e_insufficient_privs then
        apex_debug.error(p_message => c_debug_template, p0 =>'Insufficient privileges', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end recompile_all_schemas_w_plscope;

    procedure set_workspace (p_workspace in apex_workspaces.workspace%type default null)
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'set_workspace';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_workspace constant apex_workspaces.workspace%type := case when p_workspace is not null 
                                                                then upper(p_workspace)
                                                                else svt_preferences.get('SVT_WORKSPACE')
                                                                end;
    begin
      apex_debug.message(c_debug_template,'START');

      apex_util.set_workspace(c_workspace);
      
    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end set_workspace;

    procedure assign_violations
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'assign_violations';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START');
      
      -- svt_plsql_apex_audit_api.assign_from_scm;

      svt_plsql_apex_audit_api.assign_from_apex_audit;

      svt_plsql_apex_audit_api.assign_from_apex_parent_audit;

      $if oracle_apex_version.c_loki_access $then
        svt_plsql_apex_audit_api.assign_from_loki;
      $end

      svt_plsql_apex_audit_api.assign_from_default;

    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end assign_violations;

    procedure record_daily_issue_snapshot(p_application_id in svt_plsql_apex_audit.application_id%type default null,
                                          p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                                          p_test_code      in eba_stds_standard_tests.test_code%type default null,
                                          p_standard_id    in eba_stds_standard_tests.standard_id%type default null,
                                          p_schema         in all_users.username%type default null,
                                          p_issue_category in svt_plsql_apex_audit.issue_category%type default null,
                                          p_message        out nocopy varchar2
                                         )
     is
     c_scope constant varchar2(128) := gc_scope_prefix || 'record_daily_issue_snapshot'; 
     c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
     c_apex constant svt_plsql_apex_audit.issue_category%type := 'APEX';
     l_message varchar2(500);
     begin
        apex_debug.message(c_debug_template,'START',
                                            'p_application_id', p_application_id,
                                            'p_page_id', p_page_id,
                                            'p_test_code', p_test_code,
                                            'p_standard_id', p_standard_id,
                                            'p_issue_category', p_issue_category
                                            );
        set_workspace;

        <<nonapex>>
        declare
        l_na_test_count pls_integer := 0;
        begin 
          apex_debug.message(c_debug_template, '1. Non-APEX Tests');
          for rec in (
            select column_value review_schema
            from table(
                  apex_string.split(
                    svt_preferences.get('SVT_REVIEW_SCHEMAS'), ':'
                    )
                  )
            where column_value = p_schema or  p_schema is null
          )
          loop
            apex_debug.message(c_debug_template, 'rec.review_schema', rec.review_schema);
            svt_ctx_util.set_review_schema(p_schema => rec.review_schema);

            for ic_rec in (select issue_category, test_code
                            from v_eba_stds_standard_tests
                            where issue_category != c_apex
                            and (issue_category = p_issue_category or p_issue_category is null)
                            and (test_code = p_test_code or p_test_code is null)
                            and (standard_id = p_standard_id or p_standard_id is null)
                            and active_yn = gc_y
                            and standard_active_yn  = gc_y
                            order by test_code)
            loop
              <<tstlp>>
              declare 
                t1 timestamp; 
                t2 timestamp; 
              begin 
                t1 := systimestamp; 
                apex_debug.message(c_debug_template, 'Start: '||t1, ic_rec.test_code);
                svt_plsql_apex_audit_api.merge_audit_tbl (
                                p_application_id => p_application_id,
                                p_page_id        => p_page_id,
                                p_test_code      => ic_rec.test_code,
                                p_issue_category => coalesce(p_issue_category, ic_rec.issue_category)
                                );
                t2 := systimestamp; 
                apex_debug.message(c_debug_template, 'End: '||t2, ic_rec.test_code);
                svt_test_timing_api.insert_timing(ic_rec.test_code, extract( second from (t2-t1) ));
                l_na_test_count := l_na_test_count + 1;
              end tstlp; 
            end loop;
          end loop;
          l_message := 'Ran '||l_na_test_count||' non-APEX tests.';
        end nonapex;

        <<apex_issues>>
        declare
        l_apx_test_count pls_integer := 0;
        begin 
          apex_debug.message(c_debug_template, '2. APEX Tests');
          for apx_rec in (select issue_category, test_code
                          from v_eba_stds_standard_tests
                          where issue_category = c_apex
                          and (issue_category = p_issue_category or p_issue_category is null)
                          and (test_code = p_test_code or p_test_code is null)
                          and (standard_id = p_standard_id or p_standard_id is null)
                          and active_yn = gc_y
                          and standard_active_yn  = gc_y
                          order by test_code)
          loop
            <<apxtstlp>>
            declare 
              t1 timestamp; 
              t2 timestamp; 
            begin 
              t1 := systimestamp; 
              apex_debug.message(c_debug_template, 'Start: '||t1, apx_rec.test_code);
              svt_plsql_apex_audit_api.merge_audit_tbl ( 
                                p_application_id => p_application_id,
                                p_page_id        => p_page_id,
                                p_test_code      => apx_rec.test_code,
                                p_issue_category => coalesce(p_issue_category, c_apex)
                              );
              t2 := systimestamp; 
              apex_debug.message(c_debug_template, 'End: '||t2, apx_rec.test_code);
              svt_test_timing_api.insert_timing(apx_rec.test_code, extract( second from (t2-t1) ));
              l_apx_test_count := l_apx_test_count + 1;
            end apxtstlp; 
          end loop;
          l_message := l_message || ' Ran '||l_apx_test_count||' APEX tests.';
        end apex_issues;


        assign_violations;

        p_message := l_message;

    exception 
      when e_deadlock then
        apex_debug.error(p_message => c_debug_template, p0 =>'Deadlock waiting for resource in record_daily_issue_snapshot', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
      when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end record_daily_issue_snapshot;

    procedure initialize_standard(p_test_code  in eba_stds_standard_tests.test_code%type)
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'initialize_standard';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

      svt_plsql_apex_audit_api.merge_audit_tbl ( 
                        p_test_code  => p_test_code,
                        p_legacy_yn  => gc_y
                      );
      
      svt_audit_util.assign_violations;

    exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end initialize_standard;

end SVT_AUDIT_UTIL;
/

--rollback drop package SVT_AUDIT_UTIL;
