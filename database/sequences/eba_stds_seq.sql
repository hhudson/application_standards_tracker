--liquibase formatted sql
--changeset sequence_script:EBA_STDS_SEQ stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_sequences where upper(sequence_name) = upper('EBA_STDS_SEQ');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:  eba_stds_seq.sql
--        Date:  2022-Sep-16
--     Purpose:  Sequence creation DDL
--
--------------------------------------------------------------------------------

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
begin
  execute immediate q'[
    create sequence eba_stds_seq  minvalue 1000 maxvalue 999999999999999999999999999 increment by 1 start with 1000 cache 20 noorder  nocycle
     ]';
  dbms_output.put_line(q'[ sequence eba_stds_seq created ]');
exception
  when already_exists then null;
end;
/
--rollback drop sequence EBA_STDS_SEQ;