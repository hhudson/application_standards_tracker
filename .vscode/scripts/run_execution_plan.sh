#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
echo "Load Helper for explain_plan"
source $SCRIPT_DIR/../../.local/scripts/helper.sh

# File can be referenced either as a full path or relative path
FILE_DIR="$4"
VIEW_NAME="$3"
FILE_FULL_PATH="$2"
FILE_RELATIVE_PATH="$1"

UVIEW_NAME=$(echo $VIEW_NAME | tr 'a-z' 'A-Z')
EP_FILE_NAME='EP_'$UVIEW_NAME$(date +"_%d%b%Y_%H:%M")
UEP_FILE_NAME=$(echo $EP_FILE_NAME | tr 'a-z' 'A-Z')
echo $UEP_FILE_NAME
# PROJECT_NAME=$2
PROJECT_DIR='database'
ROW_LIMIT=10000

# VSCODE_TASK_COMPILE_FILE should be defined in user-config.sh
if [ -z "$VSCODE_TASK_COMPILE_FILE" ]; then
  echo -e "${COLOR_ORANGE} Warning: VSCODE_TASK_COMPILE_FILE is not defined.${COLOR_RESET}\nSet VSCODE_TASK_COMPILE_FILE in $USER_CONFIG_FILE"
  echo -e "Defaulting to full path"
  VSCODE_TASK_COMPILE_FILE=$FILE_FULL_PATH
fi
# Since VSCODE_TASK_COMPILE_FILE contains the variable reference need to evaluate it here
VSCODE_TASK_COMPILE_FILE=$(eval "echo $VSCODE_TASK_COMPILE_FILE")

# explain plan
# explain_plan $VIEW_NAME  $PROJECT_DIR
# run sqlplus, execute the script, then get the error list and exit
# VSCODE_TASK_COMPILE_BIN is set in the config.sh file (either sqlplus or sqlcl)
$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set define off
set pagesize 0
set heading off
set feedback off
set wrap off
set linesize 3000
--
-- Load user specific commands here
PRO Task : generating execution plan for for $UVIEW_NAME

PRO step 0 : compile $UVIEW_NAME
@$VSCODE_TASK_COMPILE_FILE

PRO step 1 : gathering stats on SCH_REGISTRANT_PROCEDURES
-- exec dbms_stats.gather_table_stats ( null, 'SCH_REGISTRANT_PROCEDURES', no_invalidate => false );

PRO step 2 : querying 1st $ROW_LIMIT rows of $UVIEW_NAME
select /*+ gather_plan_statistics */ * from $UVIEW_NAME fetch first $ROW_LIMIT rows only;

-- select distinct referenced_name
-- from all_dependencies
-- where name = 'V_REGISTRANT_PROCEDURES_ALL'
-- and referenced_type = 'TABLE'



PRO step 3 : capturing execution plan
spool $PROJECT_DIR/views/$UEP_FILE_NAME.sql
select p.*  
from   v\$sql s, table (  
  dbms_xplan.display_cursor (  
    s.sql_id, s.child_number, 'IOSTATS LAST'  
  )  
) p  
where s.sql_text like '%select /*+ gather_plan_statistics */ * from $UVIEW_NAME fetch first $ROW_LIMIT rows only%'
and s.sql_text not like '%dbms_xplan.display_cursor%'
and s.sql_text not like '%v\$sql%'
order by s.first_load_time desc
;
spool off

--
-- 
--
set define on
show errors
exit;
EOF

code $PROJECT_DIR/views/$UEP_FILE_NAME.sql