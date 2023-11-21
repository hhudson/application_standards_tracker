#!/bin/bash

# ./build.sh <version>
# Parameters
#   version: This is embedded in the APEX application release.

if [ -z "$1" ]; then
  echo 'Missing version number'
  exit 0
fi

VERSION=$1

# This is the directory that this file is located in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# echo "Start Dir: $SCRIPT_DIR\n"

# Load Helper and config
source $SCRIPT_DIR/../scripts/helper.sh


echo -e "*** Listing all views and packages ***\n"
list_all_files database/tables                             release/all_tables.sql $EXT_VIEW
list_all_files database/foreign_keys                       release/all_foreign_keys.sql $EXT_VIEW
list_all_files database/views                              release/all_views.sql $EXT_VIEW
list_all_files database/views/standards/ohms_apex          release/all_views_ohms_apex.sql $EXT_VIEW
list_all_files database/views/standards/ohms_apex/meta     release/all_views_ohms_apex_meta.sql $EXT_VIEW
list_all_files database/views/standards/ohms_db_view       release/all_views_ohms_db_view.sql $EXT_VIEW
list_all_files database/views/standards/ohms_db_view/meta  release/all_views_ohms_db_view_meta.sql $EXT_VIEW
list_all_files database/views/standards/ohms_plsql         release/all_views_ohms_plsql.sql $EXT_VIEW
list_all_files database/views/standards/ohms_plsql/meta    release/all_views_ohms_plsql_meta.sql $EXT_VIEW
list_all_files database/views/standards/meta               release/all_views_meta.sql $EXT_VIEW
list_all_files database/package_specs                      release/all_package_specs.sql $EXT_PACKAGE_SPEC
list_all_files database/package_bodies                     release/all_package_bodies.sql $EXT_PACKAGE_BODY
list_all_files database/triggers                           release/all_triggers.sql $EXT_TRIGGER
list_all_files database/jobs                               release/all_jobs.sql $EXT_TRIGGER
list_all_files database/adhoc_scripts                      release/all_data.sql $EXT_TRIGGER
list_all_files database/types/object_types                 release/all_object_types.sql $EXT_TRIGGER
list_all_files database/types/table_types                  release/all_table_types.sql $EXT_TRIGGER
list_all_files database/sequences                          release/all_sequences.sql $EXT_TRIGGER
list_all_files database/mviews                             release/all_mviews.sql $EXT_TRIGGER
list_all_files database/functions                          release/all_functions.sql $EXT_TRIGGER
list_all_files database/procedures                         release/all_procedures.sql $EXT_TRIGGER
list_all_files database/synonyms                           release/all_synonyms.sql $EXT_TRIGGER
list_all_files database/contexts                           release/all_contexts.sql $EXT_TRIGGER

# TODO #10 APEX Nitro configuration
# echo -e "*** APEX Nitro Publish ***\n"
# apex-nitro publish gre

# Export APEX applications, defined in project-config.sh
# export_apex_app $VERSION

# Generate release support sql files 
gen_release_sql