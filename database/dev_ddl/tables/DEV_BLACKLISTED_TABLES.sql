--liquibase formatted sql
--changeset table_script:DEV_BLACKLISTED_TABLES stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('DEV_BLACKLISTED_TABLES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  DEV_BLACKLISTED_TABLES.sql
--        Date:  07-Apr-2023 16:00
--     Purpose:  Table creation DDL for table DEV_BLACKLISTED_TABLES
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE DEV_BLACKLISTED_TABLES 
   (	SCHEMA_NAME VARCHAR2(60 CHAR), 
	TABLE_NAME VARCHAR2(60 CHAR), 
	COMMENTS VARCHAR2(500 CHAR), 
	OWNER VARCHAR2(60 CHAR), 
	TRANSIENT_PROD_TABLE VARCHAR2(1 CHAR), 
	CREATED_ON TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT ON NULL systimestamp, 
	CREATED_BY VARCHAR2(255) DEFAULT ON NULL user, 
	UPDATED_ON TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	UPDATED_BY VARCHAR2(255), 
	INC_CSSAP_COMPLIANCE VARCHAR2(1 CHAR)
   ) 
/




  ALTER TABLE DEV_BLACKLISTED_TABLES MODIFY (SCHEMA_NAME NOT NULL ENABLE)
/


  ALTER TABLE DEV_BLACKLISTED_TABLES MODIFY (TABLE_NAME NOT NULL ENABLE)
/


  ALTER TABLE DEV_BLACKLISTED_TABLES MODIFY (CREATED_BY NOT NULL ENABLE)
/


  ALTER TABLE DEV_BLACKLISTED_TABLES ADD CONSTRAINT DEV_BLCTBL_CK1 CHECK ( transient_prod_table IN ( 'N', 'Y' ) ) ENABLE
/


  ALTER TABLE DEV_BLACKLISTED_TABLES ADD CONSTRAINT DEV_BLCTBL_CK2 CHECK ( inc_cssap_compliance IN ( 'N', 'Y' ) ) ENABLE
/


  ALTER TABLE DEV_BLACKLISTED_TABLES ADD CONSTRAINT DEV_BLCTBL_PK PRIMARY KEY (SCHEMA_NAME, TABLE_NAME)
  USING INDEX  ENABLE
/


--rollback drop table DEV_BLACKLISTED_TABLES;
