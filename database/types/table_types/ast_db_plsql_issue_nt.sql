--liquibase formatted sql
--changeset table_type_script:AST_DB_PLSQL_ISSUE_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('AST_DB_PLSQL_ISSUE_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   ast_db_plsql_issue_nt.sql
--        Date:  2022-Sep-16
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  ast_db_plsql_issue_nt.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type ast_db_plsql_issue_nt as table of ast_db_plsql_issue_ot
     ]';
  dbms_output.put_line(q'[ type ast_db_plsql_issue_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type AST_DB_PLSQL_ISSUE_NT;