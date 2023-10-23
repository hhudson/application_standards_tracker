--liquibase formatted sql
--changeset view_script:V_USER_TAB_COLS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_TAB_COLS
--------------------------------------------------------

create or replace force editionable view V_USER_TAB_COLS as
select owner,
       table_name, 
       column_name,
       data_type,
       char_used,
       data_length
from dba_tab_cols
where owner = svt_ctx_util.get_default_user
and table_name not like '%XXX%'
and table_name not like 'LOGGER%'
/

--rollback drop view V_USER_TAB_COLS;