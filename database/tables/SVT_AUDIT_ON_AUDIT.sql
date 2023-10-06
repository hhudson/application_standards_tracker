--liquibase formatted sql
--changeset table_script:SVT_AUDIT_ON_AUDIT stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('SVT_AUDIT_ON_AUDIT');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_AUDIT_ON_AUDIT.sql
--        Date:  10-Apr-2023 19:40
--     Purpose:  Table creation DDL for table SVT_AUDIT_ON_AUDIT
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE SVT_AUDIT_ON_AUDIT 
   (	ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
      UNQID VARCHAR2(1000 CHAR), 
      ACTION_NAME VARCHAR2(100 CHAR), 
      TEST_CODE VARCHAR2(100 CHAR),
      AUDIT_ID NUMBER,
      VALIDATION_FAILURE_MESSAGE VARCHAR2(4000 CHAR),
      CREATED DATE, 
      CREATED_BY VARCHAR2(255 CHAR)
   ) 
/

  ALTER TABLE SVT_AUDIT_ON_AUDIT MODIFY (ACTION_NAME NOT NULL ENABLE)
/


  ALTER TABLE SVT_AUDIT_ON_AUDIT MODIFY (UNQID NOT NULL ENABLE)
/


  ALTER TABLE SVT_AUDIT_ON_AUDIT MODIFY (CREATED NOT NULL ENABLE)
/

--precondition-sql-check expectedResult:0 select count(*) from user_constraints where upper(constraint_name)  = 'SVT_ADT_PK'

  ALTER TABLE SVT_AUDIT_ON_AUDIT ADD CONSTRAINT SVT_ADT_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX SVT_ADT_PK_IDX ON SVT_AUDIT_ON_AUDIT (ID) 
  )  ENABLE
/

--rollback drop table SVT_AUDIT_ON_AUDIT;