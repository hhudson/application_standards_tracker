create or replace force view v_eba_daily_snapshot_job_log as
select job_name, log_date, status
from user_scheduler_job_log
where job_name = 'EBA_STDS_DATA_RECORD_DAILY_ISSUE_SNAPSHOT'
order by log_date desc
/