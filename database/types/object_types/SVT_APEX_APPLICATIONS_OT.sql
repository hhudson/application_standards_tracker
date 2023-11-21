--liquibase formatted sql
--changeset object_type_script:SVT_APEX_APPLICATIONS_OT stripComments:false runOnChange:true    
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('SVT_APEX_APPLICATIONS_OT');
create type SVT_APEX_APPLICATIONS_OT as object
    (
        APPLICATION_ID NUMBER,
        APPLICATION_NAME VARCHAR2(255 CHAR),
        APPLICATION_GROUP VARCHAR2(255 CHAR),
        AVAILABILITY_STATUS VARCHAR2(38 CHAR),
        AUTHORIZATION_SCHEME VARCHAR2(259 CHAR),
        CREATED_BY VARCHAR2(255 CHAR),
        CREATED_ON DATE,
        LAST_UPDATED_BY VARCHAR2(255 CHAR),
        LAST_UPDATED_ON DATE,
        WORKSPACE VARCHAR2(255 CHAR)
    )
/
--rollback drop type SVT_APEX_APPLICATIONS_OT;