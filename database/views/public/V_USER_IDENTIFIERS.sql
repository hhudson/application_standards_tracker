--liquibase formatted sql
--changeset view_script:V_USER_IDENTIFIERS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_IDENTIFIERS
--------------------------------------------------------

create or replace force editionable view v_user_identifiers as
select signature, line, name, object_name, object_type, type, usage_context_id, usage, implicit, owner
from all_identifiers
where owner = svt_ctx_util.get_default_user
/
--rollback drop view V_USER_IDENTIFIERS;