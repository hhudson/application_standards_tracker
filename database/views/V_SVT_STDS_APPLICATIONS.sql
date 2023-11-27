--liquibase formatted sql
--changeset view_script:V_SVT_STDS_APPLICATIONS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_STDS_APPLICATIONS
--------------------------------------------------------

create or replace force editionable view V_SVT_STDS_APPLICATIONS as
select /*+ result_cache */
       esa.pk_id, 
       esa.apex_app_id, 
       esa.esa_created, 
       esa.esa_created_by, 
       esa.esa_updated, 
       esa.esa_updated_by, 
       esa.default_developer,
       aa.availability_status,
       est.type_name application_type,
       esa.type_id app_type_id,
       aa.application_name,
       esa.notes,
       esa.active_yn app_active_yn,
       est.active_yn type_active_yn,
       est.type_code
from svt_stds_applications esa
inner join apex_applications aa on esa.apex_app_id = aa.application_id
                                and aa.availability_status != 'Unavailable'
inner join svt_stds_types est on est.id = esa.type_id
                              and est.active_yn = 'Y'
where esa.active_yn = 'Y'
/

--rollback drop view V_SVT_STDS_APPLICATIONS;