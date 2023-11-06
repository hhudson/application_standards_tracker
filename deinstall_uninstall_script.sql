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
*/
select *
from all_objects
where owner = 'SVT'
/
/*
select apex_string.format('drop type svt.%0;',lower(object_name)) stmt
from user_objects
where object_type = 'TYPE'
and object_name like '%NT';
*/
drop type svt.apex_application_page_rpt_cols_nt;
drop type svt.svt_apex_applications_nt;
drop type svt.svt_apex_preferences_nt;
drop type svt.svt_db_plsql_issue_nt;
drop type svt.v_eba_stds_standard_tests_nt;
drop type svt.v_svt_apex_nt;
drop type svt.v_svt_apex__0_nt;
drop type svt.v_svt_db_plsql_nt;
drop type svt.v_svt_db_plsql_ref_nt;
drop type svt.v_svt_db_tbl__0_nt;
drop type svt.v_svt_db_view__0_nt;
drop type svt.v_svt_plsql_apex__0_nt;
drop type svt.v_svt_scm_object_assignee_nt;
drop type svt.v_svt_table_data_load_def_nt;

/*
select apex_string.format('drop synonym svt.%0;',lower(object_name)) stmt
from user_objects
where object_type = 'SYNONYM';
*/
drop synonym svt.svt_flow_dictionary_views;
drop synonym svt.svt_flow_issues;

/*
select apex_string.format('drop function svt.%0;',lower(object_name)) stmt
from user_objects
where object_type = 'FUNCTION';
*/
drop function svt.except_cols;
drop function svt.orclapex_version;

/*
select apex_string.format('drop svt.procedure %0;',lower(object_name)) stmt
from user_objects
where object_type = 'PROCEDURE';
*/
drop procedure svt.compile_conditional_compilation_version_package_for;

/*
select apex_string.format('drop type svt.%0;',lower(object_name)) stmt
from user_objects
where object_type = 'TYPE'
and object_name like '%OT';
*/
drop type svt.apex_application_page_rpt_cols_ot;
drop type svt.svt_apex_applications_ot;
drop type svt.svt_apex_preferences_ot;
drop type svt.svt_db_plsql_issue_ot;
drop type svt.v_eba_stds_standard_tests_ot;
drop type svt.v_svt_apex_ot;
drop type svt.v_svt_apex__0_ot;
drop type svt.v_svt_db_plsql_ot;
drop type svt.v_svt_db_plsql_ref_ot;
drop type svt.v_svt_db_tbl__0_ot;
drop type svt.v_svt_db_view__0_ot;
drop type svt.v_svt_plsql_apex__0_ot;
drop type svt.v_svt_scm_object_assignee_ot;
drop type svt.v_svt_table_data_load_def_ot;

/*
select apex_string.format('drop table svt.%0 cascade constraints;',lower(table_name)) stmt
from user_tables
--where (table_name like 'EBA%' or table_name like 'SVT%')
;
*/
drop table svt.eba_stds_access_levels cascade constraints;
drop table svt.eba_stds_applications cascade constraints;
drop table svt.eba_stds_error_lookup cascade constraints;
drop table svt.eba_stds_inherited_tests cascade constraints;
drop table svt.eba_stds_notifications cascade constraints;
drop table svt.eba_stds_preferences cascade constraints;
drop table svt.eba_stds_standards cascade constraints;
drop table svt.eba_stds_standard_tests cascade constraints;
drop table svt.eba_stds_tests_lib cascade constraints;
drop table svt.eba_stds_types cascade constraints;
drop table svt.eba_stds_users cascade constraints;
drop table svt.svt_audit_actions cascade constraints;
drop table svt.svt_audit_on_audit cascade constraints;
drop table svt.svt_compatibility cascade constraints;
drop table svt.svt_component_types cascade constraints;
drop table svt.svt_nested_table_types cascade constraints;
drop table svt.svt_plsql_apex_audit cascade constraints;
drop table svt.svt_standards_urgency_level cascade constraints;
drop materialized view svt.mv_issues_created_by_day;
drop materialized view svt.mv_svt_bc_entries;
drop materialized view svt.mv_svt_buttons;
drop materialized view svt.mv_svt_card_actions;
drop materialized view svt.mv_svt_chart_s;
drop materialized view svt.mv_svt_classic_cols;
drop materialized view svt.mv_svt_home_link;
drop materialized view svt.mv_svt_ig;
drop materialized view svt.mv_svt_ig_cols;
drop materialized view svt.mv_svt_ir;
drop materialized view svt.mv_svt_ir_cols;
drop materialized view svt.mv_svt_list_entries;
drop materialized view svt.mv_svt_nav_bar;
drop materialized view svt.mv_svt_page_branch;
drop materialized view svt.mv_svt_page_menu_entries;
drop materialized view svt.mv_svt_search_config;

/*
select apex_string.format('drop package svt.%0;',lower(object_name)) stmt
from user_objects
where object_type = 'PACKAGE'
order by object_name;
*/
drop package svt.assert;
drop package svt.eba_stds;
drop package svt.eba_stds_data;
drop package svt.eba_stds_fw;
drop package svt.eba_stds_inherited_tests_api;
drop package svt.eba_stds_parser;
drop package svt.eba_stds_security;
drop package svt.eba_stds_standards_api;
drop package svt.eba_stds_standard_tests_api;
drop package svt.eba_stds_tests_lib_api;
drop package svt.except_cols_pkg;
drop package svt.oracle_apex_version;
drop package svt.svt_apex_issue_link;
drop package svt.svt_apex_issue_util;
drop package svt.svt_apex_view;
drop package svt.svt_audit_util;
drop package svt.svt_ctx_util;
drop package svt.svt_deployment;
drop package svt.svt_error_handler_api;
drop package svt.svt_menu_util;
drop package svt.svt_monitoring;
drop package svt.svt_mv_util;
drop package svt.svt_nested_table_types_api;
drop package svt.svt_one_report;
drop package svt.svt_one_report_macro;
drop package svt.svt_plsql_apex_audit_api;
drop package svt.svt_plsql_review;
drop package svt.svt_preferences;
drop package svt.svt_standard_view;
drop package svt.svt_urgency_level_api;

/*
select apex_string.format('drop view svt.%0;',lower(view_name)) stmt
from user_views
--where (lower(view_name) like '%svt%' ) or  (lower(view_name) like 'v_eba%' )
order by view_name;
*/

drop view svt.v_eba_stds_applications;
drop view svt.v_eba_stds_inherited_tests_tree;
drop view svt.v_eba_stds_standards;
drop view svt.v_eba_stds_standards_export;
drop view svt.v_eba_stds_standard_tests;
drop view svt.v_eba_stds_standard_tests_export;
drop view svt.v_eba_stds_tests_lib;
drop view svt.v_mv_svt;
drop view svt.v_svt_application_report_card;
drop view svt.v_svt_compatibility;
drop view svt.v_svt_component_types;
drop view svt.v_svt_db_tbl_all;
drop view svt.v_svt_db_tbl__0;
drop view svt.v_svt_db_view_all;
drop view svt.v_svt_db_view__0;
drop view svt.v_svt_email_subscriptions;
drop view svt.v_svt_flow_dictionary_views;
drop view svt.v_svt_nav_menu;
drop view svt.v_svt_plsql_apex_audit;
drop view svt.v_svt_plsql_apex__0;
drop view svt.v_svt_scm_object_assignee;
drop view svt.v_svt_table_data_load_def;
drop view svt.v_all_standards_export;
drop view svt.v_apex_applications;
drop view svt.v_apex_application_page_ir_col;
drop view svt.v_apex_workspace_developers;
drop view svt.v_apex_workspace_preferences;
drop view svt.v_automations_problems;
drop view svt.v_automations_status;
drop view svt.v_preference_problems;
drop view svt.v_user_constraints;
drop view svt.v_user_cons_columns;
drop view svt.v_user_errors;
drop view svt.v_user_identifiers;
drop view svt.v_user_ind_columns;
drop view svt.v_user_objects;
drop view svt.v_user_plsql_object_settings;
drop view svt.v_user_scheduler_jobs;
drop view svt.v_user_source;
drop view svt.v_user_statements;
drop view svt.v_user_views;

