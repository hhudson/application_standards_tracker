create or replace force view v_ast_apex_40_page_auth as
select pass_yn,
       unqid, 
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
                        p_standard_code => 'PAGE_AUTH',
                        p_failures_only => 'Y')
/