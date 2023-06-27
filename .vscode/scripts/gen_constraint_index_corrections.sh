#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source $SCRIPT_DIR/../../.local/scripts/helper.sh

# File can be referenced either as a full path or relative path
TABLE_NAME=$3
FILE_FULL_PATH=$2
FILE_RELATIVE_PATH=$1
UTABLE_NAME=$(echo $TABLE_NAME | tr 'a-z' 'A-Z')
EP_FILE_NAME='EP_'$UVIEW_NAME$(date +"_%d%b%Y_%H:%M")
UEP_FILE_NAME=$(echo $EP_FILE_NAME | tr 'a-z' 'A-Z')
PROJECT_DIR='database/adhoc_scripts'
GIT_EMAIL=$(git config user.email)
echo "GIT_EMAIL : ${GIT_EMAIL}"

# VSCODE_TASK_COMPILE_FILE should be defined in user-config.sh
if [ -z "$VSCODE_TASK_COMPILE_FILE" ]; then
  echo -e "${COLOR_ORANGE} Warning: VSCODE_TASK_COMPILE_FILE is not defined.${COLOR_RESET}\nSet VSCODE_TASK_COMPILE_FILE in $USER_CONFIG_FILE"
  echo -e "Defaulting to full path"
  VSCODE_TASK_COMPILE_FILE=$FILE_FULL_PATH
fi
# Since VSCODE_TASK_COMPILE_FILE contains the variable reference need to evaluate it here
VSCODE_TASK_COMPILE_FILE=$(eval "echo $VSCODE_TASK_COMPILE_FILE")

# explain plan
# explain_plan $TABLE_NAME  $PROJECT_DIR
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

PRO step 1 : make sure $UTABLE_NAME exists in dev_table_abbreviations

begin
    insert into dev_table_abbreviations 
    (schema_name, table_name, table_domain, table_alias, table_abbreviation, production_table, inc_cssap_compliance, review_status,created_by, updated_by)
    values
    ('CARS',
    '$UTABLE_NAME',
    dev_support_utils.table_abbreviation(p_table_name => '$UTABLE_NAME', p_attribute => 'TABLE_DOMAIN'),
    dev_support_utils.table_abbreviation(p_table_name => '$UTABLE_NAME', p_attribute => 'TABLE_ALIAS'),
    dev_support_utils.table_abbreviation(p_table_name => '$UTABLE_NAME', p_attribute => 'TABLE_ABBREVIATION'),
    'Y','Y', 'R',
    '$GIT_EMAIL','$GIT_EMAIL');
    dbms_output.put_line('inserted table into dev_table_abbreviations');
exception when dup_val_on_index then null;
end;
/
--
-- 
--
show errors
exit;
EOF

# explain plan
# explain_plan $TABLE_NAME  $PROJECT_DIR
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

PRO step 2 : generate correction script for $UTABLE_NAME

spool $PROJECT_DIR/$UTABLE_NAME.sql
select 
apex_string.format(
    p_message => 
    'alter table %0 rename constraint "%1" to "%2";
    ',
    p0 => b.table_name,
    p1 => b.constraint_name,
    p2 => b.correct_name
    ) thecode
from (  
        select ac.table_name, ac.constraint_name,  dev_support_utils.valid_constr_name(
                                                                          p_constraint_name => ac.constraint_name, 
                                                                          p_option => 'COMPLIANT_NAME',
                                                                          p_table_name => ac.table_name
                                                                        ) correct_name
        from user_constraints ac
        where ac.table_name = '$UTABLE_NAME'
     ) b
where b.constraint_name != b.correct_name
union all 
select apex_string.format(
    p_message => 
    'alter index "%1" rename to "%2";
    ',
    p0 => bi.table_name,
    p1 => bi.index_name,
    p2 => bi.correct_name
    ) thecode
from ( 
        select ai.table_name, ai.index_name, dev_support_utils.valid_index_name  ( 
                                       p_index_name       => ai.index_name
                                     , p_option           => 'COMPLIANT_NAME') correct_name
        from user_indexes ai
        where ai.table_name = '$UTABLE_NAME'
    ) bi
where bi.index_name != bi.correct_name
union all
select '-- missing indexes on foreign keys: '
from dual
union all
select apex_string.format(
    p_message => 
    'create index %0 on %1(%2);
    ',
    p0 => replace(z.constraint_name, 'FK', 'IDX'),
    p1 => z.table_name,
    p2 => z.columns
    ) thecode
from (
select table_name, constraint_name,
   cname1 || nvl2(cname2,','||cname2,null) ||
   nvl2(cname3,','||cname3,null) || nvl2(cname4,','||cname4,null) ||
   nvl2(cname5,','||cname5,null) || nvl2(cname6,','||cname6,null) ||
   nvl2(cname7,','||cname7,null) || nvl2(cname8,','||cname8,null)
          columns
from ( select b.table_name,
              b.constraint_name,
              max(decode( position, 1, column_name, null )) cname1,
              max(decode( position, 2, column_name, null )) cname2,
              max(decode( position, 3, column_name, null )) cname3,
              max(decode( position, 4, column_name, null )) cname4,
              max(decode( position, 5, column_name, null )) cname5,
              max(decode( position, 6, column_name, null )) cname6,
              max(decode( position, 7, column_name, null )) cname7,
              max(decode( position, 8, column_name, null )) cname8,
              count(*) col_cnt
         from (select substr(table_name,1,30) table_name,
                      substr(constraint_name,1,30) constraint_name,
                      substr(column_name,1,30) column_name,
                      position
                 from user_cons_columns
                 where table_name = '$UTABLE_NAME') a,
              user_constraints b
        where a.table_name = b.table_name
          and a.constraint_name = b.constraint_name
          and b.constraint_type = 'R'
        group by b.table_name, b.constraint_name
     ) cons
where col_cnt > ALL
       ( select count(*)
           from user_ind_columns i
          where i.table_name = '$UTABLE_NAME'
            and i.table_name = cons.table_name
            and i.column_name in (cname1, cname2, cname3, cname4,
                                  cname5, cname6, cname7, cname8 )
            and i.column_position <= cons.col_cnt
          group by i.index_name
       )
    ) z
;

spool off
--
-- 
--
set define on
show errors
exit;
EOF

code $PROJECT_DIR/$UTABLE_NAME.sql