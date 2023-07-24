--liquibase formatted sql
--changeset trigger_script:SVT_HOW_TO_FIX_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_HOW_TO_FIX_BIU.sql
--        Date:  06-Apr-2023 14:55
--     Purpose:  BIU Trigger creation DDL for table SVT_HOW_TO_FIX
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER SVT_HOW_TO_FIX_BIU 
    before insert or update 
    on SVT_SERT_HOW_TO_FIX
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end SVT_how_to_fix_biu;
/

ALTER TRIGGER SVT_HOW_TO_FIX_BIU ENABLE
/
