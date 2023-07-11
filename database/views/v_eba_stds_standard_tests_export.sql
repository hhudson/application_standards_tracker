--liquibase formatted sql
--changeset view_script:v_eba_stds_standard_tests_export stripComments:false endDelimiter:/ runOnChange:true

create or replace force view v_eba_stds_standard_tests_export as 
select standard_id,
       test_id,
       urgency,
       urgency_level,
       test_name,
       standard_code,
       test_type,
       standard_category_name,
       active_yn,
       nt_name,
       query_clob,
       std_creation_date,
       mv_dependency,
       ast_component_type_id,
       component_name,
       standard_active_yn,
       explanation,
       fix,
       download,
       file_blob,
       mime_type,
       file_name,
       character_set,
       'V'||version_number version_number
  from eba_stds_standard_tests_api.v_eba_stds_standard_tests()
/
--rollback drop view v_eba_stds_standard_tests_export;