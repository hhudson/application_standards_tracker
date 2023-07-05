--liquibase formatted sql
--changeset trigger_script:EBA_STDS_NOTIFICATIONS_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_NOTIFICATIONS_BIU.sql
--        Date:  04-Apr-2023 21:37
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_NOTIFICATIONS
--
--------------------------------------------------------------------------------

create or replace editionable trigger EBA_STDS_NOTIFICATIONS_BIU
  before insert or update
  on EBA_STDS_NOTIFICATIONS
  for each row
begin
  if :new.ID is null then 
    :new.ID :=  to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  end if;
  :new.ROW_VERSION_NUMBER := coalesce(:old.ROW_VERSION_NUMBER,0) + 1;
  if inserting then
      :new.created := sysdate;
      :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  end if;
  :new.updated := sysdate;
  :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end EBA_STDS_NOTIFICATIONS_BIU;
/
