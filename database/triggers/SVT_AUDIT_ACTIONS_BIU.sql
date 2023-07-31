--liquibase formatted sql
--changeset trigger_script:SVT_AUDIT_ACTIONS_BIU stripComments:false  endDelimiter:/ runOnChange:true
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_AUDIT_ACTIONS_BIU.sql
--        Date:  05-Apr-2023 14:49
--     Purpose:  BIU Trigger creation DDL for table SVT_AUDIT_ACTIONS
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER SVT_AUDIT_ACTIONS_BIU 
    before insert or update 
    on svt_audit_actions
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end svt_audit_actions_biu;
/
ALTER TRIGGER SVT_AUDIT_ACTIONS_BIU ENABLE
/
