--liquibase formatted sql
--changeset package_body_script:SVT_MONITORING stripComments:false endDelimiter:/ runOnChange:true
create or replace package body SVT_MONITORING as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_MONITORING
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso   2022-Dec-16 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_fetch_rows   constant number := 1;
  gc_table_start constant varchar2(250):= 
      '<table width="600" border="5px solid black">
          <tr>
            <th align="left">%0 violations</th>
          </tr>';
  gc_table_end   constant varchar2(50) := '</table>';
  gc_apex        constant varchar2(4)  := 'APEX';
  gc_max_urgency constant number := 99;
  gc_max_title_length constant number := 100;
  gc_max_row_count constant pls_integer := 9;

  function app_url (p_application_id in apex_applications.application_id%type default null) 
  return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'app_url';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_application_id constant apex_applications.application_id%type
                   := coalesce(p_application_id, v('APP_ID'));
  begin
    apex_debug.message(c_debug_template,'START');

    return apex_string.format(
            p_message => '%0f?p=%1',
            p0 => svt_stds_parser.get_base_url(),
            p1 => c_application_id
    );

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end app_url;

  function db_unique_name return varchar2
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'db_unique_name';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');

    return ora_database_name;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end db_unique_name;

  function unassigned_src_html 
    (p_test_code  in svt_stds_standard_tests.test_code%type,
     p_days_since in number default 1,
     p_fetch_rows in number default null
    ) return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'unassigned_src_html';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_limit     constant pls_integer := 110;
  c_fetch_rows constant number :=coalesce(p_fetch_rows, gc_fetch_rows);

  cursor cur_SVT (p_test_code varchar2) is 
  select  case when length(pad.issue_title) > gc_max_title_length 
               then substr(pad.issue_title, 1,gc_max_title_length)||'...'
               else pad.issue_title
               end issue_title, 
         pad.audit_id
  from v_svt_plsql_apex_audit pad
  where pad.test_code = p_test_code
  and created > 
      case when to_char(sysdate, 'fmdy') not in ('mon')
          then sysdate - p_days_since
          else sysdate - (p_days_since + 2)
          end
  and pad.assignee is null
  and pad.recent_yn = 'Y'
  order by urgency_level, audit_id
  fetch first c_fetch_rows rows only;

  type r_issues is record (
    issue_title svt_plsql_apex_audit.issue_title%type,
    audit_id    svt_plsql_apex_audit.id%type
  ); 

  type t_issue_rec is table of r_issues; 
  l_issues_t   t_issue_rec;

    ------------------------------------------------------------------------------
    -- nested function to add html rows
    ------------------------------------------------------------------------------
    function html_rows(p_test_code in svt_stds_standard_tests.test_code%type) 
    return varchar2
    is 
    l_row_count pls_integer := 0;
    l_row_html varchar2(4000);
    begin

      open cur_SVT (p_test_code);
      loop
        fetch cur_SVT
        bulk collect into l_issues_t
        limit c_limit;

        for i in 1..l_issues_t.count
        loop
          l_row_count := l_row_count + 1;
          l_row_html := l_row_html ||
          apex_string.format(
            p_message => 
            '<tr>
              <td>• %0 [Audit id : %1]</td>
            </tr>',
            p0 => l_issues_t(i).issue_title,
            p1 => l_issues_t(i).audit_id
          );
        end loop;
        exit when cur_SVT%notfound;
      end loop;

      return 
        case when l_row_count > 0
             then l_row_html 
             end;

    end html_rows;

  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    return html_rows(p_test_code);

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end unassigned_src_html;

  function get_db_name return varchar2
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_db_name'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');

    return case 
           when svt_preferences.get(p_preference_name => 'SVT_DB_NAME') is not null 
           then svt_preferences.get(p_preference_name => 'SVT_DB_NAME')
           else 'Unspecified DB Name'
           end;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_db_name;

  ------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 11, 2023
-- Synopsis:
--
-- Private procedure to get email html 
--
------------------------------------------------------------------------------
  procedure get_email_html (
    p_unassigned_html in varchar2,
    p_assigned_html   in varchar2,
    p_days_since      in number,
    p_application_id  in apex_applications.application_id%type default null,
    p_subject         out nocopy varchar2,
    p_html            out nocopy clob,
    p_text            out nocopy clob
  )
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_email_html';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_html        clob;
  l_subscriber_list varchar2(4000);
  c_application_id  constant apex_applications.application_id%type :=
                    coalesce(p_application_id, v('APP_ID'));
  begin
    apex_debug.message(c_debug_template,'START');

    begin <<subs_lst>>
      select listagg(user_name, ', ') within group (order by user_name) mylist
      into l_subscriber_list
      from v_svt_email_subscriptions;
    exception when no_data_found then
      apex_debug.error(p_message => c_debug_template, p0 =>'No subscribers!', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end subs_lst;

    apex_mail.prepare_template (
      p_static_id         => 'STANDARD_VIOLATION_DAILY_ALERT',
      p_placeholders      => 
      apex_string.format(
        p_message => q'~
          {
              "ENVIRONMENT" : "%0",
              "DAY_COUNT": "%1",
              "REPORT_LINK": "%2",
              "WORKSPACE_LINK": "%3",
              "MAX_URGENCY" : "%4",
              "SUBSCRIBER_LIST" :"%5",
              "DBNAME" : "%6"
          }~',
        p0 => get_db_name(),
        p1 => p_days_since,
        p2 => app_url(),
        p3 => svt_stds_parser.get_base_url(),
        p4 => gc_max_urgency,
        p5 => 'This email is subscribed to by : '||l_subscriber_list,
        p6 => db_unique_name
      ),
      p_application_id    => c_application_id, 
      p_subject           => p_subject,
      p_html              => l_html,
      p_text              => p_text
    );
    l_html := replace(l_html, 'UNASSIGNED_REPORT_HTML', p_unassigned_html); 
    l_html := replace(l_html, 'ASSIGNED_REPORT_HTML', p_assigned_html); 
    p_html := l_html;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_email_html;


  function unassigned_html_by_src (p_days_since in number) return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'unassigned_html_by_src';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_unassigned_report_html clob;
  l_row_count pls_integer := 0;
  begin
    apex_debug.message(c_debug_template,'START', 'p_days_since', p_days_since);

    for rec in (select src.test_code
                from v_svt_stds_standard_tests src
                where src.urgency_level <= gc_max_urgency
                order by src.urgency_level, src.test_code
                -- fetch first gc_max_row_count rows only
                )
    loop
      l_row_count := 1 + l_row_count;
      exit when l_row_count > gc_max_row_count;
      l_unassigned_report_html := l_unassigned_report_html||
                                   unassigned_src_html (
                                            p_test_code => rec.test_code,
                                            p_days_since    => p_days_since);
    end loop;     

    return case when l_unassigned_report_html is not null 
                then apex_string.format(gc_table_start, 'Unassigned')||l_unassigned_report_html||gc_table_end
                end;

  exception when others then 
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end unassigned_html_by_src;

  procedure assigned_html (
        p_days_since           in number,
        p_assigned_report_html out nocopy clob,
        p_list_of_assignees    out nocopy varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assigned_html';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  l_assigned_report_html clob;
  type t_aa_email is table of integer index by varchar2(101);
  l_aa_emails  t_aa_email;
  l_list_of_assignees varchar2(4000);
  l_email varchar2(101);
  l_row_count pls_integer := 0;
  begin
    apex_debug.message(c_debug_template,'START', 'p_days_since', p_days_since);

    for rec in (
      select case when length(pad.issue_title) > gc_max_title_length 
                  then substr(pad.issue_title, 1,gc_max_title_length)||'...'
                  else pad.issue_title
                  end issue_title, 
         pad.audit_id,
         pad.assignee,
         pad.test_code,
         dense_rank() over ( partition by assignee, test_code order by audit_id desc) print_rank
      from v_svt_plsql_apex_audit pad
      where coalesce(apex_created_on, created) > 
              case when to_char(sysdate, 'fmdy') not in ('mon')
                  then sysdate - p_days_since
                  else sysdate - (p_days_since + 2)
                  end
      and assignee is not null
      and recent_yn = 'Y'
      and urgency_level <= gc_max_urgency
      order by urgency_level, audit_id
    ) loop

      l_row_count := case when rec.print_rank <= gc_fetch_rows
                          then 1 + l_row_count
                          else l_row_count
                          end;
      exit when l_row_count > gc_max_row_count;
      -- dbms_output.put_line('l_row_count :'||l_row_count);
      l_aa_emails(rec.assignee) := rec.audit_id;
      l_assigned_report_html := l_assigned_report_html || 
                                case when rec.print_rank <= gc_fetch_rows
                                     then apex_string.format(
                                          p_message => 
                                          '<tr>
                                            <td>• %0 [Assigned to : %2] [Audit id : %1]</td>
                                          </tr>',
                                          p0 => rec.issue_title,
                                          p1 => rec.audit_id,
                                          p2 => rec.assignee,
                                          p3 => l_row_count
                                        )
                                      end;
    end loop;

    p_assigned_report_html := 
    case when l_assigned_report_html is not null 
         then apex_string.format(gc_table_start, 'Assigned')||l_assigned_report_html||gc_table_end
         end;

    if l_aa_emails.count > 1
    then
      l_email := l_aa_emails.first;
      loop
        exit when l_email is null;
        l_list_of_assignees := l_list_of_assignees||':'||l_email;
        l_email := l_aa_emails.next(l_email);
      end loop;
    else 
      l_list_of_assignees := l_aa_emails.first;
    end if;

    p_list_of_assignees := l_list_of_assignees;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assigned_html;

  procedure send_email (
              p_to        in varchar2,
              p_from      in varchar2,
              p_subj      in varchar2,
              p_body      in clob,
              p_body_html in clob
  )
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'send_email';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_to', p_to,
                                        'p_from', p_from,
                                        'p_subj', p_subj
                                        );

    $if oracle_apex_version.c_email_na
    $then
      raise_application_error(-20123, 'No email api configured!'); 
    $end

    $if oracle_apex_version.c_email_afw 
    $then 
      afw_messaging.send (
                p_to           => p_to,
                p_from         => p_from,
                p_subj         => p_subj,
                p_body         => p_body,
                p_body_html    => p_body_html,
                p_message_guid => null
              );
    $end
    
    if svt_preferences.get('SVT_EMAIL_API') = gc_apex then
      <<apx_ml>>
      declare 
      l_id number;
      begin
        l_id   := apex_mail.send(
          p_to        => p_to,
          p_from      => p_from,
          p_body      => p_body,
          p_body_html => p_body_html,
          p_subj      => p_subj);
      end apx_ml;
    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end send_email;

  procedure push_email
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'push_email';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    
    $if oracle_apex_version.c_email_na
    $then
      raise_application_error(-20123, 'No email api configured!'); 
    $end

    $if oracle_apex_version.c_email_afw 
    $then 
      afw_messaging.push (p_type => 'EMAIL');
    $end
    
    if svt_preferences.get('SVT_EMAIL_API') = gc_apex then
      apex_mail.push_queue;
    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end push_email;

  procedure send_update(p_days_since  in number default 1,
                        p_override_email in varchar2 default null,
                        p_application_id in apex_applications.application_id%type default null)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'send_update';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_from_email constant varchar2(50) := svt_preferences.get('SVT_FROM_EMAIL');
  l_subject     varchar2(4000);
  l_html        clob;
  l_text        clob;
  l_unassigned_report_html clob;
  l_assigned_report_html   clob;
  l_assignees              varchar2(4000);
  c_application_id constant  apex_applications.application_id%type 
                  := coalesce(p_application_id, v('APP_ID'));
  begin
    apex_debug.message(c_debug_template,'START',
                                        'p_days_since', p_days_since,
                                        'p_override_email', p_override_email);

    l_unassigned_report_html := unassigned_html_by_src (p_days_since  => p_days_since);

    assigned_html (
        p_days_since           => p_days_since,
        p_assigned_report_html => l_assigned_report_html,
        p_list_of_assignees    => l_assignees);

    case when l_unassigned_report_html||l_assigned_report_html is not null
         then 
          get_email_html (
            p_unassigned_html => l_unassigned_report_html,
            p_assigned_html   => l_assigned_report_html,
            p_days_since      => p_days_since, 
            p_subject         => l_subject,
            p_html            => l_html,
            p_text            => l_text,
            p_application_id  => p_application_id
          );

          for rec in (
                select distinct coalesce(p_override_email, email) email
                from v_svt_email_subscriptions
                union
                select coalesce(p_override_email, column_value) email
                from table(apex_string.split(l_assignees, ':'))
                where column_value is not null
              )
          loop
            apex_debug.warn(c_debug_template, 'rec.email', rec.email);
            send_email (
              p_to           => rec.email,
              p_from         => c_from_email,
              p_subj         => l_subject,
              p_body         => l_text,
              p_body_html    => l_html
            );
          end loop;
          svt_monitoring.push_email;
        else 
          apex_debug.message(c_debug_template, 'No standard violations found', p_days_since);
    end case; 

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end send_update;

  procedure enable_automations (p_application_id in apex_applications.application_id%type default null)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'enable_automations';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_disabled constant apex_appl_automations.polling_status_code%type := 'DISABLED';
  c_application_id constant apex_applications.application_id%type 
                   := coalesce(p_application_id, v('APP_ID'));
  begin
    apex_debug.message(c_debug_template,'START');

    for rec in (select application_id, static_id
                from apex_appl_automations
                where polling_status_code = c_disabled
                and application_id = c_application_id)
    loop
      apex_automation.enable(
          p_application_id  => rec.application_id,
          p_static_id       => rec.static_id );
    end loop;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end enable_automations;


end SVT_MONITORING;
/

--rollback drop package SVT_MONITORING;
