--liquibase formatted sql
--changeset fk_script:EBA_STDS_APPLICATIONS stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_APPLICATIONS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_APPLICATIONS.sql
--        Date:  05-Apr-2023 13:45
--     Purpose:  Foreign key creation DDL for table EBA_STDS_APPLICATIONS
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STDS_APPLICATIONS_FK';

  ALTER TABLE EBA_STDS_APPLICATIONS ADD CONSTRAINT EBA_STDS_APPLICATIONS_FK FOREIGN KEY (TYPE_ID)
	  REFERENCES eba_stds_types (ID) ENABLE
/
