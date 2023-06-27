--liquibase formatted sql
--changeset object_type_script:AST_APEX_APPLICATIONS_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('AST_APEX_APPLICATIONS_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   ast_apex_applications_nt.sql
--        Date:  2022-Sep-16
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  ast_apex_applications_nt.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type ast_apex_applications_nt as table of ast_apex_applications_ot
     ]';
  dbms_output.put_line(q'[ type ast_apex_applications_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type AST_APEX_APPLICATIONS_NT;