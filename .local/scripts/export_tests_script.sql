set long 100000
set trimspool off
set feedback off
set echo off

define PROJECT_DIR = "standard_tests"

spool &PROJECT_DIR/temp_script.sql

prompt set pages 0
prompt set linesize 10
prompt set trimspool off
prompt set feedback off
prompt set echo off

select distinct apex_string.format(q'[spool standard_tests/%0.json
select svt_deployment.json_content_clob (p_table_name => 'EBA_STDS_STANDARD_TESTS', p_test_code => '%0') thejsonclob from dual;]', test_code ) stmt
from v_eba_stds_standard_tests_export
where published_yn = 'Y'
order by 1;

prompt spool off

spool off

@&PROJECT_DIR/temp_script.sql