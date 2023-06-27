-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_db_plsql__0_nt.sql
--        Date:  2023-Jan-19
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type v_ast_db_plsql__0_nt as table of v_ast_db_plsql__0_ot
     ]';
  dbms_output.put_line(q'[ type v_ast_db_plsql__0_nt created ]');
exception
  when already_exists then null;
end;
/
