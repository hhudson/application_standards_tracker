--liquibase formatted sql
--changeset object_type_script:EBA_STDS_FILTER_COLUMN_T stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('EBA_STDS_FILTER_COLUMN_T');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   eba_stds_filter_column_t.sql
--        Date:  2022-Sep-16
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create type eba_stds_filter_column_t as object (
        query_column varchar2(50),
        datatype varchar2(30),
        in_text_search_yn varchar2(1),
            exact_match_yn varchar2(1),
            case_sensitive_yn varchar2(1),
            header       varchar2(64),
            lov_name     varchar2(256),
            match_column varchar2(1)
    ) ]';
  dbms_output.put_line(q'[ type eba_stds_filter_column_t created ]');
exception
  when already_exists then null;
end;
/
--rollback drop type EBA_STDS_FILTER_COLUMN_T;