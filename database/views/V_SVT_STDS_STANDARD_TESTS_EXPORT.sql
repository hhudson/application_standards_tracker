--liquibase formatted sql
--changeset view_script:v_svt_stds_standard_tests_export stripComments:false endDelimiter:/ runOnChange:true

create or replace force view V_SVT_STDS_STANDARD_TESTS_EXPORT as 
select standard_id,
       test_id,
       urgency,
       urgency_level,
       level_id,
       test_name,
       test_code,
       standard_name,
       active_yn,
       nt_name,
       query_clob,
       std_creation_date,
       mv_dependency,
       svt_component_type_id,
       component_name,
       standard_active_yn,
       explanation,
       fix,
       download,
       file_blob,
       mime_type,
       file_name,
       character_set,
       vsn,
       version_number,
       version_db,
       record_md5,
       lib_md5,
       published_yn,
       null publish_button_html,
       download_css dlclss
from svt_stds_standard_tests_api.v_svt_stds_standard_tests() 
/
--rollback drop view v_svt_stds_standard_tests_export;