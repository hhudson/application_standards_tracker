--liquibase formatted sql
--changeset view_script:V_LOKI_OBJECT_ASSIGNEE stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_LOKI_OBJECT_ASSIGNEE
--------------------------------------------------------

create or replace force editionable view V_LOKI_OBJECT_ASSIGNEE as
with loki as (select ll.object_type, 
                     ll.object_name, 
                     ll.locked, 
                     lsc.schema_name,
                     lu.full_name,
                     lu.apex_username,
                     lu.db_username,
                     dense_rank() over (partition by ll.object_type, ll.object_name order by ll.locked desc) lock_rank
                from loki.loki_locks_log ll 
                inner join loki.loki_schemas lsc on ll.schema_id = lsc.schema_id
                inner join loki.loki_users lu on ll.user_id = lu.user_id)
select object_type, 
       object_name,
       apex_username
from loki
where lock_rank = 1
/

--rollback drop view V_LOKI_OBJECT_ASSIGNEE;