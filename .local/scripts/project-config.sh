#!/bin/bash

# Name of Schema
SCHEMA_NAME=CARS
# Name of default workspace that applications are associated with
APEX_WORKSPACE=CARS
# Comma delimited list of APEX Applications to export. Ex: 100,200
# APEX_APP_IDS=750100,799100
# APEX_APP_IDS=713000
APEX_APP_IDS=1700003


# File extensions
# Will be used throughought the scripts to generate lists of packages, views, etc from the filesystem
EXT_PACKAGE_SPEC=sql
EXT_PACKAGE_BODY=sql
EXT_VIEW=sql
EXT_TRIGGER=sql

# File Mappings
# This will be used in VSCode to allow for quick generate of a given file based on template data
# Format:
# <name>:<template_file prefix (no extension)>:<file extensions (; delimited)>:<destination directory>
# 
# Definitions:
# - name: Name that will be mapped to VSCode task
# - template file: Template file prefix to use (no extension)
# - file extensions: ";" delimited list of file extensions to reference each template file
# - destination directory: where to store the new file
OBJECT_FILE_TEMPLATE_MAP=""
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,package:templates/template_pkg:pks;pkb:package_specs"
# OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,package_spec:templates/template_pkg:$EXT_PACKAGE_SPEC:package_specs"
# OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,package_body:templates/template_pkg:$EXT_PACKAGE_BODY:package_bodies"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,view:templates/template_view:$EXT_VIEW:views"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,mview:templates/template_mview:$EXT_VIEW:mviews"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,data_array:templates/template_data_array:sql:adhoc_scripts"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,data_json:templates/template_data_json:sql:adhoc_scripts"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,job:templates/template_job:sql:scheduler_jobs"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,sqlmacro:templates/template_sqlmacro:$EXT_VIEW:functions"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,table:templates/template_table:$EXT_VIEW:tables"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,trigger:templates/template_trigger:$EXT_VIEW:triggers"
OBJECT_FILE_TEMPLATE_MAP="$OBJECT_FILE_TEMPLATE_MAP,comment:templates/template_comment:sql:comments"

SVT_SCHEMA_CONFIGURED="N"