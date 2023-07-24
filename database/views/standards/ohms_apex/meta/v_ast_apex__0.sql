--------------------------------------------------------
--  DDL for View v_SVT_apex__0
--------------------------------------------------------

create or replace force editionable view v_SVT_apex__0 as
select pass_yn,
       unqid,
       application_id,
       page_id,
       created_by,
       created_on,
       LAST_updated_by,
       LAST_updated_on,
       validation_failure_message,
       issue_title,
       standard_code
from v_eba_stds_standard_tests esst
join SVT_standard_view.v_SVT_apex(p_standard_code => esst.standard_code, 
                                  p_failures_only => 'Y',
                                  p_production_apps_only => 'Y') 
                                          on  esst.nt_name = 'V_SVT_APEX__0_NT'
                                          and esst.query_clob is not null
                                          and esst.active_yn = 'Y'
/