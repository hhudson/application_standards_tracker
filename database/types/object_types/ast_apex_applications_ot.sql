--liquibase formatted sql
--changeset object_type_script:AST_APEX_APPLICATIONS_OT stripComments:false
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('AST_APEX_APPLICATIONS_OT');
create type AST_APEX_APPLICATIONS_OT as object
    (
        application_id number,
        application_name varchar2(255 char),
        application_group varchar2(255 char),
        availability_status varchar2(38 char),
        authorization_scheme varchar2(259 char),
        created_by varchar2(255 char),
        created_on date,
        last_updated_by varchar2(255 char),
        last_updated_on date
    );
--rollback drop type AST_APEX_APPLICATIONS_OT;