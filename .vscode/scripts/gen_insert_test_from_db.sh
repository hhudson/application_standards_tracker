#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

# File can be referenced either as a full path or relative path
NT_TYPE="$1"
PROJ_DIR="database"

echo -e "Gen option : ${COLOR_LIGHT_GREEN}1 - DB Objects${COLOR_RESET}"
gen_insert_script_tables_tests "$NT_TYPE" "$PROJ_DIR"


