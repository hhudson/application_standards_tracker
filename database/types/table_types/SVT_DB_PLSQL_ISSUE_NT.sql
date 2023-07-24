--liquibase formatted sql
--changeset table_type_script:SVT_DB_PLSQL_ISSUE_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('SVT_DB_PLSQL_ISSUE_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   SVT_DB_PLSQL_ISSUE_NT.sql
--        Date:  2022-Sep-16
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  SVT_db_plsql_issue_nt.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type SVT_DB_PLSQL_ISSUE_NT as table of SVT_DB_PLSQL_ISSUE_OT
     ]';
  dbms_output.put_line(q'[ type SVT_db_plsql_issue_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type SVT_DB_PLSQL_ISSUE_NT;