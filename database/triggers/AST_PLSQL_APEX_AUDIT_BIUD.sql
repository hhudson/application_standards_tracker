--liquibase formatted sql
--changeset trigger_script:AST_PLSQL_APEX_AUDIT_BIUD stripComments:false  endDelimiter:/ runOnChange:true
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_PLSQL_APEX_AUDIT_BIUD.sql
--        Date:  05-Apr-2023 19:52
--     Purpose:  BIU Trigger creation DDL for table AST_PLSQL_APEX_AUDIT
--
--------------------------------------------------------------------------------

create or replace trigger ast_plsql_apex_audit_biud
    before insert or update or delete
    on ast_plsql_apex_audit
    for each row
begin
    if inserting then
       insert into ast_audit_on_audit 
              (     unqid, action_name,      standard_code, audit_id,      validation_failure_message)
       values (:new.unqid, 'INSERT'   , :new.standard_code,  :new.id, :new.validation_failure_message);
    elsif deleting then
       insert into ast_audit_on_audit 
              (     unqid, action_name,      standard_code, audit_id,      validation_failure_message)
       values (:old.unqid, 'DELETE'   , :old.standard_code,  :old.id, :old.validation_failure_message);
    end if;
end ast_plsql_apex_audit_biud;
/
