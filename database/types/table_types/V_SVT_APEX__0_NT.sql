--liquibase formatted sql
--changeset table_type_script:V_SVT_APEX__0_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_APEX__0_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_svt_apex__0_nt.sql
--        Date:  2023-Jan-19
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  v_svt_apex__0_nt.sql

create type V_SVT_APEX__0_NT as table of v_svt_apex__0_ot
/
--rollback drop type V_SVT_APEX__0_NT;