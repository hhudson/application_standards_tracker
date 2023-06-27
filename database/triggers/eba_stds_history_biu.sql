--liquibase formatted sql
--changeset trigger_script:EBA_STDS_HISTORY_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_HISTORY_BIU.sql
--        Date:  04-Apr-2023 21:33
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_HISTORY
--
--------------------------------------------------------------------------------


  CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_HISTORY_BIU 
    before insert or update on eba_stds_history
    for each row
begin
    if :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
    if inserting then
        :new.action_date := localtimestamp;
        :new.action_by  := nvl(wwv_flow.g_user,user);
        :new.row_version_number := 1;
    elsif updating then
        :new.row_version_number := :new.row_version_number + 1;
    end if;
end EBA_STDS_HISTORY_BIU;
/

ALTER TRIGGER EBA_STDS_HISTORY_BIU ENABLE
/
