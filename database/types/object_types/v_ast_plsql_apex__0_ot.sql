
--liquibase formatted sql
--changeset object_type_script:V_AST_PLSQL_APEX__0_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_PLSQL_APEX__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_plsql_apex__0_ot.sql
--        Date:  2023-Jan-26
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- drop type v_ast_plsql_apex__0_nt
-- /
-- drop type v_ast_plsql_apex__0_ot
-- /
  create type v_ast_plsql_apex__0_ot as object
    (
        UNQID                      VARCHAR2(1000 CHAR),
        ISSUE_CATEGORY             VARCHAR2(8),
        APPLICATION_ID             NUMBER,
        PAGE_ID                    NUMBER,
        PASS_YN                    VARCHAR2(1 CHAR),
        LINE                       NUMBER,
        OBJECT_NAME                VARCHAR2(128 CHAR),
        OBJECT_TYPE                VARCHAR2(76),
        CODE                       VARCHAR2(5000 CHAR),
        VALIDATION_FAILURE_MESSAGE VARCHAR2(32767),
        ISSUE_TITLE                VARCHAR2(32767),
        APEX_CREATED_BY            VARCHAR2(1020 CHAR),
        APEX_CREATED_ON            DATE,
        APEX_LAST_UPDATED_BY       VARCHAR2(4080),
        APEX_LAST_UPDATED_ON       DATE,
        STANDARD_CODE              VARCHAR2(100),
        COMPONENT_ID               NUMBER,
        PARENT_COMPONENT_ID        NUMBER
    )
/
--rollback drop type V_AST_PLSQL_APEX__0_OT;