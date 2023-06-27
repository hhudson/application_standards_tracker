--liquibase formatted sql
--changeset fk_script:EBA_STDS_STANDARD_STATUSES stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_STANDARD_STATUSES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_STATUSES.sql
--        Date:  05-Apr-2023 13:50
--     Purpose:  Foreign key creation DDL for table EBA_STDS_STANDARD_STATUSES
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STSTST_EBA_STDSTN_FK1';

  ALTER TABLE EBA_STDS_STANDARD_STATUSES ADD CONSTRAINT EBA_STSTST_EBA_STDSTN_FK1 FOREIGN KEY (STANDARD_ID)
	  REFERENCES EBA_STDS_STANDARDS (ID) ENABLE
/
--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STSTST_EBA_STSTTS_FK1';

  ALTER TABLE EBA_STDS_STANDARD_STATUSES ADD CONSTRAINT EBA_STSTST_EBA_STSTTS_FK1 FOREIGN KEY (TEST_ID)
	  REFERENCES EBA_STDS_STANDARD_TESTS (ID) ENABLE
/

