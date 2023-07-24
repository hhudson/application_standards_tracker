/* 
 * Public pages should be public but they can be victims of an over-zealous 
 * attempt to give all pages an authorization scheme
 */

create or replace force view v_SVT_apex_60_public_pages_public_auth as
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
                        p_standard_code => 'PUBLIC_PAGE_PUBLIC_AUTH',
                        p_failures_only => 'Y')
/