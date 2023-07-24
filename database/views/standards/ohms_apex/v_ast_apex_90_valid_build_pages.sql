create or replace force view v_SVT_apex_90_valid_build_pages as
select pass_yn,
       unqid, --reference_code,
       application_id,
       page_id,
       created_by,
       created_on,
       LAST_updated_by,
       LAST_updated_on,
       validation_failure_message,
       issue_title,
       standard_code
from SVT_standard_view.v_SVT_apex(
                        p_standard_code => 'VAL_PAGE_BUILD',
                        p_failures_only => 'Y')
/