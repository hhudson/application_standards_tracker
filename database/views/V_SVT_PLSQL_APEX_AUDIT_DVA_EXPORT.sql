--liquibase formatted sql
--changeset view_script:V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT
--------------------------------------------------------

create or replace force editionable view V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT as
select paa.id audit_id, 
       paa.application_id, 
       paa.page_id, 
       paa.validation_failure_message, 
       paa.assignee, 
       paa.notes,
       paa.owner, 
       paa.test_code, 
       paa.unqid,
       src.test_name,
       aaa.action_name
from svt_plsql_apex_audit paa
inner join v_eba_stds_standard_tests src on paa.test_code  = src.test_code
left outer join svt_audit_actions aaa on paa.action_id = aaa.id
where paa.issue_category = 'APEX'
and src.standard_name = 'Accessibility'
and paa.pass_yn = 'N'
and coalesce(paa.action_id,0) in (0,3,4)
/

--rollback drop view V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT;