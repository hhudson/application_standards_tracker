create or replace force view v_ast_apex_3_app_item_naming as
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
                        p_standard_code => 'APP_ITEM_NAMING',
                        p_failures_only => 'Y')
/
