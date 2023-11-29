--liquibase formatted sql
--changeset view_script:V_USER_SOURCE stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_SOURCE
--------------------------------------------------------

create or replace force editionable view v_user_source as
select owner, type, name, line, text
from all_source
where owner = svt_ctx_util.get_default_user
and name not like 'XXX%'
and name not in ('LOGGER')
/
--rollback drop view V_USER_SOURCE;