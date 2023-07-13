
--liquibase formatted sql
--changeset object_type_script:V_EBA_STDS_STANDARD_TESTS_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_EBA_STDS_STANDARD_TESTS_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_eba_stds_standard_tests_ot.sql
--        Date:  2023-Jun-21
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- drop type v_eba_stds_standard_tests_nt
-- /
-- drop type v_eba_stds_standard_tests_ot
-- /
  create type v_eba_stds_standard_tests_ot as object
    (
        STANDARD_ID             NUMBER,
        TEST_ID                 NUMBER,
        LEVEL_ID                NUMBER,
        URGENCY                 VARCHAR2(255),
        URGENCY_LEVEL           NUMBER,
        TEST_NAME               VARCHAR2(64),
        STANDARD_CODE           VARCHAR2(100),
        STANDARD_CATEGORY_NAME  VARCHAR2(64),
        ACTIVE_YN               VARCHAR2(1),
        NT_NAME                 VARCHAR2(255 CHAR),
        QUERY_CLOB              CLOB,
        STD_CREATION_DATE       TIMESTAMP(6) WITH LOCAL TIME ZONE,
        MV_DEPENDENCY           VARCHAR2(100),
        AST_COMPONENT_TYPE_ID   NUMBER,
        COMPONENT_NAME          VARCHAR2(50),
        STANDARD_ACTIVE_YN      VARCHAR2(1),
        EXPLANATION             VARCHAR2(4000 CHAR),
        FIX                     CLOB,
        DOWNLOAD                NUMBER,   
        FILE_BLOB               BLOB,
        MIME_TYPE               CHAR(16),
        FILE_NAME               VARCHAR2(4000), 
        CHARACTER_SET           CHAR(5),
        VERSION_NUMBER          NUMBER,
        RECORD_MD5              VARCHAR2(250)
    )
/
--rollback drop type V_EBA_STDS_STANDARD_TESTS_OT;