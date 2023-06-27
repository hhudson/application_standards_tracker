--liquibase formatted sql
--changeset view_script:V_USER_VIEWS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_VIEWS
--------------------------------------------------------

create or replace force editionable view v_user_views as
select owner, 
       view_name
from all_views
where owner = case when sys_context('userenv', 'current_user') = 'AST'
                   then ast_ctx_util.get_default_user
                   else sys_context('userenv', 'current_user')
                   end
and view_name not like 'XXX%'
/
--rollback drop view V_USER_VIEWS;