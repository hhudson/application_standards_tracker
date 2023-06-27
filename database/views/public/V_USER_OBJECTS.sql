--liquibase formatted sql
--changeset view_script:V_USER_OBJECTS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_user_objects
--------------------------------------------------------

create or replace force editionable view v_user_objects as
select object_name, object_type, owner, status
from all_objects
where owner = case when sys_context('userenv', 'current_user') = 'AST'
                   then ast_ctx_util.get_default_user
                   else sys_context('userenv', 'current_user')
                   end
and object_name not like '%XXX%'
/
--rollback drop view V_USER_OBJECTS;