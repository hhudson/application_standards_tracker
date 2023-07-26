--liquibase formatted sql
--changeset object_type_script:SVT_DB_PLSQL_ISSUE_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('SVT_DB_PLSQL_ISSUE_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   SVT_DB_PLSQL_ISSUE_OT.sql
--        Date:  2022-Sep-16
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type SVT_DB_PLSQL_ISSUE_OT as object
    (
        issue_desc              varchar2(511   char),
        object_name             varchar2(128   char),  
        object_type             varchar2(23    char),   
        line                    number,
        code                    varchar2(1000 char),
        urgency                 varchar2(255  char),
        urgency_level           number,
        standard_code           varchar2(100 char)
    ) ]';
  dbms_output.put_line(q'[ type SVT_DB_PLSQL_ISSUE_OT created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type SVT_DB_PLSQL_ISSUE_OT;