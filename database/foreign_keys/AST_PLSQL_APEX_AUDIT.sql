--liquibase formatted sql
--changeset fk_script:AST_PLSQL_APEX_AUDIT stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_tables where upper(table_name) = upper('AST_PLSQL_APEX_AUDIT');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_PLSQL_APEX_AUDIT.sql
--        Date:  05-Apr-2023 12:29
--     Purpose:  Foreign key creation DDL for table AST_PLSQL_APEX_AUDIT
--               and related objects.
--
--------------------------------------------------------------------------------

--precondition-sql-check expectedResult:0 select count(1) from all_constraints where upper(constraint_name) = 'AST_PLAPAD_AST_ADTACT_FK1';

ALTER TABLE AST_PLSQL_APEX_AUDIT ADD CONSTRAINT AST_PLAPAD_AST_ADTACT_FK1 FOREIGN KEY (ACTION_ID)
	  REFERENCES AST_AUDIT_ACTIONS (ID) ENABLE
/
