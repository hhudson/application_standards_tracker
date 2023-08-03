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

select apex_string.format(q'[spool standard_tests/%1/tests/%0.json
select svt_deployment.json_content_clob (p_table_name => 'EBA_STDS_STANDARD_TESTS', p_test_code => '%0') thejsonclob from dual;]', test_code, eba_stds.file_name(standard_name) ) stmt
from v_eba_stds_standard_tests_export tet
where published_yn = 'Y'
union all
select distinct apex_string.format(q'[spool standard_tests/%1/STANDARD-%1.json
select svt_deployment.json_content_clob (p_table_name => 'V_EBA_STDS_STANDARD_TESTS_EXPORT', p_standard_id => '%0') thejsonclob from dual;]', standard_id, eba_stds.file_name(standard_name) ) stmt
from v_eba_stds_standards tet
where file_blob is not null
union all 
select q'[spool standard_tests/README.md
select svt_deployment.markdown_summary thejsonclob from dual;]' stmt
from dual
order by 1;

prompt spool off

spool off

@&PROJECT_DIR/temp_script.sql