--liquibase formatted sql
--changeset table_script:EBA_STDS_APPLICATIONS stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_APPLICATIONS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_APPLICATIONS.sql
--        Date:  10-Apr-2023 19:41
--     Purpose:  Table creation DDL for table EBA_STDS_APPLICATIONS
--               and related objects.
--
/*
Initialize this table with the a2_initial_data_load script
*/
--------------------------------------------------------------------------------

  CREATE TABLE EBA_STDS_APPLICATIONS 
   (	PK_ID NUMBER generated by default on null as identity,
      APEX_APP_ID NUMBER, 
      ESA_CREATED TIMESTAMP (6) WITH LOCAL TIME ZONE, 
      ESA_CREATED_BY VARCHAR2(255 CHAR), 
      ESA_UPDATED TIMESTAMP (6) WITH LOCAL TIME ZONE, 
      ESA_UPDATED_BY VARCHAR2(255 CHAR),
      DEFAULT_DEVELOPER VARCHAR2(100 CHAR),
      TYPE_ID NUMBER,
      NOTES VARCHAR2(4000 CHAR),
      ACTIVE_YN VARCHAR2(1 CHAR) DEFAULT 'Y'
   ) 
/
  ALTER TABLE EBA_STDS_APPLICATIONS MODIFY (ESA_CREATED NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_APPLICATIONS MODIFY (ESA_CREATED_BY NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_APPLICATIONS MODIFY (APEX_APP_ID NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_APPLICATIONS MODIFY (ESA_UPDATED_BY NOT NULL ENABLE)
/
  ALTER TABLE EBA_STDS_APPLICATIONS MODIFY (ESA_UPDATED NOT NULL ENABLE)
/

--precondition-sql-check expectedResult:0 select count(*) from user_constraints where upper(constraint_name)  = 'EBA_STDS_APPLICATIONS_PK'

  ALTER TABLE EBA_STDS_APPLICATIONS ADD CONSTRAINT EBA_STDS_APPLICATIONS_PK PRIMARY KEY (PK_ID)
  USING INDEX  ENABLE
/

--precondition-sql-check expectedResult:0 select count(*) from user_constraints where upper(constraint_name)  = 'EBA_STDAPP_UK1'

  ALTER TABLE EBA_STDS_APPLICATIONS ADD CONSTRAINT EBA_STDAPP_UK1 UNIQUE (APEX_APP_ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STDAPP_UK1_IDX ON EBA_STDS_APPLICATIONS (APEX_APP_ID) 
  )  ENABLE
/

CREATE INDEX EBA_STDAPP_IDX1 ON EBA_STDS_APPLICATIONS (TYPE_ID)
/

--rollback drop table EBA_STDS_APPLICATIONS;
