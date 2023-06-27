--liquibase formatted sql
--changeset trigger_script:AST_AUDIT_ON_AUDIT_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_AUDIT_ON_AUDIT_BIU.sql
--        Date:  05-Apr-2023 13:58
--     Purpose:  BIU Trigger creation DDL for table AST_AUDIT_ON_AUDIT
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER AST_AUDIT_ON_AUDIT_BIU 
    before insert or update 
    on ast_audit_on_audit
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
end ast_audit_on_audits_biu;
/

ALTER TRIGGER AST_AUDIT_ON_AUDIT_BIU ENABLE
/
