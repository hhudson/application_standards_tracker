--liquibase formatted sql
--changeset object_type_script:V_AST_APEX__0_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_APEX__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_apex__0_ot.sql
--        Date:  2023-Jan-19
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- drop type v_ast_apex__0_nt
-- /
-- drop type v_ast_apex__0_ot
-- /
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type v_ast_apex__0_ot as object
    (
      PASS_YN                          VARCHAR2(1 CHAR),
      UNQID                            VARCHAR2(5000 CHAR),
      APPLICATION_ID                   NUMBER,
      PAGE_ID                          NUMBER,
      CREATED_BY                       VARCHAR2(1020 CHAR),
      CREATED_ON                       DATE,
      LAST_UPDATED_BY                  VARCHAR2(1020 CHAR),
      LAST_UPDATED_ON                  DATE,
      VALIDATION_FAILURE_MESSAGE       VARCHAR2(15000 CHAR),
      ISSUE_TITLE                      VARCHAR2(5000 CHAR)
    ) ]';
  dbms_output.put_line(q'[ type v_ast_apex__0_ot created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_AST_APEX__0_OT;