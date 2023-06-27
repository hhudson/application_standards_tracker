--liquibase formatted sql
--changeset view_script:v_ast_email_subscriptions stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_AST_EMAIL_SUBSCRIPTIONS
--------------------------------------------------------

create or replace force editionable view v_ast_email_subscriptions as
select distinct lower(awp.user_name) user_name, lower(awd.email) email
from ast_apex_view.apex_workspace_preferences()  awp
inner join apex_workspace_developers awd on awp.user_name = awd.user_name
where awp.preference_name = 'AST_EMAIL_SUBSCRIPTION'
and awp.preference_value = 'Y'
/
--rollback drop view v_ast_email_subscriptions;