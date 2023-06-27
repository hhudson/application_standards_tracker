--liquibase formatted sql
--changeset table_type_script:V_AST_TABLE_DATA_LOAD_DEF_NT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_TABLE_DATA_LOAD_DEF_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_table_data_load_def_nt.sql
--        Date:  2023-Jun-21
--     Purpose:  Type creation DDL
--
-- used in package ast_standard_view
--------------------------------------------------------------------------------
-- prompt  v_ast_table_data_load_def_nt.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type v_ast_table_data_load_def_nt as table of v_ast_table_data_load_def_ot
     ]';
  dbms_output.put_line(q'[ type v_ast_table_data_load_def_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_AST_TABLE_DATA_LOAD_DEF_NT;