--liquibase formatted sql
--changeset fk_script:SVT_PLSQL_APEX_AUDIT stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('SVT_PLSQL_APEX_AUDIT');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_PLSQL_APEX_AUDIT.sql
--        Date:  05-Apr-2023 12:29
--     Purpose:  Foreign key creation DDL for table SVT_PLSQL_APEX_AUDIT
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'SVT_PLAPAD_SVT_ADTACT_FK1';

ALTER TABLE SVT_PLSQL_APEX_AUDIT ADD CONSTRAINT SVT_PLAPAD_SVT_ADTACT_FK1 FOREIGN KEY (ACTION_ID)
	  REFERENCES SVT_AUDIT_ACTIONS (ID) ENABLE
/
