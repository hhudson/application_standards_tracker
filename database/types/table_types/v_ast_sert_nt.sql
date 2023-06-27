--liquibase formatted sql
--changeset table_type_script:V_AST_SERT_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_types where upper(type_name) = upper('V_AST_SERT_OT');
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_SERT_NT');

create type v_ast_sert_nt as table of v_ast_sert_ot 
/
--rollback drop type V_AST_SERT_NT;