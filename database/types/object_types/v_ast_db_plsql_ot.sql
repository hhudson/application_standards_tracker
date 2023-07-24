--liquibase formatted sql
--changeset object_type_script:V_SVT_DB_PLSQL_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_PLSQL_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_SVT_db_plsql_ot.sql
--        Date:  2023-Jan-23
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- drop type v_SVT_db_plsql_nt
-- /
-- drop type v_SVT_db_plsql_ot
-- /
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type v_SVT_db_plsql_ot as object
    (
      PASS_YN        VARCHAR2(1 CHAR),
      OBJECT_NAME    VARCHAR2(128 CHAR),
      OBJECT_TYPE    VARCHAR2(19 CHAR),
      LINE           NUMBER,
      CODE           VARCHAR2(5000 CHAR),
      UNQID          VARCHAR2(5000 CHAR),
      STANDARD_CODE  VARCHAR2(100 CHAR)
    ) ]';
  dbms_output.put_line(q'[ type v_SVT_db_plsql_ot created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_SVT_DB_PLSQL_OT;