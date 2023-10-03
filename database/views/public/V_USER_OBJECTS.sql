--liquibase formatted sql
--changeset view_script:V_USER_OBJECTS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_user_objects
--------------------------------------------------------

create or replace force editionable view v_user_objects as
select object_id, object_name, object_type, owner, status
from all_objects
where owner = svt_ctx_util.get_default_user
and object_name not like '%XXX%'
and object_name not like 'DATABASECHANGELOG%'
and object_name not like 'DEV%'
and object_name not like 'EBA%'
/
--rollback drop view V_USER_OBJECTS;