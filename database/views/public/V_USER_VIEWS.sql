--liquibase formatted sql
--changeset view_script:V_USER_VIEWS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_VIEWS
--------------------------------------------------------

create or replace force editionable view v_user_views as
select owner, 
       view_name
from dba_views
where owner = svt_ctx_util.get_default_user
and view_name not like 'XXX%'
/
--rollback drop view V_USER_VIEWS;