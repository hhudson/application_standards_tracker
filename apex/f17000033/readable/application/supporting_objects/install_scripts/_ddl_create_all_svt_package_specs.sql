
  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_ACL" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_ACL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Sep-21 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to add an administrator 
--
/*
    svt_acl.add_admin(p_user_name => 'hayden.h.hudson@oracle.com',
                      p_application_id => :APP_ID);
*/
------------------------------------------------------------------------------
procedure add_admin (p_user_name      in apex_workspace_developers.user_name%type,
                     p_application_id in apex_applications.application_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to add a contributor 
--
/*
    svt_acl.add_contributor(p_user_name => 'hayden.h.hudson@oracle.com',
                           p_application_id => :APP_ID);
*/
------------------------------------------------------------------------------
procedure add_contributor (p_user_name      in apex_workspace_developers.user_name%type,
                           p_application_id in apex_applications.application_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to add a reader 
--
/*
    svt_acl.add_reader(p_user_name => 'hayden.h.hudson@oracle.com',
                       p_application_id => :APP_ID);
*/
------------------------------------------------------------------------------
procedure add_reader (p_user_name      in apex_workspace_developers.user_name%type,
                      p_application_id in apex_applications.application_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 21, 2023
-- Synopsis:
--
-- Procedure to add all APEX_WORKSPACE_DEVELOPERS as ACL Readers
--
/*
begin
    svt_acl.add_awd_users(p_application_id => :APP_ID);
end;
*/
------------------------------------------------------------------------------
procedure add_awd_users(p_application_id in apex_applications.application_id%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to add a default admin if none exists
--
/*
begin
    svt_acl.add_default_admin(p_user_name      => :APP_USER,
                              p_application_id => :APP_ID);
end;
*/
------------------------------------------------------------------------------
procedure add_default_admin(p_user_name      in apex_workspace_developers.user_name%type,
                            p_application_id in apex_applications.application_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 7, 2023
-- Synopsis:
--
-- Function to give the name of an admin that someone can contact 
--
/*
select svt_acl.default_admin_message(p_application_id => :APP_ID)
from dual
*/
------------------------------------------------------------------------------
function default_admin_message(p_application_id in apex_applications.application_id%type) 
return apex_workspace_developers.user_name%type;

end SVT_ACL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_APEX_ISSUE_LINK" authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_APEX_ISSUE_LINK
--
-- DESCRIPTION
-- This package requires : 
-- • grant APEX_ADMINISTRATOR_ROLE to SVT
-- • create privileges on apex_220100.wwv_flow_issues
-- • read privileges on apex_issues
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Sep-28 - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- Build link to apex issue (must be run from an apex builder session)
--
/*
select svt_apex_issue_link.build_link_to_apex_issue(
          p_app_id => 100,
          p_id => 123
        )
from dual;
*/
------------------------------------------------------------------------------
   function build_link_to_apex_issue (
      p_app_id in apex_applications.application_id%type,
      p_id     in apex_issues.issue_id%type  
    )
   return varchar2
   deterministic
   result_cache;
end SVT_APEX_ISSUE_LINK;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_APEX_ISSUE_UTIL" authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_apex_issue_util
--
-- description
-- this package requires : 
-- • grant apex_administrator_role to svt
-- • create privileges on apex_220100.wwv_flow_issues
-- • read privileges on apex_issues
--
-- runtime deployment: yes
--
-- modified  (yyyy-mon-dd)
-- hayhudso  2022-sep-28 - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 30, 2023
-- Synopsis:
--
-- function to return the boolean from oracle_apex_version.c_apex_issue_access into a y/n 
--
/*
select svt_apex_issue_util.apex_issue_access_yn
from dual
*/
------------------------------------------------------------------------------
function apex_issue_access_yn return varchar2;
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: october 5, 2022
-- synopsis:
--
-- grouping all the procedures that need to be run by svt_stds_data.record_daily_issue_snapshot
--
/*
declare
t1 timestamp; 
t2 timestamp; 
l_message varchar2(1000);
begin
  t1 := systimestamp; 
  svt_apex_issue_util.manage_apex_issues(p_message => l_message);
  t2 := systimestamp; 
  apex_automation.log_info( p_message => 
                            apex_string.format( '%0 [in %1 second(s)]',
                                p0=> l_message,
                                p1 => extract( second from (t2-t1) )
                            )
                           );
  commit;
end;
*/
------------------------------------------------------------------------------
procedure manage_apex_issues (p_message out nocopy varchar2);
$if oracle_apex_version.c_apex_issue_access $then
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: september 28, 2022
-- synopsis:
--
-- create an apex issue
-- eg:
-- set serveroutput on
-- declare 
--     l_id apex_issues.id%type;
-- begin
--     svt_apex_issue_util.create_issue (
--         p_id             => l_id,
--         p_title          => 'test issue',
--         p_issue_text     => 'please fix this issue',
--         p_application_id => 720000,
--         p_page_id        => 1
--         );
--     dbms_output.put_line('l_id :'||l_id);
-- end;
--
------------------------------------------------------------------------------
procedure create_issue (p_id             out apex_issues.issue_id%type, 
                        p_title          in  varchar2, 
                        p_issue_text     in  apex_issues.issue_text%type, 
                        p_application_id in  apex_issues.related_application_id%type, 
                        p_page_id        in  apex_issues.related_page_id%type,
                        p_audit_id       in svt_plsql_apex_audit.id%type
                        );
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: september 29, 2022
-- synopsis:
--
-- merge audit issues into apex issues
--
/*
begin
  svt_apex_issue_util.merge_from_audit_tbl(
                            p_issue_category => 'apex',
                            p_application_id => 17000033,
                            p_page_id => 1
                            );
end;
*/
------------------------------------------------------------------------------
procedure merge_from_audit_tbl(p_issue_category in svt_plsql_apex_audit.issue_category%type default null,
                               p_application_id in svt_plsql_apex_audit.application_id%type default null,
                               p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                               p_audit_id       in svt_plsql_apex_audit.id%type default null,
                               p_test_code      in svt_stds_standard_tests.test_code%type default null,
                               p_message        out nocopy varchar2
                              );
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: october 3, 2022
-- synopsis:
--
-- delete expired issues
--
/*
begin
    svt_apex_issue_util.drop_irrelevant_issues;
end;
*/
------------------------------------------------------------------------------
procedure drop_irrelevant_issues (p_message out nocopy varchar2);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: october 5, 2022
-- synopsis:
--
-- update svt_plsql_apex_audit with the changes that have been performed to apex_issues
--
-- begin
--   svt_apex_issue_util.update_audit_tbl_from_apex_issues;
-- end;
------------------------------------------------------------------------------
procedure update_audit_tbl_from_apex_issues;
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: december 7, 2022
-- synopsis:
--
-- drop an issue
--
/*
begin
    svt_apex_issue_util.drop_issue (p_id => 270816420201692571);
end;
*/
------------------------------------------------------------------------------
  procedure drop_issue (p_id in  apex_issues.issue_id%type);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: december 9, 2022
-- synopsis:
--
-- drop all svt issues 
--
/*
begin
  svt_apex_issue_util.drop_all_svt_issues;
end;
*/
------------------------------------------------------------------------------
  procedure drop_all_svt_issues;
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: may 19, 2023
-- synopsis:
--
-- not sure why this one is necessary but it is theoretically harmless
--
/*
begin
  svt_apex_issue_util.hard_correct_svt_issues;
end;
*/
------------------------------------------------------------------------------
  procedure hard_correct_svt_issues;
$end
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: february 1, 2023
-- synopsis:
--
-- rerun the auditing for a given violation, including the creation of apex issues
--
/*
begin
  svt_ctx_util.set_review_schema (p_schema => 'cars');
  svt_apex_issue_util.refresh_for_test_code (
                        p_test_code => 'sv_url_item_protect');
end;
*/
------------------------------------------------------------------------------
  procedure refresh_for_test_code (p_test_code in svt_plsql_apex_audit.test_code%type);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: february 1, 2023
-- synopsis:
--
-- rerun the auditing for a given violation, including the creation of apex issues
--
/*
begin
  svt_ctx_util.set_review_schema (p_schema => 'cars');
  svt_apex_issue_util.refresh_for_audit_id (123);
end;
*/
------------------------------------------------------------------------------
  procedure refresh_for_audit_id (p_audit_id in svt_plsql_apex_audit.id%type);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: may 19, 2023
-- synopsis:
--
-- raises an error if the version in the oracle_apex_version package does not match the current apex version
--
/*
begin
  svt_apex_issue_util.check_apex_version_up2date;
end;
*/
------------------------------------------------------------------------------
procedure check_apex_version_up2date;
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: may 19, 2023
-- synopsis:
--
-- procedure to mark a violation as an exception
--
/*
begin
  svt_apex_issue_util.mark_as_exception (p_audit_id => :P1_AUDIT_ID);
end;
*/
------------------------------------------------------------------------------
procedure mark_as_exception (p_audit_id in svt_plsql_apex_audit.id%type);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: 2023-jun-13
-- synopsis:
--
-- procedure to mark a violation as an exception
--
/*
begin
  svt_apex_issue_util.bulk_mark_as_exception (p_audit_ids => :P21_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
procedure bulk_mark_as_exception (p_audit_ids in varchar2);
end SVT_APEX_ISSUE_UTIL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_APEX_VIEW" authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_apex_view
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Sep-16 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 16, 2022
-- Synopsis:
--
-- query apex_applications, regardless of apex version  
-- --
-- select application_id, 
--        application_name, 
--        application_group, 
--        availability_status, 
--        authorization_scheme, 
--        created_by, 
--        created_on, 
--        last_updated_by, 
--        last_updated_on
-- from svt_apex_view.apex_applications() 
------------------------------------------------------------------------------
function apex_applications(p_user in all_users.username%type default null)
return svt_apex_applications_nt pipelined;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2022-Oct-14
-- Synopsis:
--
-- query apex_application_page_ir_col, regardless of apex version  
-- --
-- select application_id, 
--        page_id, 
--        region_name, 
--        use_as_row_header,
--        region_id, 
--        created_by,
--        created_on,
--        updated_by,
--        updated_on
-- from svt_apex_view.apex_application_page_ir_col() 
------------------------------------------------------------------------------
function apex_application_page_ir_col
return apex_application_page_rpt_cols_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2022-Oct-14
-- Synopsis:
--
-- query apex_appl_page_ig_columns, regardless of apex version  
-- --
-- select application_id, 
--        page_id, 
--        region_name, 
--        use_as_row_header,
--        region_id, 
--        created_by,
--        created_on,
--        updated_by,
--        updated_on
-- from svt_apex_view.apex_appl_page_ig_columns() 
------------------------------------------------------------------------------
function apex_appl_page_ig_columns
return apex_application_page_rpt_cols_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 9, 2023
-- Synopsis:
--
-- pipeline the apex_workspace_preferences view
--
/*
select workspace_id,
       workspace_name,
       workspace_display_name,
       user_name,
       preference_id,
       preference_name,
       preference_value,
       preference_type,
       preference_comment
from svt_apex_view.apex_workspace_preferences() 
*/
------------------------------------------------------------------------------
function apex_workspace_preferences --deprecated bc slow(2023-Dec-8)
return svt_apex_preferences_nt pipelined 
deterministic;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 5, 2023
-- Synopsis:
--
-- Function to determine whether a given display_position_code is 'legacy' or 'deprecated'
--
/*
select svt_apex_view.display_position_is_violation (
                p_display_position_code => 'NEXT',  
                p_template_id           => 19073555195405988198,
                p_application_id        => 17000034) violation_yn
from dual;
*/
------------------------------------------------------------------------------
function display_position_is_violation (
                p_display_position_code in apex_application_page_buttons.display_position_code%type,
                p_template_id           in apex_application_page_regions.template_id%type,
                p_application_id        in apex_application_temp_region.application_id%type
  ) return varchar2 deterministic;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- Synopsis:
--
-- Function to return the necessary link request for directing to the requisite alternate IG or IR report 
--
/*
select svt_apex_view.rpt_link_request(
              p_issue_category => 'DB_PLSQL'
        )
from dual
*/
------------------------------------------------------------------------------
function rpt_link_request(
              p_issue_category   in svt_plsql_apex_audit.issue_category%type,
              p_report_type      in varchar2 default 'IR',
              p_dest_region_name in apex_appl_page_ig_rpts.region_name%type    default null,
              p_dest_page_id     in apex_appl_page_ig_rpts.page_id%type        default null,
              p_application_id   in apex_appl_page_ig_rpts.application_id%type default null
        )
return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- global constants
-- svt_apex_view.gc_svt_app_id
------------------------------------------------------------------------------
  gc_svt_app_id constant pls_integer := 17000033;


end SVT_APEX_VIEW;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_AUDIT_ACTIONS_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_ACTIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13 - created
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P56_ID := svt_audit_actions_api.insert_aua (
                    p_action_name          => :P56_ACTION_NAME,
                    p_include_in_report_yn => :P56_INCLUDE_IN_REPORT_YN
                );
    when 'U' then
      svt_audit_actions_api.update_aua (
            p_id                   => :P56_ID,
            p_action_name          => :P56_ACTION_NAME,
            p_include_in_report_yn => :P56_INCLUDE_IN_REPORT_YN
        );
    when 'D' then
      svt_audit_actions_api.delete_aua(p_id => :P56_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to insert records into SVT_AUDIT_ACTIONS
--
------------------------------------------------------------------------------
    function insert_aua (
        p_action_name          in svt_audit_actions.action_name%type,
        p_include_in_report_yn in svt_audit_actions.include_in_report_yn%type
    ) return svt_audit_actions.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to update records into SVT_AUDIT_ACTIONS
--
------------------------------------------------------------------------------
    procedure update_aua (
        p_id                   in svt_audit_actions.id%type,
        p_action_name          in svt_audit_actions.action_name%type,
        p_include_in_report_yn in svt_audit_actions.include_in_report_yn%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to delete records into SVT_AUDIT_ACTIONS
--
------------------------------------------------------------------------------
    procedure delete_aua (
        p_id in svt_audit_actions.id%type
    );
---------------------------------------------------------------------------- 
end SVT_AUDIT_ACTIONS_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_AUDIT_ON_AUDIT_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_ON_AUDIT_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Sep-28 - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- Procedure to insert a record in  svt_audit_on_audit
--
/*
    svt_audit_on_audit_api.insert_rec (
        p_unqid                      => p_unqid,
        p_action_name                => 'INSERT',
        p_test_code                  => p_test_code,
        p_audit_id                   => p_audit_id,
        p_validation_failure_message => p_validation_failure_message
    );
*/
------------------------------------------------------------------------------
    procedure insert_rec (
        p_unqid                      in svt_audit_on_audit.unqid%type,
        p_action_name                in svt_audit_on_audit.action_name%type,
        p_test_code                  in svt_audit_on_audit.test_code%type,
        p_audit_id                   in svt_audit_on_audit.audit_id%type,
        p_validation_failure_message in svt_audit_on_audit.validation_failure_message%type,
        p_app_id                     in svt_audit_on_audit.app_id%type default null,
        p_page_id                    in svt_audit_on_audit.page_id%type default null,
        p_component_id               in svt_audit_on_audit.component_id%type default null,
        p_assignee                   in svt_audit_on_audit.assignee%type default null,
        p_line                       in svt_audit_on_audit.line%type default null,
	    p_object_name                in svt_audit_on_audit.object_name%type default null,
	    p_object_type                in svt_audit_on_audit.object_type%type default null,
	    p_code                       in svt_audit_on_audit.code%type default null,
        p_delete_reason              in varchar2 default null
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 13, 2023
-- Synopsis:
--
-- Procedure to delete extra records in SVT_AUDIT_ON_AUDIT 
-- (unqid that keep getting inserted and deleted, which is indicative of a problem)
--
/*
begin
    svt_audit_on_audit_api.delete_extra;
end;
*/
------------------------------------------------------------------------------
    procedure delete_extra;    
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 20, 2023
-- Synopsis:
--
-- Function to return the overall historic number of violations
--
/*
select svt_audit_on_audit_api.overall_violation_count
from dual
*/
------------------------------------------------------------------------------
    function overall_violation_count (
                        p_app_id      in svt_audit_on_audit.app_id%type default null,
                        p_standard_id in svt_stds_standards.id%type default null)
    return pls_integer 
    result_cache;
end SVT_AUDIT_ON_AUDIT_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_AUDIT_UTIL" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Dec-23 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     date: april 11, 2023
-- synopsis:
--
-- function to query who has checked out db objects 
--
/*
select object_name,
       email,
       folder_name 
from svt_audit_util.v_svt_scm_object_assignee()
*/
------------------------------------------------------------------------------
function v_svt_scm_object_assignee
return v_svt_scm_object_assignee_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 20, 2023
-- Synopsis:
--
-- Function to query loki assignments  
--
/*
select object_name,
       email,
       folder_name object_type
from svt_audit_util.v_loki_object_assignee()
*/
------------------------------------------------------------------------------
function v_loki_object_assignee
return v_svt_scm_object_assignee_nt pipelined;

------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: june 28, 2022
-- synopsis:
--
-- recompile all objects that are not compiled into plscope 
-- requires the "alter package" privilege
/*
begin
    svt_audit_util.recompile_w_plscope;
end;
*/
------------------------------------------------------------------------------
    procedure recompile_w_plscope;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 13, 2023
-- Synopsis:
--
-- Procedure to loop through all the chosen schemas and recompile  
--
/*
begin
    svt_audit_util.recompile_all_schemas_w_plscope;
end;
*/
------------------------------------------------------------------------------
procedure recompile_all_schemas_w_plscope;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 8, 2022
-- Synopsis:
--
-- Procedure to record existing issue in table to track when they appear / disappear.  
-- 
/*
declare
t1 timestamp; 
t2 timestamp; 
l_message varchar2(1000);
begin
  t1 := systimestamp; 
  svt_audit_util.record_daily_issue_snapshot(p_test_code => 'DISCOURAGED_CODE',
                                             p_issue_category => 'DB_PLSQL',
                                             p_message => l_message);
  t2 := systimestamp; 
  apex_automation.log_info( p_message => 
                            apex_string.format( '%0 [in %1 second(s)]',
                                p0=> l_message,
                                p1 => extract( second from (t2-t1) )
                            )
                           );
  commit;
end;
*/
--
------------------------------------------------------------------------------
   procedure record_daily_issue_snapshot(p_application_id in svt_plsql_apex_audit.application_id%type default null,
                                         p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                                         p_test_code      in svt_stds_standard_tests.test_code%type default null,
                                         p_standard_id    in svt_stds_standard_tests.standard_id%type default null,
                                         p_schema         in all_users.username%type default null,
                                         p_issue_category in svt_plsql_apex_audit.issue_category%type default null,
                                         p_message        out nocopy varchar2
                                        );


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 17, 2023
-- Synopsis:
--
-- Procedure that invokes assign_from_default, assign_from_apex_audit & assign_from_scm
--
/*
begin
    svt_audit_util.assign_violations;
end;
*/
------------------------------------------------------------------------------
procedure assign_violations;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 8, 2023
-- Synopsis:
--
-- Procedure to initialize a standard such that all existing violations are categorized as 'legacy'
--
/*
begin
    svt_ctx_util.set_review_schema (p_schema => svt_preferences.get('SVT_DEFAULT_SCHEMA'));
    svt_audit_util.initialize_standard(p_test_code => 'HTML_ESCAPING_COLS');
    commit;
end;
*/
------------------------------------------------------------------------------
procedure initialize_standard(p_test_code  in svt_stds_standard_tests.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: April 13, 2023
-- Synopsis:
--
-- Procedure to set APEX workspace
--
/*
begin
    svt_audit_util.set_workspace;
end;
*/
------------------------------------------------------------------------------
procedure set_workspace (p_workspace in apex_workspaces.workspace%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 29, 2023
-- Synopsis:
--
-- Function to return a description of what minimum conditions have not yet been met
-- for any tests to be run and return any results. A null response is a success
--
/*
select svt_audit_util.min_not_met_error_msg
from dual
*/
------------------------------------------------------------------------------
function min_not_met_error_msg return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 7, 2023
-- Synopsis:
--
-- Function to answer whether the automation is currently in progress
--
/*
set serveroutput on
declare
l_bool boolean;
begin
    apex_session.create_session(p_app_id=>17000033,p_page_id=>1,p_username=>'HAYHUDSO');   
    l_bool := svt_audit_util.audit_job_is_running;
end;
*/
------------------------------------------------------------------------------
function audit_job_is_running return boolean;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 30, 2023
-- Synopsis:
--
-- Function to answer when the next big audit run is scheduled for (to manage expectations)
--
/*
select svt_audit_util.info_on_next_audit_run
from dual
*/
------------------------------------------------------------------------------
function info_on_next_audit_run return varchar2;

e_compilation_error    exception;
pragma exception_init(e_compilation_error,-24344);
e_dependent_error    exception;
pragma exception_init(e_dependent_error,-2311);
e_object_not_exist    exception;
pragma exception_init(e_object_not_exist,-4043);
e_timeout    exception;
pragma exception_init(e_timeout,-4021);
e_deadlock    exception;
pragma exception_init(e_deadlock,-60);
e_insufficient_privs    exception;
pragma exception_init(e_insufficient_privs,-1031);

end SVT_AUDIT_UTIL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_COMPATIBILITY_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_compatibility_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13- created
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P46_ID := svt_compatibility_api.insert_cmp (
                    p_display_order      => :P46_DISPLAY_ORDER,
                    p_compatibility_mode => :P46_COMPATIBILITY_MODE,
                    p_compatibility_desc => :P46_COMPATIBILITY_DESC,
                    p_type_name          => :P46_TYPE_NAME
                );
    when 'U' then
      svt_compatibility_api.update_cmp (
            p_id                 => :P46_ID,
            p_display_order      => :P46_DISPLAY_ORDER,
            p_compatibility_mode => :P46_COMPATIBILITY_MODE,
            p_compatibility_desc => :P46_COMPATIBILITY_DESC,
            p_type_name          => :P46_TYPE_NAME
        );
    when 'D' then
      svt_compatibility_api.delete_cmp(p_id => :P46_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to insert records into SVT_COMPATIBILITY
--
------------------------------------------------------------------------------
    function insert_cmp (
        p_display_order      in svt_compatibility.display_order%type,
        p_compatibility_mode in svt_compatibility.compatibility_mode%type,
        p_compatibility_desc in svt_compatibility.compatibility_desc%type,
        p_type_name          in svt_compatibility.type_name%type
    ) return svt_compatibility.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to update records into SVT_COMPATIBILITY
--
------------------------------------------------------------------------------
    procedure update_cmp (
        p_id                 in svt_compatibility.id%type,
        p_display_order      in svt_compatibility.display_order%type,
        p_compatibility_mode in svt_compatibility.compatibility_mode%type,
        p_compatibility_desc in svt_compatibility.compatibility_desc%type,
        p_type_name          in svt_compatibility.type_name%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to delete records into SVT_COMPATIBILITY
--
------------------------------------------------------------------------------
    procedure delete_cmp (
        p_id in svt_compatibility.id%type
    );
end svt_compatibility_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_COMPONENT_TYPES_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_COMPONENT_TYPES_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13 - created
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P7_ID := svt_component_types_api.insert_cmp (
                    p_component_name    => :P7_COMPONENT_NAME,
                    p_available_yn      => :P7_AVAILABLE_YN,
                    p_nt_type_id        => :P7_NT_TYPE_ID,
                    p_pk_value          => :P7_PK_VALUE,
                    p_parent_pk_value   => :P7_PARENT_PK_VALUE,
                    p_template_url      => :P7_TEMPLATE_URL,
                    p_friendly_name     => :P7_FRIENDLY_NAME,
                    p_name_column       => :P7_NAME_COLUMN,
                    p_addl_cols         => :P7_ADDL_COLS
                );
    when 'U' then
      svt_component_types_api.update_cmp (
            p_id                 => :P7_ID,
            p_component_name    => :P7_COMPONENT_NAME,
            p_available_yn      => :P7_AVAILABLE_YN,
            p_nt_type_id        => :P7_NT_TYPE_ID,
            p_pk_value          => :P7_PK_VALUE,
            p_parent_pk_value   => :P7_PARENT_PK_VALUE,
            p_template_url      => :P7_TEMPLATE_URL,
            p_friendly_name     => :P7_FRIENDLY_NAME,
            p_name_column       => :P7_NAME_COLUMN,
            p_addl_cols         => :P7_ADDL_COLS
        );
    when 'D' then
      svt_component_types_api.delete_cmp(p_id => :P7_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to insert records into SVT_COMPONENT_TYPES
--
------------------------------------------------------------------------------
    function insert_cmp (
       p_component_name    in svt_component_types.component_name%type,
       p_available_yn      in svt_component_types.available_yn%type,
       p_nt_type_id        in svt_component_types.nt_type_id%type,
       p_pk_value          in svt_component_types.pk_value%type,
       p_parent_pk_value   in svt_component_types.parent_pk_value%type,
       p_template_url      in svt_component_types.template_url%type,
       p_friendly_name     in svt_component_types.friendly_name%type,
       p_name_column       in svt_component_types.name_column%type,
       p_addl_cols         in svt_component_types.addl_cols%type
    ) return svt_component_types.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to update records into SVT_COMPONENT_TYPES
--
------------------------------------------------------------------------------
    procedure update_cmp (
       p_id                in svt_component_types.id%type,
       p_component_name    in svt_component_types.component_name%type,
       p_available_yn      in svt_component_types.available_yn%type,
       p_nt_type_id        in svt_component_types.nt_type_id%type,
       p_pk_value          in svt_component_types.pk_value%type,
       p_parent_pk_value   in svt_component_types.parent_pk_value%type,
       p_template_url      in svt_component_types.template_url%type,
       p_friendly_name     in svt_component_types.friendly_name%type,
       p_name_column       in svt_component_types.name_column%type,
       p_addl_cols         in svt_component_types.addl_cols%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to delete records into SVT_COMPONENT_TYPES
--
------------------------------------------------------------------------------
    procedure delete_cmp (
        p_id in svt_component_types.id%type
    );
end SVT_COMPONENT_TYPES_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_CTX_UTIL" authid definer
as
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- Set the value of the schema to be reviewed  
--
/*
begin
  svt_ctx_util.set_review_schema (p_schema => sys_context('userenv', 'current_user'));
  svt_audit_util.set_workspace;-- you might need this too
end;
*/
------------------------------------------------------------------------------
    procedure set_review_schema (p_schema in all_users.username%type default null);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 8, 2023
-- Synopsis:
--
-- return default user
--
/*
select svt_ctx_util.get_default_user
from dual;
*/
-- cannot result_cache or make deterministic, I'm afraid
------------------------------------------------------------------------------
    function get_default_user return all_users.username%type;
e_insufficient_privs    exception;
pragma exception_init(e_insufficient_privs,-1031);
end SVT_CTX_UTIL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_DEPLOYMENT" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_DEPLOYMENT
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jul-28 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 28, 2023
-- Synopsis:
--
-- Assemble to query to return the json that is used in json_content_blob
--
/*
set serveroutput on
declare 
l_clob clob;
begin
    l_clob := svt_deployment.assemble_json_query (
                p_table_name => 'V_SVT_STDS_STANDARD_TESTS_EXPORT',
                p_standard_id => :p_standard_id,
                p_datatype => 'clob');
    dbms_output.put_line(l_clob);
end;
*/
------------------------------------------------------------------------------
    function assemble_json_query (
                p_table_name    in user_tables.table_name%type,
                p_row_limit     in number default null,
                p_test_code     in svt_stds_standard_tests.test_code%type default null,
                p_standard_id   in svt_stds_standards.id%type default null,
                p_datatype      in varchar2 default 'blob')
    return clob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 16, 2023
-- Synopsis:
--
-- Assemble to query to return the json that is used in json_standard_tests_clob
--
/*
set serveroutput on
declare 
l_clob clob;
begin
    l_clob := svt_deployment.assemble_json_tsts_qry (
                p_standard_id => :p_standard_id,
                p_datatype => 'clob');
    dbms_output.put_line(l_clob);
end;
*/
------------------------------------------------------------------------------
    function assemble_json_tsts_qry (
                  p_standard_id   in svt_stds_standards.id%type default null,
                  p_test_code     in svt_stds_standard_tests.test_code%type default null,
                  p_datatype      in varchar2 default 'blob')
    return clob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 16, 2023
-- Synopsis:
--
-- Function to return the json clob for a standard and its associated tests combined
--
/*
set serveroutput on
declare
l_clob clob;
begin
    l_clob := svt_deployment.json_standard_tests_clob (p_standard_id => 1);
    dbms_output.put_line(l_clob);
end;
*/
------------------------------------------------------------------------------
    function json_standard_tests_clob (
                  p_standard_id in svt_stds_standards.id%type default null,
                  p_test_code   in svt_stds_standard_tests.test_code%type default null
    ) return clob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 16, 2023
-- Synopsis:
--
-- Function to return the json blob for a standard and its associated tests combined
--
/*
declare
l_blob blob;
begin
    l_blob := svt_deployment.json_standard_tests_blob (p_standard_id => 1);
end;
*/
------------------------------------------------------------------------------
    function json_standard_tests_blob (
                  p_standard_id in svt_stds_standards.id%type default null,
                  p_test_code   in svt_stds_standard_tests.test_code%type default null
    ) return blob;
    
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 7, 2023
-- Synopsis:
--
-- function to return a blob of the json output of a table
--
/*
select svt_deployment.json_content_blob (p_table_name => 'SVT_STDS_STANDARD_TESTS')
from dual
*/
------------------------------------------------------------------------------
    function json_content_blob (p_table_name     in user_tables.table_name%type,
                                p_row_limit      in number default null,
                                p_test_code      in svt_stds_standard_tests.test_code%type default null,
                                p_standard_id    in svt_stds_standards.id%type default null,
                                p_zip_yn         in varchar2 default null)
    return blob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 28, 2023
-- Synopsis:
--
-- function to return a clob of the json output of a table
--
/*
set serveroutput on
declare 
l_clob clob;
begin
    l_clob := svt_deployment.json_content_clob (
                p_table_name => 'SVT_STDS_STANDARD_TESTS',
                p_test_code => 'PG_NAME_TITLE');
    dbms_output.put_line(l_clob);
end;
*/
------------------------------------------------------------------------------
    function json_content_clob (p_table_name    in user_tables.table_name%type,
                                p_row_limit     in number default null,
                                p_test_code     in svt_stds_standard_tests.test_code%type default null,
                                p_standard_id   in svt_stds_standards.id%type default null)
    return clob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 7, 2023
-- Synopsis:
--
-- Function to return json blob template file for a given table (for the purpose of uploading to Data Load Definition)
-- v_svt_table_data_load_definition
/*
select svt_deployment.sample_template_file (p_table_name => 'SVT_COMPONENT_TYPES') thblob
from dual
*/
------------------------------------------------------------------------------
    function sample_template_file (p_table_name in user_tables.table_name%type)
    return blob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 7, 2023
-- Synopsis:
--
-- Procedure to add a zip file of the json output of a given table to APEX_APPLICATION_STATIC_FILES  
--
/*
begin
    svt_audit_util.set_workspace;
    SVT_DEPLOYMENT.upsert_static_file(p_table_name => 'SVT_COMPONENT_TYPES');
    commit;
end;
*/
------------------------------------------------------------------------------
    procedure upsert_static_file(p_table_name in user_tables.table_name%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 8, 2023
-- Synopsis:
--
-- Procedure to merge the contents from a zip file  
--
/*
begin
    apex_session.create_session( 17000033, 1, 'hayden.h.hudson@oracle.com' );
    SVT_DEPLOYMENT.merge_from_zip (p_table_name => 'svt_audit_actions');
    commit;
end;
*/
------------------------------------------------------------------------------
    procedure merge_from_zip (p_table_name in user_tables.table_name%type);


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 21, 2023
-- Synopsis:
--
-- Function to return the date of the latest date audit value of a given table
--
/*
select svt_deployment.table_last_updated_on('SVT_AUDIT_ACTIONS')
from dual
*/
------------------------------------------------------------------------------
    function table_last_updated_on (p_table_name in user_tables.table_name%type) return apex_application_static_files.created_on%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 9, 2023
-- Synopsis:
--
-- pipeline the apex_workspace_preferences view
--
/*
select table_name,
       implicit_table,
       file_blob,
       mime_type,
       file_name,
       static_file_name,
       character_set,
       file_size,
       download,
       data_load_definition_name,
       static_application_file_name,
       inspect_static_file_icon,
       page_id,
       page_id_icon,
       application_file_id,
       zip_blob,
       zip_file_size,
       zip_download,
       zip_mime_type,
       zip_charset,
       zip_updated_on,
       table_last_updated_on,
       static_file_created_on,
       stale_yn
from svt_deployment.v_svt_table_data_load_def(p_application_id => 17000033) 
*/
------------------------------------------------------------------------------
function v_svt_table_data_load_def (p_application_id in apex_applications.application_id%type)
return v_svt_table_data_load_def_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 3, 2023
-- Synopsis:
--
-- Function to output the markdown in the github readme summary of published tests 
--
/*
set serveroutput on
declare 
l_clob clob;
begin
    l_clob := svt_deployment.markdown_summary();
    for rec in (select column_value astring
                  from table(apex_string.split(l_clob, chr(10))))
    loop 
        dbms_output.put_line(rec.astring);
    end loop;
end;
*/
------------------------------------------------------------------------------
function markdown_summary return clob;

------------------------------------------------------------------------------
-- exceptions
------------------------------------------------------------------------------
   e_missing_field exception;
   pragma exception_init(e_missing_field, -0904);
   e_non_existent_tbl exception;
   pragma exception_init(e_non_existent_tbl, -0942);
   e_numeric_or_value exception;
   pragma exception_init (e_numeric_or_value, -6512);

end SVT_DEPLOYMENT;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_ERROR_HANDLER_API" authid definer is
/*
svt_error_handler_api.error_handler
*/
function error_handler 
   (p_error in apex_error.t_error
   ) return apex_error.t_error_result
;    
end SVT_ERROR_HANDLER_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_MENU_UTIL" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_menu_util
--
-- DESCRIPTION : https://apexdebug.com/making-the-most-of-a-navigation-menu
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-6 - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 6, 2023
-- Synopsis:
--
-- simply a wrapper for apex_plugin_util.is_component_used
-- returning a Y or N instead of a boolean
--
/*
select SVT_menu_util.
from dual
*/
------------------------------------------------------------------------------
function is_component_used_yn (
                p_build_option_id           IN NUMBER   DEFAULT NULL,
                p_authorization_scheme_id   IN VARCHAR2,
                p_condition_type            IN VARCHAR2,
                p_condition_expression1     IN VARCHAR2,
                p_condition_expression2     IN VARCHAR2,
                p_component                 IN VARCHAR2 DEFAULT NULL )
            return varchar2;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 12, 2023
-- Synopsis:
--
-- Function  to convert boolean to y/n from apex_authorization.is_authorized
--
/*
select svt_menu_util.is_authorized_yn (p_authorization_name => 'CONTRIBUTION RIGHTS') is_authorized_yn
from dual
*/
------------------------------------------------------------------------------
function is_authorized_yn (
    p_authorization_name in apex_application_list_entries.authorization_scheme%type
) return varchar2;
end SVT_MENU_UTIL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_MONITORING" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_MONITORING
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso   2022-Dec-16 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudsons
--     Date: December 20, 2022
-- Synopsis:
--
-- function to generate html table for email 
/*
select svt_monitoring.unassigned_src_html (
                  p_test_code  => 'DBMS_ASSERT',
                  p_days_since => 9,
                  p_fetch_rows => 2
              ) thehtml
from dual;
*/
------------------------------------------------------------------------------
function unassigned_src_html 
    (p_test_code     in svt_stds_standard_tests.test_code%type,
     p_days_since    in number default 1,
     p_fetch_rows    in number default null
    )
    return varchar2;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 16, 2022
-- Synopsis:
--
-- Send monitoring email
--
/*
begin
    apex_session.create_session(p_app_id=>17000033,p_page_id=>1,p_username=>'HAYHUDSO');
    svt_monitoring.send_update(
                p_days_since => 2,
                p_override_email => 'hayden.h.hudson@oracle.com');
end;
*/
------------------------------------------------------------------------------
procedure send_update(p_days_since     in number default 1,
                      p_override_email in varchar2 default null,
                      p_application_id in apex_applications.application_id%type default null);

  ------------------------------------------------------------------------------
  --  Creator: Hayden Hudson
  --     Date: January 3, 2023
  -- Synopsis:
  --
  -- function to get the url to the SVT application
  --
  /*
  select svt_monitoring.app_url
  from dual;
  */
  ------------------------------------------------------------------------------
  function app_url (p_application_id in apex_applications.application_id%type default null) 
  return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 10, 2023
-- Synopsis:
--
--  function to get a human readable database name
--
/*
select svt_monitoring.get_db_name
from dual;
*/
------------------------------------------------------------------------------
  function get_db_name return varchar2;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 13, 2023
-- Synopsis:
--
-- Procedure to send an email  
--
/*
declare
l_to        varchar2(100) := 'hayden.h.hudson@oracle.com';
l_from      varchar2(100) := 'hayden.h.hudson@oracle.com';
l_subj      varchar2(100) := 'hello';
l_body      clob := 'hello';
l_body_html clob := 'hello';
begin
  svt_monitoring.send_email (
    p_to        => l_to,
    p_from      => l_from,
    p_subj      => l_subj,
    p_body      => l_body,
    p_body_html => l_body_html
  );
  svt_monitoring.push_email;
end;
*/
------------------------------------------------------------------------------
  procedure send_email (
              p_to        in varchar2,
              p_from      in varchar2,
              p_subj      in varchar2,
              p_body      in clob,
              p_body_html in clob
  );


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 13, 2023
-- Synopsis:
--
-- Procedure to push email;
--
------------------------------------------------------------------------------
  procedure push_email;

  ------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 11, 2023
-- Synopsis:
--
-- Public function to build html for unassigned issues
--
/*
select svt_monitoring.unassigned_html_by_src
                        (p_days_since => 2) uhbs
from dual;
*/
------------------------------------------------------------------------------
  function unassigned_html_by_src (
            p_days_since in number) return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 11, 2023
-- Synopsis:
--
-- Procedure to build html for assigned issues
--
/*
set serveroutput on
declare
l_assigned_report_html clob;
l_list_of_assignees clob;
begin
  svt_monitoring.assigned_html (
        p_days_since           => 2,
        p_assigned_report_html => l_assigned_report_html,
        p_list_of_assignees    => l_list_of_assignees);
  dbms_output.put_line('l_assigned_report_html :'||l_assigned_report_html);
  dbms_output.put_line('l_list_of_assignees :'||l_list_of_assignees);
end;
*/
------------------------------------------------------------------------------
  procedure assigned_html (
        p_days_since           in number,
        p_assigned_report_html out nocopy clob,
        p_list_of_assignees    out nocopy varchar2);
  
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 24, 2023
-- Synopsis:
--
-- function to return a value to uniquely identify the database
--
/*
select svt_monitoring.db_unique_name
from dual
*/
------------------------------------------------------------------------------
  function db_unique_name return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 18, 2023
-- Synopsis:
--
-- Procedure to enable SVT automations 
--
/*
begin
    svt_monitoring.enable_automations(p_application_id => :APP_ID);
end;
*/
------------------------------------------------------------------------------
  procedure enable_automations (p_application_id in apex_applications.application_id%type default null);


end SVT_MONITORING;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_MV_UTIL" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_MV_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jul-5 - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 5, 2023
-- Synopsis:
--
-- function to return the sql for a view that unions all the mv_svt_* views together
--
/*
select svt_mv_util.mv_svt_query
from dual
*/
------------------------------------------------------------------------------
function mv_svt_query return clob;
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: may 10, 2023
-- synopsis:
--
-- procedure to refresh a colon-delimited list of materialized views on demand 
--
/*
begin
    svt_mv_util.refresh_mv('MV_SVT_BC_ENTRIES:MV_SVT_BUTTONS');
end;
*/
------------------------------------------------------------------------------
procedure refresh_mv(p_mv_list in svt_stds_standard_tests.mv_dependency%type default null);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 4, 2023
-- Synopsis:
--
-- Function to answer whether v_svt_problem_assignees returns any rows
--
/*
select svt_mv_util.problem_assignments_yn
from dual
*/
------------------------------------------------------------------------------
  function problem_assignments_yn
  return varchar2;
end SVT_MV_UTIL;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_NESTED_TABLE_TYPES_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_nested_table_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-23 - created
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P64_ID := svt_nested_table_types_api.insert_nt (
                    p_nt_name       => :P64_NT_NAME,
                    p_example_query => :P64_EXAMPLE_QUERY,
                    p_object_type   => :P64_OBJECT_TYPE
                );
    when 'U' then
      svt_nested_table_types_api.update_nt (
            p_id            => :P64_ID,
            p_nt_name       => :P64_NT_NAME,
            p_example_query => :P64_EXAMPLE_QUERY,
            p_object_type   => :P64_OBJECT_TYPE
        );
    when 'D' then
      svt_nested_table_types_api.delete_nt(p_id => :P64_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 10, 2023
-- Synopsis:
--
-- Procedure to insert records into SVT_NESTED_TABLE_TYPES
--
------------------------------------------------------------------------------
    function insert_nt (
        p_nt_name       in svt_nested_table_types.nt_name%type,
        p_example_query in svt_nested_table_types.example_query%type,
        p_object_type   in svt_nested_table_types.object_type%type
    ) return svt_nested_table_types.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 10, 2023
-- Synopsis:
--
-- Procedure to update records into SVT_NESTED_TABLE_TYPES
--
------------------------------------------------------------------------------
    procedure update_nt (
        p_id            in svt_nested_table_types.id%type,
        p_nt_name       in svt_nested_table_types.nt_name%type,
        p_example_query in svt_nested_table_types.example_query%type,
        p_object_type   in svt_nested_table_types.object_type%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 10, 2023
-- Synopsis:
--
-- Procedure to delete records into SVT_NESTED_TABLE_TYPES
--
------------------------------------------------------------------------------
    procedure delete_nt (
        p_id in svt_nested_table_types.id%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- Synopsis:
--
-- Overloaded function to return the issue_category for a given nt_name
--
/*
select svt_nested_table_types_api.issue_category(p_nt_name => 'V_SVT_APEX__0_NT') ic
from dual
*/
------------------------------------------------------------------------------
    function issue_category (p_nt_name in svt_nested_table_types.nt_name%type)
    return svt_plsql_apex_audit.issue_category%type
    deterministic
    result_cache;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-29
-- Synopsis:
--
-- Function to return the nt_name for a given issue_category
--
/*
select svt_nested_table_types_api.nt_name(p_object_type => 'APEX') ic
from dual
*/
------------------------------------------------------------------------------
    function nt_name (p_object_type in svt_nested_table_types.object_type%type)
    return svt_nested_table_types.nt_name%type
    deterministic
    result_cache;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- Synopsis:
--
-- Overloaded function to return the issue_category for a given test_code
--
/*
select svt_nested_table_types_api.issue_category(p_test_code => 'APP_AUTH') ic
from dual
*/
------------------------------------------------------------------------------
    function issue_category (p_test_code in svt_stds_standard_tests.test_code%type)
    return svt_plsql_apex_audit.issue_category%type
    deterministic;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 29, 2023
-- Synopsis:
--
-- Function to return the count of nested table types that have been defined
--
/*
select svt_nested_table_types_api.nt_count
from dual
*/
------------------------------------------------------------------------------
    function nt_count return pls_integer result_cache;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 29, 2023
-- Synopsis:
--
-- Function to return a list of nested table types by friendly name
--
/*
select svt_nested_table_types_api.nt_list
from dual
*/
------------------------------------------------------------------------------
    function nt_list return varchar2 result_cache;
end svt_nested_table_types_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_ONE_REPORT" authid definer as
-- Note: this package is dependent upon the package svt_one_report_macro
-- Updated for multiple schemas
-- from https://github.com/ainielse/rando/blob/mSVTer/f_one_report.sql
--
--
function get_query( p_table_name    in varchar2,
                    p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return clob;
--
-- used for classic reports
function get_headers(p_table_name   in varchar2,
                     p_pretty_yn    in varchar2 default 'Y',
                     p_schema_name  in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2;
--
--
function show_column(   p_table_name        in varchar2,
                        p_column_number     in number,
                        p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return boolean;       
--
-- used for Interactive Reports
procedure set_ir_columns_headers(   p_table_name        in varchar2,
                                    p_base_item_name    in varchar2,
                                    p_pretty_yn         in varchar2 default 'Y',
                                    p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) ;  
end SVT_ONE_REPORT;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_ONE_REPORT_MACRO" authid definer as
-- SQL Macro
-- https://github.com/ainielse/rando/blob/mSVTer/f_one_report.sql
-- updated to allow different schemas
/*
select * 
from svt_one_report_macro.user_tab_col_macro(p_table_name => 'SVT_AUDIT_ACTIONS', p_schema_name => 'REDWOOD')
*/
function user_tab_col_macro(p_table_name    in  varchar2,
                            p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2 SQL_MACRO;
                   
end SVT_ONE_REPORT_MACRO;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_PLSQL_APEX_AUDIT_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_plsql_apex_audit_api
--
-- DESCRIPTION
--
-- runtime deployment: yes
--
-- modified  (yyyy-mon-dd)
-- hayhudso  2023-jun-29- created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 4, 2023
-- Synopsis:
--
-- Procedure to update a row of svt_plsql_apex_audit  
--
/*
begin
  case :APEX$ROW_STATUS
    when 'U' then
       svt_plsql_apex_audit_api.updated_audit  (
        p_audit_id  => :P42_AUDIT_ID,
        p_assignee  => :P42_ASSIGNEE,
        p_notes     => :P42_NOTES,
        p_action_id => :P42_ACTION_ID,
        p_legacy_yn => :P42_LEGACY_YN
      );
  end case;
end;
*/
---------------------------------------------------------------------------- 
    procedure updated_audit  (
      p_audit_id  in svt_plsql_apex_audit.id%type,
      p_assignee  in svt_plsql_apex_audit.assignee%type,
      p_notes     in svt_plsql_apex_audit.notes%type,
      p_action_id in svt_plsql_apex_audit.action_id%type,
      p_legacy_yn in svt_plsql_apex_audit.legacy_yn%type
    );
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: june 29, 2023
-- synopsis:
--
-- procedure to update a violation as an exception
--
/*
begin
    svt_plsql_apex_audit_api.mark_as_exception (p_audit_id  => p_audit_id);
end;
*/
------------------------------------------------------------------------------
procedure mark_as_exception (p_audit_id in svt_plsql_apex_audit.id%type);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: june 29, 2023
-- synopsis:
--
-- procedure to remove a pointer to an apex issue
--
/*
begin
    svt_plsql_apex_audit_api.null_out_apex_issue (p_audit_id  => p_audit_id);
end;
*/
------------------------------------------------------------------------------
procedure null_out_apex_issue (p_audit_id in svt_plsql_apex_audit.id%type);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: june 29, 2023
-- synopsis:
--
-- procedure to assign a given violation to someone
--
/*
begin
    svt_plsql_apex_audit_api.assign_violation (
                                p_audit_id  => 123,
                                p_assignee  => hayden.h.hudson@oracle.com);
end;
*/
------------------------------------------------------------------------------
procedure assign_violation (p_audit_id in svt_plsql_apex_audit.id%type,
                            p_assignee in svt_plsql_apex_audit.assignee%type);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: june 29, 2023
-- synopsis:
--
-- procedure to bulk reassign violation 
--
/*
begin
    svt_plsql_apex_audit_api.bulk_reassign (
                         p_audit_ids  => :p1_selected_ids,
                         p_assignee   => :p1_new_assignee ); 
end;
*/
------------------------------------------------------------------------------
procedure bulk_reassign (p_audit_ids in varchar2,
                         p_assignee  in svt_plsql_apex_audit.assignee%type);
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: february 1, 2023
-- synopsis:
--
-- get a row of svt_plsql_apex_audit for a given audit id
--
/*
declare
l_rec svt_plsql_apex_audit%rowtype;
begin
    l_rec := svt_plsql_apex_audit_api.get_audit_record(p_audit_id) 
end;
*/
------------------------------------------------------------------------------
function get_audit_record (p_audit_id in svt_plsql_apex_audit.id%type) 
return svt_plsql_apex_audit%rowtype;
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: february 2, 2023
-- synopsis:
--
-- function to get the audit_id for a give unqid
--
------------------------------------------------------------------------------
function get_unqid(p_audit_id in svt_plsql_apex_audit.id%type) 
return svt_plsql_apex_audit.unqid%type 
deterministic 
result_cache;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 16, 2023
-- Synopsis:
--
-- procedure to assign apex violations to developers according to v_svt_stds_applications.default_developer
-- called by assign_violations
--
/*
begin
    svt_plsql_apex_audit_api.assign_from_default;
end;
*/
------------------------------------------------------------------------------
    procedure assign_from_default;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 12, 2023
-- Synopsis:
--
-- Procedure to assign apex violations to developers according to the apex audit columns
-- called by assign_violations
--
/*
begin
    svt_plsql_apex_audit_api.assign_from_apex_audit;
end;
*/
------------------------------------------------------------------------------
    procedure assign_from_apex_audit;
$if oracle_apex_version.c_loki_access $then
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 19, 2023
-- Synopsis:
--
-- Procedure to assign issue from loki tables
--
/*
BEGIN
    svt_plsql_apex_audit_api.assign_from_loki;
end;
*/
------------------------------------------------------------------------------
procedure assign_from_loki;
$end
------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: september 26, 2022
-- synopsis:
--
-- merge data into svt_plsql_apex_audit
/*
begin
 svt_ctx_util.set_review_schema (p_schema => svt_preferences.get('svt_default_schema'));
 svt_plsql_apex_audit_api.merge_audit_tbl(p_issue_category => 'APEX');
 commit;
end;
*/
------------------------------------------------------------------------------
    procedure merge_audit_tbl (p_application_id in svt_plsql_apex_audit.application_id%type default null,
                               p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                               p_test_code      in svt_stds_standard_tests.test_code%type default null,
                               p_legacy_yn      in svt_plsql_apex_audit.legacy_yn%type default 'N',
                               p_audit_id       in svt_plsql_apex_audit.id%type default null,
                               p_issue_category in svt_plsql_apex_audit.issue_category%type default null
                              );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- Procedure to delete stale issues from svt_plsql_apex_audit
--
/*
declare
t1 timestamp; 
t2 timestamp; 
l_deleted_count pls_integer;
begin
  t1 := systimestamp; 
  svt_plsql_apex_audit_api.delete_stale(p_deleted_count => l_deleted_count);
  if l_deleted_count > 0 then
      t2 := systimestamp; 
      apex_automation.log_info( p_message => 
                                apex_string.format( 'Deleted %0 violation(s) in %1 second(s)',
                                  p0=> l_deleted_count,
                                  p1 => extract( second from (t2-t1) )
                                )
                              );
  end if;
end;
*/
------------------------------------------------------------------------------
    procedure delete_stale (p_deleted_count out nocopy pls_integer);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- Procedure to delete issues associated with inactive apps, app types, tests or standards
--
/*
declare
t1 timestamp; 
t2 timestamp; 
l_deleted_count pls_integer;
begin
  t1 := systimestamp; 
  svt_plsql_apex_audit_api.delete_inactive(p_deleted_count => l_deleted_count);
  if l_deleted_count > 0 then
      t2 := systimestamp; 
      apex_automation.log_info( p_message => 
                                apex_string.format( 'Deleted %0 violation(s) in %1 second(s)',
                                  p0=> l_deleted_count,
                                  p1 => extract( second from (t2-t1) )
                                )
                              );
  end if;
end;
*/
------------------------------------------------------------------------------
    procedure delete_inactive (p_deleted_count out nocopy pls_integer);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- Procedure to delete a record of  svt_plsql_apex_audit
--
/*
begin
  svt_plsql_apex_audit_api.delete_audit (
              p_unqid                      => p_unqid,
              p_audit_id                   => p_audit_id,
              p_test_code                  => p_test_code,
              p_validation_failure_message => p_validation_failure_message
            );
end;
*/
------------------------------------------------------------------------------
  procedure delete_audit (
              p_unqid                      in svt_plsql_apex_audit.unqid%type,
              p_audit_id                   in svt_plsql_apex_audit.id%type,
              p_test_code                  in svt_plsql_apex_audit.test_code%type,
              p_validation_failure_message in svt_plsql_apex_audit.validation_failure_message%type,
              p_application_id             in svt_plsql_apex_audit.application_id%type,
              p_page_id                    in svt_plsql_apex_audit.page_id%type,
              p_component_id               in svt_plsql_apex_audit.component_id%type,
              p_assignee                   in svt_plsql_apex_audit.assignee%type,
              p_line                       in svt_plsql_apex_audit.line%type,
              p_object_name                in svt_plsql_apex_audit.object_name%type,
              p_object_type                in svt_plsql_apex_audit.object_type%type,
              p_code                       in svt_plsql_apex_audit.code%type,
              p_delete_reason              in varchar2);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 29, 2023
-- Synopsis:
--
-- Procedure to rerun tests for a given test code
--
/*
begin
    svt_plsql_apex_audit_api.refresh_for_test_code (p_test_code => p_test_code);
end;
*/
------------------------------------------------------------------------------
  procedure refresh_for_test_code (p_test_code in svt_plsql_apex_audit.test_code%type);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 2, 2023
-- Synopsis:
--
-- Overloaded procedure to get the parent apex audit columns for the assignee
--
/*
set serveroutput on
declare
l_component_id svt_plsql_apex_audit.component_id%type;
l_view_name    svt_component_types.component_name%type;
l_assignee     svt_plsql_apex_audit.assignee%type;
l_parent_view  svt_component_types.component_name%type;
l_query1       clob;
l_query2       clob; 
begin 
    select paa.component_id, act.component_name view_name
    into l_component_id, l_view_name
    from svt_plsql_apex_audit paa
    inner join svt_stds_standard_tests st on paa.test_code = st.test_code
    inner join svt_component_types act on act.id = st.svt_component_type_id
    where paa.issue_category = 'APEX'
    and paa.application_id = 17000033
    and paa.component_id is not null
    and paa.id = 3782539;
    dbms_output.put_line('l_component_id :'||l_component_id);
    dbms_output.put_line('l_view_name :'||l_view_name);
    svt_plsql_apex_audit_api.get_assignee_from_parent_apex_audit (
      p_component_id => l_component_id,
      p_view_name    => l_view_name,
      p_query1       => l_query1,
      p_query2       => l_query2,
      p_assignee     => l_assignee,
      p_parent_view  => l_parent_view
    );
    dbms_output.put_line('l_query1 :'||l_query1);
    dbms_output.put_line('l_query2 :'||l_query2);
    dbms_output.put_line('l_assignee :'||l_assignee);
    dbms_output.put_line('l_parent_view :'||l_parent_view);
end;
*/
------------------------------------------------------------------------------
  procedure get_assignee_from_parent_apex_audit (
      p_application_id in svt_plsql_apex_audit.application_id%type,
      p_component_id   in svt_plsql_apex_audit.component_id%type,
      p_view_name      in svt_component_types.component_name%type,
      p_query1         out nocopy clob,
      p_query2         out nocopy clob,
      p_assignee       out nocopy svt_plsql_apex_audit.assignee%type,
      p_parent_pk_id   out nocopy svt_plsql_apex_audit.component_id%type,
      p_parent_view    out nocopy svt_component_types.component_name%type
  );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 2, 2023
-- Synopsis:
--
-- Overloaded function to get the parent apex audit columns for the assignee
--
/*
select paa.component_id, 
       fdv.view_name,
       svt_plsql_apex_audit_api.get_assignee_from_parent_apex_audit (
            p_component_id => paa.component_id,
            p_view_name    => act.component_nameview_name
        ) assignee
from svt_plsql_apex_audit paa
inner join svt_stds_standard_tests st on paa.test_code = st.test_code
inner join svt_component_types act on act.id = st.svt_component_type_id
where paa.issue_category = 'APEX'
and paa.application_id = 17000033
and paa.component_id is not null
and paa.id = 3782539;
*/
------------------------------------------------------------------------------
  function get_assignee_from_parent_apex_audit (
    p_component_id   in svt_plsql_apex_audit.component_id%type,
    p_view_name      in svt_component_types.component_name%type,
    p_application_id in svt_plsql_apex_audit.application_id%type,
    p_page_id        in svt_plsql_apex_audit.page_id%type
  ) return svt_plsql_apex_audit.assignee%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 2, 2023
-- Synopsis:
--
-- Procedure to find an assignee in the apex audit component hierarchy
--
/*
begin
    svt_plsql_apex_audit_api.assign_from_apex_parent_audit;
end;
*/
------------------------------------------------------------------------------
  procedure assign_from_apex_parent_audit;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 3, 2023
-- Synopsis:
--
-- Re-runnign the violation assignment for apex audit (will null out existing assignments!)
--
/*
begin
    apex_session.create_session(p_app_id=>17000033,p_page_id=>1,p_username=>'HAYHUDSO');
    svt_plsql_apex_audit_api.rerun_assignment_w_apex_audits;
    commit;
end;
*/
------------------------------------------------------------------------------
  procedure rerun_assignment_w_apex_audits;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 3, 2023
-- Synopsis:
--
-- Procedure to turn a username into an email
--
/*
select svt_plsql_apex_audit_api.get_assignee_email (p_username => 'TIM')
from dual;
*/
------------------------------------------------------------------------------
  function get_assignee_email (p_username in svt_plsql_apex_audit.apex_last_updated_by%type)
  return svt_plsql_apex_audit.assignee%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 20, 2023
-- Synopsis:
--
-- Function to return the total number of unaddressed / open violations
--
/*
select svt_plsql_apex_audit_api.total_open_violations
from dual
*/
------------------------------------------------------------------------------
  function total_open_violations(
                  p_application_id in svt_plsql_apex_audit.application_id%type default null,
                  p_standard_id    in svt_stds_standards.id%type default null)
  return pls_integer;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 20, 2023
-- Synopsis:
--
-- Function to calculate the percentage of violations that has been solved  
--
/*
select svt_plsql_apex_audit_api.percent_solved
from dual
*/
------------------------------------------------------------------------------
  function percent_solved(p_application_id in svt_plsql_apex_audit.application_id%type default null,
                          p_standard_id    in svt_stds_standards.id%type default null)
  return number;
e_compilation_error    exception;
pragma exception_init(e_compilation_error,-24344);
e_dependent_error    exception;
pragma exception_init(e_dependent_error,-2311);
e_object_not_exist    exception;
pragma exception_init(e_object_not_exist,-4043);
e_timeout    exception;
pragma exception_init(e_timeout,-4021);
e_deadlock    exception;
pragma exception_init(e_deadlock,-60);
e_invalid_id    exception;
pragma exception_init(e_invalid_id,-904);
end SVT_PLSQL_APEX_AUDIT_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_PLSQL_REVIEW" authid current_user as
    ------------------------------------------------------------------------------
    --  Creator: Hayden Hudson
    --     Date: June 17, 2022
    -- Synopsis:
    --
    -- Pipelined function to list all programed issues and warnings for a given package
    --
    /*
    select issue_desc, object_type, line, code, check_type, urgency, object_name, reference_code
    from svt_plsql_review.issues(p_object_name   => 'svt_stds')
    order by urgency_level,  issue_desc, object_name, object_type, line, code
    */
    ------------------------------------------------------------------------------
    function issues (p_object_name             in user_plsql_object_settings.name%type default null,
                     p_object_type             in user_plsql_object_settings.type%type default null,
                     p_max_test_code_count     in number default null,
                     p_max_issue_count         in number default null,
                     p_file_dirname            in varchar2 default null
                    )
    return svt_db_plsql_issue_nt pipelined;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 4, 2023
-- Synopsis:
--
-- Function to query the db for an object_type for a object_name 
--
------------------------------------------------------------------------------
  function get_object_type (p_object_name in user_objects.object_name%type) 
  return user_objects.object_type%type;
end SVT_PLSQL_REVIEW;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_PREFERENCES" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_PREFERENCES
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes  
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Apr-3 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: April 3, 2023
-- Synopsis:
--
-- Generic function to retrieve preference values 
--
/*

Instructions : Set the values of these preference in the Admin section of the application (p36)
begin
    svt_audit_util.set_workspace;
end;
select svt_preferences.get('SVT_DEFAULT_SCHEMA') default_schema,
       svt_preferences.get('SVT_WORKSPACE') default_workspace,
       svt_preferences.get('SVT_DB_NAME') db_name,
       svt_preferences.get('SVT_EMAIL_API') email_api,
       svt_preferences.get('SVT_BASE_URL') base_url,
       svt_preferences.get('SVT_APEX_ISSUES_YN') apex_issues_yn,
       svt_preferences.get('SVT_SCM_YN') scm_yn,
       svt_preferences.get('SVT_FROM_EMAIL') from_email,
       svt_preferences.get('SVT_DEFAULT_ASSIGNEE') default_assignee,
       svt_preferences.get('SVT_SRC_EDIT_DELAY') src_edit_delay,
       svt_preferences.get('SVT_CLEANUP_DELAY') cleanup_delay,
       svt_preferences.get('SVT_REVIEW_SCHEMAS') review_schemas,
       svt_preferences.get('SVT_DO_NOT_ASSIGN') do_not_assign,
       svt_preferences.get('SVT_ADMIN_VERSION_YN') admin_vsn
from dual;
*/
------------------------------------------------------------------------------
function get(p_preference_name in apex_workspace_preferences.preference_name%type)
return apex_workspace_preferences.preference_value%type
result_cache;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: April 17, 2023
-- Synopsis:
--
-- Procedure to set preferences (done through app on p45) 
--
/*
begin
    apex_util.set_workspace('REDWOOD');
    apex_session.create_session(p_app_id=>17000033,p_page_id=>1,p_username=>'hayden.h.hudson@oracle.com');   
    svt_preferences.set_preference (p_preference_name  => 'SVT_DEFAULT_SCHEMA',
                                    p_value => 'REDWOOD'); 
end;
*/
------------------------------------------------------------------------------
procedure set_preference (p_preference_name in apex_workspace_preferences.preference_name%type,
                          p_value           in apex_workspace_preferences.preference_value%type);

end SVT_PREFERENCES;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STANDARDS_URGENCY_LEVEL_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STANDARDS_URGENCY_LEVEL_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-9 - created
---------------------------------------------------------------------------- 
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P50_ID := svt_standards_urgency_level_api.insert_ul (
                    p_urgency_level => :P50_URGENCY_LEVEL,
                    p_urgency_name  => :P50_URGENCY_NAME
                );
    when 'U' then
      svt_standards_urgency_level_api.update_ul(
            p_id            => :P50_ID,
            p_urgency_level => :P50_URGENCY_LEVEL,
            p_urgency_name  => :P50_URGENCY_NAME
        );
    when 'D' then
      svt_standards_urgency_level_api.delete_ul(p_id => :P50_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to insert records into SVT_STANDARDS_URGENCY_LEVEL
--
------------------------------------------------------------------------------
    function insert_ul (
        p_id            in svt_standards_urgency_level.id%type default null,
        p_urgency_level in svt_standards_urgency_level.urgency_level%type,
        p_urgency_name  in svt_standards_urgency_level.urgency_name%type
    ) return svt_standards_urgency_level.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to update records into SVT_STANDARDS_URGENCY_LEVEL
--
------------------------------------------------------------------------------
    procedure update_ul (
        p_id            in svt_standards_urgency_level.id%type,
        p_urgency_level in svt_standards_urgency_level.urgency_level%type,
        p_urgency_name  in svt_standards_urgency_level.urgency_name%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to delete records into SVT_STANDARDS_URGENCY_LEVEL
--
------------------------------------------------------------------------------
    procedure delete_ul (
        p_id in svt_standards_urgency_level.id%type
    );
end SVT_STANDARDS_URGENCY_LEVEL_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STANDARD_VIEW" authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_standard_view
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jan-24 - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 23, 2023
-- Synopsis:
--
-- pipeline function for v_svt_db_plsql
--
/*
select  object_name,
        object_type,
        line,
        code,
        unqid
from svt_standard_view.v_svt_db_plsql(
                        p_test_code     => 'IDENTIFIER_NAMING',
                        p_failures_only => 'Y'); 
*/
------------------------------------------------------------------------------
  function v_svt_db_plsql(p_test_code     in svt_stds_standard_tests.test_code%type,
                          p_failures_only in varchar2 default 'N',
                          p_object_name   in svt_plsql_apex_audit.object_name%type default null )
  return v_svt_db_plsql_ref_nt pipelined;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jan-25
-- Synopsis:
--
-- function to pipeline apex views
--
/*
select pass_yn,
       application_id,
       page_id,
       created_by,
       created_on,
       last_updated_by,
       last_updated_on,
       validation_failure_message,
       issue_title,
       test_code
from svt_standard_view.v_svt_apex(
                        p_test_code => 'APP_AUTH',
                        p_failures_only => 'Y'); 
*/
------------------------------------------------------------------------------
  function v_svt_apex(p_test_code            in svt_stds_standard_tests.test_code%type,
                      p_failures_only        in varchar2 default 'N',
                      p_production_apps_only in varchar2 default 'N',
                      p_application_id       in svt_plsql_apex_audit.application_id%type default null,
                      p_page_id              in svt_plsql_apex_audit.page_id%type default null)
  return v_svt_apex_nt pipelined;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jan-25
-- Synopsis:
--
-- function to pipeline view views
--
/*
select view_name
from svt_standard_view.v_svt_db_view__0(
                        p_test_code => 'VIEW_NAME'); 
*/
------------------------------------------------------------------------------
  function v_svt_db_view__0(p_test_code     in svt_stds_standard_tests.test_code%type,
                            p_failures_only in varchar2 default 'N')
  return v_svt_db_view__0_nt pipelined;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Feb-7
-- Synopsis:
--
-- function to pipeline table views
--
/*
select *
from svt_standard_view.v_svt_db_tbl__0(
                        p_test_code => 'fk_indexed'); 
*/
------------------------------------------------------------------------------
  function v_svt_db_tbl__0(p_test_code     in svt_stds_standard_tests.test_code%type,
                           p_failures_only in varchar2 default 'N')
  return v_svt_db_tbl__0_nt pipelined;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jan-25
-- Synopsis:
--
-- function to pipeline v_svt_plsql_apex_all
--
/*
select *
from svt_standard_view.v_svt(p_test_code => 'MISSING_COMMENT'); 
*/
------------------------------------------------------------------------------
  function v_svt(p_test_code            in svt_stds_standard_tests.test_code%type,
                 p_failures_only        in varchar2 default 'N',
                 p_urgent_only          in varchar2 default 'N',
                 p_production_apps_only in varchar2 default 'N',
                 p_unqid                in svt_plsql_apex_audit.unqid%type default null,
                 p_audit_id             in svt_plsql_apex_audit.id%type default null,
                 p_application_id       in svt_plsql_apex_audit.application_id%type default null,
                 p_page_id              in svt_plsql_apex_audit.page_id%type default null
                 )
  return v_svt_plsql_apex__0_nt pipelined;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- Function to determine if a given query clob will error when pipelined
--
/*
return svt_standard_view.query_feedback (
                p_query_code => :P14_QUERY_CLOB,
                p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID
              );
*/
------------------------------------------------------------------------------
  function query_feedback (p_query_code            in svt_stds_standard_tests.query_clob%type,
                           p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type)
  return varchar2;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- private function to return the id of a nest table type name
--
/*
select svt_standard_view.get_nt_type_id('v_svt_apex__0_nt')
from dual;
*/
------------------------------------------------------------------------------
  function get_nt_type_id (p_nt_name in svt_nested_table_types.nt_name%type) return svt_nested_table_types.id%type;
------------------------------------------------------------------------------
-- exceptions
------------------------------------------------------------------------------
   gc_missing_field constant number := -0904;
   e_missing_field exception;
   pragma exception_init(e_missing_field, gc_missing_field);
   gc_inconsistent_data_types constant number := -0932;
   e_inconsistent_data_types exception;
   pragma exception_init(e_inconsistent_data_types,gc_inconsistent_data_types);
   gc_table_or_view_does_not_exist constant number := -0942;
   e_table_or_view_does_not_exist exception;
   pragma exception_init(e_table_or_view_does_not_exist,gc_table_or_view_does_not_exist);
  --  gc_missing_expression constant number := -0936;
   e_missing_expression exception;
   pragma exception_init(e_missing_expression,-0936);
  --  gc_ambiguous_column constant number := -0918;
   e_ambiguous_column exception;
   pragma exception_init(e_ambiguous_column,-0918);
   e_buffer2small exception;
   pragma exception_init(e_buffer2small,-22835);
end SVT_STANDARD_VIEW;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS" authid definer is
    -------------------------------------------------------------------------
    -- Generates a unique Identifier
    -------------------------------------------------------------------------
    function gen_id return number;
    -------------------------------------------------------------------------
    -- Handle the process of registering the scheduled job.
    -------------------------------------------------------------------------
    procedure register_job;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- public function to convert a standard name into it's primary key
--
/*
select svt_stds.get_standard_id (p_standard_name => :P34_STANDARD_NAME)
from dual
*/
------------------------------------------------------------------------------
    function get_standard_id (p_standard_name in svt_stds_standards.standard_name%type) 
    return svt_stds_standards.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 16, 2023
-- Synopsis:
--
-- function to get svt_stds_standard_tests.mv_dependency for a given test code
--
/*
select svt_stds.get_mv_dependency(p_test_code => 'UNREACHABLE_PAGE') mv
from dual;
*/
------------------------------------------------------------------------------
    function get_mv_dependency(p_test_code in svt_stds_standard_tests.test_code%type) 
    return svt_stds_standard_tests.mv_dependency%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 19, 2023
-- Synopsis:
--
-- Function to determine whether to display the 'initialize standard' on p14 
--
/*
set serveroutput on
declare
l_boolean boolean;
begin
    l_boolean := svt_stds.display_initialize_button (
                    p_test_code     => :P14_TEST_CODE,
                    p_level_id      => :P14_LEVEL_ID
                );
    if l_boolean then 
        dbms_output.put_line('display');
    else 
        dbms_output.put_line('do not display');
    end if;
end;
*/
------------------------------------------------------------------------------
    function display_initialize_button (
        p_test_code     in svt_plsql_apex_audit.test_code%type,
        p_level_id      in svt_standards_urgency_level.id%type
    ) return boolean;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 4, 2023
-- Synopsis:
--
-- Function to determine whether or not to close the test modal (p14) 
--
/*
set serveroutput on
declare
l_boolean boolean;
begin
    l_boolean := svt_stds.close_test_modal (
                    p_request       => :REQUEST,
                    p_test_code     => :P14_TEST_CODE,
                    p_level_id      => :P14_LEVEL_ID
                );
    if l_boolean then 
        dbms_output.put_line('display');
    else 
        dbms_output.put_line('do not display');
    end if;
end;
*/
------------------------------------------------------------------------------
    function close_test_modal (p_request   in varchar2,
                               p_test_code in svt_plsql_apex_audit.test_code%type,
                               p_level_id  in svt_standards_urgency_level.id%type
    ) return boolean;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 2, 2023
-- Synopsis:
--
-- Convert the name of your standard into something that is compatible with a file / folder name
--
/*
select svt_stds.file_name('Idiosyncratic, workspace specific')
from dual
*/
------------------------------------------------------------------------------
    function file_name (p_standard_name in svt_stds_standards.standard_name%type)
    return svt_stds_standards.standard_name%type;
end svt_stds;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_APPLICATIONS_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_APPLICATIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-9 - created
---------------------------------------------------------------------------- 
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P161_PK_ID := svt_stds_applications_api.insert_app (
                    p_apex_app_id       => :P161_APEX_APP_ID,
                    p_default_developer => :P161_DEFAULT_DEVELOPER,
                    p_type_id           => :P161_TYPE_ID,
                    p_notes             => :P161_NOTES,
                    p_active_yn         => :P161_ACTIVE_YN
                );
    when 'U' then
      svt_stds_applications_api.update_app(
            p_id                => :P161_PK_ID,
            p_apex_app_id       => :P161_APEX_APP_ID,
            p_default_developer => :P161_DEFAULT_DEVELOPER,
            p_type_id           => :P161_TYPE_ID,
            p_notes             => :P161_NOTES,
            p_active_yn         => :P161_ACTIVE_YN
        );
    when 'D' then
      svt_stds_applications_api.delete_app(p_id => :P161_PK_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to insert records into SVT_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    function insert_app (
        p_id                in svt_stds_applications.pk_id%type default null,
        p_apex_app_id       in svt_stds_applications.apex_app_id%type,
        p_default_developer in svt_stds_applications.default_developer%type,
        p_type_id           in svt_stds_applications.type_id%type,
        p_notes             in svt_stds_applications.notes%type,
        p_active_yn         in svt_stds_applications.active_yn%type default 'Y'
    ) return svt_stds_applications.pk_id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to update records into SVT_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    procedure update_app (
        p_id                in svt_stds_applications.pk_id%type,
        p_apex_app_id       in svt_stds_applications.apex_app_id%type,
        p_default_developer in svt_stds_applications.default_developer%type,
        p_type_id           in svt_stds_applications.type_id%type,
        p_notes             in svt_stds_applications.notes%type,
        p_active_yn         in svt_stds_applications.active_yn%type default 'Y'
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to delete records into SVT_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    procedure delete_app (
        p_id in svt_stds_applications.pk_id%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 29, 2023
-- Synopsis:
--
-- Function to return the number of active, registered applications to scan
--
/*
select svt_stds_applications_api.active_app_count
from dual
*/
------------------------------------------------------------------------------
    function active_app_count return pls_integer;
end SVT_STDS_APPLICATIONS_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_DATA" authid definer is
    procedure load_initial_data;
    function is_initial_data_loaded return boolean;
    procedure load_sample_data;
    procedure remove_sample_data;
    -- function is_sample_data_loaded return boolean;
end svt_stds_data;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_INHERITED_TESTS_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_inherited_tests_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-17 - created
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
        svt_stds_inherited_tests_api.inherit_test (
            p_test_id            => :P79_TEST_ID,
            p_standard_id        => :P79_STANDARD_ID
        );
    when 'U' then
      svt_stds_inherited_tests_api.inherit_test (
            p_test_id            => :P79_TEST_ID,
            p_standard_id        => :P79_STANDARD_ID
        );
    when 'D' then
       svt_stds_inherited_tests_api.disinherit (
        p_test_id            => :P79_TEST_ID,
        p_standard_id        => :P79_STANDARD_ID
    );
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- procedure to add a record to svt_stds_inherited_tests
--
/*
declare
c_standard_id svt_stds_standards.id%type := 4064835866137640665977205961047451272;
l_parent_standard_id svt_stds_standards.parent_standard_id%type;
l_test_id svt_stds_standard_tests.id%type;
begin
    select parent_standard_id
    into l_parent_standard_id
    from  svt_stds_standards
    where id = c_standard_id;
    
    select id 
    into l_test_id
    from svt_stds_standard_tests
    where standard_id = l_parent_standard_id
    fetch first 1 rows only;
    
    svt_stds_inherited_tests_api.inherit_test (
        p_test_id            => l_test_id,
        p_standard_id        => c_standard_id
    );
end;
*/
------------------------------------------------------------------------------
procedure inherit_test (
    p_test_id            in svt_stds_inherited_tests.test_id%type,
    p_standard_id        in svt_stds_inherited_tests.standard_id%type);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure sever the relationship between a standard and a test from it's parent standard  
--
/*
begin
    svt_stds_inherited_tests_api.disinherit (
        p_test_id            => l_test_id,
        p_standard_id        => c_standard_id
    );
end;
*/
------------------------------------------------------------------------------
procedure disinherit (
    p_test_id            in svt_stds_inherited_tests.test_id%type,
    p_standard_id        in svt_stds_inherited_tests.standard_id%type);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to delete all records in svt_stds_inherited_tests for a given standard_id  
--
/*
begin
    svt_stds_inherited_tests_api.delete_std (p_standard_id => p_standard_id);
end;
*/
------------------------------------------------------------------------------
procedure delete_std (p_standard_id               in svt_stds_inherited_tests.standard_id%type,
                      p_former_parent_standard_id in svt_stds_inherited_tests.parent_standard_id%type default null);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Aug-21
-- Synopsis:
--
-- Procedure to delete all records for a given test_id  
--
/*
begin
    svt_stds_inherited_tests_api.delete_test (p_test_id => p_test_id);
end;
*/
------------------------------------------------------------------------------
procedure delete_test (p_test_id  in svt_stds_inherited_tests.test_id%type);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to add colon-delimited test_ids to svt_stds_inherited_tests
--
/*
begin
    svt_stds_inherited_tests_api.bulk_add(
                    p_test_ids    => :P65_SELECTED_IDS,
                    p_standard_id => :P65_STANDARD_ID
                );
end;
*/
------------------------------------------------------------------------------
procedure bulk_add(p_test_ids    in varchar2,
                   p_standard_id in svt_stds_inherited_tests.standard_id%type);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to remove colon-delimited test_ids to svt_stds_inherited_tests
--
/*
begin
    svt_stds_inherited_tests_api.bulk_remove(
                    p_test_ids    => :P65_SELECTED_IDS,
                    p_standard_id => :P65_STANDARD_ID
                );
end;
*/
------------------------------------------------------------------------------
procedure bulk_remove(p_test_ids    in varchar2,
                      p_standard_id in svt_stds_inherited_tests.standard_id%type);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 18, 2023
-- Synopsis:
--
-- Procedure to pass on every test from one standard to another 
--
/*
begin
    svt_stds_inherited_tests_api.inherit_all(
                      p_parent_standard_id => p_parent_standard_id,
                      p_standard_id        => p_standard_id
                    );
end;
*/
------------------------------------------------------------------------------
procedure inherit_all(p_parent_standard_id in svt_stds_inherited_tests.parent_standard_id%type,
                      p_standard_id        in svt_stds_inherited_tests.standard_id%type);
end svt_stds_inherited_tests_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_NOTIFICATIONS_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_NOTIFICATIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-10 - created
---------------------------------------------------------------------------- 
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P31_ID := svt_stds_notifications_api.insert_ntf (
                    p_notification_name        => :P31_NOTIFICATION_NAME,
                    p_notification_description => :P31_NOTIFICATION_DESCRIPTION,
                    p_notification_type        => :P31_NOTIFICATION_TYPE,
                    p_display_sequence         => :P31_DISPLAY_SEQUENCE,
                    p_display_from             => :P31_DISPLAY_FROM,
                    p_display_until            => :P31_DISPLAY_UNTIL
                );
    when 'U' then
      svt_stds_notifications_api.update_ntf(
            p_id                       => :P31_ID,
            p_notification_name        => :P31_NOTIFICATION_NAME,
            p_notification_description => :P31_NOTIFICATION_DESCRIPTION,
            p_notification_type        => :P31_NOTIFICATION_TYPE,
            p_display_sequence         => :P31_DISPLAY_SEQUENCE,
            p_display_from             => :P31_DISPLAY_FROM,
            p_display_until            => :P31_DISPLAY_UNTIL
        );
    when 'D' then
      svt_stds_notifications_api.delete_ntf(p_id => :P31_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to insert records into SVT_STDS_NOTIFICATIONS
--
------------------------------------------------------------------------------
    function insert_ntf (
       p_id                       in svt_stds_notifications.id%type default null,
       p_notification_name        in svt_stds_notifications.notification_name%type,
       p_notification_description in svt_stds_notifications.notification_description%type,
       p_notification_type        in svt_stds_notifications.notification_type%type,
       p_display_sequence         in svt_stds_notifications.display_sequence%type,
       p_display_from             in svt_stds_notifications.display_from%type,
       p_display_until            in svt_stds_notifications.display_until%type
    ) return svt_stds_notifications.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to update records into SVT_STDS_NOTIFICATIONS
--
------------------------------------------------------------------------------
    procedure update_ntf (
       p_id                       in svt_stds_notifications.id%type,
       p_notification_name        in svt_stds_notifications.notification_name%type,
       p_notification_description in svt_stds_notifications.notification_description%type,
       p_notification_type        in svt_stds_notifications.notification_type%type,
       p_display_sequence         in svt_stds_notifications.display_sequence%type,
       p_display_from             in svt_stds_notifications.display_from%type,
       p_display_until            in svt_stds_notifications.display_until%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to delete records into SVT_STDS_NOTIFICATIONS
--
------------------------------------------------------------------------------
    procedure delete_ntf (
        p_id in svt_stds_notifications.id%type
    );
end SVT_STDS_NOTIFICATIONS_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_PARSER" authid definer as
    -- g_collection constant varchar2(255):= 'SVT_STDS_PARSER';
    -- g_false_neg  constant varchar2(31) := 'FALSE_NEGATIVE';
    -- g_legacy     constant varchar2(31) := 'LEGACY';
    -- g_ticket     constant varchar2(31) := 'TICKET';
    -- g_dummy_name constant svt_stds_standard_tests.test_name%type := 'DUMMY';
    -- function view_sql (p_view_name in user_views.view_name%type,
    --                    p_owner     in all_views.owner%type default null) return clob;
    
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 25, 2023
-- Synopsis:
--
-- function to replace build_link using svt_component_types.template_url/component_type_id 
-- see p8000 in app 4000 and f4000_searchResults.js
/*
'<button type="button" class="a-Button edit-button" data-link="' ||
       wwv_flow_utilities.prepare_url( link_url ) || '"' ||
       case when component_type_id is not null then
         ' data-appid="'       || flow_id || '"' ||
         ' data-pageid="'      || page_id || '"' ||
         ' data-typeid="'      || component_type_id || '"' ||
         ' data-componentid="' || component_id || '"'
       end ||
       '>' || apex_lang.message( 'VIEW_IN_BUILDER' ) || '</button>' as view_button
*/
/*
select audit_id, test_id,
       svt_stds_parser.build_url(
                        p_svt_component_type_id => svt_component_type_id,
                        p_app_id                => application_id,
                        p_page_id               => page_id,
                        p_pk_value              => component_id,
                        p_parent_pk_value       => parent_component_id,
                        p_builder_session       => v('APX_BLDR_SESSION')
       ) the_url
from v_svt_plsql_apex_audit
where audit_id = 78318
*/
------------------------------------------------------------------------------
    function build_url( p_template_url          in svt_component_types.template_url%type,
                        p_app_id                in svt_plsql_apex_audit.application_id%type,
                        p_page_id               in svt_plsql_apex_audit.page_id%type,
                        p_pk_value              in svt_plsql_apex_audit.component_id%type,
                        p_parent_pk_value       in svt_plsql_apex_audit.object_name%type,
                        p_issue_category        in svt_plsql_apex_audit.issue_category%type,
                        p_opt_parent_pk_value   in svt_plsql_apex_audit.object_type%type default null,
                        p_line                  in svt_plsql_apex_audit.line%type default null, 
                        p_object_name           in svt_plsql_apex_audit.object_name%type default null,
                        p_object_type           in svt_plsql_apex_audit.object_type%type default null,
                        p_schema                in svt_plsql_apex_audit.owner%type default null,
                        p_builder_session       in number default null
                        )
    return varchar2 deterministic result_cache;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 26, 2023
-- Synopsis:
--
-- Procedure to retrieve key values about component types 
--
/*
set serveroutput on
declare
l_component_name    svt_component_types.component_name%type;
l_component_type_id svt_component_types.component_type_id%type;
l_template_url      svt_component_types.template_url%type;
begin
    svt_stds_parser.get_component_type_rec (
                        p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID, --11
                        p_component_name        => l_component_name,
                        p_component_type_id     => l_component_type_id,
                        p_template_url          => l_template_url
                    );
    dbms_output.put_line('l_component_name :'||l_component_name);
    dbms_output.put_line('l_component_type_id :'||l_component_type_id);
    dbms_output.put_line('l_template_url :'||l_template_url);
end;
*/
------------------------------------------------------------------------------
    procedure get_component_type_rec (
                        p_svt_component_type_id in svt_component_types.id%type,
                        p_component_name        out nocopy svt_component_types.component_name%type,
                        p_component_type_id     out nocopy svt_component_types.component_type_id%type,
                        p_template_url          out nocopy svt_component_types.template_url%type
                    ) deterministic;
    -- procedure add_applications;
    -- function default_app_id  
    --     return apex_applications.application_id%type deterministic;
    -- function accessibility_app_id
    --     return apex_applications.application_id%type deterministic;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 25, 2023
-- Synopsis:
--
-- Function to determine whether a given url is valid. Used by the 'val_button_links' test, for eg
--
------------------------------------------------------------------------------
    function is_valid_url (p_origin_app_id in apex_applications.application_id%type,
                           p_url in varchar2) 
        return varchar2 deterministic;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 25, 2023
-- Synopsis:
--
-- Function to extract the app_id from a url, used by all the mv views (mv_svt_buttons for eg)  
--
------------------------------------------------------------------------------
    function app_from_url ( p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return  apex_applications.application_id%type deterministic;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 24, 2023
-- Synopsis:
--
-- function to extract the page_id from a url  
--
/*
select svt_stds_parser.page_from_url(p_origin_app_id => application_id,
                                     p_url => home_link)
from apex_applications
*/
------------------------------------------------------------------------------
    function page_from_url (p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return apex_application_pages.page_id%type deterministic;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- function to id whether or not it is being called from a builder session
--
/*
set serveroutput on
declare
l_boolean boolean;
l_override_value number := 123123123;
begin
    l_boolean := svt_stds_parser.is_logged_into_builder(l_override_value);
    if l_boolean then 
        dbms_output.put_line('logged in');
    else 
        dbms_output.put_line('not logged in');
    end if;
end;
*/
------------------------------------------------------------------------------
    function is_logged_into_builder (p_override_value in number default null) return boolean;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- Procedure to determine if a given application is in the same workspace as the Application Standard Tracker
--
/*
declare
l_boolean boolean
begin
    l_boolean := svt_stds_parser.app_in_current_workspace(100);
end;
*/
------------------------------------------------------------------------------
    function app_in_current_workspace (p_app_id in apex_applications.application_id%type) 
    return boolean;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 30, 2023
-- Synopsis:
--
-- Function to return a default query, given an svt_component_type_id
--
/*
select svt_stds_parser.seed_default_query(p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID) stmt
from dual
*/
------------------------------------------------------------------------------
    function seed_default_query(p_svt_component_type_id in svt_component_types.id%type)
    return varchar2;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 23, 2023
-- Synopsis:
--
-- Function to convert a url to friendly as appropriate 
--
/*
select svt_stds_parser.adapt_url()
from dual
*/
------------------------------------------------------------------------------
    function adapt_url (p_template_url in svt_component_types.template_url%type)
    return svt_component_types.template_url%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- Function to return the base url for an apex workspace
--
/*
select svt_stds_parser.get_base_url()
from dual;
*/
------------------------------------------------------------------------------
    function get_base_url return varchar2 deterministic;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 24, 2023
-- Synopsis:
--
-- Function to determine whether or not an HTML block is valid
--
/*
    select svt_stds_parser.valid_html_yn('<b>hello</b>') valid_yn
    from dual;
*/
------------------------------------------------------------------------------
    function valid_html_yn (p_html in clob) 
    return varchar2
    deterministic;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 2, 2023
-- Synopsis:
--
-- Function to determine whether a given column exists in a given table 
/*
set serveroutput on
declare
l_bool boolean;
begin
    l_bool := svt_stds_parser.column_exists 
                    (p_column_name => 'UPDATED_BY',
                     p_table_name => 'APEX_APPLICATION_PAGE_REGIONS'
                    );
    if l_bool then 
        dbms_output.put_line('column exists');
    else 
        dbms_output.put_line('column does not exist');
    end if;
end;
*/
------------------------------------------------------------------------------
    function column_exists (p_column_name in all_tab_cols.column_name%type,
                            p_table_name  in all_tab_cols.table_name%type) 
    return boolean;
    e_subscript_beyond_count exception;
    pragma exception_init(e_subscript_beyond_count, -6533);
    e_not_a_number exception;
    pragma exception_init(e_not_a_number, -6502);
    e_number_conversion exception;
    pragma exception_init(e_number_conversion, -1722);
    e_table_not_exist exception;
    pragma exception_init(e_table_not_exist, -942);
    e_invalid_object exception;
    pragma exception_init(e_invalid_object, -44002);
end svt_stds_parser;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_STANDARDS_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_standards_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-17 - created
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P11_ID := svt_stds_standards_api.insert_std (
                p_standard_name         => :P11_STANDARD_NAME,
                p_description           => :P11_DESCRIPTION,
                p_primary_developer     => :P11_PRIMARY_DEVELOPER,
                p_implementation        => :P11_IMPLEMENTATION,
                p_date_started          => :P11_DATE_STARTED,
                p_standard_group        => :P11_STANDARD_GROUP,
                p_active_yn             => :P11_ACTIVE_YN,
                p_compatibility_mode_id => :P11_COMPATIBILITY_MODE_ID,
                p_parent_standard_id    => :P11_PARENT_STANDARD_ID
        );
    when 'U' then
       svt_stds_standards_api.updated_std (
            p_id                    => :P11_ID,
            p_standard_name         => :P11_STANDARD_NAME,
            p_description           => :P11_DESCRIPTION,
            p_primary_developer     => :P11_PRIMARY_DEVELOPER,
            p_implementation        => :P11_IMPLEMENTATION,
            p_date_started          => :P11_DATE_STARTED,
            p_standard_group        => :P11_STANDARD_GROUP,
            p_active_yn             => :P11_ACTIVE_YN,
            p_compatibility_mode_id => :P11_COMPATIBILITY_MODE_ID,
            p_parent_standard_id    => :P11_PARENT_STANDARD_ID
        );
    when 'D' then
      svt_stds_standards_api.delete_std(p_standard_id => :P11_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- function to created a record
--
/*
begin
    :P11_ID := svt_stds_standards_api.insert_std (
                p_standard_name         => :P11_STANDARD_NAME,
                p_description           => :P11_DESCRIPTION,
                p_primary_developer     => :P11_PRIMARY_DEVELOPER,
                p_implementation        => :P11_IMPLEMENTATION,
                p_date_started          => :P11_DATE_STARTED,
                p_standard_group        => :P11_STANDARD_GROUP,
                p_active_yn             => :P11_ACTIVE_YN,
                p_compatibility_mode_id => :P11_COMPATIBILITY_MODE_ID,
                p_parent_standard_id    => :P11_PARENT_STANDARD_ID
    );
end;
*/
------------------------------------------------------------------------------
function insert_std (
    p_standard_name         in svt_stds_standards.standard_name%type,
    p_description           in svt_stds_standards.description%type,
    p_primary_developer     in svt_stds_standards.primary_developer%type,
    p_implementation        in svt_stds_standards.implementation%type,
    p_date_started          in svt_stds_standards.date_started%type,
    p_standard_group        in svt_stds_standards.standard_group%type,
    p_active_yn             in svt_stds_standards.active_yn%type,
    p_compatibility_mode_id in svt_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in svt_stds_standards.parent_standard_id%type
) return svt_stds_standards.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to update a record
--
/*
begin
    svt_stds_standards_api.updated_std (
        p_id                    => :P11_ID,
        p_standard_name         => :P11_STANDARD_NAME,
        p_description           => :P11_DESCRIPTION,
        p_primary_developer     => :P11_PRIMARY_DEVELOPER,
        p_implementation        => :P11_IMPLEMENTATION,
        p_date_started          => :P11_DATE_STARTED,
        p_standard_group        => :P11_STANDARD_GROUP,
        p_active_yn             => :P11_ACTIVE_YN,
        p_compatibility_mode_id => :P11_COMPATIBILITY_MODE_ID,
        p_parent_standard_id    => :P11_PARENT_STANDARD_ID
    );
end;
*/
------------------------------------------------------------------------------
procedure updated_std (
    p_id                    in svt_stds_standards.id%type,
    p_standard_name         in svt_stds_standards.standard_name%type,
    p_description           in svt_stds_standards.description%type,
    p_primary_developer     in svt_stds_standards.primary_developer%type,
    p_implementation        in svt_stds_standards.implementation%type,
    p_date_started          in svt_stds_standards.date_started%type,
    p_standard_group        in svt_stds_standards.standard_group%type,
    p_active_yn             in svt_stds_standards.active_yn%type,
    p_compatibility_mode_id in svt_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in svt_stds_standards.parent_standard_id%type
);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- function to retrieve a row of svt_stds_standards for a given standard id.  
--
/*
set serveroutput on
declare
l_rec svt_stds_standards%rowtype;
begin
    l_rec := svt_stds_standards_api.get_rec (p_standard_id => 1);
    dbms_output.put_line('standard name :'||l_rec.standard_name);
end;
*/
------------------------------------------------------------------------------
    function get_rec (p_standard_id in svt_stds_standards.id%type)
    return svt_stds_standards%rowtype;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to delete a standard 
--
/*
begin
    svt_stds_standards_api.delete_std(p_standard_id => :P11_ID);
end;
*/
------------------------------------------------------------------------------
    procedure delete_std (p_standard_id in svt_stds_standards.id%type);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 18, 2023
-- Synopsis:
--
-- Function to get the full name (including compatibility description) for a given standard_id 
--
/*
    select svt_stds_standards_api.get_full_name(p_standard_id => 1) fname
    from dual;
*/
------------------------------------------------------------------------------
    function get_full_name (p_standard_id in svt_stds_standards.id%type)
    return svt_stds_standards.standard_name%type
    deterministic;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 9, 2023
-- Synopsis:
--
-- procedure to update svt_stds_standard_tests.avg_exctn_scnds from v_svt_test_timing
--
/*
begin
    svt_stds_standards_api.update_test_avg_time;
end;
*/
------------------------------------------------------------------------------
    procedure update_test_avg_time;
  
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 20, 2023
-- Synopsis:
--
-- Function to return a random but deterministic hex color for a given standard
--
/*
select svt_stds_standards_api.hex_color(p_standard_id => 1) hex
from dual
*/
------------------------------------------------------------------------------
  function hex_color(p_standard_id in svt_stds_standards.id%type)
  return varchar2
  deterministic 
  result_cache;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Function to return the count of active standards
--
/*
select svt_stds_standards_api.active_standard_count
from dual
*/
------------------------------------------------------------------------------
  function active_standard_count return pls_integer;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Function to return a comma separated list of active standards
--
/*
select svt_stds_standards_api.active_standard_list
from dual
*/
------------------------------------------------------------------------------
    function active_standard_list return varchar2;
end svt_stds_standards_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_STANDARD_TESTS_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_standard_tests_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P14_ID := svt_stds_standard_tests_api.insert_test(
                  p_id                    => :P14_ID,
                  p_standard_id           => :P14_STANDARD_ID,
                  p_test_name             => :P14_SHORT_NAME,
                  p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                  p_query_clob            => :P14_QUERY_CLOB,
                  p_test_code             => :P14_TEST_CODE,
                  p_active_yn             => :P14_ACTIVE_YN,
                  p_level_id              => :P14_LEVEL_ID,
                  p_mv_dependency         => :P14_MV_DEPENDENCY,
                  p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID,
                  p_explanation           => :P14_EXPLANATION,
                  p_fix                   => :P14_FIX
                );
    when 'U' then
      svt_stds_standard_tests_api.update_test(
                          p_id                    => :P14_ID,
                          p_standard_id           => :P14_STANDARD_ID,
                          p_test_name             => :P14_SHORT_NAME,
                          p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                          p_query_clob            => :P14_QUERY_CLOB,
                          p_test_code             => :P14_TEST_CODE,
                          p_active_yn             => :P14_ACTIVE_YN,
                          p_level_id              => :P14_LEVEL_ID,
                          p_mv_dependency         => :P14_MV_DEPENDENCY,
                          p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID,
                          p_explanation           => :P14_EXPLANATION,
                          p_fix                   => :P14_FIX
                        );
    when 'D' then
      svt_stds_standard_tests_api.delete_test(p_id => :P14_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jul-10
-- Synopsis:
--
-- Procedure to insert new record into  svt_stds_standard_tests
--
/*
declare 
l_id svt_stds_standard_tests.id%type;
begin
    l_id := svt_stds_standard_tests_api.insert_test(
                p_standard_id           => p_standard_id,
                p_test_name             => p_test_name,
                p_display_sequence      => p_display_sequence,
                p_query_clob            => p_query_clob,
                p_test_code             => p_test_code,
                p_active_yn             => p_active_yn,
                p_level_id              => p_level_id,
                p_mv_dependency         => p_mv_dependency,
                p_svt_component_type_id => p_svt_component_type_id,
                p_explanation           => p_explanation,
                p_fix                   => p_fix
              );
end;
*/
------------------------------------------------------------------------------
  function insert_test(p_id                    in svt_stds_standard_tests.id%type default null,
                       p_standard_id           in svt_stds_standard_tests.standard_id%type,
                       p_test_name             in svt_stds_standard_tests.test_name%type,
                       p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                       p_query_clob            in svt_stds_standard_tests.query_clob%type,
                       p_owner                 in svt_stds_standard_tests.owner%type default null,
                       p_test_code             in svt_stds_standard_tests.test_code%type,
                       p_active_yn             in svt_stds_standard_tests.active_yn%type,
                       p_level_id              in svt_stds_standard_tests.level_id%type,
                       p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                       p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                       p_explanation           in svt_stds_standard_tests.explanation%type,
                       p_fix                   in svt_stds_standard_tests.fix%type,
                       p_version_number        in svt_stds_standard_tests.version_number%type default null,
                       p_version_db            in svt_stds_standard_tests.version_db%type default null
                       )
  return svt_stds_standard_tests.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- Procedure to insert new record into  svt_stds_standard_tests (called by SVT_STDS_TESTS_LIB_API.install_standard_test)
--
/*
begin
    svt_stds_standard_tests_api.insert_test(
                p_id                    => p_id,
                p_standard_id           => p_standard_id,
                p_test_name             => p_test_name,
                p_display_sequence      => p_display_sequence,
                p_query_clob            => p_query_clob,
                p_test_code             => p_test_code,
                p_active_yn             => p_active_yn,
                p_level_id              => p_level_id,
                p_mv_dependency         => p_mv_dependency,
                p_svt_component_type_id => p_svt_component_type_id);
end;
*/
------------------------------------------------------------------------------
  procedure insert_test(p_id                    in svt_stds_standard_tests.id%type default null,
                        p_standard_id           in svt_stds_standard_tests.standard_id%type,
                        p_test_name             in svt_stds_standard_tests.test_name%type,
                        p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                        p_query_clob            in svt_stds_standard_tests.query_clob%type,
                        p_owner                 in svt_stds_standard_tests.owner%type default null,
                        p_test_code             in svt_stds_standard_tests.test_code%type,
                        p_active_yn             in svt_stds_standard_tests.active_yn%type,
                        p_level_id              in svt_stds_standard_tests.level_id%type,
                        p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                        p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                        p_explanation           in svt_stds_standard_tests.explanation%type,
                        p_fix                   in svt_stds_standard_tests.fix%type,
                        p_version_number        in svt_stds_standard_tests.version_number%type default null,
                        p_version_db            in svt_stds_standard_tests.version_db%type default null
                      );
  
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 13, 2023
-- Synopsis:
--
-- function to get md5 for a record of svt_stds_standard_tests
--
/*
select svt_stds_standard_tests_api.build_test_md5 (
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
from svt_stds_standard_tests esst;
*/
------------------------------------------------------------------------------
  function build_test_md5 (
      p_test_name             in svt_stds_standard_tests.test_name%type,
      p_query_clob            in svt_stds_standard_tests.query_clob%type,
      p_test_code             in svt_stds_standard_tests.test_code%type,
      p_level_id              in svt_stds_standard_tests.level_id%type,
      p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
      p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
      p_explanation           in svt_stds_standard_tests.explanation%type,
      p_fix                   in svt_stds_standard_tests.fix%type,
      p_version_number        in svt_stds_standard_tests.version_number%type,
      p_version_db            in svt_stds_standard_tests.version_db%type
  ) return varchar2 deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Procedure to update svt_stds_standard_tests
--
/*
begin
  svt_stds_standard_tests_api.update_test(
                          p_id                    => :P14_ID,
                          p_standard_id           => :P14_STANDARD_ID,
                          p_test_name             => :P14_TEST_NAME,
                          p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                          p_query_clob            => :P14_QUERY_CLOB,
                          p_test_code             => :P14_TEST_CODE,
                          p_active_yn             => :P14_ACTIVE_YN,
                          p_level_id              => :P14_LEVEL_ID,
                          p_mv_dependency         => :P14_MV_DEPENDENCY,
                          p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID,
                          p_explanation           => :P14_EXPLANATION,
                          p_fix                   => :P14_FIX,
                          p_version_number        => :P14_VERSION_NUMBER
                        );
end;
*/
------------------------------------------------------------------------------
    procedure update_test(p_id                    in svt_stds_standard_tests.id%type default null,
                          p_standard_id           in svt_stds_standard_tests.standard_id%type,
                          p_test_name             in svt_stds_standard_tests.test_name%type,
                          p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                          p_query_clob            in svt_stds_standard_tests.query_clob%type,
                          p_owner                 in svt_stds_standard_tests.owner%type default null,
                          p_test_code             in svt_stds_standard_tests.test_code%type,
                          p_active_yn             in svt_stds_standard_tests.active_yn%type,
                          p_level_id              in svt_stds_standard_tests.level_id%type,
                          p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                          p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                          p_explanation           in svt_stds_standard_tests.explanation%type,
                          p_fix                   in svt_stds_standard_tests.fix%type,
                          p_version_number        in svt_stds_standard_tests.version_number%type default null,
                          p_version_db            in svt_stds_standard_tests.version_db%type default null
                        );
    

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 13, 2023
-- Synopsis:
--
-- Publish a given svt_stds_standard_tests record 
--
/*
begin
  svt_stds_standard_tests_api.publish_test(p_test_code => :P14_TEST_CODE);
end;
*/
------------------------------------------------------------------------------
    procedure publish_test(p_test_code in svt_stds_standard_tests.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 16, 2023
-- Synopsis:
--
-- Procedure to publish tests in bulk
--
/*
begin
  svt_stds_standard_tests_api.bulk_publish(p_selected_ids => :P5_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
    procedure bulk_publish(p_selected_ids in varchar2);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Oct-31
-- Synopsis:
--
-- Procedure to inactivate tests in bulk
--
/*
begin
  svt_stds_standard_tests_api.bulk_inactivate(p_selected_ids => :P5_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
    procedure bulk_inactivate(p_selected_ids in varchar2);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-15
-- Synopsis:
--
-- Procedure to delete tests in bulk
--
/*
begin
  svt_stds_standard_tests_api.bulk_delete(p_selected_ids => :P5_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
    procedure bulk_delete(p_selected_ids in varchar2);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Oct-31
-- Synopsis:
--
-- Procedure to activate tests in bulk
--
/*
begin
  svt_stds_standard_tests_api.bulk_activate(p_selected_ids => :P5_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
    procedure bulk_activate(p_selected_ids in varchar2);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Procedure to delete test
--
/*
begin
  svt_stds_standard_tests_api.delete_test(p_id => :P14_ID,
                                          p_test_code => :P14_TEST_CODE);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test(p_id        in svt_stds_standard_tests.id%type,
                          p_test_code in svt_stds_standard_tests.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 16, 2023
-- Synopsis:
--
-- overloaded function to get svt_stds_standard_tests record for a given test code
--
/*
set serveroutput on;
declare
l_rec svt_stds_standard_tests%rowtype;
begin
    l_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => 'UNREACHABLE_PAGE');
    dbms_output.put_line('code :'||l_rec.test_code);
end;
*/
------------------------------------------------------------------------------
    function get_test_rec(p_test_code in svt_stds_standard_tests.test_code%type) 
    return svt_stds_standard_tests%rowtype;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Aug-17
-- Synopsis:
--
-- overloaded function to get svt_stds_standard_tests record for a given test id
--
/*
set serveroutput on;
declare
l_rec svt_stds_standard_tests%rowtype;
begin
    l_rec := svt_stds_standard_tests_api.get_test_rec(p_test_id => :p_test_id);
    dbms_output.put_line('code :'||l_rec.test_code);
end;
*/
------------------------------------------------------------------------------
    function get_test_rec(p_test_id in svt_stds_standard_tests.id%type) 
    return svt_stds_standard_tests%rowtype;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 31, 2023
-- Synopsis:
--
-- Function to duplicate a standard (p14) 
--
/*
begin
  svt_stds_standard_tests_api.duplicate_standard (
                                    p_from_test_code  => :P16_FROM_TEST_CODE,
                                    p_to_test_code    => :P16_TO_TEST_CODE
                                );
end;
*/
------------------------------------------------------------------------------
  procedure duplicate_standard (
                                    p_from_test_code in svt_stds_standard_tests.test_code%type,
                                    p_to_test_code   in svt_stds_standard_tests.test_code%type
                                );


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 2, 2023
-- Synopsis:
--
-- Function to get the pk of a svt_stds_standard_tests record, given a test code
--
/*
select svt_stds_standard_tests_api.get_test_id (p_test_code => :P14_TEST_CODE)
from dual
*/
------------------------------------------------------------------------------
    function get_test_id (p_test_code in svt_stds_standard_tests.test_code%type)
    return svt_stds_standard_tests.id%type deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Aug-17
-- Synopsis:
--
-- Overloaded Function to get the standard_id of a svt_stds_standard_tests record, given a test id
--
/*
select svt_stds_standard_tests_api.get_standard_id (p_test_id => :p_test_id)
from dual
*/
------------------------------------------------------------------------------
    function get_standard_id (p_test_id in svt_stds_standard_tests.id%type)
    return svt_stds_standard_tests.standard_id%type deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-1
--
-- OVerloaded Function to get the standard_id of a svt_stds_standard_tests record, given a test code
--
/*
select svt_stds_standard_tests_api.get_standard_id (p_test_code => :p_test_code)
from dual
*/
------------------------------------------------------------------------------
    function get_standard_id (p_test_code in svt_stds_standard_tests.test_code%type)
    return svt_stds_standard_tests.standard_id%type deterministic;

 
 ------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Function to query the V_SVT_STDS_STANDARD_TESTS view with some additional columns
-- namely the download test sample file
--
/*
select *
from svt_stds_standard_tests_api.v_svt_stds_standard_tests()
*/
------------------------------------------------------------------------------
  function v_svt_stds_standard_tests (
                     p_standard_id        in svt_stds_standard_tests.standard_id%type default null,
                     p_active_yn          in svt_stds_standard_tests.active_yn%type default null,
                     p_published_yn       in varchar2 default null,
                     p_standard_active_yn in varchar2 default null,
                     p_issue_category     in svt_nested_table_types.nt_name%type default null,
                     p_inherited_yn       in varchar2 default null
              )
  return v_svt_stds_standard_tests_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- Synopsis:
--
-- function to retrieve the nt_name for a given test_code
--
/*
select svt_stds_standard_tests_api.nt_name(p_test_code => 'APP_AUTH')
from dual
*/
------------------------------------------------------------------------------
  function nt_name(p_test_code in svt_stds_standard_tests.test_code%type)
  return svt_nested_table_types.nt_name%type
  deterministic 
  result_cache;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Function to return the count of active tests
--
/*
select svt_stds_standard_tests_api.active_test_count
from dual
*/
------------------------------------------------------------------------------
  function active_test_count (
              p_published_yn   in varchar2 default null,
              p_issue_category in svt_nested_table_types.object_type%type default null) 
  return pls_integer;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Function to return whether or not there are active tests (more performant than active_test_count)
--
/*
select svt_stds_standard_tests_api.active_tests_yn
from dual
*/
------------------------------------------------------------------------------
  function active_tests_yn (
              p_issue_category in svt_nested_table_types.object_type%type default null) 
  return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 4, 2023
-- Synopsis:
--
-- Procedure to download a json file of a given test  
--
/*
begin
  svt_stds_standard_tests_api.get_test_file(p_test_code => 'ACC_AUTOCOMPLETE');
end;
*/
------------------------------------------------------------------------------
  procedure get_test_file(p_test_code in svt_stds_standard_tests.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 4, 2023
-- Synopsis:
--
-- function to return the url to download a test code json file 
--
/*
select svt_stds_standard_tests_api.get_test_file_url (
            p_page_id => :APP_PAGE_ID,
            p_test_code => :P14_TEST_CODE) the_url
from dual
*/
------------------------------------------------------------------------------
  function get_test_file_url (
              p_page_id   in apex_application_pages.page_id%type,
              p_test_code in svt_stds_standard_tests.test_code%type)
  return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 8, 2023
-- Synopsis:
--
-- Function to get the md5 of the current record for a given test_code 
--
/*
select svt_stds_standard_tests_api.current_md5
from dual;
*/
------------------------------------------------------------------------------
  function current_md5(p_test_code in svt_stds_standard_tests.test_code%type)
  return varchar2;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 8, 2023
-- Synopsis:
--
-- Function to answer whether a given test has been published in the current instance
--
/*
svt_audit_util.set_workspace;

select svt_stds_standard_tests_api.test_published_locally_yn (p_test_code => 'ACC_AUTOCOMPLETE') answ
from dual
*/
------------------------------------------------------------------------------
  function test_published_locally_yn (p_test_code in svt_stds_standard_tests.test_code%type)
  return varchar2;

end svt_stds_standard_tests_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_TESTS_LIB_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_TESTS_LIB_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-8 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 8, 2023
-- Synopsis:
--
-- Procedure to insert / update / merge a record into svt_stds_tests_lib
--
/*
begin
    svt_stds_tests_lib_api.upsert (
        p_standard_id           => p_standard_id,
        p_test_name             => p_test_name,
        p_test_id               => p_test_id,
        p_query_clob            => p_query_clob,
        p_test_code             => p_test_code,
        p_active_yn             => p_active_yn,
        p_mv_dependency         => p_mv_dependency,
        p_svt_component_type_id => p_svt_component_type_id,
        p_explanation           => p_explanation,
        p_fix                   => p_fix,
        p_level_id              => p_level_id,
        p_version_number        => p_version_number
    );
end;
*/
------------------------------------------------------------------------------
    procedure upsert (
        p_standard_id           in svt_stds_tests_lib.standard_id%type,
        p_test_name             in svt_stds_tests_lib.test_name%type,
        p_test_id               in svt_stds_tests_lib.test_id%type,
        p_query_clob            in svt_stds_tests_lib.query_clob%type,
        p_test_code             in svt_stds_tests_lib.test_code%type,
        p_active_yn             in svt_stds_tests_lib.active_yn%type,
        p_mv_dependency         in svt_stds_tests_lib.mv_dependency%type,
        p_svt_component_type_id in svt_stds_tests_lib.svt_component_type_id%type,
        p_explanation           in svt_stds_tests_lib.explanation%type,
        p_fix                   in svt_stds_tests_lib.fix%type,
        p_level_id              in svt_stds_tests_lib.level_id%type,
        p_version_number        in svt_stds_tests_lib.version_number%type,
        p_version_db            in svt_stds_tests_lib.version_db%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 8, 2023
-- Synopsis:
--
-- Procedure to load current standards tests
--
/*
begin
    svt_stds_tests_lib_api.take_snapshot;
    commit;
end;
*/
------------------------------------------------------------------------------
    -- procedure take_snapshot;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- Procedure to insert from svt_stds_tests_lib into svt_stds_standard_tests
--
/*
begin
    svt_stds_tests_lib_api.install_standard_test(
                        p_id => :P60_ID,
                        p_urgency_level_id =>  :P60_URGENCY_LEVEL_ID);
end;
*/
------------------------------------------------------------------------------
    procedure install_standard_test(p_id               in svt_stds_tests_lib.id%type,
                                    p_standard_id      in svt_stds_standard_tests.standard_id%type,
                                    p_urgency_level_id in svt_stds_standard_tests.level_id%type
                                    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 17, 2023
-- Synopsis:
--
-- Procedure to install all the tests for a given standard
--
/*
declare
l_message varchar2(250);
begin
    svt_stds_tests_lib_api.auto_install_standard_test(
                                p_standard_id => :P81_STANDARD_ID,
                                p_message => l_message);
end;
*/
------------------------------------------------------------------------------
    procedure auto_install_standard_test (
                      p_standard_id in svt_stds_standard_tests.standard_id%type default null,
                      p_test_code   in svt_stds_standard_tests.test_code%type   default null,
                      p_message     out nocopy varchar2);

    
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 26, 2023
-- Synopsis:
--
-- Overloaded procedure to delete a given test from the test library and zip file
-- for a given id 
--
/*
begin  
    svt_stds_tests_lib_api.delete_test_from_lib (p_id => :P60_ID);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test_from_lib (p_id in svt_stds_tests_lib.id%type);


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 7, 2023
-- Synopsis:
--
-- Procedure to delete a given test from the test library and zip file
-- for a test_code
--
/*
begin  
    svt_stds_tests_lib_api.delete_test_from_lib (p_test_code => p_test_code);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test_from_lib (p_test_code in svt_stds_tests_lib.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 11, 2023
-- Synopsis:
--
-- Function to get the primary key of svt_stds_tests_lib from a given test_code
--
/*
        select svt_stds_tests_lib_api.get_id(:P60_TEST_CODE)
        from dual
*/
------------------------------------------------------------------------------
   function get_id(p_test_code in svt_stds_tests_lib.test_code%type)
   return svt_stds_tests_lib.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 13, 2023
-- Synopsis:
--
-- Function to return the md5 of a svt_stds_tests_lib for comparison with a svt_stds_standard_tests record
--
/*
select svt_stds_tests_lib_api.current_md5(p_test_code)
from dual
*/
------------------------------------------------------------------------------
   function current_md5(p_test_code in svt_stds_tests_lib.test_code%type)
   return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 16, 2023
-- Synopsis:
--
-- Procedure to get the md5 and version number for a given test_code 
--
/*
set serveroutput on
declare
p_test_code svt_stds_tests_lib.test_code%type := 'RW_BUTTON_PLACEMENT';
l_md5 varchar2(250);
l_version_number  svt_stds_tests_lib.version_number%type;
begin
    SVT_STDS_TESTS_LIB_API.md5_imported_vsn_num (
                p_test_code      => p_test_code,
                p_md5            => l_md5,
                p_version_number => l_version_number
        );
    dbms_output.put_line('l_md5 :'||l_md5);
    dbms_output.put_line('l_version_number :'||l_version_number);
end;
*/
------------------------------------------------------------------------------
   procedure md5_imported_vsn_num (
                p_test_code      in  svt_stds_tests_lib.test_code%type,
                p_md5            out nocopy varchar2,
                p_version_number out nocopy svt_stds_tests_lib.version_number%type
   );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 8, 2023
-- Synopsis:
--
-- Function to answer whether a given testcode will be overwritten on import of a test json file automatically 
--
/*
select svt_stds_tests_lib_api.autoinstall_lib_yn(p_test_code => 'ACC_AUTOCOMPLETE')
from dual
*/
------------------------------------------------------------------------------
  function autoinstall_lib_yn (p_test_code in svt_stds_standard_tests.test_code%type)
  return varchar2;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 11, 2023
-- Synopsis:
--
-- Function to answer whether a record in  svt_stds_tests_lib exists for a given test_code
--
/*
set serveroutput on
declare
l_bool boolean;
begin
    l_bool := svt_stds_tests_lib_api.published_exists (p_test_code => 'ACC_AUTOCOMPLETE');
end;
*/
------------------------------------------------------------------------------
  function published_exists (p_test_code in svt_stds_standard_tests.test_code%type)
  return boolean;

end SVT_STDS_TESTS_LIB_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_STDS_TYPES_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-18 - created
---------------------------------------------------------------------------- 
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P24_ID := svt_stds_types_api.insert_typ (
                    p_display_sequence => :P24_DISPLAY_SEQUENCE,
                    p_type_name        => :P24_TYPE_NAME,
                    p_type_code        => :P24_TYPE_CODE,
                    p_description      => :P24_DESCRIPTION,
                    p_active_yn        => :P24_ACTIVE_YN
                );
    when 'U' then
      svt_stds_types_api.update_typ(
            p_id               => :P24_ID,
            p_display_sequence => :P24_DISPLAY_SEQUENCE,
            p_type_name        => :P24_TYPE_NAME,
            p_type_code        => :P24_TYPE_CODE,
            p_description      => :P24_DESCRIPTION,
            p_active_yn        => :P24_ACTIVE_YN
        );
    when 'D' then
      svt_stds_types_api.delete_typ(p_id => :P24_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to insert records into SVT_STDS_TYPES
--
------------------------------------------------------------------------------
    function insert_typ (
       p_id               in svt_stds_types.id%type default null,
       p_display_sequence in svt_stds_types.display_sequence%type,
       p_type_name        in svt_stds_types.type_name%type,
       p_type_code        in svt_stds_types.type_code%type,
       p_description      in svt_stds_types.description%type,
       p_active_yn        in svt_stds_types.active_yn%type
    ) return svt_stds_types.id%type;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to update records into SVT_STDS_TYPES
--
------------------------------------------------------------------------------
    procedure update_typ (
       p_id               in svt_stds_types.id%type,
       p_display_sequence in svt_stds_types.display_sequence%type,
       p_type_name        in svt_stds_types.type_name%type,
       p_type_code        in svt_stds_types.type_code%type,
       p_description      in svt_stds_types.description%type,
       p_active_yn        in svt_stds_types.active_yn%type
    );
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to delete records into SVT_STDS_TYPES
--
------------------------------------------------------------------------------
    procedure delete_typ (
        p_id in svt_stds_types.id%type
    );
    
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 18, 2023
-- Synopsis:
--
-- function to return id for a given type code
--
/*
select svt_stds_types_api.get_type_id (p_type_code => 'HUMANX') type_id
from dual
*/
------------------------------------------------------------------------------
    function get_type_id (p_type_code in svt_stds_types.type_code%type)
    return svt_stds_types.id%type;
end svt_stds_types_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_TEST_TIMING_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_test_timing_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-9 - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 9, 2023
-- Synopsis:
--
-- Procedure to insert an timing record into   svt_test_timing
--
/*
begin
    svt_test_timing_api.insert_timing('BLERG', 1);
end;
*/
------------------------------------------------------------------------------
    procedure insert_timing(p_test_code in svt_test_timing.test_code%type,
                            p_seconds   in svt_test_timing.elapsed_seconds%type);
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 9, 2023
-- Synopsis:
--
-- Procedure to clear excessive timing records - deleting any records older than a month
--
/*
begin
    svt_test_timing_api.purge_old;
end;
*/
------------------------------------------------------------------------------
    procedure purge_old;
end svt_test_timing_api;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_URGENCY_LEVEL_API" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_URGENCY_LEVEL_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-14- created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- Function to return a default level id
--
/*
select SVT_URGENCY_LEVEL_API.get_default_level_id
from dual
*/
------------------------------------------------------------------------------
function get_default_level_id return svt_standards_urgency_level.id%type;
end SVT_URGENCY_LEVEL_API;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE "SVT_UTIL" authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-21 - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 21, 2023
-- Synopsis:
--
-- Function to get the application name  
--
/*
select svt_util.app_name
from dual
*/
------------------------------------------------------------------------------
    function app_name return varchar2;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 4, 2023
-- Synopsis:
--
-- Function to answer whether any automations are currently disabled
--
/*
select svt_util.disabled_jobs_yn
from dual
*/
------------------------------------------------------------------------------
  function disabled_jobs_yn return varchar2;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 4, 2023
-- Synopsis:
--
-- Function to answer whether v_svt_automations_problems returns any rows
--
/*
select svt_util.automation_issues_yn
from dual
*/
------------------------------------------------------------------------------
  function automation_issues_yn (p_except_static_id in apex_appl_automations.static_id%type default null) 
  return varchar2;
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Function to detect presence of alerts that need to be addressed
--
/*
select svt_util.alerts_yn
from dual
*/
------------------------------------------------------------------------------
    function alerts_yn return varchar2;
end SVT_UTIL;
/