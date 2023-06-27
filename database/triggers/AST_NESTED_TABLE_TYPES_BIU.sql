--liquibase formatted sql
--changeset trigger_script:AST_NESTED_TABLE_TYPES_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_NESTED_TABLE_TYPES_BIU.sql
--        Date:  04-Apr-2023 19:50
--     Purpose:  BIU Trigger creation DDL for table AST_NESTED_TABLE_TYPES
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER AST_NESTED_TABLE_TYPES_BIU 
    before insert or update 
    on ast_nested_table_types
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end ast_nested_table_types_biu;
/

ALTER TRIGGER AST_NESTED_TABLE_TYPES_BIU ENABLE
/
