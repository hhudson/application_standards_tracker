--liquibase formatted sql
--changeset object_type_script:AST_APEX_PREFERENCES_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('AST_APEX_PREFERENCES_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   ast_apex_preferences_ot.sql
--        Date:  2023-Jan-9
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type ast_apex_preferences_ot as object
    (
        WORKSPACE_ID           NUMBER,      
        WORKSPACE_NAME         VARCHAR2(255),
        WORKSPACE_DISPLAY_NAME VARCHAR2(4000),
        USER_NAME              VARCHAR2(255),
        PREFERENCE_ID          NUMBER, 
        PREFERENCE_NAME        VARCHAR2(255),
        PREFERENCE_VALUE       VARCHAR2(4000),
        PREFERENCE_TYPE        VARCHAR2(23),
        PREFERENCE_COMMENT     VARCHAR2(55)
    ) ]';
  dbms_output.put_line(q'[ type ast_apex_preferences_ot created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type AST_APEX_PREFERENCES_OT;