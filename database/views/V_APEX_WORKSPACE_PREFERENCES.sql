--liquibase formatted sql
--changeset view_script:v_apex_workspace_preferences stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_APEX_WORKSPACE_PREFERENCES
/*
Note : for AST_EMAIL_SUBSCRIPTION, use v_ast_email_subscriptions
*/
--------------------------------------------------------

create or replace force editionable view v_apex_workspace_preferences as
select workspace_name,
       user_name, 
       preference_name,
       preference_value
from ast_apex_view.apex_workspace_preferences() 
where user_name = 'AST'
/
--rollback drop view v_apex_workspace_preferences;