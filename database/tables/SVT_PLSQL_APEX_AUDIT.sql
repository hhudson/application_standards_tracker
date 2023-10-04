--liquibase formatted sql
--changeset table_script:SVT_PLSQL_APEX_AUDIT stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('SVT_PLSQL_APEX_AUDIT');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_PLSQL_APEX_AUDIT.sql
--        Date:  10-Apr-2023 19:41
--     Purpose:  Table creation DDL for table SVT_PLSQL_APEX_AUDIT
--               and related objects.
--
--------------------------------------------------------------------------------


  CREATE TABLE SVT_PLSQL_APEX_AUDIT 
   (	ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
		ISSUE_CATEGORY VARCHAR2(10 CHAR), 
		APPLICATION_ID NUMBER, 
		PAGE_ID NUMBER, 
		LINE NUMBER, 
		OBJECT_NAME VARCHAR2(255 CHAR), 
		OBJECT_TYPE VARCHAR2(31 CHAR), 
		CODE VARCHAR2(4000 CHAR), 
		VALIDATION_FAILURE_MESSAGE VARCHAR2(4000 CHAR), 
		APEX_CREATED_BY VARCHAR2(255 CHAR), 
		APEX_CREATED_ON DATE, 
		APEX_LAST_UPDATED_BY VARCHAR2(255 CHAR), 
		APEX_LAST_UPDATED_ON DATE, 
		ASSIGNEE VARCHAR2(255 CHAR), 
		NOTES VARCHAR2(4000 CHAR), 
		ACTION_ID NUMBER, 
		APEX_ISSUE_ID NUMBER, 
		ISSUE_TITLE VARCHAR2(1000 CHAR), 
		APEX_ISSUE_TITLE_SUFFIX VARCHAR2(100 CHAR), 
		OWNER VARCHAR2(50 CHAR), 
		TEST_CODE VARCHAR2(100 CHAR), 
		UNQID VARCHAR2(1000 CHAR), 
		LEGACY_YN VARCHAR2(1 CHAR),
		COMPONENT_ID NUMBER,
		PARENT_COMPONENT_ID NUMBER,
		CREATED DATE, 
		CREATED_BY VARCHAR2(255 CHAR), 
		UPDATED DATE, 
		UPDATED_BY VARCHAR2(255 CHAR)
		-- EXPIRED_YN VARCHAR2(1 CHAR)
   )  ENABLE ROW MOVEMENT 
/

  CREATE INDEX SVT_PLAPAD_IDX1 ON SVT_PLSQL_APEX_AUDIT (ACTION_ID) 
/
  ALTER TABLE SVT_PLSQL_APEX_AUDIT MODIFY (UPDATED NOT NULL ENABLE)
/
  ALTER TABLE SVT_PLSQL_APEX_AUDIT MODIFY (CREATED_BY NOT NULL ENABLE)
/
  ALTER TABLE SVT_PLSQL_APEX_AUDIT MODIFY (CREATED NOT NULL ENABLE)
/
  ALTER TABLE SVT_PLSQL_APEX_AUDIT MODIFY (UPDATED_BY NOT NULL ENABLE)
/

--precondition-sql-check expectedResult:0 select count(*) from user_constraints where upper(constraint_name)  = 'SVT_PLAPAD_UK2'

  ALTER TABLE SVT_PLSQL_APEX_AUDIT ADD CONSTRAINT SVT_PLAPAD_UK2 UNIQUE (UNQID)
  USING INDEX  ENABLE
/

--precondition-sql-check expectedResult:0 select count(*) from user_constraints where upper(constraint_name)  = 'SVT_PLAPAD_PK'

  ALTER TABLE SVT_PLSQL_APEX_AUDIT ADD CONSTRAINT SVT_PLAPAD_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX SVT_PLAPAD_PK_IDX ON SVT_PLSQL_APEX_AUDIT (ID) 
  )  ENABLE
/

CREATE INDEX SVT_PLAPAD_IDX2 ON svt_plsql_apex_audit(TEST_CODE)
/
CREATE INDEX SVT_PLAPAD_IDX3 ON svt_plsql_apex_audit(application_id)
/
--rollback drop table SVT_PLSQL_APEX_AUDIT;