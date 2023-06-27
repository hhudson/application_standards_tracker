--liquibase formatted sql
--changeset table_type_script:EBA_STDS_FILTER_COL_TBL stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('EBA_STDS_FILTER_COL_TBL');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   eba_stds_filter_col_tbl.sql
--        Date:  2022-Sep-16
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
-- prompt  eba_stds_filter_col_tbl.sql

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create or replace type eba_stds_filter_col_tbl as table of eba_stds_filter_column_t
     ]';
  dbms_output.put_line(q'[ type eba_stds_filter_col_tbl created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type EBA_STDS_FILTER_COL_TBL;