--liquibase formatted sql
--changeset table_type_script:V_SVT_DB_MV__0_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_MV__0_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      author:  hayhudso
-- script name:   v_svt_db_mv__0_nt.sql
--        date:  2023-jan-26
--     purpose:  type creation ddl
--
--------------------------------------------------------------------------------
-- prompt  v_svt_db_mv__0_nt.sql

 create type V_SVT_DB_MV__0_NT as table of V_SVT_DB_MV__0_OT
/
--rollback drop type V_SVT_DB_MV__0_NT;