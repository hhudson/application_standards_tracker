--liquibase formatted sql
--changeset trigger_script:EBA_STDS_STANDARD_APP_REF_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_APP_REF_BIU.sql
--        Date:  04-Apr-2023 21:41
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_STANDARD_APP_REF
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_STANDARD_APP_REF_BIU 
    before insert or update on eba_stds_standard_app_ref
    for each row
begin
    if :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
end;
/

ALTER TRIGGER EBA_STDS_STANDARD_APP_REF_BIU ENABLE
/
