--liquibase formatted sql
--changeset view_script:V_USER_PLSQL_OBJECT_SETTINGS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_PLSQL_OBJECT_SETTINGS
--------------------------------------------------------

create or replace force editionable view v_user_plsql_object_settings as
select *
from all_plsql_object_settings
where owner = svt_ctx_util.get_default_user
/
--rollback drop view V_USER_PLSQL_OBJECT_SETTINGS;