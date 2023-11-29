--liquibase formatted sql
--changeset view_script:V_USER_TRIGGERS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_USER_TRIGGERS
--------------------------------------------------------

create or replace force editionable view V_USER_TRIGGERS as
select dt.owner, 
       dt.trigger_name, 
       dt.trigger_type, 
       dt.triggering_event, 
       dt.table_owner, 
       dt.base_object_type, 
       dt.table_name, 
       dt.description,
       dob.object_id
from all_triggers dt
inner join all_objects dob on dob.object_name = dt.trigger_name
                           and dob.object_type = 'TRIGGER'
                           and dob.owner = dt.owner
where dt.owner = svt_ctx_util.get_default_user
/
--rollback drop view V_USER_TRIGGERS;