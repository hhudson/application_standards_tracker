--liquibase formatted sql
--changeset table_script:AST_STANDARDS_URGENCY_LEVEL stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('AST_STANDARDS_URGENCY_LEVEL');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_STANDARDS_URGENCY_LEVEL.sql
--        Date:  10-Apr-2023 18:40
--     Purpose:  Table creation DDL for table AST_STANDARDS_URGENCY_LEVEL
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE AST_STANDARDS_URGENCY_LEVEL 
   (	ID NUMBER, 
	URGENCY_LEVEL NUMBER, 
	NAME VARCHAR2(255), 
	CREATED DATE, 
	CREATED_BY VARCHAR2(255), 
	UPDATED DATE, 
	UPDATED_BY VARCHAR2(255)
   ) 
/

  CREATE INDEX AST_STURLV_IDX2 ON AST_STANDARDS_URGENCY_LEVEL (URGENCY_LEVEL) 
  
/




  ALTER TABLE AST_STANDARDS_URGENCY_LEVEL MODIFY (CREATED NOT NULL ENABLE)
/


  ALTER TABLE AST_STANDARDS_URGENCY_LEVEL MODIFY (CREATED_BY NOT NULL ENABLE)
/


  ALTER TABLE AST_STANDARDS_URGENCY_LEVEL MODIFY (UPDATED NOT NULL ENABLE)
/


  ALTER TABLE AST_STANDARDS_URGENCY_LEVEL MODIFY (UPDATED_BY NOT NULL ENABLE)
/


  ALTER TABLE AST_STANDARDS_URGENCY_LEVEL ADD CONSTRAINT AST_STURLV_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX AST_STURLV_PK_IDX ON AST_STANDARDS_URGENCY_LEVEL (ID) 
  )  ENABLE
/


--rollback drop table AST_STANDARDS_URGENCY_LEVEL;
