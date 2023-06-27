--liquibase formatted sql
--changeset table_script:EBA_STDS_ACCESS_LEVELS stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_ACCESS_LEVELS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_ACCESS_LEVELS.sql
--        Date:  10-Apr-2023 18:41
--     Purpose:  Table creation DDL for table EBA_STDS_ACCESS_LEVELS
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE EBA_STDS_ACCESS_LEVELS 
   (	ID NUMBER, 
	ACCESS_LEVEL VARCHAR2(30)
   ) 
/




  ALTER TABLE EBA_STDS_ACCESS_LEVELS MODIFY (ACCESS_LEVEL NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_ACCESS_LEVELS ADD CONSTRAINT EBA_STACLV_CK1 CHECK (access_level in ('Administrator', 'Contributor','Reader' )) ENABLE
/


  ALTER TABLE EBA_STDS_ACCESS_LEVELS ADD CONSTRAINT EBA_STACLV_UK1 UNIQUE (ACCESS_LEVEL)
  USING INDEX (CREATE UNIQUE INDEX EBA_STACLV_UK1_IDX ON EBA_STDS_ACCESS_LEVELS (ACCESS_LEVEL) 
  )  ENABLE
/


  ALTER TABLE EBA_STDS_ACCESS_LEVELS ADD CONSTRAINT EBA_STACLV_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STACLV_PK_IDX ON EBA_STDS_ACCESS_LEVELS (ID) 
  )  ENABLE
/


--rollback drop table EBA_STDS_ACCESS_LEVELS;
