--liquibase formatted sql
--changeset table_type_script:V_SVT_TABLE_DATA_LOAD_DEF_NT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_TABLE_DATA_LOAD_DEF_NT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- script name:   V_SVT_TABLE_DATA_LOAD_DEF_NT.sql
--        date:  2023-jun-21
--     purpose:  type creation ddl
--
-- used in package svt_standard_view
--------------------------------------------------------------------------------
-- prompt  v_svt_table_data_load_def_nt.sql

declare
  already_exists exception;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type v_svt_table_data_load_def_nt as table of v_svt_table_data_load_def_ot
     ]';
  dbms_output.put_line(q'[ type v_svt_table_data_load_def_nt created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type V_SVT_TABLE_DATA_LOAD_DEF_NT;