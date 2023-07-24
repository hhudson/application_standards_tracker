--liquibase formatted sql
--changeset trigger_script:SVT_NESTED_TABLE_TYPES_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_NESTED_TABLE_TYPES_BIU.sql
--        Date:  04-Apr-2023 19:50
--     Purpose:  BIU Trigger creation DDL for table SVT_NESTED_TABLE_TYPES
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER SVT_NESTED_TABLE_TYPES_BIU 
    before insert or update 
    on SVT_NESTED_TABLE_TYPES
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end SVT_nested_table_types_biu;
/

ALTER TRIGGER SVT_NESTED_TABLE_TYPES_BIU ENABLE
/
