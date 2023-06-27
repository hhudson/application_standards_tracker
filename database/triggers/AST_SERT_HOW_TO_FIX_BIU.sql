--liquibase formatted sql
--changeset trigger_script:AST_SERT_HOW_TO_FIX_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_SERT_HOW_TO_FIX_BIU.sql
--        Date:  04-Apr-2023 19:54
--     Purpose:  BIU Trigger creation DDL for table AST_SERT_HOW_TO_FIX
--
--------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER AST_SERT_HOW_TO_FIX_BIU 
    before insert or update 
    on ast_sert_how_to_fix
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end ast_sert_how_to_fix_biu;
/

ALTER TRIGGER AST_SERT_HOW_TO_FIX_BIU ENABLE
/
