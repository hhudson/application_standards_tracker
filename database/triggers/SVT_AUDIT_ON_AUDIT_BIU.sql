--liquibase formatted sql
--changeset trigger_script:SVT_AUDIT_ON_AUDIT_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_AUDIT_ON_AUDIT_BIU.sql
--        Date:  05-Apr-2023 13:58
--     Purpose:  BIU Trigger creation DDL for table SVT_AUDIT_ON_AUDIT
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER SVT_AUDIT_ON_AUDIT_BIU 
    before insert or update 
    on SVT_audit_on_audit
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
end SVT_audit_on_audits_biu;
/

ALTER TRIGGER SVT_AUDIT_ON_AUDIT_BIU ENABLE
/
