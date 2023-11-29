  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_APEX_APPLICATIONS" ("APPLICATION_ID", "APPLICATION_NAME", "APPLICATION_GROUP", "AVAILABILITY_STATUS", "AUTHORIZATION_SCHEME", "CREATED_BY", "CREATED_ON", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "WORKSPACE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select application_id, 
       application_name, 
       application_group, 
       availability_status, 
       authorization_scheme, 
       created_by, 
       created_on, 
       last_updated_by, 
       last_updated_on,
       workspace
from svt_apex_view.apex_applications(p_user => case when sys_context('userenv', 'current_user') = svt_preferences.get('SVT_DEFAULT_SCHEMA')
                                                    then svt_ctx_util.get_default_user
                                                    else sys_context('userenv', 'current_user')
                                                    end);

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_ALL_STANDARDS_EXPORT" ("ALL_TESTS_FILE_SIZE", "STD_FILE_SIZE", "ALL_TESTS_FILE_BLOB", "STD_FILE_BLOB", "MIME_TYPE", "STD_FILE_NAME", "ALL_TESTS_FILE_NAME", "CHARACTER_SET") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with jcb as (select 'application/json' mime_type,
                    'UTF-8' character_set,
                    svt_deployment.json_content_blob (p_table_name => 'V_SVT_STDS_STANDARD_TESTS_EXPORT') all_tests_file_blob,
                    svt_deployment.json_content_blob (p_table_name => 'SVT_STDS_STANDARDS') std_file_blob
            from dual)
select sys.dbms_lob.getlength(jcb.all_tests_file_blob) all_tests_file_size,
       sys.dbms_lob.getlength(jcb.std_file_blob) std_file_size,
       jcb.all_tests_file_blob,
       jcb.std_file_blob,
       jcb.mime_type,
       'ALL_STANDARDS.json' std_file_name,
       'ALL_TESTS.json' all_tests_file_name,
       jcb.character_set
from jcb;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_APEX_APPLICATION_PAGE_IR_COL" ("APPLICATION_ID", "PAGE_ID", "REGION_NAME", "USE_AS_ROW_HEADER", "REGION_ID", "CREATED_BY", "CREATED_ON", "UPDATED_BY", "UPDATED_ON", "COLUMN_ID", "WORKSPACE", "BUILD_OPTION") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select application_id, 
       page_id, 
       region_name, 
       use_as_row_header,
       region_id, 
       created_by,
       created_on,
       updated_by,
       updated_on,
       column_id,
       workspace,
       build_option
from svt_apex_view.apex_application_page_ir_col();

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_AUTOMATIONS_PROBLEMS" ("JOB_NAME", "JOB_INITIALS", "STATUS", "LOG_DATE", "POLLING_INTERVAL", "LOG_DATE_CHAR", "ERROR_MSG") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with vas as (select v.*,
                    case when v.status_code != 'SUCCESS'
                         then 'N'
                         when v.job_initials in ('6D')
                         then case when v.start_timestamp < (systimestamp - INTERVAL '2' DAY)
                                   then 'N'
                                   else 'Y'
                                   end
                         when v.start_timestamp < (systimestamp - interval '1' day)
                         then 'N'
                         else 'Y'
                         end pass_yn
             from v_svt_automations_status v)
select job_name, 
       job_initials, 
       status, 
       start_timestamp log_date, 
       polling_interval,
       start_timestamp_char log_date_char,
       case when error_msg is not null
            then error_msg
            else 'Has the automation stopped? Check on it.'
            end  error_msg
from vas
where pass_yn = 'N';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_APEX_WORKSPACE_DEVELOPERS" ("WORKSPACE_DISPLAY_NAME", "USER_NAME", "EMAIL") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select workspace_display_name, user_name, email
from apex_workspace_developers
where workspace_display_name = svt_preferences.get('SVT_WORKSPACE');

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_APEX_WORKSPACE_PREFERENCES" ("WORKSPACE_NAME", "USER_NAME", "PREFERENCE_NAME", "PREFERENCE_VALUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select workspace_name,
       user_name, 
       preference_name,
       preference_value
from svt_apex_view.apex_workspace_preferences() 
where user_name = 'SVT';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_AUTOMATIONS_STATUS" ("JOB_NAME", "STATIC_ID", "JOB_INITIALS", "STATUS", "START_TIMESTAMP", "START_TIMESTAMP_CHAR", "IS_JOB", "APPLICATION_ID", "WORKSPACE", "TRIGGER_TYPE", "POLLING_INTERVAL", "POLLING_LAST_RUN_TIMESTAMP", "POLLING_NEXT_RUN_TIMESTAMP", "POLLING_STATUS_CODE", "END_TIMESTAMP", "STATUS_CODE", "ERROR_MSG") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with aal as (select id, 
                    automation_id, 
                    start_timestamp, 
                    end_timestamp,
                    is_job, 
                    status, 
                    status_code, 
                    dense_rank() OVER (PARTITION BY automation_id order by start_timestamp desc) therank 
             from apex_automation_log)
select aaa.name ||
       case when aal.is_job = 'Yes'
            then ' [scheduled job]'
            else ' [manual run]'
            end job_name, 
       aaa.static_id,
       apex_string.get_initials(aaa.name) job_initials,
       aal.status, 
       aal.start_timestamp,
       to_char(aal.start_timestamp, 'DD-MON-YY HH24:MI AM') start_timestamp_char,
       aal.is_job, 
       aaa.application_id, 
       aaa.workspace, 
       aaa.trigger_type, 
       aaa.polling_interval, 
       aaa.polling_last_run_timestamp, 
       aaa.polling_next_run_timestamp, 
       aaa.polling_status_code,
       aal.end_timestamp,
       aal.status_code,
       (select max(message) from apex_automation_msg_log where automation_log_id = aal.id) error_msg
from apex_appl_automations aaa
left outer join aal on aaa.automation_id = aal.automation_id
                    and aal.therank = 1
where aaa.application_name = 'Standard Violation Tracker';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_AUDIT_ON_AUDIT_KEEP_THESE" ("ID", "UNQID", "ACTION_NAME", "CREATED", "THERANK") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with std as (select id, 
                    unqid, 
                    action_name,
                    created,  
                    dense_rank() OVER (partition by unqid, action_name order by created desc) therank
             from svt_audit_on_audit)
select id, 
       unqid, 
       action_name,
       created,
       therank
from std 
where therank = 1;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_COMPATIBILITY" ("ID", "COMPATIBILITY_MODE", "COMPATIBILITY_DESC", "DISPLAY_ORDER", "TYPE_NAME", "COMPATIBILITY_NAME", "CREATED", "CREATED_BY", "UPDATED", "UPDATED_BY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select sc.id,
       sc.compatibility_mode,
       sc.compatibility_desc,
       sc.display_order,
       sc.type_name,
       apex_string.format(
        '%0%1',
        p0 => sc.type_name,
        p1 => case when sc.type_name != 'NA'
                   then ' ('||sc.compatibility_desc||')'
                   end
       ) compatibility_name,
       sc.created,
       sc.created_by,
       sc.updated,
       sc.updated_by
from svt_compatibility sc;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_COMPONENT_TYPES" ("ID", "COMPONENT_NAME", "DESCRIPTION") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select id, 
       component_name, 
       apex_string.format('%0 %1', 
                          p0 => friendly_name, 
                          p1 => '('||component_name||')'
                        ) description
from SVT_COMPONENT_TYPES
where available_yn = 'Y';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_DB_TBL_ALL" ("PASS_YN", "TEST_NAME", "TABLE_NAME", "URGENCY", "URGENCY_LEVEL", "TEST_ID", "TEST_CODE", "UNQID", "CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select  a.pass_yn,
        asrc.test_name,
        a.table_name, 
        asrc.urgency,
        asrc.urgency_level,
        asrc.test_id,
        a.test_code,
        a.unqid,
        a.code
from V_SVT_DB_TBL__0 a
inner join v_svt_stds_standard_tests asrc on a.test_code = asrc.test_code;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_DB_TBL__0" ("TABLE_NAME", "TEST_CODE", "PASS_YN", "UNQID", "CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select dv.table_name,
       esst.test_code,
       dv.pass_yn,
       dv.unqid,
       dv.code
from v_svt_stds_standard_tests esst
join svt_standard_view.v_svt_db_tbl__0(esst.test_code) dv
    on  esst.nt_name = 'V_SVT_DB_TBL__0_NT'
    and esst.query_clob is not null
    and esst.active_yn = 'Y';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_DB_VIEW_ALL" ("PASS_YN", "TEST_NAME", "VIEW_NAME", "URGENCY", "URGENCY_LEVEL", "TEST_ID", "TEST_CODE", "UNQID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select  a.pass_yn,
        asrc.test_name,
        a.view_name, 
        asrc.urgency,
        asrc.urgency_level,
        asrc.test_id,
        a.test_code,
        a.unqid
from V_SVT_DB_VIEW__0 a
inner join v_svt_stds_standard_tests asrc on a.test_code = asrc.test_code;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_DB_VIEW__0" ("VIEW_NAME", "TEST_CODE", "PASS_YN", "UNQID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select dv.view_name,
       esst.test_code,
       dv.pass_yn,
       dv.unqid 
from v_svt_stds_standard_tests esst
join SVT_STANDARD_VIEW.V_SVT_DB_VIEW__0(esst.test_code) dv
    on  esst.nt_name = 'V_SVT_DB_VIEW__0_NT'
    and esst.query_clob is not null
    and esst.active_yn = 'Y';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_EMAIL_SUBSCRIPTIONS" ("USER_NAME", "EMAIL") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select distinct lower(awp.user_name) user_name, lower(awd.email) email
from svt_apex_view.apex_workspace_preferences()  awp
inner join apex_workspace_developers awd on awp.user_name = awd.user_name
where awp.preference_name = 'SVT_EMAIL_SUBSCRIPTION'
and awp.preference_value = 'Y';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_NAV_MENU" ("LIST_ENTRY_ID", "ENTRY_TEXT", "ENTRY_TARGET", "ENTRY_URL", "ADDL_INFO", "AUTHORIZATION_SCHEME", "ENTRY_IMAGE", "IS_AUTHORIZED_YN") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select aale.list_entry_id,
       aale.entry_text, 
       aale.entry_target, 
       apex_plugin_util.replace_substitutions (
        p_value => aale.entry_target) entry_url,
       aale.entry_attribute_04 addl_info, 
       aale.authorization_scheme,
       aale.entry_image,
       svt_menu_util.is_authorized_yn (p_authorization_name => aale.authorization_scheme ) is_authorized_yn
from apex_application_list_entries aale
inner join apex_applications aa on aa.application_id = aale.application_id
                                --and aa.navigation_list = aale.list_name (now using nav bar)
where aale.application_id = v('APP_ID')
and svt_menu_util.is_authorized_yn (p_authorization_name => aale.authorization_scheme ) = 'Y';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_NESTED_TABLE_TYPES" ("ID", "NT_NAME", "OBJECT_TYPE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select id, 
       nt_name, 
       object_type
from svt_nested_table_types;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_PLSQL_APEX_AUDIT" ("AUDIT_ID", "ISSUE_CATEGORY", "APPLICATION_ID", "APPLICATION_NAME", "APPLICATION_TYPE", "APP_TYPE_ID", "APP_TYPE_CODE", "APP_PK_ID", "PAGE_ID", "TEST_ID", "URGENCY", "URGENCY_LEVEL", "LINE", "OBJECT_NAME", "OBJECT_TYPE", "CODE", "VALIDATION_FAILURE_MESSAGE", "SHORT_FAILURE_MESSAGE", "ISSUE_TEXT", "ISSUE_TITLE", "APEX_CREATED_BY", "APEX_CREATED_ON", "APEX_LAST_UPDATED_BY", "APEX_LAST_UPDATED_ON", "NOTES", "SHORT_NOTES", "ACTION_ID", "ACTION_NAME", "INCLUDE_IN_REPORT_YN", "CREATED", "UPDATED", "STALE_YN", "ASSIGNEE", "LINK_URL", "PREPARED_URL", "VIEW_TEXT", "LINK_TO_APEX_ISSUE", "APEX_ISSUE_ID", "APEX_ISSUE_TITLE", "APEX_ISSUE_TEXT", "ISSUE_STATUS", "APEX_ISSUE_TITLE_SUFFIX", "RECENT_YN", "URGENT_YN", "TEST_CODE", "TEST_NAME", "SRC_RECENT_CHANGE_YN", "LEGACY_YN", "UNQID", "IS_EXCEPTION_YN", "IS_EXCEPTION_YN2", "MV_DEPENDENCY", "ASSIGNED_TO_ME_YN", "OWNER", "VIEW_BUTTON", "RERUN", "MARK_AS_EXCEPTION", "COMPONENT_ID", "PARENT_COMPONENT_ID", "SVT_COMPONENT_TYPE_ID", "COMPONENT_TYPE_ID", "STANDARD_NAME", "STANDARD_ID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with aspaa as (
    select paa.id audit_id,
           paa.issue_category,
           paa.application_id,
           vaa.application_name,
           vaa.application_type,
           vaa.app_type_id,
           src.test_name,
           paa.page_id,
           src.test_id,
           src.urgency,
           src.urgency_level,
           paa.line,
           paa.object_name,
           paa.object_type,
           paa.code,
           paa.validation_failure_message,
           case when length(paa.validation_failure_message) > 166 
                then substr(paa.validation_failure_message,1,166) || '...'
                else paa.validation_failure_message
                end short_failure_message,
           case when length(paa.notes) > 90 
                then substr(paa.notes,1,90) || '...'
                else paa.notes
                end short_notes,
           paa.issue_title,
           paa.apex_created_by,
           paa.apex_created_on,
           paa.apex_last_updated_by,
           paa.apex_last_updated_on,
           paa.notes,
           paa.action_id,
           paa.created,
           paa.updated,
           case when paa.updated < sysdate - interval '6' hour
                then 'Y'
                else 'N'
                end stale_yn, --stale issues get deleted
           paa.assignee,
           (select svt_apex_issue_link.build_link_to_apex_issue(
                   p_app_id => paa.application_id,
                   p_id => paa.apex_issue_id ) 
           from dual ) link_to_apex_issue,
           (select svt_stds_parser.build_url(
                        p_template_url          => sct.template_url,
                        p_app_id                => paa.application_id,
                        p_page_id               => paa.page_id,
                        p_pk_value              => paa.component_id,
                        p_parent_pk_value       => paa.parent_component_id,
                        p_issue_category        => paa.issue_category,
                        p_line                  => paa.line,
                        p_object_name           => paa.object_name,
                        p_object_type           => paa.object_type,
                        p_schema                => paa.owner,
                        p_builder_session       => v('APX_BLDR_SESSION')
                        ) 
           from dual) link_url,
           paa.apex_issue_id,
           paa.apex_issue_title_suffix,
           paa.test_code,
           src.src_recent_change_yn,
           paa.legacy_yn,
           paa.unqid,
           aaa.action_name,
           coalesce(aaa.include_in_report_yn, 'Y') include_in_report_yn,
           case when aaa.include_in_report_yn is null 
                then 'N'
                when aaa.include_in_report_yn = 'Y'
                then 'N'
                else 'Y'
                end is_exception_yn,
           src.mv_dependency,
           paa.owner,
           paa.component_id,
           paa.parent_component_id,
           src.svt_component_type_id,
           src.component_name, 
           sct.component_type_id, 
           sct.template_url,
           src.standard_name,
           src.standard_id,
           vaa.type_code app_type_code,
           vaa.pk_id app_pk_id
    from svt_plsql_apex_audit paa
    inner join v_svt_stds_standard_tests src on paa.test_code  = src.test_code
    inner join svt_component_types sct on sct.id = src.svt_component_type_id
    left outer join v_svt_stds_applications vaa on paa.application_id = vaa.apex_app_id
    left outer join svt_audit_actions aaa on paa.action_id = aaa.id
)
select 
    a.audit_id,
    a.issue_category,
    a.application_id,
    a.application_name,
    a.application_type,
    a.app_type_id,
    a.app_type_code,
    a.app_pk_id,
    a.page_id,
    a.test_id,
    a.urgency,
    a.urgency_level,
    a.line,
    a.object_name,
    a.object_type,
    a.code,
    a.validation_failure_message,
    a.short_failure_message,
    apex_string.format(
    p_message => q'^
|Issue Description|
|-----------------|
|%2|
|%10|
|%7|

Details:
```
%0
```
%4


| | How to get rid of this issue|
|-------------------------------------|---|
|Option 1|Click "Manage Issue" for info on how to fix the underlying problem and rerun the test (which is run automatically every 24 hours)|
|Option 2|Close this "issue" and records will mark it as a "valid exception to the standard"|

%5
Questions/concerns? Contact hayden.h.hudson@oracle.com.
Audit id : %3
    ^',
    p0  => a.validation_failure_message,
    p2  => a.test_name,
    p3  => a.audit_id,
    p4 => case when a.notes is not null
                then 'Notes : '||a.notes 
                end,
    p5 => case when a.assignee is not null 
                then 'Assignee : '||a.assignee
                end,
    p6 => a.test_code,
    p7 => '[General info on issue + fix]('||svt_stds_parser.get_base_url()||'f?p=17000033:1::::1:P1_TEST_CODE:'||a.test_code||')',
    p8 => a.application_id,
    p9 => a.page_id,
    p10 => '[Manage Issue]('||svt_stds_parser.get_base_url()||'f?p=17000033:1::::1:P1_AUDIT_ID:'||a.audit_id||')'
    ) issue_text,
    apex_string.format(
        p_message => '[%0] %1',
        p0 => a.issue_category,
        p1 => case when a.issue_category in ('DB_PLSQL', 'TABLE', 'VIEW')
                   then a.test_name || ' (in ' ||lower(a.issue_title)||')'
                   else a.issue_title
                   end) issue_title,
    a.apex_created_by,
    a.apex_created_on,
    a.apex_last_updated_by,
    a.apex_last_updated_on,
    a.notes,
    a.short_notes,
    a.action_id,
    a.action_name,
    a.include_in_report_yn,
    a.created,
    a.updated,
    a.stale_yn,
    a.assignee,
    a.link_url,
    svt_stds_parser.adapt_url( a.link_url ) prepared_url,
    apex_lang.message( 'VIEW_IN_BUILDER' ) view_text,
    a.link_to_apex_issue,
    ai.issue_id apex_issue_id,
    ai.issue_title apex_issue_title,
    ai.issue_text apex_issue_text,
    ai.issue_status,
    a.apex_issue_title_suffix,
    case when a.legacy_yn = 'Y'
         then 'N'
         else case when src_recent_change_yn = 'Y'
                   then 'N'
                   else case when to_char(sysdate, 'fmdy') not in ('mon')
                           then case when sysdate - a.created < 2
                                       then 'Y'
                                       else 'N'
                                       end
                           else case when sysdate - a.created < 4
                                       then 'Y'
                                       else 'N'
                                       end
                               end 
                   end 
         end recent_yn,
    case when a.urgency_level <= 100
        then 'Y'
        else 'N'
        end urgent_yn,
    a.test_code,
    a.test_name,
    a.src_recent_change_yn,
    a.legacy_yn,
    a.unqid,
    a.is_exception_yn, --needed for template directive
    a.is_exception_yn is_exception_yn2, --need for yes/no display
    a.mv_dependency,
    case when upper(a.assignee) = upper(v('APP_USER_EMAIL'))
         then 'Y'
         else 'N'
         end assigned_to_me_yn,
    a.owner,
    null view_button,
    null rerun,
    null mark_as_exception,
    a.component_id,
    a.parent_component_id,
    a.svt_component_type_id,
    a.component_type_id,
    a.standard_name,
    a.standard_id
from aspaa a
left outer join apex_issues ai on a.apex_issue_id = ai.issue_id
-- where a.include_in_report_yn = 'Y';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_PLSQL_APEX__0" ("ISSUE_CATEGORY", "APPLICATION_ID", "PAGE_ID", "PASS_YN", "LINE", "OBJECT_NAME", "OBJECT_TYPE", "CODE", "VALIDATION_FAILURE_MESSAGE", "ISSUE_TITLE", "APEX_CREATED_BY", "APEX_CREATED_ON", "APEX_LAST_UPDATED_BY", "APEX_LAST_UPDATED_ON", "TEST_CODE", "UNQID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select a.issue_category,
       a.application_id, 
       a.page_id, 
       a.pass_yn, 
       a.line, 
       a.object_name, 
       a.object_type,
       a.code,
       a.validation_failure_message,
       a.issue_title,
       a.apex_created_by, 
       a.apex_created_on, 
       a.apex_last_updated_by, 
       a.apex_last_updated_on,
       esst.test_code,
       a.unqid
from v_svt_stds_standard_tests esst
join svt_standard_view.v_svt(p_test_code        => esst.test_code,
                             p_failures_only        => 'Y',
                             p_urgent_only          => 'Y',
                             p_production_apps_only => 'Y') a
        on  esst.query_clob is not null
        and esst.active_yn = 'Y';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_TABLE_DATA_LOAD_DEF" ("TABLE_NAME", "IMPLICIT_TABLE", "FILE_BLOB", "MIME_TYPE", "FILE_NAME", "STATIC_FILE_NAME", "CHARACTER_SET", "FILE_SIZE", "DOWNLOAD", "DATA_LOAD_DEFINITION_NAME", "STATIC_APPLICATION_FILE_NAME", "INSPECT_STATIC_FILE_ICON", "PAGE_ID", "PAGE_ID_ICON", "APPLICATION_FILE_ID", "ZIP_FILE_SIZE", "ZIP_DOWNLOAD", "TABLE_LAST_UPDATED_ON", "STATIC_FILE_CREATED_ON", "STALE_YN", "ZIP_BLOB", "ZIP_MIME_TYPE", "ZIP_CHARSET", "ZIP_UPDATED_ON") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select table_name,
       implicit_table,
       file_blob,
       mime_type,
       file_name,
       static_file_name,
       character_set,
       file_size,
       download,
       data_load_definition_name,
       static_application_file_name,
       inspect_static_file_icon,
       page_id,
       page_id_icon,
       application_file_id,
       zip_file_size,
       zip_download,
       table_last_updated_on,
       static_file_created_on,
       stale_yn,
       zip_blob,
       zip_mime_type,
       zip_charset,
       zip_updated_on
  from SVT_DEPLOYMENT.V_SVT_TABLE_DATA_LOAD_DEF(P_APPLICATION_ID => V('APP_ID'));

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_TEST_TIMING" ("TEST_CODE", "AVG_SECONDS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select test_code, avg(elapsed_seconds) avg_seconds
from svt_test_timing
group by test_code;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_APPLICATIONS" ("PK_ID", "APEX_APP_ID", "ESA_CREATED", "ESA_CREATED_BY", "ESA_UPDATED", "ESA_UPDATED_BY", "DEFAULT_DEVELOPER", "AVAILABILITY_STATUS", "APPLICATION_TYPE", "APP_TYPE_ID", "APPLICATION_NAME", "NOTES", "APP_ACTIVE_YN", "TYPE_ACTIVE_YN", "TYPE_CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select /*+ result_cache */
       esa.pk_id, 
       esa.apex_app_id, 
       esa.esa_created, 
       esa.esa_created_by, 
       esa.esa_updated, 
       esa.esa_updated_by, 
       esa.default_developer,
       aa.availability_status,
       est.type_name application_type,
       esa.type_id app_type_id,
       aa.application_name,
       esa.notes,
       esa.active_yn app_active_yn,
       est.active_yn type_active_yn,
       est.type_code
from svt_stds_applications esa
inner join apex_applications aa on esa.apex_app_id = aa.application_id
                                and aa.availability_status != 'Unavailable'
inner join svt_stds_types est on est.id = esa.type_id
                              and est.active_yn = 'Y'
where esa.active_yn = 'Y';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_INHERITED_TESTS" ("ID", "PARENT_STANDARD_ID", "TEST_ID", "STANDARD_ID", "TEST_CODE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select sit.id,
       sit.parent_standard_id,
       sit.test_id,
       sit.standard_id,
       sst.test_code
from svt_stds_inherited_tests sit
inner join svt_stds_standard_tests sst on sit.test_id = sst.id;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_INHERITED_TESTS_TREE" ("STANDARD_ID", "STANDARD_NAME", "PARENT_STANDARD_ID", "TEST_ID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select distinct esit.parent_standard_id standard_id, 
                ess1.full_standard_name||' (Originating standard)' standard_name, 
                null parent_standard_id, 
                esit.test_id
from svt_stds_inherited_tests esit
inner join v_svt_stds_standards ess1 on ess1.id = esit.parent_standard_id
union all 
select esit.standard_id, 
       ess2.full_standard_name standard_name, 
       esit.parent_standard_id, 
       esit.test_id
from svt_stds_inherited_tests esit
inner join v_svt_stds_standards ess2 on ess2.id = esit.standard_id;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_STANDARDS" ("ID", "STANDARD_NAME", "DESCRIPTION", "PRIMARY_DEVELOPER", "IMPLEMENTATION", "DATE_STARTED", "CREATED", "CREATED_BY", "UPDATED", "UPDATED_BY", "STANDARD_GROUP", "ACTIVE_YN", "COMPATIBILITY_MODE_ID", "COMPATIBILITY_MODE", "COMPATIBILITY_DESC", "TYPE_NAME", "COMPATIBILITY_TEXT", "FULL_STANDARD_NAME", "PARENT_STANDARD_ID", "DISPLAY_ORDER") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select ess.id,
       ess.standard_name,
       ess.description,
       ess.primary_developer,
       ess.implementation,
       ess.date_started,
       ess.created,
       ess.created_by,
       ess.updated,
       ess.updated_by,
       ess.standard_group,
       ess.active_yn,
       ess.compatibility_mode_id,
       sc.compatibility_mode,
       sc.compatibility_desc,
       sc.type_name,
       apex_string.format('%0%1',
                          p0 => case when sc.type_name = 'NA'
                                     then 'N/A'
                                     when sc.type_name = 'DB'
                                     then 'Database'
                                     else sc.type_name
                                     end,
                          p1 => case when sc.type_name != 'NA'
                                     then ' Version '||sc.compatibility_desc
                                     end) compatibility_text,
       apex_string.format('%0%1%2',
                          p0 => case when sc.type_name != 'NA'
                                     then sc.type_name||' '
                                     end,
                          p1 => ess.standard_name,
                          p2 => case when sc.type_name != 'NA'
                                     then ' ('||sc.compatibility_mode||')'
                                     end
                          ) full_standard_name,
       ess.parent_standard_id,
       sc.display_order
from svt_stds_standards ess
inner join svt_compatibility sc on ess.compatibility_mode_id = sc.id;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_STANDARDS_EXPORT" ("STANDARD_ID", "STANDARD_NAME", "FULL_STANDARD_NAME", "DESCRIPTION", "PRIMARY_DEVELOPER", "IMPLEMENTATION", "DATE_STARTED", "CREATED", "CREATED_BY", "UPDATED", "UPDATED_BY", "STANDARD_GROUP", "ACTIVE_YN", "ALL_TESTS_FILE_SIZE", "ALL_TESTS_FILE_BLOB", "MIME_TYPE", "ALL_TESTS_FILE_NAME", "CHARACTER_SET") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with jcb as (select id standard_id,
                    standard_name, 
                    description, 
                    primary_developer, 
                    implementation, 
                    date_started, 
                    created, 
                    created_by, 
                    updated, 
                    updated_by, 
                    standard_group, 
                    active_yn,
                    svt_stds.file_name(full_standard_name) base_file_name,
                    'application/json' mime_type,
                    'UTF-8' character_set,
                    svt_deployment.json_standard_tests_blob (p_standard_id => id) all_tests_file_blob,
                    compatibility_mode,
                    full_standard_name
            from v_svt_stds_standards)
select jcb.standard_id, 
       jcb.standard_name, 
       jcb.full_standard_name,
       jcb.description, 
       jcb.primary_developer, 
       jcb.implementation, 
       jcb.date_started, 
       jcb.created, 
       jcb.created_by, 
       jcb.updated, 
       jcb.updated_by, 
       jcb.standard_group, 
       jcb.active_yn,
       sys.dbms_lob.getlength(jcb.all_tests_file_blob) all_tests_file_size,
       jcb.all_tests_file_blob,
       jcb.mime_type,
       apex_string.format('ALL_TESTS-%0.json',
                     p0 => jcb.base_file_name
              ) all_tests_file_name,
       jcb.character_set
from jcb;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_STANDARD_TESTS" ("STANDARD_ID", "TEST_ID", "LEVEL_ID", "URGENCY", "URGENCY_LEVEL", "TEST_NAME", "TEST_CODE", "STANDARD_NAME", "ACTIVE_YN", "NT_NAME", "QUERY_CLOB", "STD_CREATION_DATE", "STD_UPDATED_DATE", "SRC_RECENT_CHANGE_YN", "MV_DEPENDENCY", "SVT_COMPONENT_TYPE_ID", "COMPONENT_NAME", "STANDARD_ACTIVE_YN", "EXPLANATION", "FIX", "VERSION_NUMBER", "VERSION_DB", "DISPLAY_SEQUENCE", "FULL_STANDARD_NAME", "ISSUE_CATEGORY", "AVG_EXECUTION_SECONDS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select  /*+ result_cache */
        st.standard_id,
        st.id test_id,
        st.level_id,
        asul.urgency_name urgency, 
        asul.urgency_level, --5
        st.test_name,
        st.test_code,
        ess.standard_name,
        st.active_yn,
        antt.nt_name, --10
        st.query_clob,
        st.created std_creation_date,
        st.updated std_updated_date,
       case when sysdate - trunc(st.updated) < 5
            then 'Y'
            else 'N'
            end src_recent_change_yn,
       st.mv_dependency,
       st.svt_component_type_id,
       act.component_name,
       ess.active_yn standard_active_yn,
       st.explanation,
       st.fix,
       st.version_number,
       st.version_db,
       st.display_sequence,
       ess.full_standard_name,
       antt.object_type issue_category,
       coalesce(st.avg_exctn_scnds, 0) avg_execution_seconds
from svt_stds_standard_tests st
inner join v_svt_stds_standards ess on st.standard_id = ess.id
inner join svt_component_types act on act.id = st.svt_component_type_id
inner join svt_nested_table_types antt on act.nt_type_id = antt.id
inner join svt_standards_urgency_level asul on asul.id = st.level_id;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_STANDARD_TESTS_EXPORT" ("STANDARD_ID", "TEST_ID", "URGENCY", "URGENCY_LEVEL", "LEVEL_ID", "TEST_NAME", "TEST_CODE", "STANDARD_NAME", "ACTIVE_YN", "NT_NAME", "QUERY_CLOB", "STD_CREATION_DATE", "MV_DEPENDENCY", "SVT_COMPONENT_TYPE_ID", "COMPONENT_NAME", "STANDARD_ACTIVE_YN", "EXPLANATION", "FIX", "DOWNLOAD", "FILE_BLOB", "MIME_TYPE", "FILE_NAME", "CHARACTER_SET", "VSN", "VERSION_NUMBER", "VERSION_DB", "RECORD_MD5", "LIB_MD5", "PUBLISHED_YN", "PUBLISH_BUTTON_HTML", "DLCLSS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select standard_id,
       test_id,
       urgency,
       urgency_level,
       level_id,
       test_name,
       test_code,
       standard_name,
       active_yn,
       nt_name,
       query_clob,
       std_creation_date,
       mv_dependency,
       svt_component_type_id,
       component_name,
       standard_active_yn,
       explanation,
       fix,
       download,
       file_blob,
       mime_type,
       file_name,
       character_set,
       vsn,
       version_number,
       version_db,
       record_md5,
       lib_md5,
       published_yn,
       null publish_button_html,
       download_css dlclss
from svt_stds_standard_tests_api.v_svt_stds_standard_tests();

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_STANDARD_TESTS_W_INHERITED" ("STANDARD_ID", "TEST_ID", "LEVEL_ID", "URGENCY", "URGENCY_LEVEL", "TEST_NAME", "TEST_CODE", "FULL_STANDARD_NAME", "ACTIVE_YN", "NT_NAME", "QUERY_CLOB", "STD_CREATION_DATE", "MV_DEPENDENCY", "SVT_COMPONENT_TYPE_ID", "COMPONENT_NAME", "STANDARD_ACTIVE_YN", "EXPLANATION", "FIX", "VERSION_NUMBER", "VERSION_DB", "INHERITED_YN", "DISPLAY_SEQUENCE", "ISSUE_CATEGORY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select   o.standard_id,
         o.test_id,
         o.level_id,
         o.urgency, 
         o.urgency_level,
         o.test_name,
         o.test_code,
         o.full_standard_name,
         o.active_yn,
         o.nt_name,
         o.query_clob,
         o.std_creation_date,
         o.mv_dependency,
         o.svt_component_type_id,
         o.component_name,
         o.standard_active_yn,
         o.explanation,
         o.fix,
         o.version_number,
         o.version_db,
         'N' inherited_yn,
         o.display_sequence,
         o.issue_category
  from v_svt_stds_standard_tests o
  union all
  select esit.standard_id,
         i.test_id,
         i.level_id,
         i.urgency, 
         i.urgency_level,
         i.test_name,
         i.test_code,
         i.full_standard_name,
         i.active_yn,
         i.nt_name,
         i.query_clob,
         i.std_creation_date,
         i.mv_dependency,
         i.svt_component_type_id,
         i.component_name,
         i.standard_active_yn,
         i.explanation,
         i.fix,
         i.version_number,
         i.version_db,
         'Y' inherited_yn,
         i.display_sequence,
         i.issue_category
  from v_svt_stds_standard_tests i
  inner join svt_stds_inherited_tests esit on i.test_id = esit.test_id
                                           and i.standard_id = esit.parent_standard_id;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_TESTS_LIB" ("ID", "STANDARD_ID", "TEST_NAME", "QUERY_CLOB", "TEST_CODE", "ACTIVE_YN", "MV_DEPENDENCY", "SVT_COMPONENT_TYPE_ID", "TEST_ID", "TEST_CODE_IN_DB_YN", "EXPLANATION", "FIX", "LEVEL_ID", "IMPORTED_VERSION_NUMBER", "IMPORTED_VERSION_DB", "INSTALLED_VERSION_NUMBER", "INSTALLED_VERSION_DB", "CURRENT_VERSION_INSTALLED_YN", "UPGRADE_NEEDED_YN", "ESTL_MD5", "ESST_MD5", "STANDARD_NAME", "STANDARD_ACTIVE_YN", "URGENCY_NAME", "PUBLISHED_YN") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with lib as (select estl.id,
                    estl.standard_id,
                    estl.test_name,
                    estl.query_clob,
                    estl.test_code,
                    estl.active_yn,
                    estl.mv_dependency,
                    estl.svt_component_type_id,
                    estl.test_id,
                    case when esst.id is null 
                         then 'N'
                         else 'Y'
                         end test_code_in_db_yn,
                    estl.explanation,
                    estl.fix,
                    estl.level_id,
                    estl.version_number imported_version_number,
                    estl.version_db imported_version_db,
                    esst.version_number installed_version_number,
                    esst.version_db installed_version_db,
                    case when esst.version_number is null 
                         then 'N'
                         when estl.version_number = esst.version_number
                         and  estl.version_db = esst.version_db
                         then 'Y'
                         else 'N'
                         end current_version_installed_yn,
                    case when esst.version_number is null 
                         then 'Y'
                         when estl.version_number != esst.version_number
                         and  estl.version_db = esst.version_db
                         then 'Y'
                         else 'N'
                         end upgrade_needed_yn,
                    svt_stds_standard_tests_api.build_test_md5 (
                         p_test_name             => estl.test_name,
                         p_query_clob            => estl.query_clob,
                         p_test_code             => estl.test_code,
                         p_level_id              => estl.level_id,
                         p_mv_dependency         => estl.mv_dependency,
                         p_svt_component_type_id => estl.svt_component_type_id,
                         p_explanation           => estl.explanation,
                         p_fix                   => estl.fix,
                         p_version_number        => estl.version_number,
                         p_version_db            => estl.version_db
                    ) estl_md5,
                    svt_stds_standard_tests_api.build_test_md5 (
                         p_test_name             => esst.test_name,
                         p_query_clob            => esst.query_clob,
                         p_test_code             => esst.test_code,
                         p_level_id              => esst.level_id,
                         p_mv_dependency         => esst.mv_dependency,
                         p_svt_component_type_id => esst.svt_component_type_id,
                         p_explanation           => esst.explanation,
                         p_fix                   => esst.fix,
                         p_version_number        => esst.version_number,
                         p_version_db            => esst.version_db
                    ) esst_md5
               from svt_stds_tests_lib estl
               left outer join svt_stds_standard_tests esst on estl.test_code = esst.test_code)
select lib.id,
       lib.standard_id,
       lib.test_name,
       lib.query_clob,
       lib.test_code,
       lib.active_yn,
       lib.mv_dependency,
       lib.svt_component_type_id,
       lib.test_id,
       lib.test_code_in_db_yn,
       lib.explanation,
       lib.fix,
       lib.level_id,
       lib.imported_version_number,
       lib.imported_version_db,
       lib.installed_version_number,
       lib.installed_version_db,
       lib.current_version_installed_yn,
       lib.upgrade_needed_yn,
       lib.estl_md5,
       lib.esst_md5,
       ess.standard_name,
       ess.active_yn standard_active_yn,
       asul.urgency_name,
       case  when lib.active_yn = 'N'
             then 'N'
             when lib.estl_md5 is null 
             then 'N'
             when lib.esst_md5 = lib.estl_md5
             then 'Y'
             else 'N'
             end published_yn
from lib
left outer join svt_stds_standards ess on ess.id = lib.standard_id
left outer join svt_component_types act on act.id = lib.svt_component_type_id
left outer join svt_standards_urgency_level asul on asul.id = lib.level_id;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_MISSING_BASE_DATA" ("TBL_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with std as (select count(*) rwcount, 'svt_stds_types' tbl_name from sys.dual where exists ( select 1 from svt_stds_types)
             union all
             select count(*) rwcount, 'svt_audit_actions' tbl_name from sys.dual where exists ( select 1 from svt_audit_actions)
             union all
             select count(*) rwcount, 'svt_compatibility' tbl_name from sys.dual where exists ( select 1 from svt_compatibility)
             union all
             select count(*) rwcount, 'svt_component_types' tbl_name from sys.dual where exists ( select 1 from svt_component_types)
             union all
             select count(*) rwcount, 'svt_nested_table_types' tbl_name from sys.dual where exists ( select 1 from svt_nested_table_types)
             union all
             select count(*) rwcount, 'svt_standards_urgency_level' tbl_name from sys.dual where exists ( select 1 from svt_standards_urgency_level)
            )
select tbl_name
from std 
where rwcount = 0;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_PREFERENCE_PROBLEMS" ("STMT") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with ppref as (select replace(item_name, 'P45_') preference_name
                from apex_application_page_items
                where page_id = 45
                and application_name = 'Standard Violation Tracker'
                and item_name not in ('P45_SVT_TIME_ZONE','P45_SVT_EMAIL_SUBSCRIPTION')
                and coalesce(condition_type_code,'NA') != 'NEVER'),
    stmt as (select 'The following preferences have not been configured : ' intro, listagg(ppref.preference_name, ', ') within group (order by ppref.preference_name) prefs     
                from ppref
                left outer join v_svt_apex_workspace_preferences awp on awp.preference_name = ppref.preference_name
                where awp.preference_value is null)
select intro||prefs stmt
from stmt
where prefs is not null;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_PROBLEM_ASSIGNEES" ("ASSIGNEE", "DISPLAY_ASSIGNEE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select assignee, assignee display_assignee
from mv_svt_assignee_count
where assignee not like '%@%'
union all
select assignee, 'null' display_assignee
from mv_svt_assignee_count
where assignee is null
union all
select assignee, assignee display_assignee
from mv_svt_assignee_count
where assignee in (select lower(column_value)
                   from table(apex_string.split(svt_preferences.get('SVT_DO_NOT_ASSIGN'), ':'))
                   );

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_MV_SVT" ("APPLICATION_ID", "APPLICATION_NAME", "URL_TYPE", "ELEMENT_URL", "ELEMENT_ID", "ELEMENT_LABEL", "ELEMENT_NAME", "ELEMENT_AUTHORIZATION", "PARENT_ELEMENT_ID", "PARENT_ELEMENT_NAME", "PARENT_ELEMENT_AUTHORIZATION", "PAGE_ID", "PAGE_NAME", "PAGE_AUTHORIZATION", "DESTINATION_APP_ID", "DESTINATION_PAGE_ID", "DESTINATION_PAGE_NAME", "DESTINATION_APP_NAME", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "PAGE_MODE", "OPT_PARENT_ELEMENT_ID", "CREATED_BY", "CREATED_ON") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, null as parent_element_authorization, null as page_id, null as page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_BC_ENTRIES
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_BUTTONS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_CARD_ACTIONS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_CHART_S
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_CLASSIC_COLS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, null as parent_element_id, null as parent_element_name, parent_element_authorization, null as page_id, null as page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_HOME_LINK
union all
select application_id, application_name, url_type, element_url, element_id, null as element_label, null as element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_IG
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_IG_COLS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, created_by, created_on
from MV_SVT_IR
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, created_by, created_on
from MV_SVT_IR_COLS
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, null as parent_element_authorization, null as page_id, null as page_name, null as page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_LIST_ENTRIES
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, parent_element_name, parent_element_authorization, null as page_id, null as page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_NAV_BAR
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, null as parent_element_id, null as parent_element_name, null as parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_PAGE_BRANCH
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, parent_element_id, null as parent_element_name, parent_element_authorization, page_id, page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_PAGE_MENU_ENTRIES
union all
select application_id, application_name, url_type, element_url, element_id, element_label, element_name, element_authorization, null as parent_element_id, null as parent_element_name, parent_element_authorization, null as page_id, null as page_name, page_authorization, destination_app_id, destination_page_id, destination_page_name, destination_app_name, last_updated_by, last_updated_on, null as page_mode, null as opt_parent_element_id, null as created_by, null as created_on
from MV_SVT_SEARCH_CONFIG;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_APPLICATION_REPORT_CARD" ("APPLICATION_ID", "CRITICAL_URGENCY", "HIGH_URGENCY", "MED_URGENCY", "VIOLATION_COUNT", "DEFAULT_DEVELOPER", "APPLICATION_NAME", "APPLICATION_TYPE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with rptcrd as (select application_id, 
                       critical_urgency, 
                       high_urgency, 
                       med_urgency
                    from (
                      select paa.application_id, 
                             esst.urgency
                        from svt_plsql_apex_audit paa
                        inner join v_svt_stds_standard_tests esst on paa.test_code = esst.test_code
                        left outer join svt_audit_actions aaa on paa.action_id = aaa.id
                        where coalesce(aaa.include_in_report_yn, 'Y') = 'Y'
                    )
                    pivot ( count(*) for urgency in 
                    ( 'Critical' as critical_urgency, 'High' as high_urgency,'Medium' as med_urgency,'Low' as low_urgency ) )
                )
select esa.apex_app_id application_id, 
       coalesce(rptcrd.critical_urgency,0) critical_urgency, 
       coalesce(rptcrd.high_urgency,0) high_urgency, 
       coalesce(rptcrd.med_urgency,0) med_urgency,
       coalesce(rptcrd.critical_urgency,0) + coalesce(rptcrd.high_urgency,0) + coalesce(rptcrd.med_urgency,0) violation_count,
       esa.default_developer,
       apex_string.format('%s (%s)', aa.application_name, esa.apex_app_id) application_name,
       est.type_name application_type
from svt_stds_applications esa
inner join apex_applications aa on aa.application_id = esa.apex_app_id
inner join svt_stds_types est on est.id = esa.type_id
left outer join rptcrd on esa.apex_app_id = rptcrd.application_id
--order by critical_urgency desc, high_urgency desc, med_urgency desc;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_AUDIT_ON_AUDIT_APEX" ("ID", "AUDIT_ID", "UNQID", "STANDARD_NAME", "APP_ID", "PK_ID", "COMPONENT_NAME", "CREATED", "TEST_CODE", "VALIDATION_FAILURE_MESSAGE", "URGENCY", "URGENCY_LEVEL", "TEST_NAME", "PAGE_ID", "COMPONENT_ID", "ASSIGNEE", "LINE", "OBJECT_NAME", "OBJECT_TYPE", "CODE", "DELETE_REASON") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with std as (select id, 
                    unqid, 
                    action_name,
                    created, 
                    created_by, 
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
                    dense_rank() over (partition by unqid order by created desc) therank
                from svt_audit_on_audit
                )
select  std.id, 
        std.audit_id,
        std.unqid, 
        esst.standard_name,
        std.app_id, 
        esa.pk_id,
        esst.component_name,
        std.created, 
        std.test_code, 
        std.validation_failure_message,
        esst.urgency, 
        esst.urgency_level,
        esst.test_name,
        std.page_id,
        std.component_id,
        std.assignee,
        std.line,
        std.object_name,
        std.object_type,
        std.code,
        std.delete_reason
from std
inner join v_svt_stds_standard_tests esst on std.test_code = esst.test_code
                                          and esst.issue_category = 'APEX'
inner join v_svt_stds_applications esa on esa.apex_app_id = std.app_id
where std.therank = 1
and std.action_name = 'DELETE'; 