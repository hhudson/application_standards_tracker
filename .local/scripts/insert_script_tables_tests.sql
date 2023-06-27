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

define PROJECT_DIR = "&1"
define NT_TYPE_ID = "&2"
define NT_TYPE_NAME = "&3"
define TABLE_NAME1 = "EBA_STDS_STANDARD_TESTS"
define FILE_NAME1 = "&TABLE_NAME1._&NT_TYPE_NAME..sql"
define TABLE_NAME2 = "AST_SUB_REFERENCE_CODES"
define FILE_NAME2 = "&TABLE_NAME2._&NT_TYPE_NAME..sql"

set termout on
set serveroutput on
begin
  dbms_output.put_line ( 'Project Dir: &PROJECT_DIR' );
  dbms_output.put_line ( 'Table name: &TABLE_NAME1' );
  dbms_output.put_line ( 'Type ID: &NT_TYPE_ID' );
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

spool &PROJECT_DIR/data/tables2/&FILE_NAME1
select '--liquibase formatted sql' lbstmt
from dual
union all
select '--changeset data_script:&FILE_NAME1 stripComments:false ' lbstmt
from dual 
union all
select '--preconditions onFail:MARK_RAN onError:HALT' lbstmt
from dual 
union all
select '--precondition-sql-check expectedResult:0 select count(1) from EBA_STDS_STANDARD_TESTS where nt_type_id = &NT_TYPE_ID;' lbstmt
from dual 
union all
select q'[--precondition-sql-check expectedResult:Y select ast_preferences.get_preference ('AST_SERT_YN') from dual;]' lbstmt
from dual 
where &NT_TYPE_ID = 21
;

set sqlformat insert

select *  
from   except_cols (  
  EBA_STDS_STANDARD_TESTS,  
  columns ( created, created_by, updated, updated_by )  
)
where nt_type_id = &NT_TYPE_ID
order by display_sequence;

spool off

spool