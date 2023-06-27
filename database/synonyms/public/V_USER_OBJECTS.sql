--liquibase formatted sql
--changeset synonym_script:V_USER_OBJECTS stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_synonyms where upper(synonym_name) = upper('V_USER_OBJECTS');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:  V_USER_OBJECTS.sql
--        Date:  2023-Feb-7
--     Purpose:  Synonym for V_USER_OBJECTS
--
--------------------------------------------------------------------------------

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate 'create public synonym V_USER_OBJECTS for ast.V_USER_OBJECTS';
  dbms_output.put_line(q'[ synonym V_USER_OBJECTS created ]');
exception
  when already_exists then null;
end;
/
--rollback drop synonym V_USER_OBJECTS;