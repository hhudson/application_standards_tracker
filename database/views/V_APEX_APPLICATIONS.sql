--------------------------------------------------------
--  DDL for View v_apex_applications
--------------------------------------------------------

create or replace force editionable view v_apex_applications as
select application_id, 
       application_name, 
       application_group, 
       availability_status, 
       authorization_scheme, 
       created_by, 
       created_on, 
       last_updated_by, 
       last_updated_on
from ast.ast_apex_view.apex_applications(p_user => case when sys_context('userenv', 'current_user') = 'AST'
                                                        then ast_ctx_util.get_default_user
                                                        else sys_context('userenv', 'current_user')
                                                        end) 
/