--liquibase formatted sql
--changeset table_type_script:v_svt_db_trigger__0_nt stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('v_svt_db_trigger__0_nt');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      author:  hayhudso
-- script name:   v_svt_db_trigger__0_nt.sql
--        date:  2023-Nov-8
--     purpose:  type creation ddl
--
--------------------------------------------------------------------------------
-- prompt  v_svt_db_trigger__0_nt.sql

 create type v_svt_db_trigger__0_nt as table of v_svt_db_trigger__0_ot
/
--rollback drop type v_svt_db_trigger__0_nt;