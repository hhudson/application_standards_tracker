--liquibase formatted sql
--changeset table_type_script:V_SVT_DB_plsql_REF_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_plsql_REF_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   V_SVT_DB_PLSQL_REF_NT.sql
--        Date:  2023-Jan-30
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  V_SVT_DB_PLSQL_REF_NT.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type V_SVT_DB_PLSQL_REF_NT as table of V_SVT_DB_PLSQL_REF_OT
     ]';
  dbms_output.put_line(q'[ type V_SVT_DB_PLSQL_REF_NT created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_SVT_DB_plsql_REF_NT;