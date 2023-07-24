--liquibase formatted sql
--changeset table_script:EBA_STDS_APP_STATUSES stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_APP_STATUSES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_APP_STATUSES.sql
--        Date:  04-Apr-2023 21:14
--     Purpose:  Table creation DDL for table EBA_STDS_APP_STATUSES
--               and related objects.
--
--------------------------------------------------------------------------------

  CREATE TABLE EBA_STDS_APP_STATUSES 
   (	ID NUMBER, 
      DISPLAY_SEQUENCE NUMBER, 
      STATUS_NAME VARCHAR2(32), 
      DESCRIPTION VARCHAR2(2000)
   ) 
/

  CREATE UNIQUE INDEX EBA_STAPST_IDX1 ON EBA_STDS_APP_STATUSES (STATUS_NAME) 
  
/


  ALTER TABLE EBA_STDS_APP_STATUSES MODIFY (DISPLAY_SEQUENCE NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_APP_STATUSES MODIFY (STATUS_NAME NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_APP_STATUSES ADD CONSTRAINT EBA_STAPST_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STAPST_PK_IDX ON EBA_STDS_APP_STATUSES (ID) 
  )  ENABLE
/


--rollback drop table EBA_STDS_APP_STATUSES;
