--liquibase formatted sql
--changeset trigger_script:AST_STANDARDS_URGENCY_LEVEL_BIU stripComments:false  endDelimiter:/ endDelimiter:/ runOnChange:true
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_STANDARDS_URGENCY_LEVEL_BIU.sql
--        Date:  04-Apr-2023 21:05
--     Purpose:  BIU Trigger creation DDL for table AST_STANDARDS_URGENCY_LEVEL
--
--------------------------------------------------------------------------------

create or replace editionable trigger AST_STANDARDS_URGENCY_LEVEL_BIU
  before insert or update
  on AST_STANDARDS_URGENCY_LEVEL
  for each row
begin
  if :new.ID is null
  then 
    :new.ID :=  to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  end if;
  if inserting then
      :new.created := sysdate;
      :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  end if;
  :new.updated := sysdate;
  :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end AST_STANDARDS_URGENCY_LEVEL_BIU;
/
