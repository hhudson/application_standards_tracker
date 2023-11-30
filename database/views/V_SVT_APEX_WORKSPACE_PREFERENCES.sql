--liquibase formatted sql
--changeset view_script:v_svt_apex_workspace_preferences stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_APEX_WORKSPACE_PREFERENCES
/*
Note : for SVT_EMAIL_SUBSCRIPTION, use v_svt_email_subscriptions
*/
--------------------------------------------------------

create or replace force editionable view v_svt_apex_workspace_preferences as
select workspace_name,
       user_name, 
       preference_name,
       preference_value
from svt_apex_view.apex_workspace_preferences() 
where user_name = 'SVT'
/
--rollback drop view v_svt_apex_workspace_preferences;