--liquibase formatted sql
--changeset view_script:V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT

/*
begin
    svt_audit_util.set_workspace;
end;
*/
--------------------------------------------------------

create or replace force editionable view V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT as
select paa.id audit_id, 
       paa.application_id, 
       aa.application_name,
       paa.page_id, 
       aa.page_name,
       paa.validation_failure_message, 
       paa.assignee, 
       paa.test_code, 
       paa.unqid,
       src.test_name,
       aaa.action_name,
       tcl.wcag_delimited
from svt_plsql_apex_audit paa
inner join apex_application_pages aa on paa.application_id = aa.application_id 
                                     and paa.page_id = aa.page_id
inner join v_eba_stds_standard_tests src on paa.test_code  = src.test_code
inner join v_svt_wcag_test_codes_listagg tcl on tcl.test_id = src.test_id
left outer join svt_audit_actions aaa on paa.action_id = aaa.id
where paa.issue_category = 'APEX'
and src.standard_name = 'Accessibility'
and coalesce(paa.action_id,0) in (0,3,4)
/

--rollback drop view V_SVT_PLSQL_APEX_AUDIT_DVA_EXPORT;