--liquibase formatted sql
--changeset table_script:EBA_STDS_STANDARD_TESTS stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_STANDARD_TESTS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_TESTS.sql
--        Date:  10-Apr-2023 17:45
--     Purpose:  Table creation DDL for table EBA_STDS_STANDARD_TESTS
--               and related objects.
-- data is deployed via EBA_STDS_TESTS_LIB
--
--------------------------------------------------------------------------------


  CREATE TABLE EBA_STDS_STANDARD_TESTS 
   (	ID NUMBER, 
      STANDARD_ID NUMBER, 
      TEST_NAME VARCHAR2(64), 
      DISPLAY_SEQUENCE NUMBER, 
      QUERY_CLOB CLOB, 
      OWNER VARCHAR2(128) DEFAULT sys_context('userenv','current_schema'), 
      STANDARD_CODE VARCHAR2(100), 
      LEVEL_ID NUMBER,
      EXPLANATION VARCHAR2(4000 CHAR), 
      FIX CLOB,
      ACTIVE_YN VARCHAR2(1) DEFAULT 'Y', 
      VERSION_NUMBER NUMBER,
      CREATED TIMESTAMP (6) WITH LOCAL TIME ZONE, 
      CREATED_BY VARCHAR2(255), 
      UPDATED TIMESTAMP (6) WITH LOCAL TIME ZONE, 
      UPDATED_BY VARCHAR2(255)
   ) 
/

--   CREATE INDEX EBA_STSTTS_IDX5 ON EBA_STDS_STANDARD_TESTS (NT_TYPE_ID) 
  
-- /

  CREATE INDEX EBA_STSTTS_IDX1 ON EBA_STDS_STANDARD_TESTS (STANDARD_ID) 
  
/

  CREATE INDEX EBA_STSTTS_IDX4 ON EBA_STDS_STANDARD_TESTS (LEVEL_ID) 
  
/




  ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (STANDARD_CODE NOT NULL ENABLE)
/


--   ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (NT_TYPE_ID NOT NULL ENABLE)
-- /



  ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (STANDARD_ID NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (TEST_NAME NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (CREATED NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (CREATED_BY NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (UPDATED NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (UPDATED_BY NOT NULL ENABLE)
/


  ALTER TABLE EBA_STDS_STANDARD_TESTS ADD CONSTRAINT EBA_STDS_STANDARD_TESTS_UK1 UNIQUE (test_name)
  USING INDEX  ENABLE
/


  ALTER TABLE EBA_STDS_STANDARD_TESTS ADD CONSTRAINT EBA_STSTTS_PK PRIMARY KEY (ID)
  USING INDEX (CREATE UNIQUE INDEX EBA_STSTTS_PK_IDX ON EBA_STDS_STANDARD_TESTS (ID) 
  )  ENABLE
/


--rollback drop table EBA_STDS_STANDARD_TESTS;

--liquibase formatted sql
--changeset table_script:EBA_STDS_STANDARD_TESTS.MV_DEPENDENCY stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tab_cols where upper(table_name) = 'EBA_STDS_STANDARD_TESTS' and column_name = 'MV_DEPENDENCY';

alter table EBA_STDS_STANDARD_TESTS add MV_DEPENDENCY varchar2(100)
/

--liquibase formatted sql
--changeset table_script:EBA_STDS_STANDARD_TESTS.AST_COMPONENT_TYPE_ID stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tab_cols where upper(table_name) = 'EBA_STDS_STANDARD_TESTS' and column_name = 'AST_COMPONENT_TYPE_ID';

alter table EBA_STDS_STANDARD_TESTS add ast_component_type_id number
/
ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (ast_component_type_id NOT NULL ENABLE)
/

ALTER TABLE EBA_STDS_STANDARD_TESTS ADD CONSTRAINT EBA_STDS_STANDARD_TESTS_UK2 UNIQUE (standard_code)
USING INDEX  ENABLE
/

alter table EBA_STDS_STANDARD_TESTS add EXPLANATION VARCHAR2(4000 CHAR)
/
alter table EBA_STDS_STANDARD_TESTS add FIX CLOB
/

alter table eba_stds_standard_tests add version_number number
/

  ALTER TABLE EBA_STDS_STANDARD_TESTS MODIFY (version_number NOT NULL ENABLE)
/
