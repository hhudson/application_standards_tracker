--liquibase formatted sql
--changeset view_script:V_SVT_AUDIT_ON_AUDIT_KEEP_THESE stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_AUDIT_ON_AUDIT_KEEP_THESE
--------------------------------------------------------

create or replace force editionable view V_SVT_AUDIT_ON_AUDIT_KEEP_THESE as
with std as (select id, 
                    unqid, 
                    action_name,
                    created,  
                    dense_rank() OVER (partition by unqid, action_name order by created desc) therank
             from svt_audit_on_audit)
select id, 
       unqid, 
       action_name,
       created,
       therank
from std 
where therank = 1
/

--rollback drop view V_SVT_AUDIT_ON_AUDIT_KEEP_THESE;