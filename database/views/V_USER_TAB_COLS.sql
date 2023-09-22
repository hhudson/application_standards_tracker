--liquibase formatted sql
--changeset view_script:V_USER_TAB_COLS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_TAB_COLS
--------------------------------------------------------

create or replace force editionable view V_USER_TAB_COLS as
select owner,
       table_name, 
       column_name 
from all_tab_cols
where owner = case when sys_context('userenv', 'current_user') = svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA')
                   then svt_ctx_util.get_default_user
                   else sys_context('userenv', 'current_user')
                   end
and table_name not like '%XXX%'
/

--rollback drop view V_USER_TAB_COLS;