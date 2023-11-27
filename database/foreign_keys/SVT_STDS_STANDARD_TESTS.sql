--liquibase formatted sql
--changeset fk_script:SVT_STDS_STANDARD_TESTS stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('SVT_STDS_STANDARD_TESTS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STDS_STANDARD_TESTS.sql
--        Date:  10-Apr-2023 16:01
--     Purpose:  Foreign key creation DDL for table SVT_STDS_STANDARD_TESTS
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'SVT_STSTTS_SVT_STDSTN_FK5';

  ALTER TABLE SVT_STDS_STANDARD_TESTS ADD CONSTRAINT SVT_STSTTS_SVT_STDSTN_FK5 FOREIGN KEY (LEVEL_ID)
	  REFERENCES SVT_STANDARDS_URGENCY_LEVEL (ID) ENABLE
/
--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'SVT_STSTTS_SVT_STDSTN_FK1';

  ALTER TABLE SVT_STDS_STANDARD_TESTS ADD CONSTRAINT SVT_STSTTS_SVT_STDSTN_FK1 FOREIGN KEY (STANDARD_ID)
	  REFERENCES SVT_STDS_STANDARDS (ID) ENABLE
/

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'SVT_STSTTS_SVT_STDSTN_FK2';

  ALTER TABLE SVT_STDS_STANDARD_TESTS ADD CONSTRAINT SVT_STSTTS_SVT_STDSTN_FK2 FOREIGN KEY (SVT_COMPONENT_TYPE_ID)
	  REFERENCES SVT_COMPONENT_TYPES (ID) ENABLE
/

