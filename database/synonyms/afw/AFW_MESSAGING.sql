--liquibase formatted sql
--changeset synonym_script:AFW_MESSAGING stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_synonyms where upper(synonym_name) = upper('AFW_MESSAGING');
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:  afw_messaging.sql
--        Date:  2023-Apr-3
--     Purpose:  Synonym for afw_messaging.
--
--------------------------------------------------------------------------------

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
  c_create_stmt varchar2(250) := 
    apex_string.format(
        p_message => 'create synonym afw_messaging for %0.afw_messaging',
        p0 => SVT_preferences.get_preference ('SVT_DEFAULT_SCHEMA')
  );
begin
  execute immediate c_create_stmt;
  dbms_output.put_line(q'[ synonym afw_messaging created ]');
exception
  when already_exists then dbms_output.put_line('already ran : '||c_create_stmt);
end;
/
--rollback drop synonym AFW_MESSAGING;