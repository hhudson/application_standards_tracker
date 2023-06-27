--liquibase formatted sql
--changeset fk_script:EBA_STDS_STANDARD_APP_REF stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_STANDARD_APP_REF');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_APP_REF.sql
--        Date:  05-Apr-2023 13:48
--     Purpose:  Foreign key creation DDL for table EBA_STDS_STANDARD_APP_REF
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STSTAR_EBA_STDSTN_FK1';

  ALTER TABLE EBA_STDS_STANDARD_APP_REF ADD CONSTRAINT EBA_STSTAR_EBA_STDSTN_FK1 FOREIGN KEY (STANDARD_ID)
	  REFERENCES EBA_STDS_STANDARDS (ID) ENABLE
/
