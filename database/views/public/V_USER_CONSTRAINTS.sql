--liquibase formatted sql
--changeset view_script:V_USER_CONSTRAINTS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_user_constraints
--------------------------------------------------------

create or replace force editionable view  v_user_constraints   as
select table_name, constraint_name, constraint_type, owner
from all_constraints
where owner = svt_ctx_util.get_default_user
and table_name not like 'XXX%'
/
--rollback drop view V_USER_CONSTRAINTS;