--liquibase formatted sql
--changeset fk_script:EBA_STDS_STANDARD_TESTS stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_STANDARD_TESTS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_TESTS.sql
--        Date:  10-Apr-2023 16:01
--     Purpose:  Foreign key creation DDL for table EBA_STDS_STANDARD_TESTS
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STSTTS_EBA_STDSTN_FK5';

  ALTER TABLE EBA_STDS_STANDARD_TESTS ADD CONSTRAINT EBA_STSTTS_EBA_STDSTN_FK5 FOREIGN KEY (LEVEL_ID)
	  REFERENCES AST_STANDARDS_URGENCY_LEVEL (ID) ENABLE
/
--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STSTTS_EBA_STDSTN_FK1';

  ALTER TABLE EBA_STDS_STANDARD_TESTS ADD CONSTRAINT EBA_STSTTS_EBA_STDSTN_FK1 FOREIGN KEY (STANDARD_ID)
	  REFERENCES EBA_STDS_STANDARDS (ID) ENABLE
/

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STSTTS_EBA_STDSTN_FK2';

  ALTER TABLE EBA_STDS_STANDARD_TESTS ADD CONSTRAINT EBA_STSTTS_AST_CMPNT_TP_FK1 FOREIGN KEY (component_type_id)
	  REFERENCES ast_component_types (ID) ENABLE
/

