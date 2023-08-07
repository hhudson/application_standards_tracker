--liquibase formatted sql
--changeset view_script:v_eba_stds_standard_tests_export stripComments:false endDelimiter:/ runOnChange:true

create or replace force view V_EBA_STDS_STANDARD_TESTS_EXPORT as 
with  estl as (
            select version_number imported_version_number,
                   test_code,
                   eba_stds_standard_tests_api.build_test_md5 (
                        p_standard_id           => standard_id,
                        p_test_name             => test_name,
                        p_query_clob            => query_clob,
                        p_test_code             => test_code,
                        p_active_yn             => active_yn,
                        p_level_id              => level_id,
                        p_mv_dependency         => mv_dependency,
                        p_svt_component_type_id => svt_component_type_id,
                        p_explanation           => explanation,
                        p_fix                   => fix
                   ) estl_md5
            from eba_stds_tests_lib estl
    ),
      std as (
            select esst.standard_id,
                   esst.test_id,
                   esst.urgency,
                   esst.urgency_level,
                   esst.level_id,
                   esst.test_name,
                   esst.test_code,
                   esst.standard_name,
                   esst.active_yn,
                   esst.nt_name,
                   esst.query_clob,
                   esst.std_creation_date,
                   esst.mv_dependency,
                   esst.svt_component_type_id,
                   esst.component_name,
                   esst.standard_active_yn,
                   esst.explanation,
                   esst.fix,
                   esst.download,
                   esst.file_blob,
                   esst.mime_type,
                   esst.file_name,
                   esst.character_set,
                   'V'||esst.version_number vsn,
                   esst.version_number,
                   esst.record_md5,
                   estl.estl_md5,
                   estl.imported_version_number,
                   case  when esst.active_yn = 'N'
                         then 'N'
                         when estl.estl_md5 is null 
                         then 'N'
                         when esst.record_md5 = estl.estl_md5
                         then 'Y'
                         else 'N'
                         end published_yn
            from eba_stds_standard_tests_api.v_eba_stds_standard_tests() esst
            left outer join estl on estl.test_code = esst.test_code
)
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
       record_md5,
       estl_md5,
       published_yn,
       null publish_button_html,
       case when published_yn = 'N'
            then 'hide'
            else 'show t-Button t-Button--icon t-Button--simple'
            end dlclss,
       case when published_yn = 'N'
            then 'show'
            else 'hide'
            end publish_clss,
       case when published_yn = 'N'
           and imported_version_number is null 
           then 'Publish'
           else 'Update'
           end publish_text
from std 
/
--rollback drop view v_eba_stds_standard_tests_export;