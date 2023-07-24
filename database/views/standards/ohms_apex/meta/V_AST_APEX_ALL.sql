--liquibase formatted sql
--changeset view_script:V_SVT_APEX_ALL stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_SVT_apex_all
--------------------------------------------------------

create or replace force editionable view v_SVT_apex_all as
select a0.pass_yn, 
       a0.unqid, 
       a0.application_id, 
       aa.application_name,
       a0.page_id, 
       a0.created_by, 
       a0.created_on, 
       a0.LAST_updated_by, 
       a0.LAST_updated_on, 
       a0.validation_failure_message,
       a0.issue_title,
       asrc.test_name,
       asrc.urgency,
       asrc.urgency_level,
       asrc.test_id,
       a0.standard_code
from v_SVT_apex__0 a0
inner join v_eba_stds_standard_tests asrc on a0.standard_code = asrc.standard_code
inner join v_apex_applications aa on aa.application_id = a0.application_id
/
--rollback drop view V_SVT_APEX_ALL;