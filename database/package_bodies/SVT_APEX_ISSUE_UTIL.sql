--liquibase formatted sql
--changeset package_body_script:SVT_APEX_ISSUE_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package body SVT_APEX_ISSUE_UTIL as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_apex_issue_util
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Sep-28 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix      constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_false_positive_id constant svt_audit_actions.id%type := 2;
  gc_title_max         constant number := 250; --limit is 255
  

  -- https://docs.oracle.com/en/database/oracle/application-express/21.2/aeapi/SUBMIT_FEEDBACK_FOLLOWUP-Procedure.html#GUID-C6F4E4A8-7E40-498F-8E8F-7D99D98527B0

$if oracle_apex_version.c_apex_issue_access $then
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 3, 2022
-- Synopsis:
--
-- Private function to return security group id
--
------------------------------------------------------------------------------
  function get_security_group_id return apex_issues.workspace_id%type
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_security_group_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  l_security_groupd_id apex_issues.workspace_id%type;
  begin
     apex_debug.message(c_debug_template,'START');

    select workspace_id
    into l_security_groupd_id
    from apex_workspaces
    where workspace = svt_preferences.get('SVT_WORKSPACE');

    apex_debug.message(c_debug_template, 'l_security_groupd_id', l_security_groupd_id);

    return l_security_groupd_id;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_security_group_id;

  procedure create_issue (p_id             out apex_issues.issue_id%type, 
                          p_title          in  varchar2, 
                          p_issue_text     in  apex_issues.issue_text%type, 
                          p_application_id in  apex_issues.related_application_id%type, 
                          p_page_id        in  apex_issues.related_page_id%type,
                          p_audit_id       in  svt_plsql_apex_audit.id%type
                        )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'create_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_security_groupd_id constant apex_issues.workspace_id%type := get_security_group_id;
  c_title              constant apex_issues.issue_title%type := substr(p_title, 1, gc_title_max); 
  begin
    apex_debug.message(c_debug_template,'START',
                                        'p_audit_id', p_audit_id,
                                        'p_title', p_title,
                                        'p_issue_text', p_issue_text,
                                        'p_application_id', p_application_id,
                                        'p_page_id', p_page_id
                      );

    if v('APP_ID') is null then
      apex_debug.message(c_debug_template, 'setting security group');
      apex_util.set_security_group_id( c_security_groupd_id );
    else 
      apex_debug.message(c_debug_template, 'apex session is active');
    end if;

    insert into svt_flow_issues
    (
    --  security_group_id,
     title, 
     slug,  
     issue_text, 
     application_id, 
     page_id
    ) 
    values (
      -- c_security_groupd_id,
      c_title,
      $if oracle_apex_version.version >= 21
      $then
      apex_string_util.get_slug(c_title),
      $else 
      apex_string_util.to_slug(c_title),
      $end
      p_issue_text,
      p_application_id,
      p_page_id
    ) return id into p_id;
    apex_debug.message(c_debug_template, 'p_id', p_id);

  exception 
    when dup_val_on_index then
      p_id := null;
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'dup_val_on_indexn', 
                       p1 => sqlerrm, 
                       p2 => c_title,
                       p3 => p_application_id,
                       p4 => p_audit_id,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
    when others then
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'Unhandled Exception', 
                       p1 => sqlerrm, 
                       p2 => c_title,
                       p3 => p_application_id,
                       p4 => p_audit_id,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
      raise;  
  end create_issue;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 3, 2022
-- Synopsis:
--
-- Private procedure to update an apex issue 
--
------------------------------------------------------------------------------
  procedure update_issue (p_id             in  apex_issues.issue_id%type, 
                          p_title          in  varchar2, 
                          p_issue_text     in  apex_issues.issue_text%type, 
                          p_application_id in  apex_issues.related_application_id%type, 
                          p_page_id        in  apex_issues.related_page_id%type,
                          p_title_suffix   in  svt_plsql_apex_audit.apex_issue_title_suffix%type
                        )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12';
  c_title constant apex_issues.issue_title%type := substr(p_title, 1, gc_title_max); 
  begin
    apex_debug.enable(p_level => apex_debug.c_log_level_info); --temporary
    apex_debug.message(c_debug_template,'START',
                                        'p_id', p_id,
                                        'p_title', p_title,
                                        'p_application_id', p_application_id,
                                        'p_page_id', p_page_id,
                                        'p_title_suffix', p_title_suffix,
                                        'p_issue_text', p_issue_text
                      );

    update svt_flow_issues
    set title = c_title||p_title_suffix,
        slug  = apex_string_util.get_slug(c_title||p_title_suffix),
        issue_text = p_issue_text,
        application_id = p_application_id, 
        page_id = p_page_id
    where id = p_id;

    apex_debug.message(c_debug_template, 'udpate apex_issues :', sql%rowcount);

  exception 
    when dup_val_on_index then
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'dup_val_on_index', 
                       p1 => sqlerrm, 
                       p2 => p_id,
                       p3 => c_title,
                       p4 => p_title_suffix,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
      -- drop_issue (p_id => p_id);
      raise_application_error(-20126, 'Duplicate issue title:'||p_title||' '||p_title_suffix);
    when others then 
      apex_debug.error(p_message => c_debug_template, 
                       p0 =>'Unhandled Exception', 
                       p1 => sqlerrm, 
                       p2 => p_id,
                       p3 => c_title,
                       p4 => p_title_suffix,
                       p5 => sqlcode, 
                       p6 => dbms_utility.format_error_stack, 
                       p7 => dbms_utility.format_error_backtrace, 
                       p_max_length => 4096);
      raise;
  end update_issue;

  procedure drop_issue (p_id in  apex_issues.issue_id%type)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'drop_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START',
                                        'p_id', p_id
                      );
    delete from svt_flow_issues
    where id = p_id;

    apex_debug.message(c_debug_template, 'deleted from apex_issues :', sql%rowcount);

    svt_plsql_apex_audit_api.null_out_apex_issue (p_audit_id  => p_id);
    apex_debug.message(c_debug_template, 'updated svt_plsql_apex_audit :', sql%rowcount);

  exception when others then 
    apex_debug.error(p_message => c_debug_template, 
                     p0 =>'Unhandled Exception', 
                     p1 => sqlerrm, 
                     p2 => 'p_id',
                     p3 => p_id,
                     p5 => sqlcode, 
                     p6 => dbms_utility.format_error_stack, 
                     p7 => dbms_utility.format_error_backtrace, 
                     p_max_length => 4096);
    raise;
  end drop_issue;

  procedure drop_irrelevant_issues (p_message out nocopy varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'drop_irrelevant_issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_security_groupd_id constant apex_issues.workspace_id%type := get_security_group_id;
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START');

    if v('APP_ID') is null then
      apex_debug.message(c_debug_template, 'setting security group');
      apex_util.set_security_group_id( c_security_groupd_id );
    else 
      apex_debug.message(c_debug_template, 'apex session active');
    end if;

    delete from svt_flow_issues
    -- where title like '[SVT]%'
    where title like '[%'
    and id not in (select apex_issue_id
                   from svt_plsql_apex_audit
                   where apex_issue_id is not null);
    apex_debug.message(c_debug_template, 'deleted expired issues in svt_flow_issues:', sql%rowcount);

    delete from svt_flow_issues
    -- where title like '[SVT]%'
    where title like '[%'
    and id in (select apex_issue_id
               from svt_plsql_apex_audit
               where action_id = gc_false_positive_id);
    apex_debug.message(c_debug_template, 'deleted valid exceptions in svt_flow_issues:', sql%rowcount);

    p_message := l_message;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end drop_irrelevant_issues;

  procedure merge_from_audit_tbl(p_issue_category in svt_plsql_apex_audit.issue_category%type default null,
                                 p_application_id in svt_plsql_apex_audit.application_id%type default null,
                                 p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                                 p_audit_id       in svt_plsql_apex_audit.id%type default null,
                                 p_test_code      in svt_stds_standard_tests.test_code%type default null,
                                 p_message        out nocopy varchar2
                                )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'merge_from_audit_tbl';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_limit    constant pls_integer := 100;
  c_apex     constant varchar2(4) := 'APEX';
  cursor cur_issues
    is
    select audit_id, application_id, page_id, issue_title, issue_text, unqid, apex_issue_id, apex_issue_title_suffix
      from v_svt_plsql_apex_audit
      where application_id != 0
      and issue_category in (c_apex,'SERT')
      and (issue_category = upper(p_issue_category) or p_issue_category is null)
      and (application_id = upper(p_application_id) or p_application_id is null)
      and (page_id = upper(p_page_id) or p_page_id is null)
      and (audit_id = upper(p_audit_id) or p_audit_id is null)
      and (test_code = upper(p_test_code) or p_test_code is null)
      and page_id is not null
      and issue_title is not null
      and issue_text is not null
      order by audit_id
      ;

  type r_issues is record (
    audit_id           svt_plsql_apex_audit.id%type, 
    application_id     svt_plsql_apex_audit.application_id%type, 
    page_id            svt_plsql_apex_audit.page_id%type, 
    issue_title        svt_plsql_apex_audit.issue_title%type, 
    issue_text         svt_plsql_apex_audit.validation_failure_message%type,
    unqid              svt_plsql_apex_audit.unqid%type,
    apex_issue_id      svt_plsql_apex_audit.apex_issue_id%type,
    issue_title_suffix svt_plsql_apex_audit.apex_issue_title_suffix%type
  );
  type t_issue_rec is table of r_issues; 
  l_issues_t   t_issue_rec;
  l_issue_id    apex_issues.issue_id%type;
  l_issue_title_suffix svt_plsql_apex_audit.apex_issue_title_suffix%type := null;
  l_counter pls_integer := 2;
  l_inserted_count pls_integer := 0;
  l_updated_count  pls_integer := 0;
  begin
    apex_debug.message(c_debug_template,'START',
                                          'p_issue_category',p_issue_category,
                                          'p_application_id', p_application_id,
                                          'p_page_id', p_page_id,
                                          'p_audit_id', p_audit_id,
                                          'p_test_code', p_test_code
                                          );
    if v('APP_ID') is null then
      apex_debug.message(c_debug_template, 'creating apex session');
      apex_session.create_session(p_app_id=>svt_apex_view.gc_svt_app_id,p_page_id=>1,p_username=>'HAYHUDSO');   
      apex_debug.enable(p_level => apex_debug.c_log_level_engine_trace);
    else
      apex_debug.message(c_debug_template, 'apex session already active');
    end if;

    open cur_issues;

        loop
            fetch cur_issues
            bulk collect into l_issues_t
            limit c_limit;

            for i in 1..l_issues_t.count
            loop
              case when l_issues_t(i).apex_issue_id is null 
                   then 
                        begin <<insert_section>>
                        
                          apex_debug.message(c_debug_template, 'unqid', l_issues_t(i).unqid);
                          create_issue (p_id             => l_issue_id,
                                        p_title          => l_issues_t(i).issue_title,
                                        p_issue_text     => l_issues_t(i).issue_text,
                                        p_application_id => l_issues_t(i).application_id,
                                        p_page_id        => l_issues_t(i).page_id,
                                        p_audit_id       => l_issues_t(i).audit_id
                                      );
                          apex_debug.message(c_debug_template, 'l_issue_id', l_issue_id);
                          if l_issue_id is null then 
                            l_counter := 2;
                            while l_issue_id is null
                            loop
                              apex_debug.message(c_debug_template, 'l_counter', l_counter);
                              l_issue_title_suffix := ' #'||l_counter;
                              create_issue (
                                        p_id             => l_issue_id,
                                        p_title          => l_issues_t(i).issue_title||l_issue_title_suffix,
                                        p_issue_text     => l_issues_t(i).issue_text,
                                        p_application_id => l_issues_t(i).application_id,
                                        p_page_id        => l_issues_t(i).page_id,
                                        p_audit_id       => l_issues_t(i).audit_id
                                      );
                              l_counter := l_counter+ 1;
                              exit when l_counter > 15;
                            end loop;
                          apex_debug.message(c_debug_template, 'l_issue_title_suffix', l_issue_title_suffix);
                          apex_debug.message(c_debug_template, 'l_issue_id after loop', l_issue_id);
                          end if;

                          if l_issue_id is not null then
                            update svt_plsql_apex_audit
                            set apex_issue_id = l_issue_id,
                                apex_issue_title_suffix = l_issue_title_suffix
                            where id = l_issues_t(i).audit_id;
                          end if;

                          l_inserted_count := l_inserted_count + 1;
                        exception when others then
                          apex_debug.error(p_message => c_debug_template, p0 =>'Duplicate value!', p1 => sqlerrm, p2=> l_issues_t(i).issue_title, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
                          raise;
                        end insert_section;
                   else 
                      begin <<svt_upd>>
                        update_issue (
                            p_id             => l_issues_t(i).apex_issue_id,
                            p_title          => l_issues_t(i).issue_title,
                            p_issue_text     => l_issues_t(i).issue_text,
                            p_application_id => l_issues_t(i).application_id,
                            p_page_id        => l_issues_t(i).page_id,
                            p_title_suffix   => l_issues_t(i).issue_title_suffix
                          );
                      exception when dup_val_on_index then
                        l_issue_title_suffix := null;
                        update svt_plsql_apex_audit
                        set apex_issue_title_suffix = ' #'||to_number(
                                                              to_number(replace(apex_issue_title_suffix,' #')
                                                                        ) + 10)
                        where id = l_issues_t(i).audit_id
                        returning apex_issue_title_suffix into l_issue_title_suffix;
                        apex_debug.message(c_debug_template, 'l_issue_title_suffix',l_issue_title_suffix);

                        update_issue (
                          p_id             => l_issues_t(i).apex_issue_id,
                          p_title          => l_issues_t(i).issue_title,
                          p_issue_text     => l_issues_t(i).issue_text,
                          p_application_id => l_issues_t(i).application_id,
                          p_page_id        => l_issues_t(i).page_id,
                          p_title_suffix   => l_issue_title_suffix
                        );

                        l_updated_count := l_updated_count + 1;
                      end svt_upd;
              end case;
            end loop;

            exit when cur_issues%notfound;
        end loop;

    p_message := apex_string.format('Updated %0 issue(s) and created %1 new issues',
                  p0 => l_updated_count,
                  p1 => l_inserted_count
                );

  exception when others then 
    apex_debug.error(p_message => c_debug_template, 
                    p0 =>'Unhandled Exception', 
                    p1 => sqlerrm, 
                    p2 => p_page_id,
                    p3 => p_issue_category,
                    p4 => p_application_id,
                    p5 => sqlcode, p6 => dbms_utility.format_error_stack, 
                    p7 => dbms_utility.format_error_backtrace, 
                    p_max_length => 4096);
    raise;
  end merge_from_audit_tbl;


  procedure update_audit_tbl_from_apex_issues
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_audit_tbl_from_apex_issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');

    merge into svt_plsql_apex_audit dest
      using (
        select issue_id apex_issue_id
        from apex_issues
        where issue_status = 'CLOSED'
      ) src
      on (1=1
        and dest.apex_issue_id = src.apex_issue_id
        and (dest.action_id is null or dest.action_id != gc_false_positive_id)
      )
    when matched then
      update
        set
          dest.action_id = gc_false_positive_id,
          dest.notes = 'Automatically updated from apex_issues';
    apex_debug.message(c_debug_template, 'udpated svt_plsql_apex_audit:', sql%rowcount);

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end update_audit_tbl_from_apex_issues;


  procedure drop_all_svt_issues
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'drop_all_svt_issues'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');

    delete from svt_flow_issues
    where title like '[SVT]%';
    apex_debug.message(c_debug_template, 'deleted from apex_issues:', sql%rowcount);

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end drop_all_svt_issues;

  procedure hard_correct_svt_issues 
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'hard_correct_svt_issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START');
    delete
    from svt_flow_issues
    where security_group_id = 0;

    for rec in (select paa.id audit_id
                  from svt_plsql_apex_audit paa 
                  left outer join apex_issues ai on paa.apex_issue_id = ai.issue_id
                  where paa.apex_issue_id is not null
                  -- and ai.issue_id is null
                  )
    loop 
      svt_plsql_apex_audit_api.null_out_apex_issue (p_audit_id  => rec.audit_id);
    end loop;
    
    drop_irrelevant_issues(p_message => l_message);

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end hard_correct_svt_issues;

$end
  
  procedure refresh_for_test_code (p_test_code in svt_plsql_apex_audit.test_code%type)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'refresh_for_test_code';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    svt_plsql_apex_audit_api.refresh_for_test_code (p_test_code => p_test_code);
    

    $if oracle_apex_version.c_apex_issue_access $then
    <<dii>>
    declare
    l_dii_message varchar2(500);
    begin
      svt_apex_issue_util.drop_irrelevant_issues(p_message => l_dii_message);
      l_message := l_message || l_dii_message;
      commit; -- necessary for succinctness / user friendliness (hayhudso 2023-Feb-6)
    end dii;
    $end

    svt_audit_util.assign_violations;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end refresh_for_test_code;

  procedure refresh_for_audit_id (p_audit_id in svt_plsql_apex_audit.id%type)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'refresh_for_audit_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_svt_plsql_apex_audit_rec1 constant svt_plsql_apex_audit%rowtype 
                             := svt_plsql_apex_audit_api.get_audit_record (p_audit_id);
  l_svt_plsql_apex_audit_rec2 svt_plsql_apex_audit%rowtype;
  l_apex_issue_id svt_plsql_apex_audit.apex_issue_id%type;
  c_mv_dependency constant svt_stds_standard_tests.mv_dependency%type 
                    := svt_stds.get_mv_dependency(p_test_code => c_svt_plsql_apex_audit_rec1.test_code);
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);

    if c_svt_plsql_apex_audit_rec1.id is not null then
      
      if c_mv_dependency is not null then
        svt_mv_util.refresh_mv(c_mv_dependency); --refresh the dependent materialized view
      end if;

      l_apex_issue_id := c_svt_plsql_apex_audit_rec1.apex_issue_id;
      svt_plsql_apex_audit_api.merge_audit_tbl (
                        p_test_code      => c_svt_plsql_apex_audit_rec1.test_code,
                        p_application_id => c_svt_plsql_apex_audit_rec1.application_id,
                        p_page_id        => c_svt_plsql_apex_audit_rec1.page_id,
                        p_audit_id       => p_audit_id
                    );
      
      l_svt_plsql_apex_audit_rec2 := svt_plsql_apex_audit_api.get_audit_record (p_audit_id);

      if c_svt_plsql_apex_audit_rec1.updated < l_svt_plsql_apex_audit_rec2.updated then
        apex_debug.message(c_debug_template, 'violation has not been fixed');
        $if oracle_apex_version.c_apex_issue_access $then
        <<mfat>>
        declare
        l_mfat_message varchar2(500);
        begin
          svt_apex_issue_util.merge_from_audit_tbl(p_audit_id => p_audit_id,
                                                  p_message  => l_mfat_message);
          l_message := l_message||l_mfat_message;
        end mfat;
        svt_apex_issue_util.update_audit_tbl_from_apex_issues;
        $end
      else
        -- the audit record was unaffected by the merge, so it must not longer exist
        apex_debug.message(c_debug_template, 'violation has been fixed so the issue and associated apex issue must be dropped');
        svt_plsql_apex_audit_api.delete_audit (
              p_unqid                      => l_svt_plsql_apex_audit_rec2.unqid,
              p_audit_id                   => l_svt_plsql_apex_audit_rec2.id,
              p_test_code                  => l_svt_plsql_apex_audit_rec2.test_code,
              p_validation_failure_message => l_svt_plsql_apex_audit_rec2.validation_failure_message,
              p_application_id             => l_svt_plsql_apex_audit_rec2.application_id,
              p_page_id                    => l_svt_plsql_apex_audit_rec2.page_id,
              p_component_id               => l_svt_plsql_apex_audit_rec2.component_id,
              p_assignee                   => c_svt_plsql_apex_audit_rec1.assignee,
              p_line                       => l_svt_plsql_apex_audit_rec2.line,
              p_object_name                => l_svt_plsql_apex_audit_rec2.object_name,
              p_object_type                => l_svt_plsql_apex_audit_rec2.object_type,
              p_code                       => l_svt_plsql_apex_audit_rec2.code,
              p_delete_reason              => 'REFRESH_FOR_AUDIT_ID'
            );
        $if oracle_apex_version.c_apex_issue_access $then
        drop_issue (l_apex_issue_id);
        $end
      end if;
      commit; -- necessary for succinctness (hayhudso 2023-Feb-6)

    else 
      apex_debug.error(c_debug_template, 'p_audit_id not found', p_audit_id);
      $if oracle_apex_version.c_apex_issue_access $then
      <<dii>>
      declare
      l_dii_message varchar2(500);
      begin
        svt_apex_issue_util.drop_irrelevant_issues(p_message => l_dii_message);
        l_message := l_message||l_dii_message;
      end dii;
      $end
      commit; -- necessary for succinctness (hayhudso 2023-Feb-6)
      raise_application_error(-20123,'Unknown audit_id :'||p_audit_id);
    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end refresh_for_audit_id;

  procedure manage_apex_issues (p_message out nocopy varchar2)
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'manage_apex_issues';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_message varchar2(500);
  begin
    apex_debug.message(c_debug_template,'START');
    
    check_apex_version_up2date;

    $if oracle_apex_version.c_apex_issue_access $then

    <<mfat>>
    declare 
    l_mfat_message varchar2(500);
    begin
      merge_from_audit_tbl(p_message  => l_mfat_message);
      l_message := l_message || l_mfat_message;
    end mfat;

    <<dii>>
    declare 
    l_dii_message varchar2(500);
    begin
      drop_irrelevant_issues(p_message => l_dii_message);
      l_message := l_message || l_dii_message;
    end dii;
    update_audit_tbl_from_apex_issues;
    $end

    p_message := l_message;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end manage_apex_issues;

  procedure check_apex_version_up2date 
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'check_apex_version_up2date';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 
  c_current_version constant varchar2(25) := orclapex_version;
  l_first_period integer;
  l_version   number;
  l_release   number;
  l_is_match  boolean;
  begin
    apex_debug.message(c_debug_template,'START');
    l_first_period := instr(c_current_version, '.', 1, 1);
    l_version      := to_number(substr(c_current_version, 1, l_first_period - 1));
    l_release      := to_number(substr(c_current_version, l_first_period + 1, l_first_period - 2));
    
    l_is_match := case when l_version = oracle_apex_version.version
                       then case when l_release = oracle_apex_version.release
                                 then true
                                 else false
                                 end
                       else false 
                       end;
    if l_is_match then
      apex_debug.message(c_debug_template, 'APEX Version is correct');
    else 
      raise_application_error(-20123, 
              apex_string.format('APEX version out-of-date. Version is now %0 but the version in oracle_apex_version is %1.%2',
                                 p0 => c_current_version,
                                 p1 => oracle_apex_version.version,
                                 p2 => oracle_apex_version.release
                                )
      );
    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end check_apex_version_up2date;

  procedure mark_as_exception (p_audit_id in svt_plsql_apex_audit.id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'mark_as_exception';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_svt_plsql_apex_audit_rec svt_plsql_apex_audit%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_id', p_audit_id);

    if p_audit_id is not null then

      svt_plsql_apex_audit_api.mark_as_exception (p_audit_id  => p_audit_id);
    
      $if oracle_apex_version.c_apex_issue_access $then
      l_svt_plsql_apex_audit_rec := svt_plsql_apex_audit_api.get_audit_record (p_audit_id);
      svt_apex_issue_util.drop_issue (p_id => l_svt_plsql_apex_audit_rec.apex_issue_id);
      svt_plsql_apex_audit_api.null_out_apex_issue (p_audit_id  => p_audit_id);
      $end

    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end mark_as_exception;

  procedure bulk_mark_as_exception (p_audit_ids in varchar2)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_mark_as_exception';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_audit_ids', p_audit_ids);

    for rec in (select column_value audit_id
                  from table(apex_string.split(p_audit_ids, ','))
                )
    loop
      mark_as_exception (p_audit_id => rec.audit_id);
    end loop;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end bulk_mark_as_exception;

end svt_apex_issue_util;
/

--rollback drop package SVT_APEX_ISSUE_UTIL;
