--liquibase formatted sql
--changeset trigger_script:EBA_STDS_TESTS_LIB_BIU_biu stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Trigger EBA_STDS_TESTS_LIB_BIU
--------------------------------------------------------

create or replace editionable trigger EBA_STDS_TESTS_LIB_BIU_biu
    before insert or update 
    on EBA_STDS_TESTS_LIB_BIU
    for each row
begin
  if inserting then 
    :new.workspace := case when :new.workspace is null 
                           then svt_preferences.get_preference ('SVT_DEFAULT_WORKSPACE')
                           else :new.workspace
                           end;
  end if; 
 
end EBA_STDS_TESTS_LIB_BIU_biu;
/

alter trigger EBA_STDS_TESTS_LIB_BIU enable;