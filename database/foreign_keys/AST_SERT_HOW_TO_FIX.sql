--liquibase formatted sql
--changeset fk_script:SVT_SERT_HOW_TO_FIX stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('SVT_SERT_HOW_TO_FIX');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_SERT_HOW_TO_FIX.sql
--        Date:  05-Apr-2023 13:46
--     Purpose:  Foreign key creation DDL for table SVT_SERT_HOW_TO_FIX
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'SVT_HOW_TO_FIX_SRC_ID_FK1';

  ALTER TABLE SVT_SERT_HOW_TO_FIX ADD CONSTRAINT SVT_HOW_TO_FIX_SRC_ID_FK1 FOREIGN KEY (TEST_ID)
	  REFERENCES EBA_STDS_STANDARD_TESTS (ID) ENABLE
/
