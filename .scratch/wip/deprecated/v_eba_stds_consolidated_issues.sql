/* 
 * Consolidated view of issues, populated by eba_stds_data.record_daily_issue_snapshot
 * deprecated
 */
create or replace force view v_eba_stds_consolidated_issues as
select /*+ RESULT_CACHE */ 
    sci.id,
    sci.reference_code,
    sci.test_id,
    sci.application_id,
    sci.src_id,
    eba_stds_parser.build_link( p_test_id => sci.test_id, 
                                p_param   => sci.reference_code) link_to_underlying_element,
    sci.link_to_documentation,
    sci.issue_desc,
    sci.test_name,
    sci.standard_name,
    sci.check_type,
    sci.src,
    sci.action_id,
    sci.notified_yn,
    sci.ignored_yn,
    sci.followup_later_yn,
    sci.urgency,
    sci.urgency_level,
    sci.issue_creation_date,
    sci.test_creation_date,
    sci.test_update_date,
    sci.timing_window,
    sci.issue_description
from v_eba_stds_consolidated_issues_0 sci
/