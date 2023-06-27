--liquibase formatted sql
--changeset trigger_script:EBA_STDS_NOTES_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_NOTES_BIU.sql
--        Date:  04-Apr-2023 21:35
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_NOTES
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_NOTES_BIU 
    before insert or update on eba_stds_notes
    for each row
begin
    if :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
    if inserting then
        :new.created    := localtimestamp;
        :new.created_by := nvl(wwv_flow.g_user,user);
        :new.row_version_number := 1;
    elsif updating then
        :new.row_version_number := nvl(:old.row_version_number,1) + 1;
    end if;
    :new.updated    := localtimestamp;
    :new.updated_by := nvl(wwv_flow.g_user,user);
end;
/

ALTER TRIGGER EBA_STDS_NOTES_BIU ENABLE
/
