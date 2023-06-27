--liquibase formatted sql
--changeset table_type_script:V_AST_APEX_NT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_APEX_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_apex_nt.sql
--        Date:  2023-Jan-25
--     Purpose:  Type creation DDL
--
-- used in package ast_standard_view
--------------------------------------------------------------------------------
-- prompt  v_ast_apex_nt.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type v_ast_apex_nt as table of v_ast_apex_ot
     ]';
  dbms_output.put_line(q'[ type v_ast_apex_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_AST_APEX_NT;