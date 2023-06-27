--liquibase formatted sql
--changeset object_type_script:V_AST_SERT__0_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_SERT__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_sert__0_ot.sql
--        Date:  2023-Jan-9
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type v_ast_sert__0_ot as object
    (
      APPLICATION_ID                   NUMBER,
      ATTRIBUTE_ID                     NUMBER,
      CATEGORY_KEY                     VARCHAR2(26),
      COLLECTION_NAME                  VARCHAR2(26),
      COMPONENT_SIGNATURE              VARCHAR2(1000),
      ISSUE_TITLE                      VARCHAR2(1000),
      LAST_UPDATED_BY                  VARCHAR2(255),
      LAST_UPDATED_ON                  DATE,
      LINK                             VARCHAR2(264),
      LINK_DESC                        VARCHAR2(42),
      PAGE_ID                          NUMBER,
      RESULT                           VARCHAR2(10),
      VALIDATION_FAILURE_MESSAGE       VARCHAR2(4000)
    ) ]';
  dbms_output.put_line(q'[ type v_ast_sert__0_ot created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_AST_SERT__0_OT;