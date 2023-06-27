--liquibase formatted sql
--changeset object_type_script:V_AST_APEX_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_APEX_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_apex_ot.sql
--        Date:  2023-Jan-25
--     Purpose:  Type creation DDL
--
-- used in package v_ast_apex_nt
--------------------------------------------------------------------------------
-- drop type v_ast_apex_nt
-- /
-- drop type v_ast_apex_ot
-- /
create type v_ast_apex_ot as object
    (
      PASS_YN                          VARCHAR2(1 CHAR),
      REFERENCE_CODE                   VARCHAR2(5000 CHAR),
      APPLICATION_ID                   NUMBER,
      PAGE_ID                          NUMBER,
      CREATED_BY                       VARCHAR2(1020 CHAR),
      CREATED_ON                       DATE,
      LAST_UPDATED_BY                  VARCHAR2(1020 CHAR),
      LAST_UPDATED_ON                  DATE,
      VALIDATION_FAILURE_MESSAGE       VARCHAR2(15000 CHAR),
      ISSUE_TITLE                      VARCHAR2(5000 CHAR),
      STANDARD_CODE                    VARCHAR2(100),
      CHILD_CODE                       VARCHAR2(100),
      COMPONENT_ID                     NUMBER,
      PARENT_COMPONENT_ID              NUMBER
    )
/
--rollback drop type V_AST_APEX_OT;