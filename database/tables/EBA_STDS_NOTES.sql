--liquibase formatted sql
--changeset table_script:EBA_STDS_NOTES stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_NOTES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_NOTES.sql
--        Date:  04-Apr-2023 21:34
--     Purpose:  Table creation DDL for table EBA_STDS_NOTES
--               and related objects.
--
--------------------------------------------------------------------------------

  CREATE TABLE EBA_STDS_NOTES 
   (	ID NUMBER, 
	APPLICATION_ID NUMBER, 
	NOTE CLOB, 
	ROW_VERSION_NUMBER NUMBER, 
	CREATED TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	CREATED_BY VARCHAR2(255), 
	UPDATED TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	UPDATED_BY VARCHAR2(255)
   ) 
/

  CREATE INDEX EBA_STDNTS_IDX1 ON EBA_STDS_NOTES (APPLICATION_ID) 
  
/




  ALTER TABLE EBA_STDS_NOTES MODIFY (ROW_VERSION_NUMBER NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_NOTES MODIFY (CREATED NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_NOTES MODIFY (CREATED_BY NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_NOTES MODIFY (UPDATED NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_NOTES MODIFY (UPDATED_BY NOT NULL ENABLE)
/

  ALTER TABLE EBA_STDS_NOTES MODIFY (APPLICATION_ID NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_NOTES MODIFY (NOTE NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_NOTES ADD CONSTRAINT EBA_STDNTS_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STDNTS_PK_IDX ON EBA_STDS_NOTES (ID) 
  )  ENABLE
/


--rollback drop table EBA_STDS_NOTES;
