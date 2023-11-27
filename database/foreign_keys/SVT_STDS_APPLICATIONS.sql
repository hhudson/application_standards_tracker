--liquibase formatted sql
--changeset fk_script:SVT_STDS_APPLICATIONS stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('SVT_STDS_APPLICATIONS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STDS_APPLICATIONS.sql
--        Date:  05-Apr-2023 13:45
--     Purpose:  Foreign key creation DDL for table SVT_STDS_APPLICATIONS
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'SVT_STDS_APPLICATIONS_FK';

  ALTER TABLE SVT_STDS_APPLICATIONS ADD CONSTRAINT SVT_STDS_APPLICATIONS_FK FOREIGN KEY (TYPE_ID)
	  REFERENCES eba_stds_types (ID) ENABLE
/
