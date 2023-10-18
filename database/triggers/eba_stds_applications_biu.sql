--liquibase formatted sql
--changeset trigger_script:EBA_STDS_APPLICATIONS_BIU stripComments:false runOnChange:true endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_APPLICATIONS_BIU.sql
--        Date:  04-Apr-2023 21:18
--     Purpose:  BIU Trigger creation DDL for table EBA_STDS_APPLICATIONS
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER EBA_STDS_APPLICATIONS_BIU 
    before insert or update 
    on eba_stds_applications
    for each row
begin
    if inserting then
        :new.esa_created := sysdate;
        :new.esa_created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.esa_updated := coalesce(:new.esa_updated, sysdate);
    :new.esa_updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);

    :new.default_developer := lower(:new.default_developer);
end eba_stds_applications_biu;
/

ALTER TRIGGER EBA_STDS_APPLICATIONS_BIU ENABLE
/
