  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_APPLICATION_REPORT_CARD" ("APPLICATION_ID", "CRITICAL_URGENCY", "HIGH_URGENCY", "MED_URGENCY", "VIOLATION_COUNT", "DEFAULT_DEVELOPER", "APPLICATION_NAME", "APPLICATION_TYPE") AS 
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
--order by critical_urgency desc, high_urgency desc, med_urgency desc
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_AUDIT_ON_AUDIT_APEX" ("ID", "AUDIT_ID", "UNQID", "STANDARD_NAME", "APP_ID", "PK_ID", "COMPONENT_NAME", "CREATED", "TEST_CODE", "VALIDATION_FAILURE_MESSAGE", "URGENCY", "URGENCY_LEVEL", "TEST_NAME", "PAGE_ID", "COMPONENT_ID", "ASSIGNEE", "LINE", "OBJECT_NAME", "OBJECT_TYPE", "CODE", "DELETE_REASON") AS 
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
and std.action_name = 'DELETE'
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_AUTOMATIONS_PROBLEMS" ("JOB_NAME", "JOB_INITIALS", "STATUS", "LOG_DATE", "POLLING_INTERVAL", "LOG_DATE_CHAR", "ERROR_MSG") AS 
  with vas as (select v.*,
                    case when v.status_code != 'SUCCESS'
                         then 'N'
                         when lower(v.job_name) like '%email%' and svt_preferences.get('SVT_EMAIL_API') = 'NA'
                         then 'Y'
                         when lower(v.job_name) like '%apex%' and svt_apex_issue_util.apex_issue_access_yn = 'N'
                         then 'Y'
                         else case when v.start_timestamp < (systimestamp - interval '2' day)
                                   then 'N'
                                   else 'Y'
                                   end
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
where pass_yn = 'N'
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_DB_TBL__0" ("TABLE_NAME", "TEST_CODE", "PASS_YN", "UNQID", "CODE") AS 
  select dv.table_name,
       esst.test_code,
       dv.pass_yn,
       dv.unqid,
       dv.code
from v_svt_stds_standard_tests esst
join svt_standard_view.v_svt_db_tbl__0(esst.test_code) dv
    on  esst.nt_name = 'V_SVT_DB_TBL__0_NT'
    and esst.query_clob is not null
    and esst.active_yn = 'Y'
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_DB_VIEW__0" ("VIEW_NAME", "TEST_CODE", "PASS_YN", "UNQID") AS 
  select dv.view_name,
       esst.test_code,
       dv.pass_yn,
       dv.unqid 
from v_svt_stds_standard_tests esst
join SVT_STANDARD_VIEW.V_SVT_DB_VIEW__0(esst.test_code) dv
    on  esst.nt_name = 'V_SVT_DB_VIEW__0_NT'
    and esst.query_clob is not null
    and esst.active_yn = 'Y'
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_PLSQL_APEX_AUDIT" ("AUDIT_ID", "ISSUE_CATEGORY", "APPLICATION_ID", "APPLICATION_NAME", "APPLICATION_TYPE", "APP_TYPE_ID", "APP_TYPE_CODE", "APP_PK_ID", "PAGE_ID", "TEST_ID", "URGENCY", "URGENCY_LEVEL", "LINE", "OBJECT_NAME", "OBJECT_TYPE", "CODE", "VALIDATION_FAILURE_MESSAGE", "SHORT_FAILURE_MESSAGE", "ISSUE_TEXT", "ISSUE_TITLE", "APEX_CREATED_BY", "APEX_CREATED_ON", "APEX_LAST_UPDATED_BY", "APEX_LAST_UPDATED_ON", "NOTES", "SHORT_NOTES", "ACTION_ID", "ACTION_NAME", "INCLUDE_IN_REPORT_YN", "CREATED", "UPDATED", "STALE_YN", "ASSIGNEE", "LINK_URL", "PREPARED_URL", "VIEW_TEXT", "LINK_TO_APEX_ISSUE", "APEX_ISSUE_ID", "APEX_ISSUE_TITLE", "APEX_ISSUE_TEXT", "ISSUE_STATUS", "APEX_ISSUE_TITLE_SUFFIX", "RECENT_YN", "URGENT_YN", "TEST_CODE", "TEST_NAME", "SRC_RECENT_CHANGE_YN", "LEGACY_YN", "UNQID", "IS_EXCEPTION_YN", "IS_EXCEPTION_YN2", "MV_DEPENDENCY", "ASSIGNED_TO_ME_YN", "OWNER", "VIEW_BUTTON", "RERUN", "MARK_AS_EXCEPTION", "COMPONENT_ID", "PARENT_COMPONENT_ID", "SVT_COMPONENT_TYPE_ID", "COMPONENT_TYPE_ID", "STANDARD_NAME", "STANDARD_ID") AS 
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
-- where a.include_in_report_yn = 'Y'
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_PLSQL_APEX__0" ("ISSUE_CATEGORY", "APPLICATION_ID", "PAGE_ID", "PASS_YN", "LINE", "OBJECT_NAME", "OBJECT_TYPE", "CODE", "VALIDATION_FAILURE_MESSAGE", "ISSUE_TITLE", "APEX_CREATED_BY", "APEX_CREATED_ON", "APEX_LAST_UPDATED_BY", "APEX_LAST_UPDATED_ON", "TEST_CODE", "UNQID") AS 
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
        and esst.active_yn = 'Y'
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_INHERITED_TESTS_TREE" ("STANDARD_ID", "STANDARD_NAME", "PARENT_STANDARD_ID", "TEST_ID") AS 
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
inner join v_svt_stds_standards ess2 on ess2.id = esit.standard_id
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_STDS_STANDARD_TESTS_W_INHERITED" ("STANDARD_ID", "TEST_ID", "LEVEL_ID", "URGENCY", "URGENCY_LEVEL", "TEST_NAME", "TEST_CODE", "FULL_STANDARD_NAME", "ACTIVE_YN", "NT_NAME", "QUERY_CLOB", "STD_CREATION_DATE", "MV_DEPENDENCY", "SVT_COMPONENT_TYPE_ID", "COMPONENT_NAME", "STANDARD_ACTIVE_YN", "EXPLANATION", "FIX", "VERSION_NUMBER", "VERSION_DB", "INHERITED_YN", "DISPLAY_SEQUENCE", "ISSUE_CATEGORY") AS 
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
                                           and i.standard_id = esit.parent_standard_id
; 