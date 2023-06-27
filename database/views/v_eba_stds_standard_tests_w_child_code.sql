--liquibase formatted sql
--changeset view_script:V_EBA_STDS_STANDARD_TESTS_W_CHILD_CODE stripComments:false endDelimiter:/ runOnChange:true

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: April 17, 2023
-- Synopsis:
--
-- View to represent standard codes  + child code
-- invoked by V_AST_PLSQL_APEX_AUDIT
--
------------------------------------------------------------------------------

create or replace force view v_eba_stds_standard_tests_w_child_code as
select  st.id test_id,
        subr.id sub_src_id,
        case when subr.explanation is null
            then st.issue_desc
            else subr.explanation
            end issue_desc, 
        asul.name urgency, 
        asul.urgency_level,
        st.name test_name,
        st.standard_code,
        st.test_type,
        st.standard_id,
        ess.name standard_category_name,
        st.active_yn,
        antt.nt_name,
        st.query_clob,
        case when subr.fix is null
             then 'N'
             else 'Y'
             end fix_defined_yn,
        case when ahtf.id is not null
            then 'Y'
            else 'N'
            end sert_help_yn,
        st.created std_creation_date,
        st.updated std_updated_date,
        coalesce(subr.sub_code, st.standard_code) child_code,
       case when sysdate - trunc(st.updated) < ast_preferences.get_preference ('AST_SRC_EDIT_DELAY')
            then 'Y'
            else 'N'
            end src_recent_change_yn,
       case when subr.explanation is null
            then st.issue_desc
            else '**'||st.issue_desc||'**
            '||subr.explanation
            end explanation,
       subr.fix,
       st.mv_dependency,
       st.ast_component_type_id,
       act.component_name,
       ess.active_yn standard_active_yn
from eba_stds_standard_tests st
inner join eba_stds_standards ess on st.standard_id = ess.id
inner join ast_component_types act on act.id = st.ast_component_type_id
inner join ast_nested_table_types antt on act.nt_type_id = antt.id
inner join ast_standards_urgency_level asul on asul.id = st.level_id
left join ast_sub_reference_codes subr on subr.test_id = st.id
left join ast_sert_how_to_fix ahtf on ahtf.test_id = st.id
/
--rollback drop view V_EBA_STDS_STANDARD_TESTS_W_CHILD_CODE;