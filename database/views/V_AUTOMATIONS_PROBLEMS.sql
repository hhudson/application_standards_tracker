--liquibase formatted sql
--changeset view_script:V_AUTOMATIONS_PROBLEMS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_AUTOMATIONS_PROBLEMS
--------------------------------------------------------

create or replace force editionable view V_AUTOMATIONS_PROBLEMS as
with vas as (select v.*,
                    case when v.status_code != 'SUCCESS'
                         then 'N'
                         when v.start_timestamp < (systimestamp - interval '1' day)
                         then 'N'
                         else 'Y'
                         end pass_yn
             from v_automations_status v)
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

--rollback drop view V_AUTOMATIONS_PROBLEMS;