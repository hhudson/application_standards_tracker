--liquibase formatted sql
--changeset trigger_script:SVT_PLSQL_APEX_AUDIT_BIU stripComments:false  endDelimiter:/ runOnChange:true
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_PLSQL_APEX_AUDIT_BIU.sql
--        Date:  04-Apr-2023 19:52
--     Purpose:  BIU Trigger creation DDL for table SVT_PLSQL_APEX_AUDIT
--
--------------------------------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER SVT_PLSQL_APEX_AUDIT_BIU 
    before insert or update 
    on svt_plsql_apex_audit
    for each row
declare 
    c_user constant varchar2(100) := coalesce(sys_context('APEX$SESSION','APP_USER'),user,'nobody');
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := c_user;
        :new.updated := coalesce(:new.updated, sysdate);
        :new.updated_by := c_user;
    end if;
    if updating and c_user != 'nobody' then
        :new.updated := coalesce(:new.updated, sysdate);
        :new.updated_by := c_user;
    end if;
    :new.assignee := lower(:new.assignee);
end svt_plsql_apex_audit_biu;
/

ALTER TRIGGER SVT_PLSQL_APEX_AUDIT_BIU ENABLE
/
