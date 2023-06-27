--liquibase formatted sql
--changeset trigger_script:AST_PLSQL_EXCEPTIONS_BIU stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_PLSQL_EXCEPTIONS_BIU.sql
--        Date:  04-Apr-2023 20:59
--     Purpose:  BIU Trigger creation DDL for table AST_PLSQL_EXCEPTIONS
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER AST_PLSQL_EXCEPTIONS_BIU 
    before insert or update 
    on ast_plsql_exceptions
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end ast_plsql_exceptions_biu;
/

ALTER TRIGGER AST_PLSQL_EXCEPTIONS_BIU ENABLE
/
