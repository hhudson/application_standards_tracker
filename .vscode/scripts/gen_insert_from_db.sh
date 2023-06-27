#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

# File can be referenced either as a full path or relative path
INS_OPTION="$1"
OBJECT_NAME="$2"
PROJ_DIR="database"
UOBJECT_NAME=$(echo $OBJECT_NAME | tr 'a-z' 'A-Z')

if [[ "$INS_OPTION" == "1 - With Primary Key" ]]; then

    echo -e "Gen option : ${COLOR_LIGHT_GREEN}With Primary Key${COLOR_RESET}"
    gen_insert_script_tables1 "$UOBJECT_NAME" "$PROJ_DIR"

elif [[ "$INS_OPTION" == "2 - No Primary Key" ]]; then

    echo -e "Gen option : ${COLOR_LIGHT_GREEN}No Primary Key${COLOR_RESET}"
    gen_insert_script_tables2 "$UOBJECT_NAME" "$PROJ_DIR"

else

  echo -e "Gen option : ${COLOR_RED}unknown option${COLOR_RESET}"

fi

