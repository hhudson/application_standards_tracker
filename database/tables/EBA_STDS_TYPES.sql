--liquibase formatted sql
--changeset table_script:EBA_STDS_TYPES stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_TYPES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_TYPES.sql
--        Date:  04-Apr-2023 22:12
--     Purpose:  Table creation DDL for table EBA_STDS_TYPES
--               and related objects.
--
--------------------------------------------------------------------------------

  CREATE TABLE EBA_STDS_TYPES 
   (	ID NUMBER, 
	    DISPLAY_SEQUENCE NUMBER, 
	    TYPE_NAME VARCHAR2(32 CHAR), 
      TYPE_CODE VARCHAR2(10 CHAR),
	    DESCRIPTION VARCHAR2(2000 CHAR),
      ACTIVE_YN VARCHAR2(1 CHAR) DEFAULT 'Y'
   ) 
/

  CREATE UNIQUE INDEX EBA_STDTYP_IDX1 ON EBA_STDS_TYPES (TYPE_NAME) 
  
/


--   ALTER TABLE EBA_STDS_TYPES MODIFY (DISPLAY_SEQUENCE NOT NULL ENABLE)
-- /


  ALTER TABLE EBA_STDS_TYPES MODIFY (TYPE_NAME NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_TYPES ADD CONSTRAINT EBA_STDTYP_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STDTYP_PK_IDX ON EBA_STDS_TYPES (ID) 
  )  ENABLE
/


ALTER TABLE EBA_STDS_TYPES ADD CONSTRAINT EBA_STDTYP_UK2 UNIQUE (TYPE_CODE)
  USING INDEX (CREATE UNIQUE INDEX EBA_STDTYP_IDX2 ON EBA_STDS_TYPES (TYPE_CODE) 
  )  ENABLE
/

ALTER TABLE EBA_STDS_TYPES MODIFY (TYPE_CODE NOT NULL ENABLE)
/

--rollback drop table EBA_STDS_TYPES;
