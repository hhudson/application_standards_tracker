#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

# File can be referenced either as a full path or relative path
FILE_DIR="$4"
FILE_BASE_NAME="$3"
FILE_FULL_PATH="$2"
FILE_RELATIVE_PATH="$1"

compile_code "$FILE_FULL_PATH" "$FILE_BASE_NAME" "$FILE_RELATIVE_PATH" "$FILE_DIR"





