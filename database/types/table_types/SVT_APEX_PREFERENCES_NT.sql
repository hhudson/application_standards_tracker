--liquibase formatted sql
--changeset table_type_script:SVT_APEX_PREFERENCES_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('SVT_APEX_PREFERENCES_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   SVT_APEX_PREFERENCES_NT.sql
--        Date:  2023-Jan-9
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  SVT_apex_preferences_nt.sql

create type SVT_APEX_PREFERENCES_NT as table of SVT_APEX_PREFERENCES_OT
/
--rollback drop type SVT_APEX_PREFERENCES_NT;