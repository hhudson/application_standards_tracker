--liquibase formatted sql
--changeset view_script:V_SVT_APPLICATION_REPORT_CARD stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_APPLICATION_REPORT_CARD
--------------------------------------------------------

create or replace force editionable view V_SVT_APPLICATION_REPORT_CARD as
with rptcrd as (select application_id, 
                       critical_urgency, 
                       high_urgency, 
                       med_urgency
                    from (
                      select paa.application_id, 
                             esst.urgency
                        from svt_plsql_apex_audit paa
                        inner join v_svt_stds_standard_tests esst on paa.test_code = esst.test_code
                        left outer join svt_audit_actions aaa on paa.action_id = aaa.id
                        where coalesce(aaa.include_in_report_yn, 'Y') = 'Y'
                    )
                    pivot ( count(*) for urgency in 
                    ( 'Critical' as critical_urgency, 'High' as high_urgency,'Medium' as med_urgency,'Low' as low_urgency ) )
                )
select esa.apex_app_id application_id, 
       coalesce(rptcrd.critical_urgency,0) critical_urgency, 
       coalesce(rptcrd.high_urgency,0) high_urgency, 
       coalesce(rptcrd.med_urgency,0) med_urgency,
       coalesce(rptcrd.critical_urgency,0) + coalesce(rptcrd.high_urgency,0) + coalesce(rptcrd.med_urgency,0) violation_count,
       esa.default_developer,
       apex_string.format('%s (%s)', aa.application_name, esa.apex_app_id) application_name,
       est.type_name application_type
from svt_stds_applications esa
inner join apex_applications aa on aa.application_id = esa.apex_app_id
inner join svt_stds_types est on est.id = esa.type_id
left outer join rptcrd on esa.apex_app_id = rptcrd.application_id
--order by critical_urgency desc, high_urgency desc, med_urgency desc
/

--rollback drop view V_SVT_APPLICATION_REPORT_CARD;