--------------------------------------------------------
--  DDL for Scheduler Job CHANGEME
--------------------------------------------------------

begin
    dbms_scheduler.create_job (
            job_name => 'CHANGEME',
            job_type => 'PLSQL_BLOCK',
            job_action => 'CHANGEME',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => 'FREQ=DAILY;BYTIME=030000',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => '');
    
    dbms_scheduler.enable(name => 'CHANGEME');
end;
/

