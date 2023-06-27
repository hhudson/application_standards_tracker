--liquibase formatted sql
--changeset view_script:V_USER_IND_COLUMNS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_user_ind_columns
--------------------------------------------------------

create or replace force editionable view v_user_ind_columns as
select table_name, column_name, column_position, index_name
from all_ind_columns
where table_name not like 'XXX%'
-- where owner = case when sys_context('userenv', 'current_user') = 'AST'
--                    then ast_ctx_util.get_default_user
--                    else sys_context('userenv', 'current_user')
--                    end
/
--rollback drop view V_USER_IND_COLUMNS;