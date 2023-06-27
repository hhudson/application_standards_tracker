--liquibase formatted sql
--changeset trigger_script:EBA_STDS_APP_STATUSES_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_APP_STATUSES_BIU.sql
--        Date:  04-Apr-2023 21:14
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_APP_STATUSES
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_APP_STATUSES_BIU 
    before insert or update on eba_stds_app_statuses
    for each row
begin
    if :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
end;
/

ALTER TRIGGER EBA_STDS_APP_STATUSES_BIU ENABLE
/
