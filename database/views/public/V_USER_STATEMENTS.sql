--liquibase formatted sql
--changeset view_script:V_USER_STATEMENTS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_STATEMENTS
--------------------------------------------------------

create or replace force editionable view v_user_statements as
select object_type, object_name, line, signature, type, sql_id, text
from all_statements
where owner = case when sys_context('userenv', 'current_user') = svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA')
                   then svt_ctx_util.get_default_user
                   else sys_context('userenv', 'current_user')
                   end
/
--rollback drop view V_USER_STATEMENTS;