--liquibase formatted sql
--changeset table_script:AST_SUB_REFERENCE_CODES stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('AST_SUB_REFERENCE_CODES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_SUB_REFERENCE_CODES.sql
--        Date:  10-Apr-2023 18:40
--     Purpose:  Table creation DDL for table AST_SUB_REFERENCE_CODES
--               and related objects.
-- data is deployed via EBA_TEST_HELP_LIB
--
--------------------------------------------------------------------------------


  CREATE TABLE AST_SUB_REFERENCE_CODES 
   (	ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	SUB_CODE VARCHAR2(100) DEFAULT 'NA', 
	EXPLANATION VARCHAR2(4000 CHAR), 
	CREATED DATE, 
	CREATED_BY VARCHAR2(255 CHAR), 
	UPDATED DATE, 
	UPDATED_BY VARCHAR2(255 CHAR), 
	FIX CLOB, 
	TEST_ID NUMBER DEFAULT 1
   ) 
/

  CREATE INDEX AST_SUB_REFERENCE_I1 ON AST_SUB_REFERENCE_CODES (TEST_ID) 
  
/




  ALTER TABLE AST_SUB_REFERENCE_CODES MODIFY (SUB_CODE NOT NULL ENABLE)
/


  ALTER TABLE AST_SUB_REFERENCE_CODES MODIFY (TEST_ID NOT NULL ENABLE)
/


  ALTER TABLE AST_SUB_REFERENCE_CODES MODIFY (CREATED NOT NULL ENABLE)
/


  ALTER TABLE AST_SUB_REFERENCE_CODES MODIFY (CREATED_BY NOT NULL ENABLE)
/


  ALTER TABLE AST_SUB_REFERENCE_CODES MODIFY (UPDATED NOT NULL ENABLE)
/


  ALTER TABLE AST_SUB_REFERENCE_CODES MODIFY (UPDATED_BY NOT NULL ENABLE)
/


  ALTER TABLE AST_SUB_REFERENCE_CODES ADD CONSTRAINT AST_SUB_REFERENCE_ID_PK PRIMARY KEY (ID)
  USING INDEX  ENABLE
/


  ALTER TABLE AST_SUB_REFERENCE_CODES ADD CONSTRAINT AST_SUB_REFERENCE_CODES_UK1 UNIQUE (SUB_CODE)
  USING INDEX  ENABLE
/


--rollback drop table AST_SUB_REFERENCE_CODES;
