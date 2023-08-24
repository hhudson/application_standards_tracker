--liquibase formatted sql
--changeset fk_script:EBA_STDS_STANDARDS stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_STANDARDS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARDS.sql
--        Date:  05-Apr-2023 13:45
--     Purpose:  Foreign key creation DDL for table EBA_STDS_STANDARDS
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STDS_STANDARDS_FK';

  ALTER TABLE EBA_STDS_STANDARDS ADD CONSTRAINT EBA_STDS_STANDARDS_FK FOREIGN KEY (COMPATIBILITY_MODE_ID)
	  REFERENCES SVT_COMPATIBILITY (ID) ENABLE
/

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STDS_STANDARDS_FK2';
  ALTER TABLE EBA_STDS_STANDARDS ADD CONSTRAINT EBA_STDS_STANDARDS_FK2 FOREIGN KEY (PARENT_STANDARD_ID)
	  REFERENCES EBA_STDS_STANDARDS (ID) ENABLE
/
  