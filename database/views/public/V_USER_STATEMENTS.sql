--liquibase formatted sql
--changeset view_script:V_USER_STATEMENTS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_STATEMENTS
--------------------------------------------------------

create or replace force editionable view v_user_statements as
select object_type, object_name, line, signature, type, sql_id, text, owner
from all_statements
where owner = svt_ctx_util.get_default_user
and object_name not in ('LOGGER')
/
--rollback drop view V_USER_STATEMENTS;