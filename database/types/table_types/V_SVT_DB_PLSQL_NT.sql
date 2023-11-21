--liquibase formatted sql
--changeset table_type_script:V_SVT_DB_PLSQL_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_PLSQL_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_svt_db_plsql_nt.sql
--        Date:  2023-Jan-19
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  v_svt_db_plsql_nt.sql

create type V_SVT_DB_PLSQL_NT as table of V_SVT_DB_PLSQL_OT
/
--rollback drop type V_SVT_DB_PLSQL_NT;