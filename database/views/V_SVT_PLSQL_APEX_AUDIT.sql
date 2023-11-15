--liquibase formatted sql
--changeset view_script:V_SVT_PLSQL_APEX_AUDIT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_PLSQL_APEX_AUDIT
--------------------------------------------------------

create or replace force editionable view V_SVT_PLSQL_APEX_AUDIT as
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
           (select eba_stds_parser.build_url(
                        p_template_url          => coalesce(fdv.link_url, sct.template_url),
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
           src.mv_dependency,
           paa.owner,
           paa.component_id,
           paa.parent_component_id,
           src.svt_component_type_id,
           src.component_name, 
           fdv.component_type_id, 
           coalesce(fdv.link_url, sct.template_url) template_url,
           src.standard_name,
           src.standard_id,
           vaa.type_code app_type_code,
           vaa.pk_id app_pk_id
    from svt_plsql_apex_audit paa
    inner join v_eba_stds_standard_tests src on paa.test_code  = src.test_code
    inner join svt_component_types sct on sct.id = src.svt_component_type_id
    left outer join v_eba_stds_applications vaa on paa.application_id = vaa.apex_app_id
    left outer join v_svt_flow_dictionary_views fdv on fdv.view_name = src.component_name
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
    p7 => '[General info on issue + fix]('||eba_stds_parser.get_base_url()||'f?p=17000033:1::::1:P1_TEST_CODE:'||a.test_code||')',
    p8 => a.application_id,
    p9 => a.page_id,
    p10 => '[Manage Issue]('||eba_stds_parser.get_base_url()||'f?p=17000033:1::::1:P1_AUDIT_ID:'||a.audit_id||')'
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
    a.created,
    a.updated,
    a.stale_yn,
    a.assignee,
    a.link_url,
    eba_stds_parser.adapt_url( a.link_url ) prepared_url,
    wwv_flow_lang.system_message( 'VIEW_IN_BUILDER' ) view_text,
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
    a.src_recent_change_yn,
    a.legacy_yn,
    a.unqid,
    case when a.include_in_report_yn ='Y'
         then 'N'
         else 'Y'
         end is_exception_yn,
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
/
--rollback drop view V_SVT_PLSQL_APEX_AUDIT;