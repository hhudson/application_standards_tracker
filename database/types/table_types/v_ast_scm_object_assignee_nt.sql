--liquibase formatted sql
--changeset table_type_script:V_AST_SCM_OBJECT_ASSIGNEE_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_SCM_OBJECT_ASSIGNEE_NT');
  
create type v_ast_scm_object_assignee_nt as table of v_ast_scm_object_assignee_ot
/
--rollback drop type V_AST_SCM_OBJECT_ASSIGNEE_NT;


