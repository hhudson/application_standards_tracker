
--liquibase formatted sql
--changeset object_type_script:V_SVT_STDS_STANDARD_TESTS_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_STDS_STANDARD_TESTS_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   V_SVT_STDS_STANDARD_TESTS_OT.sql
--        Date:  2023-Jun-21
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------

  create type v_svt_stds_standard_tests_ot as object
    (
        STANDARD_ID             NUMBER,
        TEST_ID                 NUMBER,
        LEVEL_ID                NUMBER,
        URGENCY                 VARCHAR2(255),
        URGENCY_LEVEL           NUMBER,
        TEST_NAME               VARCHAR2(64),
        TEST_CODE               VARCHAR2(100),
        STANDARD_NAME           VARCHAR2(64),
        ACTIVE_YN               VARCHAR2(1),
        NT_NAME                 VARCHAR2(255 CHAR),
        QUERY_CLOB              CLOB,
        STD_CREATION_DATE       TIMESTAMP(6) WITH LOCAL TIME ZONE,
        MV_DEPENDENCY           VARCHAR2(100),
        SVT_COMPONENT_TYPE_ID   NUMBER,
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
        VERSION_DB              VARCHAR2(55),
        VSN                     VARCHAR2(5),
        RECORD_MD5              VARCHAR2(250),
        LIB_MD5                 VARCHAR2(250),
        LIB_IMPORTED_VERSION    NUMBER,
        PUBLISHED_YN            VARCHAR2(1),
        DOWNLOAD_CSS            VARCHAR2(50),
        INHERITED_YN            VARCHAR2(1),
        CALLING_STANDARD_NAME   VARCHAR2(64), --only relevant for inherited tests
        DISPLAY_SEQUENCE        NUMBER
    )
/
--rollback drop type V_SVT_STDS_STANDARD_TESTS_OT;