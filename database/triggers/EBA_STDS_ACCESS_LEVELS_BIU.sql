--liquibase formatted sql
--changeset trigger_script:EBA_STDS_ACCESS_LEVELS_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_ACCESS_LEVELS_BIU.sql
--        Date:  04-Apr-2023 21:13
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_ACCESS_LEVELS
--
--------------------------------------------------------------------------------

create or replace editionable trigger EBA_STDS_ACCESS_LEVELS_BIU
  before insert or update
  on EBA_STDS_ACCESS_LEVELS
  for each row
begin
  if :new.ID is null
  then 
    :new.ID :=  to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  end if;
end EBA_STDS_ACCESS_LEVELS_BIU;
/
