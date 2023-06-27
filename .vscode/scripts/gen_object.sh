#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
# echo "log : Load Helper"
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

# Generate object
gen_object "$1"  "$2"  "$3"
