--liquibase formatted sql
--changeset package_script:SVT_APEX_ISSUE_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package SVT_APEX_ISSUE_UTIL authid current_user as
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
--  creator: hayden hudson
--     date: october 5, 2022
-- synopsis:
--
-- grouping all the procedures that need to be run by eba_stds_data.record_daily_issue_snapshot
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
                        p_title          in  apex_issues.issue_title%type, 
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
                            p_issue_category => 'sert',
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
                               p_test_code      in eba_stds_standard_tests.test_code%type default null);

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
procedure drop_irrelevant_issues;


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

--rollback drop package SVT_APEX_ISSUE_UTIL;
