--liquibase formatted sql
--changeset table_script:SVT_STANDARDS_URGENCY_LEVEL stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('SVT_STANDARDS_URGENCY_LEVEL');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STANDARDS_URGENCY_LEVEL.sql
--        Date:  10-Apr-2023 18:40
--     Purpose:  Table creation DDL for table SVT_STANDARDS_URGENCY_LEVEL
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE SVT_STANDARDS_URGENCY_LEVEL 
   (	ID NUMBER, 
	    URGENCY_LEVEL NUMBER NOT NULL, 
	    URGENCY_NAME VARCHAR2(255 CHAR) NOT NULL, 
	    CREATED DATE, 
	    CREATED_BY VARCHAR2(255 CHAR), 
	    UPDATED DATE, 
	    UPDATED_BY VARCHAR2(255 CHAR)
   ) 
/

  CREATE INDEX SVT_STURLV_IDX2 ON SVT_STANDARDS_URGENCY_LEVEL (URGENCY_LEVEL) 
/
  ALTER TABLE SVT_STANDARDS_URGENCY_LEVEL MODIFY (CREATED NOT NULL ENABLE)
/
  ALTER TABLE SVT_STANDARDS_URGENCY_LEVEL MODIFY (CREATED_BY NOT NULL ENABLE)
/
  ALTER TABLE SVT_STANDARDS_URGENCY_LEVEL MODIFY (UPDATED NOT NULL ENABLE)
/
  ALTER TABLE SVT_STANDARDS_URGENCY_LEVEL MODIFY (UPDATED_BY NOT NULL ENABLE)
/
  ALTER TABLE SVT_STANDARDS_URGENCY_LEVEL ADD CONSTRAINT SVT_STURLV_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX SVT_STURLV_PK_IDX ON SVT_STANDARDS_URGENCY_LEVEL (ID) 
  )  ENABLE
/


--rollback drop table SVT_STANDARDS_URGENCY_LEVEL;
