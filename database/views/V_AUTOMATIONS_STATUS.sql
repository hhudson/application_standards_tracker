--liquibase formatted sql
--changeset view_script:V_AUTOMATIONS_STATUS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_AUTOMATIONS_STATUS
--------------------------------------------------------

create or replace force editionable view V_AUTOMATIONS_STATUS as
with aal as (select id, 
                    automation_id, 
                    start_timestamp, 
                    end_timestamp,
                    is_job, 
                    status, 
                    status_code, 
                    dense_rank() OVER (PARTITION BY automation_id order by start_timestamp desc) therank 
             from apex_automation_log)
select aaa.name ||
       case when aal.is_job = 'Yes'
            then ' [scheduled job]'
            else ' [manual run]'
            end job_name, 
       apex_string.get_initials(aaa.name) job_initials,
       aal.status, 
       aal.start_timestamp,
       to_char(aal.start_timestamp, 'DD-MON-YY HH24:MI AM') start_timestamp_char,
       aal.is_job, 
       aaa.application_id, 
       aaa.workspace, 
       aaa.trigger_type, 
       aaa.polling_interval, 
       aaa.polling_last_run_timestamp, 
       aaa.polling_next_run_timestamp, 
       aaa.polling_status_code,
       aal.end_timestamp,
       aal.status_code,
       (select max(message) from apex_automation_msg_log where automation_log_id = aal.id) error_msg
from apex_appl_automations aaa
inner join aal on aaa.automation_id = aal.automation_id
                  and aal.therank = 1
where aaa.application_id = 17000033
and aaa.workspace != 'AST' -- do not install the application in the AST schema, it belongs in the schema of objects being reviewed
/

--rollback drop view V_AUTOMATIONS_STATUS;