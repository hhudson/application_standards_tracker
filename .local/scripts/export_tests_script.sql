set long 1000000
set trimspool off
set feedback off
set echo off
set pages 0
set linesize 10

define PROJECT_DIR = "standard_tests"

spool &PROJECT_DIR/temp_script.sql

select apex_string.format(q'[spool standard_tests/%1/tests/%3
select svt_deployment.json_standard_tests_clob (p_standard_id => %2, p_test_code => '%0') thejsonclob from dual;]', vess.test_code, svt_stds.file_name(vess.calling_standard_name), ess.id, vess.file_name) stmt
from svt_stds_standards ess
cross join svt_stds_standard_tests_api.v_svt_stds_standard_tests(
        p_standard_id => ess.id,
        p_active_yn => 'Y',
        p_standard_active_yn => 'Y',
        p_published_yn => 'Y'
    ) vess
union all
select distinct apex_string.format(q'[spool standard_tests/%1/ALL_TESTS-%1.json
select svt_deployment.json_standard_tests_clob (p_standard_id => '%0') thejsonclob from dual;]', standard_id, svt_stds.file_name(full_standard_name) ) stmt
from v_svt_stds_standards_export tet
where all_tests_file_blob is not null
union all
-- select distinct apex_string.format(q'[spool standard_tests/ALL_TESTS.json
-- select svt_deployment.json_content_clob (p_table_name => 'V_SVT_STDS_STANDARD_TESTS_EXPORT') thejsonclob from dual;]') stmt
-- from dual
-- union all 
select q'[spool standard_tests/README.md
select svt_deployment.markdown_summary thejsonclob from dual;]' stmt
from dual
order by 1;

prompt spool off

spool off

@&PROJECT_DIR/temp_script.sql