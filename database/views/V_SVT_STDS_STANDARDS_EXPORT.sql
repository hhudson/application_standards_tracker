--liquibase formatted sql
--changeset view_script:v_svt_stds_standards_export stripComments:false endDelimiter:/ runOnChange:true

create or replace force view V_SVT_STDS_STANDARDS_EXPORT as
with jcb as (select id standard_id,
                    standard_name, 
                    description, 
                    primary_developer, 
                    implementation, 
                    date_started, 
                    created, 
                    created_by, 
                    updated, 
                    updated_by, 
                    standard_group, 
                    active_yn,
                    svt_stds.file_name(full_standard_name) base_file_name,
                    'application/json' mime_type,
                    'UTF-8' character_set,
                    svt_deployment.json_standard_tests_blob (p_standard_id => id) all_tests_file_blob,
                    compatibility_mode,
                    full_standard_name
            from v_svt_stds_standards)
select jcb.standard_id, 
       jcb.standard_name, 
       jcb.full_standard_name,
       jcb.description, 
       jcb.primary_developer, 
       jcb.implementation, 
       jcb.date_started, 
       jcb.created, 
       jcb.created_by, 
       jcb.updated, 
       jcb.updated_by, 
       jcb.standard_group, 
       jcb.active_yn,
       sys.dbms_lob.getlength(jcb.all_tests_file_blob) all_tests_file_size,
       jcb.all_tests_file_blob,
       jcb.mime_type,
       apex_string.format('ALL_TESTS-%0.json',
                     p0 => jcb.base_file_name
              ) all_tests_file_name,
       jcb.character_set
from jcb
/

--rollback drop view v_svt_stds_standards_export;