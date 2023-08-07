 
--liquibase formatted sql
--changeset fk_script:SVT_COMPONENT_TYPES stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('SVT_COMPONENT_TYPES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_COMPONENT_TYPES.sql
--        Date:  05-Apr-2023 12:29
--     Purpose:  Foreign key creation DDL for table SVT_COMPONENT_TYPES
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where lower(constraint_name) = 'svt_component_types_fk1';

  ALTER TABLE SVT_COMPONENT_TYPES ADD CONSTRAINT SVT_COMPONENT_TYPES_FK1 FOREIGN KEY (NT_TYPE_ID)
	  REFERENCES SVT_NESTED_TABLE_TYPES (ID) ENABLE
/
