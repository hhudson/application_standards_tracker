--liquibase formatted sql
--changeset object_type_script:V_SVT_DB_PLSQL_REF_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_PLSQL_REF_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   V_SVT_DB_PLSQL_REF_OT.sql
--        Date:  2023-Jan-30
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
drop type V_SVT_DB_PLSQL_REF_NT
/
drop type V_SVT_DB_PLSQL_REF_OT
/
create type V_SVT_DB_PLSQL_REF_OT as object
    (
      PASS_YN        VARCHAR2(1 CHAR),
      SCHEMA         VARCHAR2(128 CHAR),
      OBJECT_NAME    VARCHAR2(128 CHAR),
      OBJECT_TYPE    VARCHAR2(19 CHAR),
      LINE           NUMBER,
      CODE           VARCHAR2(5000 CHAR),
      UNQID          VARCHAR2(5000 CHAR),
      TEST_CODE      VARCHAR2(100 CHAR)
    ) 
/
create type V_SVT_DB_PLSQL_REF_NT as table of V_SVT_DB_PLSQL_REF_OT
/
--rollback drop type V_SVT_DB_PLSQL_REF_OT;