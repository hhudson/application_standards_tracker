#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

ADM_OPTION="$1"
GIT_EMAIL=$(git config user.email)

if [[ "$ADM_OPTION" == "2 - List invalid objects" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}2 - List invalid objects${COLOR_RESET}"
  invalid_objects 'INVALID_OBJECTS_'$(date +"_%d%b%Y_%H:%M")

elif [[ "$ADM_OPTION" == "3 - Install APEX app" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}3 - Install APEX app${COLOR_RESET}"
  install_apex_app

elif [[ "$ADM_OPTION" == "4 - Export results JSON file" ]]; then

  echo -e "Gen option : ${COLOR_LIGHT_GREEN}4 - Exporting results JSON file${COLOR_RESET}"
  export_results

else

  echo -e "Gen option : ${COLOR_RED}unknown option${COLOR_RESET}"

fi
