--liquibase formatted sql
--changeset synonym_script:AST_FLOW_COMPANY_SCHEMAS stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_synonyms where upper(synonym_name) = upper('AST_FLOW_COMPANY_SCHEMAS');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:  ast_flow_company_schemas.sql
--        Date:  2023-Jun-15
--     Purpose:  Used for building the link to sql workshop
--
/*
drop synonym ast_flow_company_schemas
*/
--------------------------------------------------------------------------------

declare
  already_exists EXCEPTION;
  pragma exception_init (already_exists, -00955);
  c_create_stmt varchar2(250) := 
    apex_string.format(
        p_message => 'create synonym ast_flow_company_schemas for apex_%s0%s00.wwv_flow_company_schemas',
        p0 => oracle_apex_version.version,
        p1 => oracle_apex_version.release
  );
begin
  execute immediate c_create_stmt;
  dbms_output.put_line(q'[ synonym ast_flow_company_schemas created ]');
exception
  when already_exists then dbms_output.put_line('already ran : '||c_create_stmt);
end;
/
--rollback drop synonym AST_FLOW_COMPANY_SCHEMAS;