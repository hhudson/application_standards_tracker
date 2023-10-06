--liquibase formatted sql
--changeset table_script:EBA_STDS_STANDARDS stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_STANDARDS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARDS.sql
--        Date:  07-Apr-2023 22:36
--     Purpose:  Table creation DDL for table EBA_STDS_STANDARDS
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE EBA_STDS_STANDARDS 
   (	ID NUMBER, 
      STANDARD_NAME VARCHAR2(64 CHAR),
      DESCRIPTION VARCHAR2(4000 CHAR),
      PRIMARY_DEVELOPER VARCHAR2(255 CHAR),
      IMPLEMENTATION CLOB, 
      DATE_STARTED TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT localtimestamp, 
      CREATED TIMESTAMP (6) WITH LOCAL TIME ZONE, 
      CREATED_BY VARCHAR2(255 CHAR),
      UPDATED TIMESTAMP (6) WITH LOCAL TIME ZONE, 
      UPDATED_BY VARCHAR2(255 CHAR),
      STANDARD_GROUP VARCHAR2(32 CHAR),
      ACTIVE_YN VARCHAR2(1 CHAR),
      COMPATIBILITY_MODE_ID NUMBER NOT NULL,
      PARENT_STANDARD_ID NUMBER
   ) 
/
  ALTER TABLE EBA_STDS_STANDARDS MODIFY (STANDARD_NAME NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_STANDARDS MODIFY (DATE_STARTED NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_STANDARDS MODIFY (CREATED NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_STANDARDS MODIFY (CREATED_BY NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_STANDARDS MODIFY (UPDATED NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_STANDARDS MODIFY (UPDATED_BY NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_STANDARDS ADD CONSTRAINT EBA_STDSTN_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STDSTN_PK_IDX ON EBA_STDS_STANDARDS (ID) 
  )  ENABLE
/

  ALTER TABLE EBA_STDS_STANDARDS MODIFY (ACTIVE_YN NOT NULL ENABLE)
/

ALTER TABLE EBA_STDS_STANDARDS ADD CONSTRAINT EBA_STDSTN_UK UNIQUE (STANDARD_NAME, COMPATIBILITY_MODE_ID)
/

  ALTER TABLE EBA_STDS_STANDARDS ADD CONSTRAINT EBA_STDSTN_UK2 UNIQUE (id, parent_standard_id)
  USING INDEX  ENABLE
/

create index eba_stdstn_idx1 on eba_stds_standards (compatibility_mode_id)
/

create index eba_stdstn_idx2 on eba_stds_standards (parent_standard_id)
/

--rollback drop table EBA_STDS_STANDARDS;