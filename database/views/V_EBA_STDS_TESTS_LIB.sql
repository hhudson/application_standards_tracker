--liquibase formatted sql
--changeset view_script:V_EBA_STDS_TESTS_LIB stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_EBA_STDS_TESTS_LIB
--------------------------------------------------------

create or replace force editionable view V_EBA_STDS_TESTS_LIB as
with lib as (select estl.id,
                    estl.standard_id,
                    estl.test_name,
                    estl.query_clob,
                    estl.test_code,
                    estl.active_yn,
                    estl.mv_dependency,
                    estl.svt_component_type_id,
                    estl.test_id,
                    case when esst.id is null 
                         then 'N'
                         else 'Y'
                         end test_code_in_db_yn,
                    estl.explanation,
                    estl.fix,
                    estl.level_id,
                    estl.version_number imported_version_number,
                    estl.version_db imported_version_db,
                    esst.version_number installed_version_number,
                    esst.version_db installed_version_db,
                    case when esst.version_number is null 
                         then 'N'
                         when estl.version_number = esst.version_number
                         and  estl.version_db = esst.version_db
                         then 'Y'
                         else 'N'
                         end current_version_installed_yn,
                    case when esst.version_number is null 
                         then 'Y'
                         when estl.version_number != esst.version_number
                         and  estl.version_db = esst.version_db
                         then 'Y'
                         else 'N'
                         end upgrade_needed_yn,
                    eba_stds_standard_tests_api.build_test_md5 (
                         p_test_name             => estl.test_name,
                         p_query_clob            => estl.query_clob,
                         p_test_code             => estl.test_code,
                         p_level_id              => estl.level_id,
                         p_mv_dependency         => estl.mv_dependency,
                         p_svt_component_type_id => estl.svt_component_type_id,
                         p_explanation           => estl.explanation,
                         p_fix                   => estl.fix,
                         p_version_number        => estl.version_number,
                         p_version_db            => estl.version_db
                    ) estl_md5,
                    eba_stds_standard_tests_api.build_test_md5 (
                         p_test_name             => esst.test_name,
                         p_query_clob            => esst.query_clob,
                         p_test_code             => esst.test_code,
                         p_level_id              => esst.level_id,
                         p_mv_dependency         => esst.mv_dependency,
                         p_svt_component_type_id => esst.svt_component_type_id,
                         p_explanation           => esst.explanation,
                         p_fix                   => esst.fix,
                         p_version_number        => esst.version_number,
                         p_version_db            => esst.version_db
                    ) esst_md5
               from eba_stds_tests_lib estl
               left outer join eba_stds_standard_tests esst on estl.test_code = esst.test_code)
select lib.id,
       lib.standard_id,
       lib.test_name,
       lib.query_clob,
       lib.test_code,
       lib.active_yn,
       lib.mv_dependency,
       lib.svt_component_type_id,
       lib.test_id,
       lib.test_code_in_db_yn,
       lib.explanation,
       lib.fix,
       lib.level_id,
       lib.imported_version_number,
       lib.imported_version_db,
       lib.installed_version_number,
       lib.installed_version_db,
       lib.current_version_installed_yn,
       lib.upgrade_needed_yn,
       lib.estl_md5,
       lib.esst_md5,
       ess.standard_name,
       act.component_code,
       ess.active_yn standard_active_yn,
       asul.urgency_name,
       case  when lib.active_yn = 'N'
             then 'N'
             when lib.estl_md5 is null 
             then 'N'
             when lib.esst_md5 = lib.estl_md5
             then 'Y'
             else 'N'
             end published_yn
from lib
left outer join eba_stds_standards ess on ess.id = lib.standard_id
left outer join svt_component_types act on act.id = lib.svt_component_type_id
left outer join svt_standards_urgency_level asul on asul.id = lib.level_id
/


--rollback drop view V_EBA_STDS_TESTS_LIB;