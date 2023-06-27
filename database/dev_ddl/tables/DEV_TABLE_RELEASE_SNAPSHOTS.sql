--liquibase formatted sql
--changeset table_script:DEV_TABLE_RELEASE_SNAPSHOTS stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('DEV_TABLE_RELEASE_SNAPSHOTS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  DEV_TABLE_RELEASE_SNAPSHOTS.sql
--        Date:  07-Apr-2023 16:05
--     Purpose:  Table creation DDL for table DEV_TABLE_RELEASE_SNAPSHOTS
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE DEV_TABLE_RELEASE_SNAPSHOTS 
   (	RELEASE_LABEL VARCHAR2(12 CHAR), 
	TABLE_NAME VARCHAR2(60 CHAR), 
	CREATED DATE, 
	LAST_DDL_TIME DATE, 
	CREATED_ON TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	CREATED_BY VARCHAR2(255), 
	UPDATED_ON TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	UPDATED_BY VARCHAR2(255)
   ) 
/




  ALTER TABLE DEV_TABLE_RELEASE_SNAPSHOTS MODIFY (RELEASE_LABEL NOT NULL ENABLE)
/


  ALTER TABLE DEV_TABLE_RELEASE_SNAPSHOTS MODIFY (TABLE_NAME NOT NULL ENABLE)
/


  ALTER TABLE DEV_TABLE_RELEASE_SNAPSHOTS MODIFY (CREATED_ON NOT NULL ENABLE)
/


  ALTER TABLE DEV_TABLE_RELEASE_SNAPSHOTS MODIFY (CREATED_BY NOT NULL ENABLE)
/


  ALTER TABLE DEV_TABLE_RELEASE_SNAPSHOTS ADD CONSTRAINT DEV_TBRLSN_PK PRIMARY KEY (RELEASE_LABEL, TABLE_NAME)
  USING INDEX  ENABLE
/


--rollback drop table DEV_TABLE_RELEASE_SNAPSHOTS;
