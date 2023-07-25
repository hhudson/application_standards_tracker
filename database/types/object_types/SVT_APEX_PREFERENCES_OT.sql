--liquibase formatted sql
--changeset object_type_script:SVT_APEX_PREFERENCES_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('SVT_APEX_PREFERENCES_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   SVT_APEX_PREFERENCES_OT.sql
--        Date:  2023-Jan-9
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
create type SVT_APEX_PREFERENCES_OT as object
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
    )
/
--rollback drop type SVT_APEX_PREFERENCES_OT;