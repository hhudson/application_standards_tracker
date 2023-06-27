--------------------------------------------------------
--  DDL for View V_APEX_WORKSPACE_DEVELOPERS
--------------------------------------------------------

create or replace view v_apex_workspace_developers as 
select workspace_display_name, user_name, email
from apex_workspace_developers
where workspace_display_name = case when sys_context('userenv', 'current_user') = 'AST'
                                    then ast_ctx_util.get_default_user
                                    else sys_context('userenv', 'current_user')
                                    end
/