--liquibase formatted sql
--changeset package_script:SVT_APEX_ISSUE_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package SVT_APEX_ISSUE_UTIL authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_apex_issue_util
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
--     Date: October 5, 2022
-- Synopsis:
--
-- Grouping all the procedures that need to be run by eba_stds_data.record_daily_issue_snapshot
--
/*
begin
  svt_apex_issue_util.manage_apex_issues;
  commit;
end;
*/
------------------------------------------------------------------------------
procedure manage_apex_issues;

$if oracle_apex_version.c_apex_issue_access $then
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2022
-- Synopsis:
--
-- Create an apex issue
-- eg:
-- set serveroutput on
-- declare 
--     l_id apex_issues.id%type;
-- begin
--     SVT_apex_issue_util.create_issue (
--         p_id             => l_id,
--         p_title          => 'Test issue',
--         p_issue_text     => 'Please fix this issue',
--         p_application_id => 720000,
--         p_page_id        => 1
--         );
--     dbms_output.put_line('l_id :'||l_id);
-- end;
--
------------------------------------------------------------------------------
procedure create_issue (p_id             out apex_issues.issue_id%type, 
                        p_title          in  apex_issues.issue_title%type, 
                        p_issue_text     in  apex_issues.issue_text%type, 
                        p_application_id in  apex_issues.related_application_id%type, 
                        p_page_id        in  apex_issues.related_page_id%type,
                        p_audit_id       in SVT_plsql_apex_audit.id%type
                        );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 29, 2022
-- Synopsis:
--
-- Merge audit issues into apex issues
--
/*
begin
  SVT_apex_issue_util.merge_from_audit_tbl(
                            p_issue_category => 'SERT',
                            p_application_id => 17000033,
                            p_page_id => 1
                            );
end;
*/
------------------------------------------------------------------------------
procedure merge_from_audit_tbl(p_issue_category in SVT_plsql_apex_audit.issue_category%type default null,
                               p_application_id in SVT_plsql_apex_audit.application_id%type default null,
                               p_page_id        in SVT_plsql_apex_audit.page_id%type default null,
                               p_audit_id       in SVT_plsql_apex_audit.id%type default null,
                               p_standard_code  in eba_stds_standard_tests.standard_code%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 3, 2022
-- Synopsis:
--
-- delete expired issues
--
/*
begin
    SVT_apex_issue_util.drop_irrelevant_issues;
end;
*/
------------------------------------------------------------------------------
procedure drop_irrelevant_issues;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 5, 2022
-- Synopsis:
--
-- Update SVT_plsql_apex_audit with the changes that have been performed to apex_issues
--
-- begin
--   SVT_apex_issue_util.update_audit_tbl_from_apex_issues;
-- end;
------------------------------------------------------------------------------
procedure update_audit_tbl_from_apex_issues;



------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 7, 2022
-- Synopsis:
--
-- Drop an issue
--
/*
begin
    SVT_apex_issue_util.drop_issue (p_id => 270816420201692571);
end;
*/
------------------------------------------------------------------------------
  procedure drop_issue (p_id in  apex_issues.issue_id%type);


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 9, 2022
-- Synopsis:
--
-- Drop all SVT issues 
--
/*
begin
  SVT_apex_issue_util.drop_all_SVT_issues;
end;
*/
------------------------------------------------------------------------------
  procedure drop_all_SVT_issues;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 19, 2023
-- Synopsis:
--
-- Not sure why this one is necessary but it is theoretically harmless
--
/*
begin
  SVT_apex_issue_util.hard_correct_svt_issues;
end;
*/
------------------------------------------------------------------------------
  procedure hard_correct_svt_issues;


$end

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 1, 2023
-- Synopsis:
--
-- Rerun the auditing for a given violation, including the creation of apex issues
--
/*
begin
  SVT_ctx_util.set_review_schema (p_schema => 'CARS');
  SVT_apex_issue_util.refresh_for_standard_app_page (
                        p_standard_code => 'SV_URL_ITEM_PROTECT',
                        p_app_id  => 17000033,
                        p_page_id => 14);
end;
*/
------------------------------------------------------------------------------
  procedure refresh_for_standard_app_page (
                                  p_standard_code in SVT_plsql_apex_audit.standard_code%type,
                                  p_app_id        in SVT_plsql_apex_audit.application_id%type default null,
                                  p_page_id       in SVT_plsql_apex_audit.page_id%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 1, 2023
-- Synopsis:
--
-- Rerun the auditing for a given violation, including the creation of apex issues
--
/*
begin
  SVT_ctx_util.set_review_schema (p_schema => 'CARS');
  SVT_apex_issue_util.refresh_for_audit_id (123);
end;
*/
------------------------------------------------------------------------------
  procedure refresh_for_audit_id (p_audit_id in SVT_plsql_apex_audit.id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 19, 2023
-- Synopsis:
--
-- raises an error if the version in the oracle_apex_version package does not match the current apex version
--
/*
begin
  SVT_apex_issue_util.check_apex_version_up2date;
end;
*/
------------------------------------------------------------------------------
procedure check_apex_version_up2date;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 19, 2023
-- Synopsis:
--
-- Procedure to mark a violation as an exception
--
/*
begin
  SVT_apex_issue_util.mark_as_exception (p_audit_id => :P1_AUDIT_ID);
end;
*/
------------------------------------------------------------------------------
procedure mark_as_exception (p_audit_id in SVT_plsql_apex_audit.id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jun-13
-- Synopsis:
--
-- Procedure to mark a violation as an exception
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

--rollback drop package SVT_APEX_ISSUE_UTIL;
