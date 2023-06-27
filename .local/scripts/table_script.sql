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
define TABLE_NAME = "&2"
define FILE_NAME = "&TABLE_NAME..sql"
define AUTHOR = "&3"

set termout on
set serveroutput on
begin
  dbms_output.put_line ( 'Project Dir: &PROJECT_DIR' );
  dbms_output.put_line ( 'Table name: &TABLE_NAME' );
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

spool &PROJECT_DIR/tables/&FILE_NAME

select column_value
from apex_string.split(dev_support_utils.generate_table_script(
                                                p_table_name => '&TABLE_NAME', 
                                                p_include_add_cols => 'N',
                                                p_remove_quotes => 'Y',
                                                p_remove_nls => 'Y',
                                                p_author => '&AUTHOR'), '
');

spool off