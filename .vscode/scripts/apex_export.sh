#!/bin/bash
# Env variables $1, $2, etc are from the tasks.json args array

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source "$SCRIPT_DIR/../../.local/scripts/helper.sh"

EXP_OPTION="$1"

# Export APEX applications
# 

if [[ "$EXP_OPTION" == "1 - APEX Readable YAML" ]]; then

    echo -e "Gen option : ${COLOR_LIGHT_GREEN}Exporting Readable YAML${COLOR_RESET}"
    export_apex_app_readable_yaml

elif [[ "$EXP_OPTION" == "2 - APEX installation file" ]]; then

    echo -e "Gen option : ${COLOR_LIGHT_GREEN}Exporting APEX install file${COLOR_RESET}"
    export_apex_app

elif [[ "$EXP_OPTION" == "3 - All APEX stuff (options 1 & 2)" ]]; then

    echo -e "Gen option : ${COLOR_LIGHT_GREEN}Exporting APEX YAML + install file${COLOR_RESET}"
    export_apex_app_readable_yaml
    export_apex_app

elif [[ "$EXP_OPTION" == "4 - Export published tests & standards" ]]; then

    echo -e "Gen option : ${COLOR_LIGHT_GREEN}Exporting published standards +  tests${COLOR_RESET}"
    export_tests

elif [[ "$EXP_OPTION" == "5 - All of the above" ]]; then

    echo -e "Gen option : ${COLOR_LIGHT_GREEN}Exporting APEX install file + Readable YAML + Published tests${COLOR_RESET}"
    export_apex_app
    export_apex_app_readable_yaml
    export_tests

else

  echo -e "Gen option : ${COLOR_RED}unknown option${COLOR_RESET}"

fi