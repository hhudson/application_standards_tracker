/* Pages should require authentication and should not have access protection set to 'Unrestricted' 
to do : prioritize apps that have  :
      - items that are session state protection unrestricted
*/

create or replace force view v_ast_apex_30_page_access_protection as
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
                        p_standard_code => 'PAGE_ACCESS_PROTECTION',
                        p_failures_only => 'Y')
/