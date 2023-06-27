--liquibase formatted sql
--changeset trigger_script:CHANGEME_biu stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Trigger CHANGEME
--------------------------------------------------------

create or replace editionable trigger CHANGEME_biu
    before insert or update 
    on CHANGEME
    for each row
begin
  if inserting then 
    :new.row_version := 1; 
  elsif updating then 
    :new.row_version := nvl ( :old.row_version, 0 ) + 1; 
  end if; 
 
  if inserting then 
    :new.created_on := localtimestamp; 
    :new.created_by := nvl ( sys_context ( 'APEX$SESSION', 'APP_USER' ), user ); 
  end if; 
 
  :new.updated_on := localtimestamp; 
  :new.updated_by := nvl ( sys_context ( 'APEX$SESSION', 'APP_USER' ), user ); 
end CHANGEME_biu;
/

alter trigger CHANGEME enable;