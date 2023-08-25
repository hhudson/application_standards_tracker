--liquibase formatted sql
--changeset view_script:V_USER_PLSQL_OBJECT_SETTINGS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_PLSQL_OBJECT_SETTINGS
--------------------------------------------------------

create or replace force editionable view v_user_plsql_object_settings as
select *
from all_plsql_object_settings
where owner = case when sys_context('userenv', 'current_user') = svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA')
                   then svt_ctx_util.get_default_user
                   else sys_context('userenv', 'current_user')
                   end
/
--rollback drop view V_USER_PLSQL_OBJECT_SETTINGS;