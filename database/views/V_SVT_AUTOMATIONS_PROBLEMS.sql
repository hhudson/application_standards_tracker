--liquibase formatted sql
--changeset view_script:V_SVT_AUTOMATIONS_PROBLEMS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_AUTOMATIONS_PROBLEMS
--------------------------------------------------------

create or replace force editionable view V_SVT_AUTOMATIONS_PROBLEMS as
with vas as (select v.*,
                    case when v.status_code != 'SUCCESS'
                         then 'N'
                         when v.job_initials in ('6D')
                         then case when v.start_timestamp < (systimestamp - INTERVAL '2' DAY)
                                   then 'N'
                                   else 'Y'
                                   end
                         when v.start_timestamp < (systimestamp - interval '1' day)
                         then 'N'
                         else 'Y'
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