--liquibase formatted sql
--changeset trigger_script:EBA_STDS_USERS_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_USERS_BIU.sql
--        Date:  04-Apr-2023 21:45
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_USERS
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_USERS_BIU 
    before insert or update on eba_stds_users
    for each row
begin
    if inserting then
        if :new.id is null then
            :new.id := eba_stds.gen_id();
        end if;
        :new.created_by := nvl(v('APP_USER'), USER);
        :new.created    := localtimestamp;
        :new.row_version_number := 1;
        if :new.account_locked is null then
            :new.account_locked := 'N';    
        end if;
    end if;
    if updating then
        :new.row_version_number := nvl(:old.row_version_number,1) + 1;
    end if;
    :new.updated_by := nvl(v('APP_USER'), USER);
    :new.updated    := localtimestamp;
    -- Always store username as upper case
    :new.username := upper(:new.username);
end EBA_STDS_USERS_BIU;
/

ALTER TRIGGER EBA_STDS_USERS_BIU ENABLE
/
