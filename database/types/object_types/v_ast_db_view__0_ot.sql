--liquibase formatted sql
--changeset object_type_script:V_AST_DB_VIEW__0_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_DB_VIEW__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_db_view__0_ot.sql
--        Date:  2023-Jan-26
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type v_ast_db_view__0_ot as object
    (   
      PASS_YN    VARCHAR2(1 CHAR),
      VIEW_NAME  VARCHAR2(128 CHAR),
      UNQID      VARCHAR2(5000 CHAR)
    ) ]';
  dbms_output.put_line(q'[ type v_ast_db_view__0_ot created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_AST_DB_VIEW__0_OT;