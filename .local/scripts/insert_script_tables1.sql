set termout off
set verify off


-- From: https://stackoverflow.com/questions/13474899/default-value-for-paramteters-not-passed-sqlplus-script
-- and: http://vbegun.blogspot.com/2008/04/on-sqlplus-defines.html
-- Allow for optional value of 2
column 1 new_value 1
column 2 new_value 2
select '' "1", '' "2"
from dual 
where rownum = 0;

define 1
define 2

define PROJECT_DIR = "&1"
define TABLE_NAME = "&2"
define FILE_NAME = "&TABLE_NAME..sql"

set termout on
set serveroutput on
begin
  dbms_output.put_line ( 'Project Dir: &PROJECT_DIR' );
  dbms_output.put_line ( 'Table name: &TABLE_NAME' );
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

spool &PROJECT_DIR/data/tables1/&FILE_NAME
select '--liquibase formatted sql' lbstmt
from dual
union all
select '--changeset data_script:&TABLE_NAME stripComments:false ' lbstmt
from dual 
union all
select '--preconditions onFail:MARK_RAN onError:HALT' lbstmt
from dual 
union all
select '--precondition-sql-check expectedResult:0 select count(1) from &TABLE_NAME;' lbstmt
from dual ;

set sqlformat insert

select *  
from   except_cols (  
  &TABLE_NAME,  
  columns ( created, created_by, updated, updated_by )  
);

spool off