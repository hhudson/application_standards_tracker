--------------------------------------------------------
--  DDL for View v_SVT_apex_1_app_auth
--------------------------------------------------------

create or replace force view v_SVT_apex_1_app_auth as
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
                        p_standard_code => 'APP_AUTH',
                        p_failures_only => 'Y',
                        p_production_apps_only => 'Y')
/