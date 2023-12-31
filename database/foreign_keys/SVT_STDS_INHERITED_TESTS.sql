--liquibase formatted sql
--changeset fk_script:SVT_STDS_INHERITED_TESTS stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('SVT_STDS_INHERITED_TESTS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STDS_INHERITED_TESTS.sql
--        Date:  05-Apr-2023 13:45
--     Purpose:  Foreign key creation DDL for table SVT_STDS_INHERITED_TESTS
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'SVT_STDS_INHERITED_TESTS_FK';

  alter table svt_stds_inherited_tests add constraint svt_stds_inherited_tests_fk foreign key (standard_id)
	  references svt_stds_standards (id) enable
/