--liquibase formatted sql
--changeset trigger_script:EBA_STDS_STANDARD_TESTS_BIU_v2 stripComments:false  endDelimiter:/ runOnChange:true
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_TESTS_BIU.sql
--        Date:  04-Apr-2023 22:00
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_STANDARD_TESTS
--
-- THIS GETS RUN EVERY TIME? REMOVING RUNONCHANGE (2023-Apr-12)
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_STANDARD_TESTS_BIU 
    before insert or update on eba_stds_standard_tests
    for each row
begin
    :new.test_code := upper(replace(:new.test_code, ' ', '_'));
    if :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
    if inserting then
        :new.created    := localtimestamp;
        :new.created_by := nvl(wwv_flow.g_user,user);
    end if;
    :new.updated    := localtimestamp;
    :new.updated_by := nvl(wwv_flow.g_user,user);
end EBA_STDS_STANDARD_TESTS_BIU;
/
ALTER TRIGGER EBA_STDS_STANDARD_TESTS_BIU ENABLE
/
