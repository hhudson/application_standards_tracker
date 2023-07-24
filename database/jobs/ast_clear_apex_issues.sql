set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:  SVT_clear_apex_issues.sql
--        Date:  
--     Purpose:  Job SVT_clear_apex_issues
--
--------------------------------------------------------------------------------

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -27477);
BEGIN
    $if oracle_apex_version.version < 21
    $then 
        DBMS_SCHEDULER.CREATE_JOB (
                job_name => 'SVT_CLEAR_APEX_ISSUES',
                job_type => 'PLSQL_BLOCK',
                job_action => 'SVT_plsql_review.clear_invalid_exceptions;',
                number_of_arguments => 0,
                start_date => NULL,
                repeat_interval => 'FREQ=DAILY;BYTIME=050000',
                end_date => NULL,
                enabled => FALSE,
                auto_drop => FALSE,
                comments => '');
        
        DBMS_SCHEDULER.enable(
                name => 'SVT_CLEAR_APEX_ISSUES');
   $else
        dbms_output.put_line('use automations not db job');
   $end
exception when already_exists then null;
END;
/

/*
select log_date, job_name, operation, status
from USER_SCHEDULER_JOB_LOG
where job_name = 'EBA_STDS_DATA_RECORD_DAILY_ISSUE_SNAPSHOT'
order by log_date desc
*/

/*
begin
        dbms_scheduler.run_job(job_name => 'EBA_STDS_DATA_RECORD_DAILY_ISSUE_SNAPSHOT');
        commit;
end;
*/