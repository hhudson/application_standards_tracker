--liquibase formatted sql
--changeset view_script:V_SVT_AUDIT_ON_AUDIT_APEX stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_AUDIT_ON_AUDIT_APEX
--------------------------------------------------------

create or replace force editionable view V_SVT_AUDIT_ON_AUDIT_APEX as
with std as (select id, 
                    unqid, 
                    action_name,
                    created, 
                    created_by, 
                    test_code, 
                    audit_id, 
                    validation_failure_message, 
                    app_id,
                    page_id,
                    component_id,
                    assignee,
                    line,
                    object_name,
                    object_type,
                    code,
                    delete_reason,
                    dense_rank() over (partition by unqid order by created desc) therank
                from svt_audit_on_audit
                )
select  std.id, 
        std.audit_id,
        std.unqid, 
        esst.standard_name,
        std.app_id, 
        esa.pk_id,
        esst.component_name,
        std.created, 
        std.test_code, 
        std.validation_failure_message,
        esst.urgency, 
        esst.urgency_level,
        esst.test_name,
        std.page_id,
        std.component_id,
        std.assignee,
        std.line,
        std.object_name,
        std.object_type,
        std.code,
        std.delete_reason
from std
inner join v_svt_stds_standard_tests esst on std.test_code = esst.test_code
                                          and esst.issue_category = 'APEX'
inner join v_svt_stds_applications esa on esa.apex_app_id = std.app_id
where std.therank = 1
and std.action_name = 'DELETE'
/

--rollback drop view V_SVT_AUDIT_ON_AUDIT_APEX;