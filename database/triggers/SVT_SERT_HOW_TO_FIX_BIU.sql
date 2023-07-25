--liquibase formatted sql
--changeset trigger_script:SVT_SERT_HOW_TO_FIX_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_SERT_HOW_TO_FIX_BIU.sql
--        Date:  04-Apr-2023 19:54
--     Purpose:  BIU Trigger creation DDL for table SVT_SERT_HOW_TO_FIX
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER SVT_SERT_HOW_TO_FIX_BIU 
    before insert or update 
    on SVT_sert_how_to_fix
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end SVT_sert_how_to_fix_biu;
/

ALTER TRIGGER SVT_SERT_HOW_TO_FIX_BIU ENABLE
/
