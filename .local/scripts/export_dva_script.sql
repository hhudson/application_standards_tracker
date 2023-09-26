set long 1000000
set trimspool off
set feedback off
set echo off
set pages 0
set linesize 10

define PROJECT_DIR = "standard_tests"

spool &PROJECT_DIR/temp_dva_script.sql

select apex_string.format(q'[spool standard_tests/.results/AUDIT_DVA_EXPORT_%0DB_%1.json
select svt_deployment.json_content_clob (p_table_name => 'V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT') thejsonclob from dual;]',
p0 => coalesce(svt_preferences.get_preference ('SVT_DB_NAME'),'MYSTERY'),
p1=> to_char(sysdate,'DDMONYYYY')) stmt
from dual;

prompt spool off

spool off

@&PROJECT_DIR/temp_dva_script.sql