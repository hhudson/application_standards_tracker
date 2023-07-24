--liquibase formatted sql
--changeset synonym_script:SVT_FLOW_ISSUES stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_synonyms where upper(synonym_name) = upper('SVT_FLOW_ISSUES');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:  SVT_FLOW_ISSUES.sql
--        Date:  2022-Dec-13
--     Purpose:  Synonym for the underlying table behind apex_issues.
--
/*
drop synonym SVT_flow_issues
*/
--------------------------------------------------------------------------------

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
  c_create_stmt varchar2(250) := 
    apex_string.format(
        p_message => 'create synonym SVT_FLOW_ISSUES for apex_%s0%s00.wwv_flow_issues',
        p0 => oracle_apex_version.version,
        p1 => oracle_apex_version.release
  );
begin
  execute immediate c_create_stmt;
  dbms_output.put_line(q'[ synonym SVT_FLOW_ISSUES created ]');
exception
  when already_exists then dbms_output.put_line('already ran : '||c_create_stmt);
end;
/
--rollback drop synonym SVT_FLOW_ISSUES;