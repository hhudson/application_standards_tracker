--liquibase formatted sql
--changeset view_script:V_USER_CONSTRAINTS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_user_constraints
--------------------------------------------------------

create or replace force editionable view  v_user_constraints   as
select table_name, constraint_name, constraint_type
from all_constraints
where owner = case when sys_context('userenv', 'current_user') = svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA')
                   then svt_ctx_util.get_default_user
                   else sys_context('userenv', 'current_user')
                   end
and table_name not like 'XXX%'
/
--rollback drop view V_USER_CONSTRAINTS;