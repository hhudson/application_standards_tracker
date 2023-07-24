--------------------------------------------------------
--  DDL for View v_SVT_job_status
--------------------------------------------------------

create or replace force editionable view v_SVT_job_status as
select z.log_date, z.status
from (
    select log_date, status
    from user_scheduler_job_log
    where job_name = 'EBA_STDS_DATA_RECORD_DAILY_ISSUE_SNAPSHOT'
    order by log_date desc
) z
fetch first 1 rows only
/