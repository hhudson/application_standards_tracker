--liquibase formatted sql
--changeset table_type_script:V_SVT_APEX__0_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_APEX__0_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_SVT_apex__0_nt.sql
--        Date:  2023-Jan-19
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  v_SVT_apex__0_nt.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type v_SVT_apex__0_nt as table of v_SVT_apex__0_ot
     ]';
  dbms_output.put_line(q'[ type v_SVT_apex__0_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_SVT_APEX__0_NT;