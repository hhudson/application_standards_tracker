  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_CONSTRAINTS" ("TABLE_NAME", "CONSTRAINT_NAME", "CONSTRAINT_TYPE", "OWNER")   AS 
  select table_name, constraint_name, constraint_type, owner
from all_constraints
where owner = svt_ctx_util.get_default_user
and table_name not like 'XXX%';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_CONS_COLUMNS" ("TABLE_NAME", "CONSTRAINT_NAME", "COLUMN_NAME", "POSITION")   AS 
  select table_name, constraint_name, column_name, position
from all_cons_columns
where owner = case when sys_context('userenv', 'current_user') = svt_preferences.get('SVT_DEFAULT_SCHEMA')
                   then svt_ctx_util.get_default_user
                   else sys_context('userenv', 'current_user')
                   end
and table_name not like 'XXX%';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_ERRORS" ("NAME", "TYPE", "LINE", "TEXT", "MESSAGE_NUMBER", "SEQUENCE", "POSITION", "ATTRIBUTE", "OWNER")   AS 
  select name, 
       type,
       line, 
       text,
       message_number, 
       sequence,
       position,
       attribute,
       owner
from all_errors
where owner = svt_ctx_util.get_default_user;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_IDENTIFIERS" ("SIGNATURE", "LINE", "NAME", "OBJECT_NAME", "OBJECT_TYPE", "TYPE", "USAGE_CONTEXT_ID", "USAGE", "IMPLICIT", "OWNER")   AS 
  select signature, line, name, object_name, object_type, type, usage_context_id, usage, implicit, owner
from all_identifiers
where owner = svt_ctx_util.get_default_user
and name not in ('LOGGER');

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_IND_COLUMNS" ("TABLE_NAME", "COLUMN_NAME", "COLUMN_POSITION", "INDEX_NAME")   AS 
  select table_name, column_name, column_position, index_name
from all_ind_columns
where table_name not like 'XXX%'
-- where owner = case when sys_context('userenv', 'current_user') = 'SVT'
--                    then svt_ctx_util.get_default_user
--                    else sys_context('userenv', 'current_user')
--                    end;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_MVIEWS" ("OWNER", "MVIEW_NAME")   AS 
  select owner, mview_name
from all_mviews
where owner = svt_ctx_util.get_default_user;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_OBJECTS" ("OBJECT_ID", "OBJECT_NAME", "OBJECT_TYPE", "OWNER", "STATUS")   AS 
  select object_id, object_name, object_type, owner, status
from all_objects
where owner = svt_ctx_util.get_default_user
and object_name not like '%XXX%'
and object_name not like 'DATABASECHANGELOG%'
and object_name not like 'DEV%'
and object_name not like 'SVT%'
and object_name not like 'MLOG%'
and object_name not like 'LOGGER%';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_PLSQL_OBJECT_SETTINGS" ("OWNER", "NAME", "TYPE", "PLSQL_OPTIMIZE_LEVEL", "PLSQL_CODE_TYPE", "PLSQL_DEBUG", "PLSQL_WARNINGS", "NLS_LENGTH_SEMANTICS", "PLSQL_CCFLAGS", "PLSCOPE_SETTINGS", "ORIGIN_CON_ID")   AS 
  select "OWNER","NAME","TYPE","PLSQL_OPTIMIZE_LEVEL","PLSQL_CODE_TYPE","PLSQL_DEBUG","PLSQL_WARNINGS","NLS_LENGTH_SEMANTICS","PLSQL_CCFLAGS","PLSCOPE_SETTINGS","ORIGIN_CON_ID"
from all_plsql_object_settings
where owner = svt_ctx_util.get_default_user;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_SCHEDULER_JOBS" ("JOB_NAME", "STATE", "START_DATE", "LAST_START_DATE", "NEXT_RUN_DATE")   AS 
  select job_name, state, start_date, last_start_date, next_run_date
from user_scheduler_jobs;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_SOURCE" ("OWNER", "TYPE", "NAME", "LINE", "TEXT")   AS 
  select owner, type, name, line, text
from all_source
where owner = svt_ctx_util.get_default_user
and name not like 'XXX%'
and name not in ('LOGGER');

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_STATEMENTS" ("OBJECT_TYPE", "OBJECT_NAME", "LINE", "SIGNATURE", "TYPE", "SQL_ID", "TEXT", "OWNER")   AS 
  select object_type, object_name, line, signature, type, sql_id, text, owner
from all_statements
where owner = svt_ctx_util.get_default_user
and object_name not in ('LOGGER');

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_TAB_COLS" ("OWNER", "TABLE_NAME", "COLUMN_NAME", "DATA_TYPE", "CHAR_USED", "DATA_LENGTH")   AS 
  select owner,
       table_name, 
       column_name,
       data_type,
       char_used,
       data_length
from all_tab_cols
where owner = svt_ctx_util.get_default_user
and table_name not like '%XXX%'
and table_name not like 'LOGGER%';

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_TRIGGERS" ("OWNER", "TRIGGER_NAME", "TRIGGER_TYPE", "TRIGGERING_EVENT", "TABLE_OWNER", "BASE_OBJECT_TYPE", "TABLE_NAME", "DESCRIPTION", "OBJECT_ID")   AS 
  select dt.owner, 
       dt.trigger_name, 
       dt.trigger_type, 
       dt.triggering_event, 
       dt.table_owner, 
       dt.base_object_type, 
       dt.table_name, 
       dt.description,
       dob.object_id
from all_triggers dt
inner join all_objects dob on dob.object_name = dt.trigger_name
                           and dob.object_type = 'TRIGGER'
                           and dob.owner = dt.owner
where dt.owner = svt_ctx_util.get_default_user;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_USER_VIEWS" ("OWNER", "VIEW_NAME")   AS 
  select owner, 
       view_name
from all_views
where owner = svt_ctx_util.get_default_user
and view_name not like 'XXX%'; 