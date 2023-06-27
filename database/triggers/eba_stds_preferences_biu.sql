--liquibase formatted sql
--changeset trigger_script:EBA_STDS_PREFERENCES_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_PREFERENCES_BIU.sql
--        Date:  04-Apr-2023 21:38
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_PREFERENCES
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_PREFERENCES_BIU 
before insert or update on eba_stds_preferences
    for each row
begin
    if inserting and :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
    if inserting then
        :new.created_by  := nvl(v('APP_USER'),USER);
        :new.created     := localtimestamp;
        :new.row_version_number := 1;
    end if;
    if updating then
        :new.row_version_number := nvl(:old.row_version_number,1) + 1;
    end if;
    :new.updated_by := nvl(v('APP_USER'),USER);
    :new.updated    := localtimestamp;
    :new.preference_name := upper(:new.preference_name);
end EBA_STDS_PREFERENCES_BIU;
/

ALTER TRIGGER EBA_STDS_PREFERENCES_BIU ENABLE
/
