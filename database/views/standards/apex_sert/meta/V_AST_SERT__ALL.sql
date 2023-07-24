--liquibase formatted sql
--changeset view_script:V_SVT_SERT__ALL stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_views where upper(view_name) = upper('V_SVT_SERT__ALL');

--------------------------------------------------------
--  DDL for View V_SVT_SERT__ALL
--------------------------------------------------------

create or replace force editionable view V_SVT_SERT__ALL as
with data as (
    select 
        'N' pass_yn, 
        collection_name||'__'||component_signature unqid,
        application_id, 
        attribute_id, 
        page_id, 
        null created_by, 
        null created_on, 
        LAST_updated_by, 
        LAST_updated_on, 
        validation_failure_message,
        issue_title,
        collection_name,
        standard_code
    from v_SVT_sert__0
)
select a0.pass_yn, 
       a0.unqid,
       a0.application_id, 
       aa.application_name,
       a0.attribute_id,
       a0.page_id, 
       a0.created_by, 
       a0.created_on, 
       a0.LAST_updated_by, 
       a0.LAST_updated_on, 
       a0.validation_failure_message,
       a0.issue_title,
       a0.collection_name sert_attribute_key,
       asrc.urgency,
       asrc.urgency_level,
       asrc.test_id,
       a0.standard_code,
       asrc.test_name
from data a0
left join v_eba_stds_standard_tests asrc on asrc.standard_code = a0.collection_name
inner join v_apex_applications aa on aa.application_id = a0.application_id
inner join v_eba_stds_applications esa on a0.application_id = esa.apex_app_id -- already in v_SVT_sert__0
/

--rollback drop type V_SVT_SERT__ALL;