--liquibase formatted sql
--changeset object_type_script:V_AST_PLSQL_APEX_ALL_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_PLSQL_APEX_ALL_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_plsql_apex_all_ot.sql
--        Date:  2023-Jan-26
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type v_ast_plsql_apex_all_ot as object
    (
        REFERENCE_CODE             VARCHAR2(5000 CHAR),
        ISSUE_CATEGORY             VARCHAR2(8 CHAR),
        ISSUE_SUBCATEGORY          VARCHAR2(26 CHAR),
        APPLICATION_ID             NUMBER,    
        APPLICATION_NAME           VARCHAR2(255 CHAR),
        CHECK_TYPE                 VARCHAR2(511 CHAR),
        ISSUE_DESC                 VARCHAR2(511 CHAR),
        PAGE_ID                    NUMBER, 
        PASS_YN                    VARCHAR2(1 CHAR),
        SRC                        VARCHAR2(31 CHAR),
        SRC_ID                     NUMBER,   
        ATTRIBUTE_ID               NUMBER,   
        TEST_ID                    NUMBER,   
        STANDARD_REF_LINK          VARCHAR2(542 CHAR),
        URGENCY                    VARCHAR2(255 CHAR),
        URGENCY_LEVEL              NUMBER,
        LINE                       NUMBER,
        OBJECT_NAME                VARCHAR2(128 CHAR),       
        OBJECT_TYPE                VARCHAR2(19 CHAR),
        CODE                       VARCHAR2(5000 CHAR),
        VALIDATION_FAILURE_MESSAGE VARCHAR2(15000 CHAR),
        ISSUE_TITLE                VARCHAR2(5000 CHAR),
        APEX_CREATED_BY            VARCHAR2(1020 CHAR),
        APEX_CREATED_ON            DATE,
        APEX_LAST_UPDATED_BY       VARCHAR2(1020 CHAR),
        APEX_LAST_UPDATED_ON       DATE,
        STANDARD_CODE              VARCHAR2(100)
    ) ]';
  dbms_output.put_line(q'[ type v_ast_plsql_apex_all_ot created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_AST_PLSQL_APEX_ALL_OT;