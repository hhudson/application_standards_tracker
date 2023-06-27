--liquibase formatted sql
--changeset table_type_script:AST_APEX_PREFERENCES_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('AST_APEX_PREFERENCES_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   ast_apex_preferences_nt.sql
--        Date:  2023-Jan-9
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  ast_apex_preferences_nt.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type ast_apex_preferences_nt as table of ast_apex_preferences_ot
     ]';
  dbms_output.put_line(q'[ type ast_apex_preferences_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type AST_APEX_PREFERENCES_NT;