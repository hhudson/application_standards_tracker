--liquibase formatted sql
--changeset table_script:DEV_OHMS_CSSAP_DATA_MATRIX stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('DEV_OHMS_CSSAP_DATA_MATRIX');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  DEV_OHMS_CSSAP_DATA_MATRIX.sql
--        Date:  07-Apr-2023 16:02
--     Purpose:  Table creation DDL for table DEV_OHMS_CSSAP_DATA_MATRIX
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE DEV_OHMS_CSSAP_DATA_MATRIX 
   (	SCHEMA_NAME VARCHAR2(60 CHAR) DEFAULT ON NULL 'CARS', 
	TABLE_NAME VARCHAR2(60 CHAR) DEFAULT '6 years', 
	COLUMN_NAME VARCHAR2(60 CHAR) DEFAULT '6 years', 
	DATA_ELEMENT VARCHAR2(121 CHAR), 
	JUSTIFICATION VARCHAR2(1000 CHAR), 
	DATA_SOURCE VARCHAR2(250 CHAR) DEFAULT 'System being reviewed', 
	CUSTOMER_DATA VARCHAR2(3 CHAR) DEFAULT 'Yes', 
	STORED_WHERE VARCHAR2(50 CHAR) DEFAULT 'Application database', 
	GEOGRAPHIC_LOCATION VARCHAR2(100 CHAR), 
	METHOD_OF_DATA_COLLECTION VARCHAR2(255 CHAR), 
	ENCRYPTION_METHOD VARCHAR2(100 CHAR) DEFAULT 'Oracle Transparent Data Encryption', 
	ACCESS_CONTROLS VARCHAR2(255 CHAR) DEFAULT 'Application Authorization System and IdP', 
	DATA_CLASSIFICATION VARCHAR2(255 CHAR) DEFAULT 'Confidential - Oracle Highly Restricted', 
	DATA_RETENTION VARCHAR2(50 CHAR) DEFAULT '6 years', 
	CREATED_ON TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT ON NULL systimestamp, 
	CREATED_BY VARCHAR2(255) DEFAULT ON NULL user, 
	UPDATED_ON TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	UPDATED_BY VARCHAR2(255)
   ) 
/

  CREATE UNIQUE INDEX DEV_OHCSDM_IDX1 ON DEV_OHMS_CSSAP_DATA_MATRIX (SCHEMA_NAME, DATA_ELEMENT) 
  
/

  ALTER TABLE DEV_OHMS_CSSAP_DATA_MATRIX MODIFY (TABLE_NAME NOT NULL ENABLE)
/


  ALTER TABLE DEV_OHMS_CSSAP_DATA_MATRIX MODIFY (COLUMN_NAME NOT NULL ENABLE)
/


  ALTER TABLE DEV_OHMS_CSSAP_DATA_MATRIX MODIFY (DATA_ELEMENT NOT NULL ENABLE)
/


  ALTER TABLE DEV_OHMS_CSSAP_DATA_MATRIX MODIFY (DATA_SOURCE NOT NULL ENABLE)
/


  ALTER TABLE DEV_OHMS_CSSAP_DATA_MATRIX MODIFY (CREATED_ON NOT NULL ENABLE)
/


  ALTER TABLE DEV_OHMS_CSSAP_DATA_MATRIX MODIFY (CREATED_BY NOT NULL ENABLE)
/


  ALTER TABLE DEV_OHMS_CSSAP_DATA_MATRIX ADD CONSTRAINT DEV_OHCSDM_PK PRIMARY KEY (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME)
  USING INDEX  ENABLE
/


  ALTER TABLE DEV_OHMS_CSSAP_DATA_MATRIX ADD CONSTRAINT DEV_OHCSDM_UN1 UNIQUE (SCHEMA_NAME, DATA_ELEMENT)
  USING INDEX DEV_OHCSDM_IDX1  ENABLE
/


--rollback drop table DEV_OHMS_CSSAP_DATA_MATRIX;
