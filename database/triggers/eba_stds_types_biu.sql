--liquibase formatted sql
--changeset trigger_script:EBA_STDS_TYPES_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_TYPES_BIU.sql
--        Date:  04-Apr-2023 22:13
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_TYPES
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_TYPES_BIU 
    before insert or update on eba_stds_types
    for each row
begin
    if :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
end EBA_STDS_TYPES_BIU;
/

ALTER TRIGGER EBA_STDS_TYPES_BIU ENABLE
/
