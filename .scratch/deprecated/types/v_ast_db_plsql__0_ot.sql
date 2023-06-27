-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_db_plsql__0_ot.sql
--        Date:  2023-Jan-19
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type v_ast_db_plsql__0_ot as object
    (
      PASS_FAIL      CHAR(1),
      REFERENCE_CODE VARCHAR2(5000 CHAR),
      SRC_ID         NUMBER,
      OBJECT_NAME    VARCHAR2(128 CHAR),
      OBJECT_TYPE    VARCHAR2(19 CHAR),
      LINE           NUMBER,
      CODE           VARCHAR2(5000 CHAR),
      UNQID          VARCHAR2(5000 CHAR)
    ) ]';
  dbms_output.put_line(q'[ type v_ast_db_plsql__0_ot created ]');
exception
  when already_exists then null;
end;
/