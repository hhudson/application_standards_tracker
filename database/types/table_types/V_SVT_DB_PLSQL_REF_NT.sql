--liquibase formatted sql
--changeset table_type_script:V_SVT_DB_plsql_REF_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_plsql_REF_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   V_SVT_DB_PLSQL_REF_NT.sql
--        Date:  2023-Jan-30
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  V_SVT_DB_PLSQL_REF_NT.sql

create type V_SVT_DB_PLSQL_REF_NT as table of V_SVT_DB_PLSQL_REF_OT
/
--rollback drop type V_SVT_DB_plsql_REF_NT;