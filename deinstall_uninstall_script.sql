-- begin
--     wwv_flow_api.create_or_remove_file( 
--         p_location => 'APPLICATION',
--         p_name     => 'fs-sprite.png',
--         p_mode     => 'REMOVE',
--         p_type     => 'IMAGE');
-- end;
-- /
/*
select *
from all_objects
where owner = 'SVT'
select *
from all_objects
where owner = 'SVT'
*/

/
/*
select apex_string.format('drop type %0;',lower(object_name)) stmt
from user_objects
where object_type = 'TYPE'
and object_name like '%NT';
*/
drop type apex_application_page_rpt_cols_nt;
drop type svt_apex_applications_nt;
drop type svt_apex_preferences_nt;
drop type svt_db_plsql_issue_nt;
drop type v_eba_stds_standard_tests_nt;
drop type v_svt_apex_nt;
drop type v_svt_apex__0_nt;
drop type v_svt_db_plsql_nt;
drop type v_svt_db_plsql_ref_nt;
drop type v_svt_db_tbl__0_nt;
drop type v_svt_db_view__0_nt;
drop type v_svt_plsql_apex__0_nt;
drop type v_svt_scm_object_assignee_nt;
drop type v_svt_table_data_load_def_nt;
drop type v_svt_db_mv__0_nt;
drop type v_svt_db_trigger__0_nt;

/*
select apex_string.format('drop synonym %0;',lower(object_name)) stmt
from user_objects
where object_type = 'SYNONYM';
*/
drop synonym svt_flow_dictionary_views;
drop synonym svt_flow_issues;

/*
select apex_string.format('drop function %0;',lower(object_name)) stmt
from user_objects
where object_type = 'FUNCTION';
*/
drop function except_cols;
drop function orclapex_version;

/*
select apex_string.format('drop procedure %0;',lower(object_name)) stmt
from user_objects
where object_type = 'PROCEDURE';
*/
drop procedure compile_conditional_compilation_version_package_for;

/*
select apex_string.format('drop type %0;',lower(object_name)) stmt
from user_objects
where object_type = 'TYPE'
and object_name like '%OT';
*/
drop type apex_application_page_rpt_cols_ot;
drop type svt_apex_applications_ot;
drop type svt_apex_preferences_ot;
drop type svt_db_plsql_issue_ot;
drop type v_eba_stds_standard_tests_ot;
drop type v_svt_apex_ot;
drop type v_svt_apex__0_ot;
drop type v_svt_db_plsql_ot;
drop type v_svt_db_plsql_ref_ot;
drop type v_svt_db_tbl__0_ot;
drop type v_svt_db_view__0_ot;
drop type v_svt_plsql_apex__0_ot;
drop type v_svt_scm_object_assignee_ot;
drop type v_svt_table_data_load_def_ot;
drop type v_svt_db_mv__0_ot;
drop type v_svt_db_trigger__0_ot;
/*
select apex_string.format('drop table %0 cascade constraints;',lower(table_name)) stmt
from user_tables
--where (table_name like 'EBA%' or table_name like 'SVT%')
;
*/
drop table eba_stds_access_levels cascade constraints;
drop table eba_stds_applications cascade constraints;
drop table eba_stds_error_lookup cascade constraints;
drop table eba_stds_inherited_tests cascade constraints;
drop table eba_stds_notifications cascade constraints;
drop table eba_stds_preferences cascade constraints;
drop table eba_stds_standards cascade constraints;
drop table eba_stds_standard_tests cascade constraints;
drop table eba_stds_tests_lib cascade constraints;
drop table eba_stds_types cascade constraints;
drop table eba_stds_users cascade constraints;
drop table svt_audit_actions cascade constraints;
drop table svt_audit_on_audit cascade constraints;
drop table svt_compatibility cascade constraints;
drop table svt_component_types cascade constraints;
drop table svt_nested_table_types cascade constraints;
drop table svt_plsql_apex_audit cascade constraints;
drop table svt_standards_urgency_level cascade constraints;
drop materialized view mv_issues_created_by_day;
drop materialized view mv_svt_bc_entries;
drop materialized view mv_svt_buttons;
drop materialized view mv_svt_card_actions;
drop materialized view mv_svt_chart_s;
drop materialized view mv_svt_classic_cols;
drop materialized view mv_svt_home_link;
drop materialized view mv_svt_ig;
drop materialized view mv_svt_ig_cols;
drop materialized view mv_svt_ir;
drop materialized view mv_svt_ir_cols;
drop materialized view mv_svt_list_entries;
drop materialized view mv_svt_nav_bar;
drop materialized view mv_svt_page_branch;
drop materialized view mv_svt_page_menu_entries;
drop materialized view mv_svt_search_config;
drop table svt_test_timing cascade constraints;
drop table mv_svt_issues_created_by_day cascade constraints;
drop table mv_svt_assignee_count cascade constraints;

/*
select apex_string.format('drop package %0;',lower(object_name)) stmt
from user_objects
where object_type = 'PACKAGE'
order by object_name;
*/
drop package assert;
drop package eba_stds;
drop package eba_stds_data;
drop package eba_stds_fw;
drop package eba_stds_inherited_tests_api;
drop package eba_stds_parser;
drop package eba_stds_security;
drop package eba_stds_standards_api;
drop package eba_stds_standard_tests_api;
drop package eba_stds_tests_lib_api;
drop package except_cols_pkg;
drop package oracle_apex_version;
drop package svt_apex_issue_link;
drop package svt_apex_issue_util;
drop package svt_apex_view;
drop package svt_audit_util;
drop package svt_ctx_util;
drop package svt_deployment;
drop package svt_error_handler_api;
drop package svt_menu_util;
drop package svt_monitoring;
drop package svt_mv_util;
drop package svt_nested_table_types_api;
drop package svt_one_report;
drop package svt_one_report_macro;
drop package svt_plsql_apex_audit_api;
drop package svt_plsql_review;
drop package svt_preferences;
drop package svt_standard_view;
drop package svt_urgency_level_api;
drop package eba_stds_applications_api;
drop package eba_stds_notifications_api;
drop package eba_stds_types_api;
drop package svt_acl;
drop package svt_audit_actions_api;
drop package svt_audit_on_audit_api;
drop package svt_compatibility_api;
drop package svt_component_types_api;
drop package svt_standards_urgency_level_api;
drop package svt_test_timing_api;
drop package svt_util;

/*
select apex_string.format('drop view %0;',lower(view_name)) stmt
from user_views
--where (lower(view_name) like '%svt%' ) or  (lower(view_name) like 'v_eba%' )
order by view_name;
*/

drop view v_eba_stds_applications;
drop view v_eba_stds_inherited_tests_tree;
drop view v_eba_stds_standards;
drop view v_eba_stds_standards_export;
drop view v_eba_stds_standard_tests;
drop view v_eba_stds_standard_tests_export;
drop view v_eba_stds_tests_lib;
drop view v_mv_svt;
drop view v_svt_application_report_card;
drop view v_svt_compatibility;
drop view v_svt_component_types;
drop view v_svt_db_tbl_all;
drop view v_svt_db_tbl__0;
drop view v_svt_db_view_all;
drop view v_svt_db_view__0;
drop view v_svt_email_subscriptions;
drop view v_svt_flow_dictionary_views;
drop view v_svt_nav_menu;
drop view v_svt_plsql_apex_audit;
drop view v_svt_plsql_apex__0;
drop view v_svt_scm_object_assignee;
drop view v_svt_table_data_load_def;
drop view v_all_standards_export;
drop view v_apex_applications;
drop view v_apex_application_page_ir_col;
drop view v_apex_workspace_developers;
drop view v_apex_workspace_preferences;
drop view v_automations_problems;
drop view v_automations_status;
drop view v_preference_problems;
drop view v_user_constraints;
drop view v_user_cons_columns;
drop view v_user_errors;
drop view v_user_identifiers;
drop view v_user_ind_columns;
drop view v_user_objects;
drop view v_user_plsql_object_settings;
drop view v_user_scheduler_jobs;
drop view v_user_source;
drop view v_user_statements;
drop view v_user_views;
drop view v_eba_stds_inherited_tests;
drop view v_eba_stds_standard_tests_w_inherited;
drop view v_svt_audit_on_audit_apex;
drop view v_svt_audit_on_audit_keep_these;
drop view v_svt_missing_base_data;
drop view v_svt_nested_table_types;
drop view v_svt_preference_problems;
drop view v_svt_problem_assignees;
drop view v_svt_test_timing;
drop view v_user_mviews;
drop view v_user_tab_cols;
drop view v_user_triggers;
