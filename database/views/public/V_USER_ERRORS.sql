--liquibase formatted sql
--changeset view_script:V_USER_ERRORS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_user_errors
--------------------------------------------------------

create or replace force editionable view v_user_errors as
select *
from all_errors
where owner = case when sys_context('userenv', 'current_user') = 'AST'
                   then ast_ctx_util.get_default_user
                   else sys_context('userenv', 'current_user')
                   end
/
--rollback drop view V_USER_ERRORS;