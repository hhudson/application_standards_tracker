--liquibase formatted sql
--changeset table_script:EBA_STDS_STANDARD_APP_REF stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_STANDARD_APP_REF');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_APP_REF.sql
--        Date:  04-Apr-2023 21:40
--     Purpose:  Table creation DDL for table EBA_STDS_STANDARD_APP_REF
--               and related objects.
--
--------------------------------------------------------------------------------

  CREATE TABLE EBA_STDS_STANDARD_APP_REF 
   (	ID NUMBER, 
	STANDARD_ID NUMBER, 
	APPLICATION_ID NUMBER
   ) 
/

  CREATE UNIQUE INDEX EBA_STSTAR_IDX1 ON EBA_STDS_STANDARD_APP_REF (STANDARD_ID, APPLICATION_ID) 
  
/

  CREATE INDEX EBA_STSTAR_IDX2 ON EBA_STDS_STANDARD_APP_REF (APPLICATION_ID) 
  
/


  ALTER TABLE EBA_STDS_STANDARD_APP_REF MODIFY (STANDARD_ID NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_APP_REF MODIFY (APPLICATION_ID NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_APP_REF ADD CONSTRAINT EBA_STSTAR_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STSTAR_PK_IDX ON EBA_STDS_STANDARD_APP_REF (ID) 
  )  ENABLE
/


--rollback drop table EBA_STDS_STANDARD_APP_REF;
