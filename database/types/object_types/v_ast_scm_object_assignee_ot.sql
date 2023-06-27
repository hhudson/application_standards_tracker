--liquibase formatted sql
--changeset object_type_script:V_AST_SCM_OBJECT_ASSIGNEE_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_SCM_OBJECT_ASSIGNEE_OT');
  
create type v_ast_scm_object_assignee_ot as object
    (
    object_name       varchar2(256),
    email             varchar2(240),
    folder_name       varchar2(256)
);
/
--rollback drop type V_AST_SCM_OBJECT_ASSIGNEE_OT;


