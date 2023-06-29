create or replace force view v_ast_apex_10_accessibility_col_alt_text as
select pass_yn,
       unqid, --reference_code,
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
                        p_standard_code => 'COL_ALT_TEXT',
                        p_failures_only => 'Y')
/