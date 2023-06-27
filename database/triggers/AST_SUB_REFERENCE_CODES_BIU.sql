--liquibase formatted sql
--changeset trigger_script:AST_SUB_REFERENCE_CODES_BIU_v3 stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_SUB_REFERENCE_CODES_BIU.sql
--        Date:  04-Apr-2023 21:08
--     Purpose:  BIU Trigger creation DDL for table AST_SUB_REFERENCE_CODES
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER AST_SUB_REFERENCE_CODES_BIU 
    before insert or update 
    on ast_sub_reference_codes
    for each row
begin
    :new.sub_code := upper(:new.sub_code);
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end ast_sub_reference_codes_biu;
/

ALTER TRIGGER AST_SUB_REFERENCE_CODES_BIU ENABLE
/
