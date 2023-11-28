#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

ADM_OPTION="$1"

if [[ "$ADM_OPTION" == "1 - Preview SQL" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}Preview SQL${COLOR_RESET}"
  liquibase_preview_sql 'SQL_PREVIEW_'$(date +"_%d%b%Y_%H:%M")

elif [[ "$ADM_OPTION" == "2 - Deploy Changes" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}2 - Deploy Changes${COLOR_RESET}"
  liquibase_deploy_changes

elif [[ "$ADM_OPTION" == "3 - Clear Checksums" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}3 - Clear Checksums${COLOR_RESET}"
  liquibase_clear_checksums

elif [[ "$ADM_OPTION" == "4 - Validate" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}4 - Validate${COLOR_RESET}"
  liquibase_validate

elif [[ "$ADM_OPTION" == "5 - Clean slate" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}5 - Clean slate${COLOR_RESET}"
  liquibase_cleanslate

else

  echo -e "Gen option : ${COLOR_RED}unknown option${COLOR_RESET}"

fi
