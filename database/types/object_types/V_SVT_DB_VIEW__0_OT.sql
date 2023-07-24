--liquibase formatted sql
--changeset object_type_script:V_SVT_DB_VIEW__0_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_VIEW__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   V_SVT_DB_VIEW__0_OT.sql
--        Date:  2023-Jan-26
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
  create type v_svt_db_view__0_ot as object
    (   
      pass_yn    varchar2(1 char),
      view_name  varchar2(128 char),
      unqid      varchar2(5000 char)
    ) ]';
  dbms_output.put_line(q'[ type v_svt_db_view__0_ot created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_SVT_DB_VIEW__0_OT;