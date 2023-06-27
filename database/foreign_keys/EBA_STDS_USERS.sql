--liquibase formatted sql
--changeset fk_script:EBA_STDS_USERS stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_USERS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_USERS.sql
--        Date:  05-Apr-2023 13:53
--     Purpose:  Foreign key creation DDL for table EBA_STDS_USERS
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STDUSR_EBA_STACLV_FK1';

  ALTER TABLE EBA_STDS_USERS ADD CONSTRAINT EBA_STDUSR_EBA_STACLV_FK1 FOREIGN KEY (ACCESS_LEVEL_ID)
	  REFERENCES EBA_STDS_ACCESS_LEVELS (ID) ENABLE
/

