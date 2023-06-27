#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

# VSCODE_TASK_COMPILE_FILE should be defined in user-config.sh
if [ -z "$VSCODE_TASK_COMPILE_FILE" ]; then
  echo -e "${COLOR_ORANGE} Warning: VSCODE_TASK_COMPILE_FILE is not defined.${COLOR_RESET}\nSet VSCODE_TASK_COMPILE_FILE in $USER_CONFIG_FILE"
  echo -e "Defaulting to full path"
  VSCODE_TASK_COMPILE_FILE=$FILE_FULL_PATH
fi
# Since VSCODE_TASK_COMPILE_FILE contains the variable reference need to evaluate it here
VSCODE_TASK_COMPILE_FILE=$(eval "echo $VSCODE_TASK_COMPILE_FILE")


code .local/scripts/user-config.sh