--liquibase formatted sql
--changeset trigger_script:EBA_STDS_STANDARD_STATUSES_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_STATUSES_BIU.sql
--        Date:  04-Apr-2023 22:01
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_STANDARD_STATUSES
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_STANDARD_STATUSES_BIU 
    before insert or update on eba_stds_standard_statuses
    for each row
begin
    if :new.id is null then
        :new.id := eba_stds.gen_id();
    end if;
    :new.updated := systimestamp;
end EBA_STDS_STANDARD_STATUSES_BIU;
/

ALTER TRIGGER EBA_STDS_STANDARD_STATUSES_BIU ENABLE
/
