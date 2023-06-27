/*
select * 
from user_objects
where object_name not like 'SYS%'
and object_name not like 'ISEQ%'
*/

begin
  dbms_scheduler.drop_job (job_name => 'EBA_STDS_DATA_RECORD_DAILY_ISSUE_SNAPSHOT');
end;
/
begin
  ast_apex_issue_util.drop_all_ast_issues;
exception when others then null;
end;
/
alter table ast_plsql_apex_audit no flashback archive
/

drop package assert;
drop package oracle_apex_version;
drop view v_apex_applications;
drop view v_apex_application_page_ir_col;
drop procedure compile_conditional_compilation_version_package_for;
drop function orclapex_version;
drop function except_cols;
drop materialized view apex_application_page_rpt_cols_ot;
drop materialized view apex_application_page_rpt_cols_nt;

drop synonym ast_flow_issues;

------------------------------------------------------------------------------
-- DO NOT EDIT ABOVE THIS LINE - these need to be run 1st
------------------------------------------------------------------------------
/*
select apex_string.format('drop synonym %0;',lower(synonym_name)) stmt
from user_synonyms
where (lower(synonym_name) like 'ast%' or  (lower(synonym_name) like 'eba%' ))
and synonym_name not like '%XXX%'
order by synonym_name
*/

drop synonym eba_archive_access_levels;
drop synonym eba_archive_errors;
drop synonym eba_archive_error_lookup;
drop synonym eba_archive_notifications;
drop synonym eba_archive_preferences;
drop synonym eba_archive_users;
drop synonym eba_ut_chart_projects;
drop synonym eba_ut_chart_tasks;


/*
select apex_string.format('drop table %0 cascade constraints;',lower(table_name)) stmt
from user_tables
where (lower(table_name) like 'ast%' or  (lower(table_name) like 'eba%' ))
and table_name not like '%XXX%'
order by table_name
*/     
drop TABLE AST_AUDIT_ON_AUDIT;
drop TABLE AST_NESTED_TABLE_TYPES;
drop TABLE AST_SERT_HOW_TO_FIX;
drop TABLE AST_SUB_REFERENCE_CODES;
drop table ast_audit_actions cascade constraints;
drop table ast_how_to_fix cascade constraints;
drop table ast_plsql_apex_audit cascade constraints;
drop table ast_plsql_exceptions cascade constraints;
drop table ast_standards_base_urls cascade constraints;
drop table ast_standards_check_types cascade constraints;
drop table ast_standards_reference_codes cascade constraints;
drop table ast_standards_urgency_level cascade constraints;
drop table ast_tracking_action cascade constraints;
drop table ast_tracking_issues cascade constraints;
drop table eba_archive_access_levels cascade constraints;
drop table eba_archive_errors cascade constraints;
drop table eba_archive_error_lookup cascade constraints;
drop table eba_archive_notifications cascade constraints;
drop table eba_archive_preferences cascade constraints;
drop table eba_archive_users cascade constraints;
drop table eba_stds_access_levels cascade constraints;
drop table eba_stds_applications cascade constraints;
drop table eba_stds_app_statuses cascade constraints;
drop table eba_stds_errors cascade constraints;
drop table eba_stds_error_lookup cascade constraints;
drop table eba_stds_flex_page_map cascade constraints;
drop table eba_stds_flex_registry cascade constraints;
drop table eba_stds_flex_static_lovs cascade constraints;
drop table eba_stds_history cascade constraints;
drop table eba_stds_notes cascade constraints;
drop table eba_stds_notifications cascade constraints;
drop table eba_stds_preferences cascade constraints;
drop table eba_stds_standards cascade constraints;
drop table eba_stds_standard_app_ref cascade constraints;
drop table eba_stds_standard_statuses cascade constraints;
drop table eba_stds_standard_tests cascade constraints;
drop table eba_stds_standard_type_ref cascade constraints;
drop table eba_stds_tags cascade constraints;
drop table eba_stds_tags_sum cascade constraints;
drop table eba_stds_tags_type_sum cascade constraints;
drop table eba_stds_test_validations cascade constraints;
drop table eba_stds_types cascade constraints;
drop table eba_stds_tz_pref cascade constraints;
drop table eba_stds_users cascade constraints;


drop sequence eba_stds_seq;


/*
select apex_string.format('drop package %0;',lower(uo.object_name)) stmt
from user_objects uo
where (lower(object_name) like '%ast%' or  (lower(object_name) like 'eba%' ))
and object_type = 'PACKAGE'
order by uo.object_name
*/
drop package ast_apex_issue_link;
drop package ast_preferences;
drop package ast_standard_view;
drop package ast_apex_issue_util;
drop package ast_apex_sert_util;
drop package ast_apex_view;
drop package ast_plsql_review;
drop package eba_archive;
drop package eba_archive_fw;
drop package eba_stds;
drop package eba_stds_data;
drop package eba_stds_export;
drop package eba_stds_filter2_fw;
drop package eba_stds_flex_fw;
drop package eba_stds_fw;
drop package eba_stds_parser;
drop package eba_stds_security;
drop package ast_audit_util;
drop package ast_ctx_util;
drop package ast_monitoring;
drop package ast_standard_ref_code_util;
drop PACKAGE BODY DEV_SUPPORT_UTILS;
drop package except_cols_pkg;
-- drop INDEX AST_HOW_TO_FIX_ID_PK           
-- drop INDEX AST_NESTED_TABLE_TYPES_UK1     
-- drop INDEX AST_NESTED_TABLE_T_ID_PK       
-- drop INDEX AST_SERT_HOW_TO_FIX_IDX1       
-- drop INDEX AST_SUB_REFERENCE_CODES_UK1    
-- drop INDEX AST_SUB_REFERENCE_I1           
-- drop INDEX AST_SUB_REFERENCE_ID_PK        

/*
select apex_string.format('drop view %0;',lower(view_name)) stmt
from user_views
where (lower(view_name) like '%ast%' or  lower(view_name) like 'v_eba%' )
order by view_name
*/
drop view v_apex_workspace_developers;
drop view v_user_constraints;
drop view v_user_cons_columns;
drop view v_user_errors;
drop view v_user_ind_columns;
drop view v_user_plsql_object_settings;
drop view v_user_scheduler_jobs;
drop view v_ast_db_tbl_all;
drop view v_ast_db_tbl_fk_missing_index;
drop view v_ast_db_tbl__0;
drop view v_ast_plsql_apex__0;
drop view v_ast_sub_reference_codes;
drop view v_eba_stds_standard_tests_w_child_code;
drop view v_ast_apexsert_11_sv_xss_list_url;
drop view v_ast_apex_0;
drop view v_ast_apex_100_valid_col_links;
drop view v_ast_apex_10_accessibility_col_alt_text;
drop view v_ast_apex_110_valid_link_buttons;
drop view v_ast_apex_11_accessibility_row_header;
drop view v_ast_apex_120_valid_list_links;
drop view v_ast_apex_1_app_auth;
drop view v_ast_apex_20_html_escaping_cols;
drop view v_ast_apex_2_app_available;
drop view v_ast_apex_30_page_access_protection;
drop view v_ast_apex_3_app_item_naming;
drop view v_ast_apex_40_page_auth;
drop view v_ast_apex_50_page_item_naming;
drop view v_ast_apex_60_public_pages_public_auth;
drop view v_ast_apex_70_val_col_authorization;
drop view v_ast_apex_80_valid_build_list_entry;
drop view v_ast_apex_90_valid_build_pages;
drop view v_ast_apex_accessibility_col_alt_text;
drop view v_ast_apex_all;
drop view v_ast_apex_app_auth;
drop view v_ast_apex_app_available;
drop view v_ast_apex_app_item_naming;
drop view v_ast_apex_html_escaping_cols;
drop view v_ast_apex_issues;
drop view v_ast_apex_page_access_protection;
drop view v_ast_apex_page_auth;
drop view v_ast_apex_page_item_naming;
drop view v_ast_apex_public_pages_public_auth;
drop view v_ast_apex_sert_10_sv_xss_no_data;
drop view v_ast_apex_sert_11_sv_xss_reg_head_foot;
drop view v_ast_apex_sert_12_sv_xss_list_attr;
drop view v_ast_apex_sert_13_sv_xss_list_url;
drop view v_ast_apex_sert_23_sv_xss_hidden_items;
drop view v_ast_apex_sert_25_sv_xss_list_entries;
drop view v_ast_apex_sert_26_sv_xss_region_titles;
drop view v_ast_apex_sert_2_sv_ps_deep_linking;
drop view v_ast_apex_sert_32_sv_url_item_protect;
drop view v_ast_apex_sert_38_sv_url_item_encrypt;
drop view v_ast_apex_sert_41_sv_xss_app_items;
drop view v_ast_apex_sert_42_sv_xss_static_region;
drop view v_ast_apex_sert_48_sv_ps_rpt_exp_data;
drop view v_ast_apex_sert_49_sv_ps_rpt_max_rows;
drop view v_ast_apex_sert_4_sv_xss_unescaped_items;
drop view v_ast_apex_sert_51_sv_ps_browser_cache;
drop view v_ast_apex_sert_53_sv_xss_stab_labels;
drop view v_ast_apex_sert_54_sv_xss_ptab_labels;
drop view v_ast_apex_sert_56_sv_url_page_protect;
drop view v_ast_apex_sert_57_sv_xss_ir_rpt_cols;
drop view v_ast_apex_sert_58_sv_xss_unescaped_processes;
drop view v_ast_apex_sert_59_sv_xss_unescaped_regions;
drop view v_ast_apex_sert_61_sv_ps_rejoin_session;
drop view v_ast_apex_sert_63_sv_xss_ig_rpt_cols;
drop view v_ast_apex_sert_6_sv_xss_plsql_output;
drop view v_ast_apex_sert_7_sv_xss_link_icon;
drop view v_ast_apex_sert_8_sv_xss_show_null;
drop view v_ast_apex_sert_9_sv_xss_more_data;
drop view v_ast_apex_sv_sec_col_xss_list_url_v;
drop view v_ast_apex_upgrade_opportunities;
drop view v_ast_apex_valid_build_list_entry;
drop view v_ast_apex_valid_build_pages;
drop view v_ast_apex_valid_col_links;
drop view v_ast_apex_valid_link_buttons;
drop view v_ast_apex_valid_list_links;
drop view v_ast_apex_val_col_authorization;
drop view v_ast_apex__0;
drop view v_ast_db_fk_missing_index;
drop view v_ast_db_plsql_0;
drop view v_ast_db_plsql_1_commented_specs;
drop view v_ast_db_plsql_2_discouraged_code;
drop view v_ast_db_plsql_3_duplicate_statements;
drop view v_ast_db_plsql_4_identifier_naming;
drop view v_ast_db_plsql_5_unusued_identifiers;
drop view v_ast_db_plsql_6_translateable;
drop view v_ast_db_plsql_7_anchored_declarations;
drop view v_ast_db_plsql_8_dbms_assert;
drop view v_ast_db_plsql_9_urgent_plsql_warnings;
drop view v_ast_db_plsql_all;
drop view v_ast_db_plsql__0;
drop view v_ast_db_table_naming;
drop view v_ast_db_utplsql_package_naming;
drop view v_ast_job_status;
drop view v_ast_plsql_apex_all;
drop view v_ast_plsql_apex_audit;
drop view v_ast_sert;
drop view v_ast_sert__0;
drop view v_ast_sert__all;
drop view v_ast_standards_reference_codes;
drop view v_eba_daily_snapshot_job_log;
drop view v_eba_stds_application_test_pass_fail;
drop view v_eba_stds_consolidated_issues;
drop view v_eba_stds_consolidated_issues_0;
drop view v_eba_stds_standards;
drop view v_eba_stds_standard_tests;
drop view v_eba_stds_tickets;
drop view v_ast_db_view_all;
drop view v_ast_db_view_invalid;
drop view v_ast_db_view_naming;
drop view v_ast_db_view__0;
drop view v_ast_email_subscriptions;
drop view v_apex_workspace_preferences;
drop view v_automations_log;
drop view v_user_identifiers;
drop view v_user_objects;
drop view v_user_source;
drop view v_user_statements;
drop view v_user_views;

/*
select apex_string.format('drop type %0;',lower(object_name)) stmt
from user_objects
where (lower(object_name) like '%ast%' or  lower(object_name) like 'eba%' )
and object_type = 'TYPE'
order by object_name asc
*/
drop type eba_stds_filter_col_tbl;
drop type eba_stds_filter_column_t;
drop type ast_db_plsql_issue_nt;
drop type ast_db_plsql_issue_ot;
drop type ast_apex_applications_nt;
drop type ast_apex_applications_ot;
drop type ast_apex_preferences_nt;
drop type ast_apex_preferences_ot;
drop type v_ast_sert__0_nt;
drop type v_ast_sert__0_ot;
drop type apex_application_page_rpt_cols_nt;
drop type apex_application_page_rpt_cols_ot;

/*
select apex_string.format('drop materialized view %0;',lower(object_name)) stmt, object_type
from user_objects
where (lower(object_name) like '%ast%' or  lower(object_name) like '%eba%' )
and object_type != 'TYPE'
order by object_name desc
*/
drop materialized view mv_eba_stds_parsed_urls;

------------------------------------------------------------------------------
-- DO NOT EDIT BELOW THIS LINE - these need to be run last
------------------------------------------------------------------------------
drop type ast_db_plsql_issue_ot;
drop type ast_apex_applications_ot;
begin
  dbms_scheduler.drop_job (job_name => 'EBA_STDS_DATA_RECORD_DAILY_ISSUE_SNAPSHOT');
end;
/