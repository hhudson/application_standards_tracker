--liquibase formatted sql
--changeset table_script:EBA_STDS_HISTORY stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_HISTORY');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_HISTORY.sql
--        Date:  04-Apr-2023 21:32
--     Purpose:  Table creation DDL for table EBA_STDS_HISTORY
--               and related objects.
--
--------------------------------------------------------------------------------

  CREATE TABLE EBA_STDS_HISTORY 
   (	ID NUMBER, 
	COMPONENT_ID NUMBER, 
	COMPONENT_ROWKEY VARCHAR2(30), 
	TABLE_NAME VARCHAR2(60), 
	COLUMN_NAME VARCHAR2(60), 
	OLD_VALUE VARCHAR2(4000), 
	NEW_VALUE VARCHAR2(4000), 
	ACTION_DATE TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	ACTION_BY VARCHAR2(255), 
	ROW_VERSION_NUMBER NUMBER
   ) 
/

  CREATE INDEX EBA_STDHST_IDX1 ON EBA_STDS_HISTORY (COMPONENT_ID) 
  
/


  ALTER TABLE EBA_STDS_HISTORY MODIFY (TABLE_NAME NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_HISTORY MODIFY (COLUMN_NAME NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_HISTORY MODIFY (ACTION_DATE NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_HISTORY MODIFY (ACTION_BY NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_HISTORY MODIFY (ROW_VERSION_NUMBER NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_HISTORY ADD CONSTRAINT EBA_STDHST_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STDHST_PK_IDX ON EBA_STDS_HISTORY (ID) 
  )  ENABLE
/


--rollback drop table EBA_STDS_HISTORY;
