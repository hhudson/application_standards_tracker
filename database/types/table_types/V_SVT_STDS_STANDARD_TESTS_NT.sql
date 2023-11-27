--liquibase formatted sql
--changeset table_type_script:V_SVT_STDS_STANDARD_TESTS_NT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_STDS_STANDARD_TESTS_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   V_SVT_STDS_STANDARD_TESTS_NT.sql
--        Date:  2023-Jun-21
--     Purpose:  Type creation DDL
--
-- used in package svt_standard_view
--------------------------------------------------------------------------------
-- prompt  v_svt_stds_standard_tests_nt.sql

create type v_svt_stds_standard_tests_nt as table of v_svt_stds_standard_tests_ot
/
--rollback drop type V_SVT_STDS_STANDARD_TESTS_NT;