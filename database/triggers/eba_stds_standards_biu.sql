--liquibase formatted sql
--changeset trigger_script:EBA_STDS_STANDARDS_BIU stripComments:false  endDelimiter:/  runOnChange:true
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARDS_BIU.sql
--        Date:  04-Apr-2023 22:06
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_STANDARDS
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_STANDARDS_BIU 
    before insert or update on eba_stds_standards
    for each row
begin
    if :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
    if inserting then
        :new.created    := localtimestamp;
        :new.created_by := nvl(wwv_flow.g_user,user);
    end if;
    :new.updated    := localtimestamp;
    :new.updated_by := nvl(wwv_flow.g_user,user);
    :new.active_yn := coalesce(:new.active_yn, 'N');
end EBA_STDS_STANDARDS_BIU;
/

ALTER TRIGGER EBA_STDS_STANDARDS_BIU ENABLE
/
