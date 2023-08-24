--liquibase formatted sql
--changeset fk_script:EBA_STDS_INHERITED_TESTS stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_INHERITED_TESTS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_INHERITED_TESTS.sql
--        Date:  05-Apr-2023 13:45
--     Purpose:  Foreign key creation DDL for table EBA_STDS_INHERITED_TESTS
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'EBA_STDS_INHERITED_TESTS_FK';

  alter table eba_stds_inherited_tests add constraint eba_stds_inherited_tests_fk foreign key (standard_id)
	  references eba_stds_standards (id) enable
/
  alter table eba_stds_inherited_tests add constraint eba_stds_inherited_tests_fk2 foreign key (parent_standard_id, test_id)
	  references  eba_stds_standard_tests (standard_id, id) enable
/