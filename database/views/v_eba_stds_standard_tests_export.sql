--liquibase formatted sql
--changeset view_script:v_eba_stds_standard_tests_export stripComments:false endDelimiter:/ runOnChange:true

create or replace force view v_eba_stds_standard_tests_export as 
with std as (
    select esst.standard_id,
           esst.test_id,
           esst.urgency,
           esst.urgency_level,
           esst.test_name,
           esst.standard_code,
           esst.standard_category_name,
           esst.active_yn,
           esst.nt_name,
           esst.query_clob,
           esst.std_creation_date,
           esst.mv_dependency,
           esst.ast_component_type_id,
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
           esst.record_md5,
           estl.estl_md5,
           case when estl.estl_md5 is null 
                 then 'N'
                 when esst.record_md5 = estl.estl_md5
                 then 'Y'
                 else 'N'
                 end published_yn
      from eba_stds_standard_tests_api.v_eba_stds_standard_tests() esst
      left outer join v_eba_stds_tests_lib estl on estl.standard_code = esst.standard_code
)
select standard_id,
       test_id,
       urgency,
       urgency_level,
       test_name,
       standard_code,
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
       vsn,
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
            end publish_clss
from std 
/
--rollback drop view v_eba_stds_standard_tests_export;