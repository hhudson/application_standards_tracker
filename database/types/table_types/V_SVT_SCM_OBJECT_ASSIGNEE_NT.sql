--liquibase formatted sql
--changeset table_type_script:V_SVT_SCM_OBJECT_ASSIGNEE_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_SCM_OBJECT_ASSIGNEE_NT');
  
create type V_SVT_SCM_OBJECT_ASSIGNEE_NT as table of v_svt_scm_object_assignee_ot
/
--rollback drop type V_SVT_SCM_OBJECT_ASSIGNEE_NT;


