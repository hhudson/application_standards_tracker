set termout off
set verify off


-- From: https://stackoverflow.com/questions/13474899/default-value-for-paramteters-not-passed-sqlplus-script
-- and: http://vbegun.blogspot.com/2008/04/on-sqlplus-defines.html
-- Allow for optional value of 2
column 1 new_value 1
column 2 new_value 2
column 3 new_value 3
select '' "1", '' "2", '' "3"
from dual 
where rownum = 0;

define 1
define 2
define 3

define PROJECT_DIR = "&1"
define PACKAGE_NAME = "&2"
define FILE_NAME = "&PACKAGE_NAME..sql"
define AUTHOR = "&3"

set termout on
set serveroutput on
begin
  dbms_output.put_line ( 'Project Dir: &PROJECT_DIR' );
  dbms_output.put_line ( 'Package name: &PACKAGE_NAME' );
  dbms_output.put_line ( 'Author: &AUTHOR' );
  dbms_output.put_line ( '------------------' );
end;
/
set serveroutput off

set term off
set feed off
set pagesize 0
set heading off
set wrap off
set linesize 3000
set verify off
set headings off
set trimspool off
set pages 0

spool &PROJECT_DIR/package_bodies/&FILE_NAME

select column_value
from apex_string.split(dev_support_utils.generate_package_script(
                              p_package_name => '&PACKAGE_NAME',
                              p_type => 'PACKAGE BODY'), '
');

spool off