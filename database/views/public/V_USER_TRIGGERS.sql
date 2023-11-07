--liquibase formatted sql
--changeset view_script:V_USER_TRIGGERS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_TRIGGERS
--------------------------------------------------------

create or replace force editionable view V_USER_TRIGGERS as
select owner, 
       trigger_name, 
       trigger_type, 
       triggering_event, 
       table_owner, 
       base_object_type, 
       table_name, 
       description
from dba_triggers
where owner = svt_ctx_util.get_default_user
and view_name not like 'XXX%'
/
--rollback drop view V_USER_TRIGGERS;