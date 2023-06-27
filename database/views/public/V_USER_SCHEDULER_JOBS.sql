--liquibase formatted sql
--changeset view_script:V_USER_SCHEDULER_JOBS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_SCHEDULER_JOBS

-- to use when v_automations_log is not available
--------------------------------------------------------

create or replace view v_user_scheduler_jobs as 
select job_name, state, start_date, last_start_date, next_run_date
from user_scheduler_jobs
/
--rollback drop view V_USER_SCHEDULER_JOBS;