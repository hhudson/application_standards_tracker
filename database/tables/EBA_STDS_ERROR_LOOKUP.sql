--liquibase formatted sql
--changeset table_script:EBA_STDS_ERROR_LOOKUP stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_ERROR_LOOKUP');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_ERROR_LOOKUP.sql
--        Date:  04-Apr-2023 21:20
--     Purpose:  Table creation DDL for table EBA_STDS_ERROR_LOOKUP
--               and related objects.
--
--------------------------------------------------------------------------------

  CREATE TABLE EBA_STDS_ERROR_LOOKUP 
   (	CONSTRAINT_NAME VARCHAR2(30 CHAR), 
      MESSAGE VARCHAR2(4000 CHAR), 
      LANGUAGE_CODE VARCHAR2(30 CHAR)
   ) 
/

  ALTER TABLE EBA_STDS_ERROR_LOOKUP MODIFY (CONSTRAINT_NAME NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_ERROR_LOOKUP MODIFY (MESSAGE NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_ERROR_LOOKUP MODIFY (LANGUAGE_CODE NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_ERROR_LOOKUP ADD CONSTRAINT EBA_STERLK_PK PRIMARY KEY (CONSTRAINT_NAME)
  USING INDEX (CREATE UNIQUE INDEX EBA_STERLK_PK_IDX ON EBA_STDS_ERROR_LOOKUP (CONSTRAINT_NAME) 
  )  ENABLE
/


  ALTER TABLE EBA_STDS_ERROR_LOOKUP ADD CONSTRAINT EBA_STERLK_UK1 UNIQUE (CONSTRAINT_NAME, LANGUAGE_CODE)
  USING INDEX (CREATE UNIQUE INDEX EBA_STERLK_UK1_IDX ON EBA_STDS_ERROR_LOOKUP (CONSTRAINT_NAME, LANGUAGE_CODE) 
  )  ENABLE
/


--rollback drop table EBA_STDS_ERROR_LOOKUP;
