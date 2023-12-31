--liquibase formatted sql
--changeset object_type_script:V_SVT_SCM_OBJECT_ASSIGNEE_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_SCM_OBJECT_ASSIGNEE_OT');

create type V_SVT_SCM_OBJECT_ASSIGNEE_OT as object
    (
    object_name       varchar2(256),
    email             varchar2(240),
    folder_name       varchar2(256),
    lock_rank         number
);
/
--rollback drop type V_SVT_SCM_OBJECT_ASSIGNEE_OT;


