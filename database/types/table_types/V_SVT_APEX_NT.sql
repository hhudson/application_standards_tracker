--liquibase formatted sql
--changeset table_type_script:V_SVT_APEX_NT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_APEX_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   V_SVT_APEX_NT.sql
--        Date:  2023-Jan-25
--     Purpose:  Type creation DDL
--
-- used in package svt_standard_view
--------------------------------------------------------------------------------
-- prompt  v_svt_apex_nt.sql

create type V_SVT_APEX_NT as table of V_SVT_APEX_OT
/
--rollback drop type V_SVT_APEX_NT;