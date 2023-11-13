--liquibase formatted sql
--changeset view_script:V_SVT_AUDIT_ON_AUDIT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_AUDIT_ON_AUDIT
--------------------------------------------------------

create or replace force editionable view V_SVT_AUDIT_ON_AUDIT as
with std as (select id, 
                    unqid, 
                    instr(unqid,':',1, 1) delim1,
                    instr(unqid,':',1, 2) delim2,
                    action_name,
                    created, 
                    created_by, 
                    test_code, 
                    audit_id, 
                    validation_failure_message, 
                    dense_rank() over (partition by unqid order by created desc) therank
                from svt_audit_on_audit
                )
select  esst.standard_name,
        substr(std.unqid, std.delim1 + 1,std.delim2-std.delim1-1) app_id, 
        esst.component_name,
        std.created, 
        std.test_code, 
        std.validation_failure_message,
        esst.urgency, 
        esst.urgency_level,
        esst.test_name
from std
inner join v_eba_stds_standard_tests esst on std.test_code = esst.test_code
                                          and esst.issue_category = 'APEX'
where std.therank = 1
and std.action_name = 'DELETE'
/

--rollback drop view V_SVT_AUDIT_ON_AUDIT;