#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

# File can be referenced either as a full path or relative path
GEN_OPTION="$1"
OBJECT_NAME="$2"
PROJ_DIR="database"
UOBJECT_NAME=$(echo $OBJECT_NAME | tr 'a-z' 'A-Z')
GIT_EMAIL=$(git config user.email)

if [[ "$GEN_OPTION" == "1 - Scripts for Table, Foreign Keys, Comments & BIU Trigger" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}Scripts for Table, Foreign Keys, Comments & BIU Trigger${COLOR_RESET}"
  gen_table_script "$UOBJECT_NAME" "$PROJ_DIR" "$GIT_EMAIL"
  gen_fk_script "$UOBJECT_NAME" "$PROJ_DIR" "$GIT_EMAIL"
  gen_comment_script "$UOBJECT_NAME" "$PROJ_DIR" "$GIT_EMAIL"
  gen_trigger_script "$UOBJECT_NAME" "$PROJ_DIR" "$GIT_EMAIL"

elif [[ "$GEN_OPTION" == "2 - Scripts for Package Spec and Body" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}Scripts for Package Spec and Body${COLOR_RESET}"
  refresh_package_script_from_db "$UOBJECT_NAME" "$PROJ_DIR"

elif [[ "$GEN_OPTION" == "3 - Table script only" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}Table script only${COLOR_RESET}"
  gen_table_script "$UOBJECT_NAME" "$PROJ_DIR" "$GIT_EMAIL"

else

  echo -e "Gen option : ${COLOR_RED}unknown option${COLOR_RESET}"
  
fi

