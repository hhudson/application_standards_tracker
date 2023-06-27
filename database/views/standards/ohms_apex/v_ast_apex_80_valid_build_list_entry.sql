/* List entries should not have a build option that excludes them or an invalid build option indefinitely */
create or replace force view v_ast_apex_80_valid_build_list_entry as
select pass_yn,
       reference_code,
       application_id,
       page_id,
       created_by,
       created_on,
       last_updated_by,
       last_updated_on,
       validation_failure_message,
       issue_title,
       standard_code
from ast_standard_view.v_ast_apex(
                        p_standard_code => 'VAL_BUILD_LIST_ENTRY',
                        p_failures_only => 'Y')
/