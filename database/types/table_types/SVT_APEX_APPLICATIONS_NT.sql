--liquibase formatted sql
--changeset object_type_script:SVT_APEX_APPLICATIONS_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('SVT_APEX_APPLICATIONS_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   SVT_APEX_APPLICATIONS_NT.sql
--        Date:  2022-Sep-16
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  SVT_APEX_APPLICATIONS_NT.sql

create type SVT_APEX_APPLICATIONS_NT as table of SVT_APEX_APPLICATIONS_OT
/
--rollback drop type SVT_APEX_APPLICATIONS_NT;