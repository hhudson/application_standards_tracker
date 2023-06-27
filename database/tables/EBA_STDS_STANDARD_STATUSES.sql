--liquibase formatted sql
--changeset table_script:EBA_STDS_STANDARD_STATUSES stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_STANDARD_STATUSES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_STATUSES.sql
--        Date:  04-Apr-2023 22:01
--     Purpose:  Table creation DDL for table EBA_STDS_STANDARD_STATUSES
--               and related objects.
--
--------------------------------------------------------------------------------

  CREATE TABLE EBA_STDS_STANDARD_STATUSES 
   (	ID NUMBER, 
	STANDARD_ID NUMBER, 
	APPLICATION_ID NUMBER, 
	TEST_ID NUMBER, 
	PASS_FAIL_PCT NUMBER, 
	TEST_DURATION NUMBER, 
	UPDATED TIMESTAMP (6) WITH LOCAL TIME ZONE
   ) 
/

  CREATE INDEX EBA_STSTST_IDX1 ON EBA_STDS_STANDARD_STATUSES (APPLICATION_ID) 
  
/

  CREATE INDEX EBA_STSTST_IDX2 ON EBA_STDS_STANDARD_STATUSES (STANDARD_ID) 
  
/

  CREATE INDEX EBA_STSTST_IDX3 ON EBA_STDS_STANDARD_STATUSES (TEST_ID) 
  
/

  ALTER TABLE EBA_STDS_STANDARD_STATUSES MODIFY (UPDATED NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_STATUSES ADD CONSTRAINT EBA_STSTST_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STSTST_PK_IDX ON EBA_STDS_STANDARD_STATUSES (ID) 
  )  ENABLE
/


--rollback drop table EBA_STDS_STANDARD_STATUSES;
