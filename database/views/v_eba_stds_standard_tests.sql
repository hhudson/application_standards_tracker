--liquibase formatted sql
--changeset view_script:v_eba_stds_standard_tests stripComments:false endDelimiter:/ runOnChange:true

-- the column order must match eba_stds_standard_tests_api.v_eba_stds_standard_tests() for the data loading to id the correct columns
-- keep this view light- it's used every time you compile!

create or replace force view v_eba_stds_standard_tests as 
select  st.standard_id,
        st.id test_id,
        st.level_id,
        asul.urgency_name urgency, 
        asul.urgency_level, --5
        st.test_name,
        st.test_code,
        ess.standard_name,
        st.active_yn,
        antt.nt_name, --10
        st.query_clob,
        st.created std_creation_date,
        st.updated std_updated_date,
       case when sysdate - trunc(st.updated) < 5
            then 'Y'
            else 'N'
            end src_recent_change_yn,
       st.mv_dependency,
       st.svt_component_type_id,
       act.component_name,
       ess.active_yn standard_active_yn,
       st.explanation,
       st.fix,
       st.version_number,
       st.display_sequence,
       ess.full_standard_name
from eba_stds_standard_tests st
inner join v_eba_stds_standards ess on st.standard_id = ess.id
inner join svt_component_types act on act.id = st.svt_component_type_id
inner join svt_nested_table_types antt on act.nt_type_id = antt.id
inner join svt_standards_urgency_level asul on asul.id = st.level_id
/
--rollback drop view v_eba_stds_standard_tests;