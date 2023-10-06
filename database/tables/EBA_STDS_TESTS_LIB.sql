--liquibase formatted sql
--changeset table_script:EBA_STDS_TESTS_LIB stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_TESTS_LIB');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_TESTS_LIB.sql
--        Date:  08-Jun-2023 21:55
--     Purpose:  Table creation DDL for table EBA_STDS_TESTS_LIB
--               and related objects.
-- preserves contents of EBA_STDS_STANDARD_TESTS for deployment
--
--------------------------------------------------------------------------------

-- drop table EBA_STDS_TESTS_LIB
-- /
  CREATE TABLE EBA_STDS_TESTS_LIB 
   (	ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE, 
	    STANDARD_ID NUMBER, 
	    TEST_NAME VARCHAR2(64 CHAR), 
	    QUERY_CLOB CLOB, 
	    TEST_CODE VARCHAR2(100 CHAR), 
	    ACTIVE_YN VARCHAR2(1 CHAR), 
	    MV_DEPENDENCY VARCHAR2(100 CHAR), 
	    SVT_COMPONENT_TYPE_ID NUMBER, 
	    TEST_ID NUMBER,
      EXPLANATION VARCHAR2(4000 CHAR),
      FIX CLOB,
      LEVEL_ID NUMBER,
      VERSION_NUMBER NUMBER,
      VERSION_DB VARCHAR2(55 CHAR)
   ) 
/


--   ALTER TABLE EBA_STDS_TESTS_LIB MODIFY (TEST_NAME NOT NULL ENABLE)
-- /


  ALTER TABLE EBA_STDS_TESTS_LIB MODIFY (TEST_CODE NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_TESTS_LIB MODIFY (WORKSPACE NOT NULL ENABLE)
/

  ALTER TABLE EBA_STDS_TESTS_LIB MODIFY (VERSION_NUMBER NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_TESTS_LIB MODIFY (VERSION_DB NOT NULL ENABLE)
/

--precondition-sql-check expectedResult:0 select count(*) from user_constraints where upper(constraint_name)  = 'EBA_STSTTS_LIB_PK'

  ALTER TABLE EBA_STDS_TESTS_LIB ADD CONSTRAINT EBA_STSTTS_LIB_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STSTTS_LIB_IDX ON EBA_STDS_TESTS_LIB (ID) 
  )  ENABLE
/

--precondition-sql-check expectedResult:0 select count(*) from user_constraints where upper(constraint_name)  = 'EBA_STSTTS_LIB_UK1'

  ALTER TABLE EBA_STDS_TESTS_LIB ADD CONSTRAINT EBA_STSTTS_LIB_UK1 UNIQUE (TEST_CODE)
  USING INDEX  ENABLE
/

--rollback drop table EBA_STDS_TESTS_LIB;
