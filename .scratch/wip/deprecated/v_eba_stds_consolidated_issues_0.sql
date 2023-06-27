/* 
 * Consolidated view of issues, populated by eba_stds_data.record_daily_issue_snapshot
 */
create or replace force view v_eba_stds_consolidated_issues_0 as
with dftl as (
    select 
        85 as char_limit,
        to_date('10-JUL-2022', 'DD-MON-YYYY') job_start_date
    from dual
)
select /*+ RESULT_CACHE */ 
    ati.id,
    ati.reference_code,
    ati.test_id,
    ati.application_id,
    ati.src_id,
    asr.link_to_doc link_to_documentation,
    asr.issue_desc,
    esst.name test_name,
    ess.name standard_name,
    asr.check_type,
    asr.src,
    ata.id action_id,
    ata.notified_yn,
    ata.ignored_yn,
    ata.followup_later_yn,
    asr.urgency,
    asr.urgency_level,
    ati.created  issue_creation_date,
    asr.std_creation_date test_creation_date,
    asr.std_updated_date test_update_date,
    case when ati.created < d.job_start_date
         then 'OLD'
         when ati.created < asr.std_updated_date + 1
         then 'OLD'
         when ati.created > sysdate -1
         then 'TOO NEW'
         else 'NEW'
         end as timing_window,
    case when length(ati.description) > d.char_limit
         then substr(to_char(ati.description),1,d.char_limit)||'...'
         else to_char(ati.description)
         end issue_description
from ast_tracking_issues ati
inner join eba_stds_applications esa on esa.apex_app_id = ati.application_id
inner join eba_stds_standard_type_ref str on esa.type_id = str.type_id
inner join eba_stds_standard_tests esst on str.standard_id = esst.standard_id
                                        and esst.id = ati.test_id
inner join eba_stds_standards ess on ess.id = esst.standard_id 
inner join v_eba_stds_standard_tests asr on ati.test_id = asr.test_id
left join ast_tracking_action ata on ata.ast_tracking_issue_id = ati.id
cross join dftl d
where ati.deleted is null
and ati.description is not null
/