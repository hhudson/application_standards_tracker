set long 1000000
set trimspool off
set feedback off
set echo off
set pages 0
set linesize 10

define PROJECT_DIR = "standard_tests"

spool &PROJECT_DIR/temp_script.sql

select apex_string.format(q'[spool standard_tests/%1/tests/%0.json
select svt_deployment.json_content_clob (p_table_name => 'EBA_STDS_STANDARD_TESTS', p_test_code => '%0') thejsonclob from dual;]', vess.test_code, eba_stds.file_name(vess.calling_standard_name) ) stmt
from eba_stds_standards ess
cross join eba_stds_standard_tests_api.v_eba_stds_standard_tests(
        p_standard_id => ess.id,
        p_active_yn => 'Y',
        p_standard_active_yn => 'Y',
        p_published_yn => 'Y'
    ) vess
union all
select distinct apex_string.format(q'[spool standard_tests/%1/ALL_TESTS-%1.json
select svt_deployment.json_content_clob (p_table_name => 'V_EBA_STDS_STANDARD_TESTS_EXPORT', p_standard_id => '%0') thejsonclob from dual;]', standard_id, eba_stds.file_name(full_standard_name) ) stmt
from v_eba_stds_standards_export tet
where all_tests_file_blob is not null
union all
select apex_string.format(q'[spool standard_tests/%1/STANDARD-%1.json
select svt_deployment.json_content_clob (p_table_name => 'EBA_STDS_STANDARDS', p_standard_id => '%0') thejsonclob from dual;]', id, eba_stds.file_name(full_standard_name) ) stmt
from v_eba_stds_standards ess
where active_yn = 'Y'
union all
select apex_string.format(q'[spool standard_tests/ALL_STANDARDS.json
select svt_deployment.json_content_clob (p_table_name => 'EBA_STDS_STANDARDS') thejsonclob from dual;]' ) stmt
from dual
union all
select distinct apex_string.format(q'[spool standard_tests/ALL_TESTS.json
select svt_deployment.json_content_clob (p_table_name => 'V_EBA_STDS_STANDARD_TESTS_EXPORT') thejsonclob from dual;]') stmt
from dual
union all 
select q'[spool standard_tests/README.md
select svt_deployment.markdown_summary thejsonclob from dual;]' stmt
from dual
order by 1;

prompt spool off

spool off

@&PROJECT_DIR/temp_script.sql