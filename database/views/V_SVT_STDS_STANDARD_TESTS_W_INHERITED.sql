--liquibase formatted sql
--changeset view_script:v_svt_stds_standard_tests_w_inherited stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_svt_stds_standard_tests_w_inherited
--------------------------------------------------------

create or replace force editionable view v_svt_stds_standard_tests_w_inherited as
select   o.standard_id,
         o.test_id,
         o.level_id,
         o.urgency, 
         o.urgency_level,
         o.test_name,
         o.test_code,
         o.full_standard_name,
         o.active_yn,
         o.nt_name,
         o.query_clob,
         o.std_creation_date,
         o.mv_dependency,
         o.svt_component_type_id,
         o.component_name,
         o.standard_active_yn,
         o.explanation,
         o.fix,
         o.version_number,
         o.version_db,
         'N' inherited_yn,
         o.display_sequence
  from v_svt_stds_standard_tests o
  union all
  select esit.standard_id,
         i.test_id,
         i.level_id,
         i.urgency, 
         i.urgency_level,
         i.test_name,
         i.test_code,
         i.full_standard_name,
         i.active_yn,
         i.nt_name,
         i.query_clob,
         i.std_creation_date,
         i.mv_dependency,
         i.svt_component_type_id,
         i.component_name,
         i.standard_active_yn,
         i.explanation,
         i.fix,
         i.version_number,
         i.version_db,
         'Y' inherited_yn,
         i.display_sequence
  from v_svt_stds_standard_tests i
  inner join svt_stds_inherited_tests esit on i.test_id = esit.test_id
                                           and i.standard_id = esit.parent_standard_id
/

--rollback drop view v_svt_stds_standard_tests_w_inherited;