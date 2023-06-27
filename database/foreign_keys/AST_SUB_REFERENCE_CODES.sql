--liquibase formatted sql
--changeset fk_script:AST_SUB_REFERENCE_CODES stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('AST_SUB_REFERENCE_CODES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_SUB_REFERENCE_CODES.sql
--        Date:  05-Apr-2023 13:45
--     Purpose:  Foreign key creation DDL for table AST_SUB_REFERENCE_CODES
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'AST_SUB_REFERENCE_CODES_FK';

  ALTER TABLE AST_SUB_REFERENCE_CODES ADD CONSTRAINT AST_SUB_REFERENCE_CODES_FK FOREIGN KEY (TEST_ID)
	  REFERENCES EBA_STDS_STANDARD_TESTS (ID) ENABLE
/
