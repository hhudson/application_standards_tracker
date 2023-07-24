
--liquibase formatted sql
--changeset object_type_script:V_SVT_PLSQL_APEX__0_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_PLSQL_APEX__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      author:  hayhudso
-- script name:   V_SVT_PLSQL_APEX__0_OT.sql
--        date:  2023-jan-26
--     purpose:  type creation ddl
--
--------------------------------------------------------------------------------
-- drop type v_svt_plsql_apex__0_nt
-- /
-- drop type v_svt_plsql_apex__0_ot
-- /
  create type v_svt_plsql_apex__0_ot as object
    (
        UNQID                      VARCHAR2(1000 CHAR),
        ISSUE_CATEGORY             VARCHAR2(8),
        APPLICATION_ID             NUMBER,
        PAGE_ID                    NUMBER,
        PASS_YN                    VARCHAR2(1 CHAR),
        LINE                       NUMBER,
        OBJECT_NAME                VARCHAR2(128 CHAR),
        OBJECT_TYPE                VARCHAR2(76),
        CODE                       VARCHAR2(5000 CHAR),
        VALIDATION_FAILURE_MESSAGE VARCHAR2(32767),
        ISSUE_TITLE                VARCHAR2(32767),
        APEX_CREATED_BY            VARCHAR2(1020 CHAR),
        APEX_CREATED_ON            DATE,
        APEX_LAST_UPDATED_BY       VARCHAR2(4080),
        APEX_LAST_UPDATED_ON       DATE,
        STANDARD_CODE              VARCHAR2(100),
        COMPONENT_ID               NUMBER,
        PARENT_COMPONENT_ID        NUMBER
    )
/
--rollback drop type V_SVT_PLSQL_APEX__0_OT;