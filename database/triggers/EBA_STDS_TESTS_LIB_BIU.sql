--liquibase formatted sql
--changeset trigger_script:EBA_STDS_TESTS_LIB_BIU_biu stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Trigger EBA_STDS_TESTS_LIB_BIU
--------------------------------------------------------

create or replace editionable trigger EBA_STDS_TESTS_LIB_BIU
    before insert or update 
    on EBA_STDS_TESTS_LIB
    for each row
begin
  if :new.ID is null
  then 
    :new.ID :=  to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  end if;
 
end EBA_STDS_TESTS_LIB_BIU;
/

alter trigger EBA_STDS_TESTS_LIB_BIU enable;