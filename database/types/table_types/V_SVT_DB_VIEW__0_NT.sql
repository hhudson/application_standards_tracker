--liquibase formatted sql
--changeset table_type_script:V_SVT_DB_VIEW__0_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_VIEW__0_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      author:  hayhudso
-- script name:   v_svt_db_view__0_nt.sql
--        date:  2023-jan-26
--     purpose:  type creation ddl
--
--------------------------------------------------------------------------------
-- prompt  v_svt_db_view__0_nt.sql

declare
  already_exists exception;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type V_SVT_DB_VIEW__0_NT as table of V_SVT_DB_VIEW__0_OT
     ]';
  dbms_output.put_line(q'[ type v_svt_db_view__0_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_SVT_DB_VIEW__0_NT;