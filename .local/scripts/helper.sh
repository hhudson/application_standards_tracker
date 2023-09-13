#!/bin/bash

# Global variables
# Find the current path this script is in
# This needs to be run outside of any functions as $0 has different meaning in a function
# If this script is being called from using "source ..." then ${BASH_SOURCE[0]} evaluates to null Use $0 instead
# echo "log : helper.sh file"
if [ -z "${BASH_SOURCE[0]}" ] ; then 
  SCRIPT_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
  # echo "log : SCRIPT_DIR 1 : $SCRIPT_DIR"
else 
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# echo "log : SCRIPT_DIR 2 : $SCRIPT_DIR"
fi
# Root folder in project directory
LOCAL_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="$(dirname "$LOCAL_DIR")"
# echo "log : SCRIPT_DIR: $SCRIPT_DIR"
# echo "log : PROJECT_DIR: $PROJECT_DIR"


# Load colors
# To use colors: echo -e "${COLOR_RED}this is red${COLOR_RESET}"
load_colors(){
  # echo "log : load_colors"
  # Colors for bash. See: http://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
  COLOR_LIGHT_GREEN='\033[0;92m'
  COLOR_ORANGE='\033[0;33m'
  COLOR_RED='\033[0;31m'
  COLOR_RESET='\033[0m' # No Color

  FONT_BOLD='\033[1m'
  FONT_RESET='\033[22m'
} # load_colors

# Load the config file stored in scripts/config
load_config(){
  # echo "log : load_config"
  USER_CONFIG_FILE=$PROJECT_DIR/.local/scripts/user-config.sh
  PROJECT_CONFIG_FILE=$PROJECT_DIR/.local/scripts/project-config.sh
  # echo "log : USER_CONFIG_FILE: $USER_CONFIG_FILE"
  # echo "log : PROJECT_CONFIG_FILE: $PROJECT_CONFIG_FILE"

  if [[ ! -f $USER_CONFIG_FILE ]] ; then
    echo -e "${COLOR_RED}Warning: database connection configuration is missing ${COLOR_RESET}"
    echo -e "${FONT_BOLD}Modify $USER_CONFIG_FILE${FONT_RESET} with your DB connection string and APEX applications"
    cat > "$USER_CONFIG_FILE" <<EOL
#!/bin/bash

# [GBU Confluence Page](https://gbuconfluence.us.oracle.com/display/CDSTS/How+to+use+the+VSCode+Integrations+in+the+dms_utplsql+and+dms+repos)
# If you need to register any aliases in bash uncomment these lines
# shopt -s expand_aliases
# This should reference where you store aliases (or manually define them)
# source ~/.aliases.sh

# Connection string to development environment
## for a Mac computer :
DB_CONN="/nolog :@/Users/hayhudso/sql_connections/connect_dev.sql"
## for a PC :
# DB_CONN="//nolog :@\C:\sql_connections\connect_dev.sql"

# SQLcl binary (either sql or sqlcl depending on if you changed anything)
# If using a docker container for SQLcl ensure the run alias does not include the "-it" option as TTY is not necessary for these scripts
SQLCL=sql

# sql*plus binary
# If using a docker container for sqlplus ensure the run alias does not include the "-it" option as TTY is not necessary for these scripts
SQLPLUS=sqlplus


# *** VSCode settings ***

# Compile file: chose $SQLCL or $SQLPLUS
VSCODE_TASK_COMPILE_BIN=\$SQLCL

# File to compile. Options:
# \\\$FILE_RELATIVE_PATH: Will evaluate to relative to project ex: views/my_view.sql
# \\\$p_file_full_path: Will evalutate to full path to file ex:
# 
# If using sqlplus for docker an example may be:
# VSCODE_TASK_COMPILE_FILE=/sqlplus/\\\$FILE_RELATIVE_PATH 
# Note: You need to escape the "$" here so it should say "\\\$p_file_full_path"
VSCODE_TASK_COMPILE_FILE=\\\$p_file_full_path

# This code will be run before the file is executed
read -d '' VSCODE_TASK_COMPILE_SQL_PREFIX << EOF
-- Add any custom alter statements etc here
alter session set plsql_warnings = 'ENABLE:ALL';
alter session set plscope_settings='IDENTIFIERS:ALL, STATEMENTS:ALL';
EOF

EOL
    chmod 755 "$USER_CONFIG_FILE"
    # echo "log : just newly created user-config.sh"
    code .local/scripts/user-config.sh
    exit
  fi

  # Load project config
  source "$PROJECT_CONFIG_FILE"
  # Load user config
  source "$USER_CONFIG_FILE"
  # echo "log : end load_config"
} # load_config


# Verifies configuration
verify_config(){
  # echo "log : verify_config"
  # SCHEMA_NAME is required
  if [[ $SCHEMA_NAME = "CHANGEME" ]] || [[ -z "$SCHEMA_NAME" ]]; then
    echo -e "${COLOR_RED}SCHEMA_NAME is not configured.${COLOR_RESET} Modify $PROJECT_CONFIG_FILE"
    exit
  fi
  
  # APEX_APP_IDS should be blank or list of IDs and not what is provided by default
  if [[ $APEX_APP_IDS = "CHANGEME" ]]; then
    echo -e "${COLOR_RED}APEX_APP_IDS is not configured.${COLOR_RESET} Modify $PROJECT_CONFIG_FILE"
    exit
  fi

  # APEX_WORKSPACE should be blank or list of IDs and not what is provided by default
  if [[ $APEX_WORKSPACE = "CHANGEME" ]]; then
    echo -e "${COLOR_RED}APEX_WORKSPACE is not configured.${COLOR_RESET} Modify $PROJECT_CONFIG_FILE"
    exit
  fi

  # Check that DB connection string is defined
  if [[ $DB_CONN == *"CHANGME_USERNAME"* ]]; then
    echo -e "${COLOR_RED}DB_CONN is not configured.${COLOR_RESET} Modify $USER_CONFIG_FILE"
    code .local/scripts/user-config.sh
    exit
  fi
  # echo "log : end verif_config"
} # verify_config


# Export APEX applications
# Parameters
# $1 Version number
export_apex_app(){
  # echo "log : export_apex_app"

  local p_apex_id="17000033"
  # echo "log : p_apex_id : ${p_apex_id}"

    echo "APEX Export: $p_apex_id"

    # Export single file app
    cd $PROJECT_DIR
    cd "apex"
    # echo "log : $(pwd)"

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set serveroutput on
set define off
set pagesize 0
set heading off
set feedback off
set wrap off
set linesize 3000
--
-- Load user specific commands here
apex export -applicationid $p_apex_id -dir f$p_apex_id 
--
-- 
--
show errors
exit;
EOF
}

# Export APEX applications
# Parameters
# $1 Version number
export_apex_app_readable_yaml(){
  # echo "log : export_apex_app_readable_yaml"

  local p_apex_id="17000033"
  # echo "log : p_apex_id : ${p_apex_id}"

    echo "APEX Export Readable YAML: $p_apex_id"

    # Export single file app
    cd $PROJECT_DIR
    cd "apex"
    # echo "log : $(pwd)"

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set serveroutput on
set define off
set pagesize 0
set heading off
set feedback off
set wrap off
set linesize 3000
--
-- Load user specific commands here

apex export -applicationid $p_apex_id -dir f$p_apex_id -expType READABLE_YAML
--
-- 
--
show errors
exit;
EOF
}


# Resets release/code/_run_code.sql and deletes all files in release/code directory
# 
# Parmaters
# $1 confirmation root folder name. Given that this will delete files in the release folder want to make sure we're deleting files where expexcted.
#  For example this starter project exsts in /users/martin/git/starter-project-template
#  For this function to work you must call: reset_release starter-project-template
reset_release(){
  local CONFIRMATION_DIR=$1
  local PROJECT_DIR_FOLDER_NAME=${PROJECT_DIR##*/}

  if [[ $CONFIRMATION_DIR != $PROJECT_DIR_FOLDER_NAME ]]; then
    echo -e "${COLOR_RED}Error: ${COLOR_RESET} confirmation directory missing or not matching. Correct value is: $PROJECT_DIR_FOLDER_NAME"
    # exit 1
  else
    # Clear release-specific code
    rm $PROJECT_DIR/release/code/*.sql
    # Reset _run_code.sql file
    echo "-- Release specific references to files in this folder" > $PROJECT_DIR/release/code/_run_code.sql
    echo "-- This file is automatically executed from the /release/_release.sql file" >>$PROJECT_DIR/release/code/_run_code.sql
    echo "-- \n-- Ex: @code/issue-123.sql \n" >>$PROJECT_DIR/release/code/_run_code.sql
  fi
} # reset_release



# List all files in directory
#
# Parameters
# $1: Folder (relative to root project folder) to list all the files from. Ex: views
# $2: File (relative to root project folder) to store the list of files in: ex: release/all_views.sql
# $3: Comma delimited list of file extensions to search for. Ex: pks,pkb. Default sql
list_all_files(){

  local FOLDER_NAME=$1
  local OUTPUT_FILE=$2
  local FILE_EXTENSION_ARR=$3

  local RUN_HELP="get_all_files <relative_folder_name> <relative_output_file> <optional: file_extension_list>
The following example will list all the .sql files in ./views and reference them in release/all_views.sql

get_all_files views release/all_views.sql sql

For packages it's useful to list the extensions in order as they should be compiled. Ex: pks,pkb to compile spec before body
"
  
  # Validation
  if [ -z "$FOLDER_NAME" ]; then
    echo "${COLOR_RED}Error: ${COLOR_RESET} Missing folder name"
    echo "\n$RUN_HELP"
    return 1
  elif [ -z "$OUTPUT_FILE" ]; then
    echo "${COLOR_RED}Error: ${COLOR_RESET} Missing output file"
    echo "\n$RUN_HELP"
    return 1
  fi

  # Defaulting extensions
  if [ -z "$FILE_EXTENSION_ARR" ]; then
    FILE_EXTENSION_ARR="sql"
  fi

  echo "-- GENERATED from build/build.sh DO NOT modify this file directly as all changes will be overwritten upon next build" > $PROJECT_DIR/$OUTPUT_FILE
  echo "-- Automated listing for $FOLDER_NAME" >> $PROJECT_DIR/$OUTPUT_FILE
  for FILE_EXT in $(echo $FILE_EXTENSION_ARR | sed "s/,/ /g"); do

    echo "Listing files in: $PROJECT_DIR/$FOLDER_NAME extension: $FILE_EXT"
    for file in $PROJECT_DIR/$FOLDER_NAME/*.$FILE_EXT; do
    # for file in $PROJECT_DIR/$FOLDER_NAME/*.sql; do
    # for file in $(ls $PROJECT_DIR/$FOLDER_NAME/*.sql ); do
      echo "prompt @../$FOLDER_NAME/${file##*/}" >> $OUTPUT_FILE
      echo "@../$FOLDER_NAME/${file##*/}" >> $OUTPUT_FILE
    done
  done

} # list_all_files



# Builds files required for the release
# Should be called in build/build.sh
# 
# Issue: #28
gen_release_sql(){
  local loc_env_vars="$PROJECT_DIR/release/load_env_vars.sql"
  local loc_apex_install_all="$PROJECT_DIR/release/all_apex.sql"

  # Build helper sql file to load specific env variables into SQL*Plus session
  echo "-- GENERATED from build/build.sh DO NOT modify this file directly as all changes will be overwritten upon next build\n\n" > $loc_env_vars
  echo "define env_schema_name=$SCHEMA_NAME" >> $loc_env_vars
  echo "define env_apex_app_ids=$APEX_APP_IDS" >> $loc_env_vars
  echo "define env_apex_workspace=$APEX_WORKSPACE" >> $loc_env_vars
  echo "" >> $loc_env_vars
  echo "
prompt ENV variables
select 
  '&env_schema_name.' env_schema_name,
  '&env_apex_app_ids.' env_apex_app_ids,
  '&env_apex_workspace.' env_apex_workspace
from dual;

" >> $loc_env_vars

  # Build helper file to install all APEX applications
  echo "-- GENERATED from build/build.sh DO NOT modify this file." > $loc_apex_install_all
  echo "prompt *** APEX Installation ***" >> $loc_apex_install_all
  for APEX_APP_ID in $(echo $APEX_APP_IDS | sed "s/,/ /g"); do
    echo "prompt *** App: $APEX_APP_ID ***" >> $loc_apex_install_all
    echo "@../scripts/apex_install.sql $SCHEMA_NAME $APEX_WORKSPACE $APEX_APP_ID" >> $loc_apex_install_all
  done
} #gen_release_sql



# #36 Create new files quickly based on template files
# 
# See scripts/project-config.sh on how to define the various object types
# 
# Actions:
# - Create a new file in defined destination folder
# - Based on template
# - Replace all referneces to CHANGEME with the object name
#
# Parameters
# $1 Object type
# $2 Object Name
gen_object(){
  # echo "log : gen object"
  # Parameters
  local p_object_type=$1
  local p_object_name=$2
  local p_u_object_name=$(echo $p_object_name | tr 'a-z' 'A-Z')
  local p_db_folder='database'
  local p_email=$(git config user.email)
  # echo "log :p_email : ${p_email}"
  local p_date=$(date +"%Y-%b-%d %H:%M")
  # echo "log :p_date : ${p_date}"


  # Loop variables
  local object_type_arr
  local object_type
  local object_template
  local object_dest_folder
  local object_dest_file

  # OBJECT_FILE_TEMPLATE_MAP is defined in scripts/project-config.sh
  for object_type in $(echo $OBJECT_FILE_TEMPLATE_MAP | sed "s/,/ /g"); do

    object_type_arr=(`echo "$object_type" | sed 's/:/ /g'`)

    # In bash arrays start at 0 whereas in zsh they start at 1
    # Only way to make array reference compatible with both is to specify the offset and length
    # See: https://stackoverflow.com/questions/50427449/behavior-of-arrays-in-bash-scripting-and-zsh-shell-start-index-0-or-1/50433774
    object_type=${object_type_arr[@]:0:1}
    object_template=${object_type_arr[@]:1:1}
    object_file_exts=${object_type_arr[@]:2:1}

    if [[ "$p_object_type" == "$object_type" ]]; then
      # echo "log : object_dest_folder :$object_dest_folder"
      # echo "log : db folder :$p_db_folder"
      # echo "log : object name :$p_u_object_name"
      # echo "log : object name :$p_u_object_name"

      for file_ext in $(echo $object_file_exts | sed "s/;/ /g"); do
         if [[ $file_ext == "pkb" ]]; then
          object_dest_folder="package_bodies"
        else 
          object_dest_folder=${object_type_arr[@]:3:1}
        fi
        object_dest_file="$PROJECT_DIR/$p_db_folder/$object_dest_folder/$p_u_object_name.sql"
        # echo "log : object_dest_folder :$object_dest_folder"

        if [[ -f $object_dest_file ]]; then
          echo "${COLOR_ORANGE}File already exists:${COLOR_RESET} $object_dest_file"
        else
           cp .local/$object_template.$file_ext "$object_dest_file"
          sed -i.bak -e "s/CHANGEME/$p_object_name/g" -e "s/GITUSER/$p_email/g" -e "s/THEDATE/$p_date/g" -- "$object_dest_file" && rm -- "$object_dest_file.bak"

          echo "Created: $object_dest_file"

          # Open file in code
          code "$object_dest_file"
        fi
      done

      break # No longer need to loop through other definitions
    fi

  done # OBJECT_FILE_TEMPLATE_MAP

} # gen_object


refresh_sert_scripts(){
  # echo "log  :run refresh_sert_scripts"
  FOLDER_PATH="database/views/standards/apex_sert"
  # echo "log  :FOLDER_PATH = '$FOLDER_PATH'"
  local p_git_email=$1
  # echo "log  :p_git_email = '$p_git_email'"

  echo "Listing files in: $FOLDER_PATH extension: $EXT_VIEW"
for file in $FOLDER_PATH/*.$EXT_VIEW; do
  local p_file_name_w_ext="${file##*/}"
  local p_view_name=$(echo ${p_file_name_w_ext/.$EXT_VIEW/})
  # echo "log  :p_view_name = $p_view_name"

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set define off
set pagesize 0
set heading off
set feedback off
set wrap off
set linesize 3000

PRO step 1 : generate view script for $p_view_name

spool $FOLDER_PATH/$p_view_name.$EXT_VIEW
select column_value
from apex_string.split(svt_apex_sert_util.generate_svt_view(
                              p_view_name => '$p_view_name',
                              p_author => '$p_git_email'), '
');
spool off
--
-- 
--
set define on
show errors
exit;
EOF

done

} # refresh_sert_scripts


refresh_meta_sert_view(){
  # echo "log  :run refresh_meta_sert_view"
  FOLDER_PATH="database/views/standards/apex_sert/meta"
  # echo "log  :FOLDER_PATH = '$FOLDER_PATH'"
  local p_git_email=$1

  local p_meta_view='V_SVT_SERT__0'

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set define off
set pagesize 0
set heading off
set feedback off
set wrap off
set linesize 3000

PRO step 2 : generate meta view script for $p_meta_view

spool $FOLDER_PATH/$p_meta_view.$EXT_VIEW
select column_value
from apex_string.split(svt_apex_sert_util.generate_union_view(
                              p_author => '$p_git_email'), '
');
spool off
--
-- 
--
set define on
show errors
exit;
EOF

code $FOLDER_PATH/$p_meta_view.$EXT_VIEW

}

name_fixer(){
  local p_utable_name="$1"
  # echo "log :p_utable_name : ${p_utable_name}"
  local p_file_dir_name="$4"
  # echo "log :p_file_dir_name : ${p_file_dir_name}"
  local p_project_path=$(echo ${p_file_dir_name/database\/tables/database})
  # echo "log :p_project_path : ${p_project_path}"
  local p_email=$(git config user.email)
  # echo "log :p_email : ${p_email}"
if [[ "$p_dir_name" == *"tables"* ]]; then
    # echo "log : this is the correct directory"

  cp $SCRIPT_DIR/name_fixer/name_fixer.sql         $p_project_path
  cp $SCRIPT_DIR/name_fixer/gen_fk_renames.sql     $p_project_path
  cp $SCRIPT_DIR/name_fixer/gen_ix_renames.sql     $p_project_path
  cp $SCRIPT_DIR/name_fixer/gen_non_fk_renames.sql $p_project_path

  cd $p_project_path


$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set serveroutput on
set define off
set pagesize 0
set heading off
set feedback off
set wrap off
set linesize 3000
--
-- Load user specific commands here

PRO make sure $p_utable_name exists in dev_table_abbreviations

begin
    insert into dev_table_abbreviations 
    (schema_name, table_name, table_domain, table_alias, table_abbreviation, production_table, inc_cssap_compliance, review_status,created_by, updated_by)
    values
    ('CARS',
    '$p_utable_name',
    dev_support_utils.table_abbreviation(p_table_name => '$p_utable_name', p_attribute => 'TABLE_DOMAIN'),
    dev_support_utils.table_abbreviation(p_table_name => '$p_utable_name', p_attribute => 'TABLE_ALIAS'),
    dev_support_utils.table_abbreviation(p_table_name => '$p_utable_name', p_attribute => 'TABLE_ABBREVIATION'),
    'Y','Y', 'R',
    '$p_email','$p_email');
    dbms_output.put_line('inserted table into dev_table_abbreviations');
exception when dup_val_on_index then dbms_output.put_line('Already in dev_table_abbreviations');
end;
/
--
-- 
--
show errors
exit;
EOF

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
define schema_name = 'CARS' (CHAR)
define table_match = '$p_utable_name' (CHAR)
@name_fixer.sql
show errors
exit;
EOF

  rm $p_project_path/name_fixer.sql
  rm $p_project_path/gen_fk_renames.sql
  rm $p_project_path/gen_ix_renames.sql
  rm $p_project_path/gen_non_fk_renames.sql
  rm $p_project_path/non_fk_renames.sql
  rm $p_project_path/fk_renames.sql
  rm $p_project_path/ix_renames.sql
  rm $p_project_path/name_fixer.dat
else 
  echo -e "Abort task: ${COLOR_RED}This is a not a table. You can only run this for a table ${COLOR_RED}"
fi

} #name-fixer

compile_code() {
  # called by run_sql.sh
  # echo "log : compile code"
  # Parameters
  local p_file_full_path="$1"
  # echo "log : p_file_full_path = '$p_file_full_path'"
  local p_file_base_name=$2
  # echo "log : p_file_base_name = $p_file_base_name"
  local p_file_rel_path="$3"
  # echo "log : p_file_rel_path = $p_file_rel_path"
  local p_file_dir="$4"
  # echo "log : p_file_dir = $p_file_dir"

  echo -e "Parsing file: ${COLOR_LIGHT_GREEN}$p_file_full_path${COLOR_RESET}"

  # echo "log : SVT_SCHEMA_CONFIGURED = '$SVT_SCHEMA_CONFIGURED'"
  if [[ "$SVT_SCHEMA_CONFIGURED" == "Y" ]]; then
  l_svt_command="select object_type, line, apex_string.format('%0 (%1)',code, test_code) issue, urgency
                from svt_plsql_review.issues( 
                                  p_object_name     => '$p_file_base_name',
                                  p_max_test_code_count   => 3,
                                  p_max_issue_count => 8,
                                  p_file_dirname => '$p_file_dir')
                order by urgency, object_type, line"
   else
   l_svt_command="select 'Standards not configured for this environment' Message from dual"
   fi

# run sqlplus, execute the script, then get the error list and exit
# VSCODE_TASK_COMPILE_BIN is set in the config.sh file (either sqlplus or sqlcl)
set JAVA_TOOL_OPTIONS=-Ddev.flag=123
$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set define off
set sqlblanklines on
set sqlformat ansiconsole -config=$SCRIPT_DIR/highlight.json
--
-- Set any alter session statements here (examples below)
-- alter session set plsql_ccflags = 'dev_env:true';
-- alter session set plsql_warnings = 'ENABLE:ALL';
-- 
-- #38: This will raise a warning message in SQL*Plus but worth keeping in to encourage use if using SQLcl to compile
-- set codescan all
--
-- Load user specific commands here
$VSCODE_TASK_COMPILE_SQL_PREFIX
--
-- 
-- Run file
@"$p_file_rel_path"
--
set sqlblanklines off

PRO running standards for $p_file_base_name
$l_svt_command

set define on
show errors
exit;
EOF

} # compile_code

export_tests() {
  # echo "log : export_tests"

  cd $PROJECT_DIR
  
  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/export_tests_script.sql

  rm standard_tests/temp_script.sql

} # export_tests

run_test() {
  # echo "log : run test"
  # Parameters
  local p_file_full_path="$1"
  # echo "log : p_file_full_path = '$p_file_full_path'"
  local p_file_base_name="$2"
  # echo "log : p_file_base_name = $p_file_base_name"
  local p_proc_name="$3"
  # echo "log : p_proc_name = $p_proc_name"
  local p_dir_name="$4"
  # echo "log : p_dir_name = $p_dir_name"
  if [[ "$p_dir_name" == *"package_"* ]]; then
    # echo "log : this is the correct directory"

echo -e "Parsing file: ${COLOR_LIGHT_GREEN}$p_file_full_path${COLOR_RESET}"

# run sqlplus, execute the script, then get the error list and exit
# VSCODE_TASK_COMPILE_BIN is set in the config.sh file (either sqlplus or sqlcl)
$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set define off
--
-- Set any alter session statements here (examples below)
-- alter session set plsql_ccflags = 'dev_env:true';
-- alter session set plsql_warnings = 'ENABLE:ALL';
-- 
-- #38: This will raise a warning message in SQL*Plus but worth keeping in to encourage use if using SQLcl to compile
-- set codescan on
--
-- Load user specific commands here
$VSCODE_TASK_COMPILE_SQL_PREFIX
--
-- 
-- Run test
PRO running tests for $p_file_base_name.$p_proc_name
SELECT COLUMN_VALUE test_output 
FROM TABLE (ut_cars.utt_run_tests_pkg.run_tests_for_pkg (p_package_name => '$p_file_base_name',
                                                         p_procedure_name => '$p_proc_name',
                                                         p_summary_placement => 'BOTTOM')
)
/
--
set define on
show errors
exit;
EOF
  else 
   echo -e "Abort task: ${COLOR_RED}This is a not a package. You can only run this for a package function / procedure ${COLOR_RED}"
  fi

} #run_test

gen_table_script() {
  # echo "log : gen_table_script"
  # Parameters
  local p_utable_name="$1"
  # echo "log : p_utable_name = '$p_utable_name'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"
  local p_author="$3"
  # echo "log : p_author = '$p_author'"

  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/table_script.sql "$2" "$1" "$3"

# $VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
# set define off
# set pagesize 0
# set heading off
# set wrap off
# set linesize 3000
# set feed off
# set echo off
# set verify off
# set headings off
# set trimspool off
# set termout off
# set pages 0

# --
# -- Load user specific commands here

# PRO step 1 : generate table script for $p_utable_name
# @$SCRIPT_DIR/spool_script.sql database SVT_AUDIT_ACTIONS
# -- @$SCRIPT_DIR/spool_script.sql 'blerg' '$P_UTABLE_NAME' '$P_AUTHOR'
# -- spool $p_project_dir/tables/$p_utable_name.sql
# -- select column_value
# -- from apex_string.split(dev_support_utils.generate_table_script(
# --                                                 p_table_name => '$p_utable_name', 
# --                                                 p_include_add_cols => 'N',
# --                                                 p_remove_quotes => 'Y',
# --                                                 p_remove_nls => 'Y',
# --                                                 p_author => '$p_author'), '
# -- ');
# -- spool off
# --
# -- 
# --
# set define on
# show errors
# exit;
# EOF

code $p_project_dir/tables/$p_utable_name.sql

} # gen_table_script

gen_fk_script() {
  # echo "log : gen_fk_script"
  # Parameters
  local p_utable_name="$1"
  # echo "log : p_utable_name = '$p_utable_name'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"
  local p_author="$3"
  # echo "log : p_author = '$p_author'"

  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/fk_script.sql "$2" "$1" "$3"

# $VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
# set define off
# set pagesize 0
# set heading off
# set feedback off
# set wrap off
# set linesize 3000
# --
# -- Load user specific commands here

# PRO step 2 : generate foreign key script for $p_utable_name

# spool $p_project_dir/foreign_keys/$p_utable_name.sql
# select 'set serveroutput on'
# from dual
# union all
# select replace(column_value, '"','') 
# from apex_string.split(dev_support_utils.generate_table_fk_script(
#                                                     p_table_name => '$p_utable_name',
#                                                     p_author => '$p_author'), '
# ');
# spool off
# --
# -- 
# --
# set define on
# show errors
# exit;
# EOF

code $p_project_dir/foreign_keys/$p_utable_name.sql

} # gen_fk_script

gen_comment_script() {
  # echo "log : gen_comment_script"
  # Parameters
  local p_utable_name="$1"
  # echo "log : p_utable_name = '$p_utable_name'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"
  local p_author="$3"
  # echo "log : p_author = '$p_author'"

  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/comment_script.sql "$2" "$1" "$3"

# $VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
# set define off
# set pagesize 0
# set heading off
# set feedback off
# set wrap off
# set linesize 3000
# --
# -- Load user specific commands here

# PRO step 3 : generate comment script for $p_utable_name

# spool $p_project_dir/comments/$p_utable_name.sql
# select 'set serveroutput on'
# from dual
# union all
# select replace(column_value, '"','') 
# from apex_string.split(dev_support_utils.generate_comment_script(
#                                                   p_table_name => '$p_utable_name',
#                                                   p_author => '$p_author'), '
# ');
# spool off
# --
# -- 
# --
# set define on
# show errors
# exit;
# EOF

code $p_project_dir/comments/$p_utable_name.sql

} # gen_comment_script

gen_trigger_script() {
  # echo "log : gen_comment_script"
  # Parameters
  local p_utable_name="$1"
  # echo "log : p_utable_name = '$p_utable_name'"
  local p_ubiu_trigger_name=$(echo $p_utable_name'_BIU')
  # echo "log : p_ubiu_trigger_name = '$p_ubiu_trigger_name'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"
  local p_author="$3"
  # echo "log : p_author = '$p_author'"

  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/trigger_script.sql "$2" "$1" "$3"

# $VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
# set define off
# set pagesize 0
# set heading off
# set feedback off
# set wrap off
# set linesize 3000
# --
# -- Load user specific commands here

# PRO step 4 : generate trigger script for $p_ubiu_trigger_name

# spool $p_project_dir/triggers/$p_ubiu_trigger_name.sql
# select 'set serveroutput on'
# from dual
# union all
# select replace(column_value, '"','') 
# from apex_string.split(dev_support_utils.generate_biu_trigger_script(
#                                                   p_table_name => '$p_utable_name',
#                                                   p_author => '$p_author'), '
# ');
# spool off
# --
# -- 
# --
# set define on
# show errors
# exit;
# EOF

code $p_project_dir/triggers/$p_ubiu_trigger_name.sql

} # gen_trigger_script

gen_insert_script_tables1 () {
  # echo "log : gen_insert_script_tables1"
  # Parameters
  local p_utable_name="$1"
  # echo "log : p_utable_name = '$p_utable_name'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"

  object_dest_file="$p_project_dir/data/tables1/$p_utable_name.sql"
  # echo "log : object_dest_file :$object_dest_file"

  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/insert_script_tables1.sql "$2" "$1"
  sed -i.bak -e "s/MYTABLE/$p_utable_name/g" -- "$object_dest_file"
  sed -i.bak -e "s/--REM/REM/g" -- "$object_dest_file"
  sed -i.bak -e "s/REM/--REM/g" -- "$object_dest_file"
  sed -i.bak -e "s/--SET/SET/g" -- "$object_dest_file"
  sed -i.bak -e "s/SET/--SET/g" -- "$object_dest_file"
  # echo "log : rm $object_dest_file.bak"
  rm $object_dest_file.bak

  code $object_dest_file
} # gen_insert_script_tables1

gen_insert_script_tables2 () {
  # echo "log : gen_insert_script_tables2"
  # Parameters
  local p_utable_name="$1"
  # echo "log : p_utable_name = '$p_utable_name'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"

  object_dest_file="$p_project_dir/data/tables2/$p_utable_name.sql"
  # echo "log : object_dest_file :$object_dest_file"

  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/insert_script_tables2.sql "$2" "$1"
  sed -i.bak -e "s/MYTABLE/$p_utable_name/g" -- "$object_dest_file"
  sed -i.bak -e "s/--REM/REM/g" -- "$object_dest_file"
  sed -i.bak -e "s/REM/--REM/g" -- "$object_dest_file"
  sed -i.bak -e "s/--SET/SET/g" -- "$object_dest_file"
  sed -i.bak -e "s/SET/--SET/g" -- "$object_dest_file"
  # echo "log : rm $object_dest_file.bak"
  rm $object_dest_file.bak

  code $object_dest_file
} # gen_insert_script_tables2

gen_insert_script_tables_tests() {
  # echo "log : gen_insert_script_tables_tests"
  # Parameters
  local p_nt_type_id="$1"
  # echo "log : p_nt_type_id = '$p_nt_type_id'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"
  local p_utable_name="EBA_STDS_STANDARD_TESTS"
  # echo "log : p_utable_name = '$p_utable_name'"
  
  if [[ "$p_nt_type_id" == "1 - PLSQL" ]]; then
    local p_filename="EBA_STDS_STANDARD_TESTS_PLSQL.sql"
    object_dest_file="$p_project_dir/data/tables2/$p_filename"
    local p_nt_type_id="1"
    local p_nt_type_name="PLSQL"
  elif [[ "$p_nt_type_id" == "2 - SERT" ]]; then
    local p_filename="EBA_STDS_STANDARD_TESTS_SERT.sql"
    object_dest_file="$p_project_dir/data/tables2/$p_filename"
    local p_nt_type_id="21"
    local p_nt_type_name="SERT"
  elif [[ "$p_nt_type_id" == "3 - APEX" ]]; then
    local p_filename="EBA_STDS_STANDARD_TESTS_APEX.sql"
    object_dest_file="$p_project_dir/data/tables2/$p_filename"
    local p_nt_type_id="41"
    local p_nt_type_name="APEX"
  elif [[ "$p_nt_type_id" == "4 - Views" ]]; then
    local p_filename="EBA_STDS_STANDARD_TESTS_VIEWS.sql"
    object_dest_file="$p_project_dir/data/tables2/$p_filename"
    local p_nt_type_id="81"
    local p_nt_type_name="VIEWS"
  elif [[ "$p_nt_type_id" == "5 - Tables" ]]; then
    local p_filename="EBA_STDS_STANDARD_TESTS_TABLES.sql"
    object_dest_file="$p_project_dir/data/tables2/$p_filename"
    local p_nt_type_id="101"
    local p_nt_type_name="TABLES"
  fi
  # echo "log : p_nt_type_id = '$p_nt_type_id'"
  # echo "log : p_nt_type_name = '$p_nt_type_name'"
  # echo "log : object_dest_file :$object_dest_file"

  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/insert_script_tables_tests.sql "$2" "$p_nt_type_id" "$p_nt_type_name"
  sed -i.bak -e "s/MYTABLE/$p_utable_name/g" -- "$object_dest_file"
  sed -i.bak -e "s/--REM/REM/g" -- "$object_dest_file"
  sed -i.bak -e "s/REM/--REM/g" -- "$object_dest_file"
  sed -i.bak -e "s/--SET/SET/g" -- "$object_dest_file"
  sed -i.bak -e "s/SET/--SET/g" -- "$object_dest_file"
  # echo "log : rm $object_dest_file.bak"
  rm $object_dest_file.bak

  code $object_dest_file

  gen_insert_script_tables_sub_reference_codes $p_nt_type_id $p_project_dir $p_nt_type_name

} # gen_insert_script_tables_tests

gen_insert_script_tables_sub_reference_codes() {
  # echo "log : gen_insert_script_tables_sub_reference_codes"
  # Parameters
  local p_nt_type_id="$1"
  # echo "log : p_nt_type_id = '$p_nt_type_id'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"
  local p_nt_type_name="$3"
  # echo "log : p_nt_type_name = '$p_nt_type_name'"
  local p_utable_name="SVT_SUB_REFERENCE_CODES"
  # echo "log : p_utable_name = '$p_utable_name'"
  local p_filename=$(echo ${p_utable_name}_${p_nt_type_name}.sql)
  # $(echo ${p_file_dir_name/database\/tables/database})
  # local p_filename="SVT_SUB_REFERENCE_CODES_PLSQL.sql"
  # echo "log : p_filename = '$p_filename'"
  object_dest_file="$p_project_dir/data/tables3/$p_filename"

  echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/insert_script_tables_sub_reference_codes.sql "$2" "$p_nt_type_id" "$p_nt_type_name"
  sed -i.bak -e "s/into EBA_STDS_STANDARD_TESTS/into $p_utable_name/g" -- "$object_dest_file"
  sed -i.bak -e "s/--REM/REM/g" -- "$object_dest_file"
  sed -i.bak -e "s/REM/--REM/g" -- "$object_dest_file"
  sed -i.bak -e "s/--SET/SET/g" -- "$object_dest_file"
  sed -i.bak -e "s/SET/--SET/g" -- "$object_dest_file"
  # echo "log : rm $object_dest_file.bak"
  rm $object_dest_file.bak

  code $object_dest_file
} # gen_insert_script_tables_sub_reference_codes

refresh_package_script_from_db() {
  # echo "log : refresh_package_script_from_db"
  # Parameters
  local p_uobject_name="$1"
  # echo "log : p_uobject_name = '$p_uobject_name'"
  local p_project_dir="$2"
  # echo "log : p_project_dir = '$p_project_dir'"

echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/pkg_spec_script.sql "$2" "$1"

# $VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
# set define off
# set pagesize 0
# set heading off
# set feedback off
# set wrap off
# set linesize 3000
# --
# -- Load user specific commands here

# PRO step 1 : generate package spec script for $p_uobject_name

# spool $p_project_dir/package_specs/$p_uobject_name.sql
# select column_value
# from apex_string.split(dev_support_utils.generate_package_script(
#                               p_package_name => '$p_uobject_name',
#                               p_type => 'PACKAGE'), '
# ');
# spool off
# --
# -- 
# --
# set define on
# show errors
# exit;
# EOF

code $p_project_dir/package_specs/$p_uobject_name.sql

echo exit | $VSCODE_TASK_COMPILE_BIN $DB_CONN -s $SCRIPT_DIR/pkg_body_script.sql "$2" "$1"

# $VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
# set define off
# set pagesize 0
# set heading off
# set feedback off
# set wrap off
# set linesize 3000
# --
# -- Load user specific commands here

# PRO step 2 : generate package body script for $p_uobject_name

# spool $p_project_dir/package_bodies/$p_uobject_name.sql
# select column_value
# from apex_string.split(dev_support_utils.generate_package_script(
#                               p_package_name => '$p_uobject_name',
#                               p_type => 'PACKAGE BODY'), '
# ');
# spool off
# --
# -- 
# --
# set define on
# show errors
# exit;
# EOF

code $p_project_dir/package_bodies/$p_uobject_name.sql

} # refresh_package_script_from_db

liquibase_preview_sql() {
  # echo "log : liquibase_preview_sql"
  # Parameters
  local p_file_name="$1"
  # echo "log : p_file_name = '$p_file_name'"

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
--
-- Load user specific commands here

PRO step 1 : generate liquibase preview SQL script ($p_file_name)

lb update-sql -changelog-file controller.xml -output-file release/$p_file_name.sql
--
-- 
--
set define on
show errors
exit;
EOF

code release/$p_file_name.sql

} # liquibase_preview_sql

liquibase_deploy_changes() {
  # echo "log : liquibase_deploy_changes"

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
--
-- Load user specific commands here

PRO step 1 : deploying changes

lb update -changelog-file controller.xml -debug true -log true
--
-- 
--
set define on
show errors
exit;
EOF

} # liquibase_deploy_changes


liquibase_clear_checksums() {
  # echo "log : liquibase_clear_checksums"

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
--
-- Load user specific commands here

PRO step 1 : clear-checksums

lb clear-checksums
--
-- 
--
set define on
show errors
exit;
EOF

} # liquibase_clear_checksums

liquibase_validate () {
  # echo "log : liquibase_validate"

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
--
-- Load user specific commands here

PRO : validate

lb validate -changelog-file controller.xml -log true
--
-- 
--
set define on
show errors
exit;
EOF

} # liquibase_validate

invalid_objects () {
  # echo "log : invalid_objects"
  # Parameters
  local p_file_name="$1"
  # echo "log : p_file_name = '$p_file_name'"

$VSCODE_TASK_COMPILE_BIN $DB_CONN << EOF
set define off
set pagesize 0
set heading off
set feedback off
set wrap off
set linesize 3000

PRO step 1 : compile schema 
begin
  dbms_utility.compile_schema(schema => user, compile_all => false);
end;
/

PRO step 2 : generate list of invalid objects ($p_file_name)

spool release/$p_file_name.sql
select object_name, object_type
from user_objects
where status != 'VALID'
order by object_name
;
spool off
--
-- 
--
set define on
show errors
exit;
EOF

code release/$p_file_name.sql

} # invalid_objects

# Merge a SQL file into one file
# Copied and modified from: https://github.com/insum-labs/conference-manager/blob/master/release/build_release_script.sh
#
# This script received a .sql file as input and will create an output file
# that can be processed by SQL Workshop on apex.oracle.com
# This means that single commands can be executed as they are (for example 
# alter, create table, update, inserts, etc..).
# When a script is found with the form @../file, ie:
# @../views/ks_users_v.sql
# It will be "expanded" into the output file (defined by OUT_FILE)
# 
# Note this will recursively expand files. 
# For example if calling "merge_sql_files _release.sql merged_release.sql" and:
# _release.sql references _all_packages.sql
# and _all_packages.sql references pkg_emp.pks
# Then both _all_packages.sql and pkg_emp.pks will be exampled at the the points they were referenced in each file
#
# Issue: #42
# Example:
# source helper.sh
# merge_sql_files all_packages.sql merged_all_packages.sql
# 
# Parameters
# $1 From/In File
# $2 To/Out File
merge_sql_files(){
  local IN_FILE=$1
  local OUT_FILE=$2

  # Logging function. Calling "logger" so there's no name conflict as "log" is a function in bash
  logger() {
    echo "`date`: $1"
  } # logger

  #*****************************************************************************
  # Expand Script Lines or output regular lines
  # Parameters
  # $1 FILE_LINE: This is the current line from the $IN_FILE
  #******************************************************************************
  process_line (){
    local FILE_LINE=$1

    # logger "Is $1 a script?"
    # ${1:1} https://stackoverflow.com/questions/30197247/using-11-in-bash
    # In this case it's removing the "@" from each line in the script

    if [ -f "${FILE_LINE:1}" ]
    then
      logger "Expanding file: ${FILE_LINE:1}"
      echo "-- $FILE_LINE" >> $OUT_FILE
      
      # Recursively open each file as they themselves may reference other files
      process_file ${FILE_LINE:1}
      
      # Print blank lines
      echo >> $OUT_FILE
      echo >> $OUT_FILE
    else
      echo "$line" >> $OUT_FILE
    fi

  } # process_line


  # Will loop over a file and process each line
  # 
  # Note: process_line will recursively call this function
  # 
  # Parameters
  # $1 file_name
  process_file(){
    echo "Processing: $file_name"
    local file_name=$1

    while IFS='' read -r line || [[ -n "$line" ]]; do
      process_line $line
    done < "$file_name"
  }


  logger "Procesing $IN_FILE into $OUT_FILE"

  echo "-- =============================================================================" > $OUT_FILE
  echo "-- ==========================  Full $IN_FILE file" >> $OUT_FILE
  echo "-- =============================================================================" >> $OUT_FILE
  echo -n >> $OUT_FILE

  # Start merging the original file which will recursively find other files
  process_file $IN_FILE
} # merge_sql_files


# Initialize
init(){
  local PROJECT_DIR_FOLDER_NAME=$(basename $PROJECT_DIR)
  local VSCODE_TASK_FILE=$PROJECT_DIR/.vscode/tasks.json
  
  # #36 Change the VSCode Labels
  # See: https://unix.stackexchange.com/questions/13711/differences-between-sed-on-mac-osx-and-other-standard-sed/131940#131940
  # sed -i -bak "s/CHANGEME_TASKLABEL/$PROJECT_DIR_FOLDER_NAME/g" $VSCODE_TASK_FILE
  # Remove backup versin of file
  # rm $VSCODE_TASK_FILE-bak


  # Initializing Helper
  load_colors
  load_config
  verify_config
}

init