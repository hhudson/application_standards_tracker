--liquibase formatted sql
--changeset view_script:v_svt_email_subscriptions stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_EMAIL_SUBSCRIPTIONS
--------------------------------------------------------

create or replace force editionable view V_SVT_EMAIL_SUBSCRIPTIONS as
select distinct lower(awp.user_name) user_name, lower(awd.email) email
from apex_workspace_preferences  awp
inner join apex_workspace_developers awd on awp.user_name = awd.user_name
where awp.preference_name = 'SVT_EMAIL_SUBSCRIPTION'
and awp.preference_value = 'Y'
/
--rollback drop view v_svt_email_subscriptions;