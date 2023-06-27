#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
# echo "log: Load Helper"
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

TABLE_NAME="$3"
UTABLE_NAME=$(echo $TABLE_NAME | tr 'a-z' 'A-Z')

# Generate object
name_fixer "$UTABLE_NAME" "$1" "$2" "$4" "$5" "$6"
