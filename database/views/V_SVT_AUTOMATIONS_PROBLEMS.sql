--liquibase formatted sql
--changeset view_script:V_SVT_AUTOMATIONS_PROBLEMS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_AUTOMATIONS_PROBLEMS
--------------------------------------------------------

create or replace force editionable view V_SVT_AUTOMATIONS_PROBLEMS as
with vas as (select v.*,
                    case when v.status_code != 'SUCCESS'
                         then 'N'
                         when lower(v.job_name) like '%email%' and svt_preferences.get('SVT_EMAIL_API') = 'NA'
                         then 'Y'
                         when lower(v.job_name) like '%apex%' and svt_apex_issue_util.apex_issue_access_yn = 'N'
                         then 'Y'
                         else case when v.start_timestamp < (systimestamp - interval '2' day)
                                   then 'N'
                                   else 'Y'
                                   end
                         end pass_yn
             from v_svt_automations_status v)
select job_name, 
       job_initials, 
       status, 
       start_timestamp log_date, 
       polling_interval,
       start_timestamp_char log_date_char,
       case when error_msg is not null
            then error_msg
            else 'Has the automation stopped? Check on it.'
            end  error_msg
from vas
where pass_yn = 'N'
/

--rollback drop view V_SVT_AUTOMATIONS_PROBLEMS;