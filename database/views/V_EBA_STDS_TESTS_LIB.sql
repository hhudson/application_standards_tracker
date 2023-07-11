--liquibase formatted sql
--changeset view_script:V_EBA_STDS_TESTS_LIB stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_EBA_STDS_TESTS_LIB
--------------------------------------------------------

create or replace force editionable view V_EBA_STDS_TESTS_LIB as
select estl.id,
       estl.standard_id,
       coalesce(ess.standard_name, '[MISSING STANDARD]') standard_name,
       estl.test_name,
       estl.query_clob,
       estl.standard_code,
       estl.active_yn,
       estl.mv_dependency,
       estl.ast_component_type_id,
       coalesce(act.component_code, '[MISSING COMPONENT]') component_code,
       estl.workspace,
       estl.test_id,
       case when esst.id is null 
            then 'N'
            else 'Y'
            end standard_code_in_db_yn,
       ess.active_yn standard_active_yn,
       estl.explanation,
       estl.fix,
       estl.level_id,
       coalesce(asul.urgency_name, '[MISSING URGENCY]') urgency_name,
       estl.version_number imported_version_number,
       esst.version_number installed_version_number,
       case when esst.version_number is null 
            then 'N'
            when estl.version_number = esst.version_number
            then 'Y'
            else 'N'
            end current_version_installed_yn
  from eba_stds_tests_lib estl
  left outer join eba_stds_standard_tests esst on estl.standard_code = esst.standard_code
  left outer join eba_stds_standards ess on ess.id = estl.standard_id
  left outer join ast_component_types act on act.id = estl.ast_component_type_id
  left outer join ast_standards_urgency_level asul on asul.id = estl.level_id
/

--rollback drop view V_EBA_STDS_TESTS_LIB;