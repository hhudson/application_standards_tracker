-- Installs an APEX application
-- 
-- Parameters:
-- 1: Schema to install into
-- 2: Workspace to install into
-- 3: Application ID to run
set termout off
set verify off

column 1 new_value 1
column 2 new_value 2
column 3 new_value 3
select '' "1", '' "2", '' "3"
from dual 
where rownum = 0;

define 1
define 2
define 3

define APP_ID = "&1"
define SCHEMA_NAME = "&2"
define WORKSPACE_NAME = "&3"


set termout on
set serveroutput on
begin
  dbms_output.put_line ( 'App ID: &APP_ID' );
  apex_application_install.set_application_id(&APP_ID);
  dbms_output.put_line ( 'Schema: &SCHEMA_NAME' );
  apex_application_install.set_schema(upper('&SCHEMA_NAME'));
  dbms_output.put_line ( 'Workspace: &WORKSPACE_NAME' );
  apex_application_install.set_workspace(upper('&WORKSPACE_NAME'));
  apex_application_install.generate_offset;
end;
/
set serveroutput off

@apex/f&APP_ID/f&APP_ID..sql