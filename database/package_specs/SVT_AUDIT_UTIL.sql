--liquibase formatted sql
--changeset package_script:SVT_AUDIT_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package SVT_AUDIT_UTIL authid definer as
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
--  creator: hayden hudson
--     date: september 26, 2022
-- synopsis:
--
-- merge data into svt_plsql_apex_audit
/*
begin
 svt_ctx_util.set_review_schema (p_schema => svt_preferences.get_preference ('svt_default_schema'));
 svt_audit_util.merge_audit_tbl(
                    p_test_code => 'SERT',
                    p_application_id => 17000033,
                    p_page_id => 1);
 commit;
end;
*/
------------------------------------------------------------------------------
    procedure merge_audit_tbl (p_application_id in svt_plsql_apex_audit.application_id%type default null,
                               p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                               p_test_code      in eba_stds_standard_tests.test_code%type default null,
                               p_legacy_yn      in svt_plsql_apex_audit.legacy_yn%type default 'N',
                               p_audit_id       in svt_plsql_apex_audit.id%type default null
                              );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 8, 2022
-- Synopsis:
--
-- Procedure to record existing issue in table to track when they appear / disappear.  
-- 
/*
begin
    SVT_ctx_util.set_review_schema (p_schema => svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA'));
    SVT_audit_util.record_daily_issue_snapshot();
     commit;
end;
*/
--
------------------------------------------------------------------------------
   procedure record_daily_issue_snapshot(p_application_id in svt_plsql_apex_audit.application_id%type default null,
                                         p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                                         p_test_code      in eba_stds_standard_tests.test_code%type default null
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
    SVT_audit_util.assign_violations;
end;
*/
------------------------------------------------------------------------------
procedure assign_violations;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 25, 2023
-- Synopsis:
--
-- Procedure to delete standard violations that have been resolved
--
/*
begin
  SVT_audit_util.delete_obsolete_violations;
  commit;
end;
*/
------------------------------------------------------------------------------
procedure delete_obsolete_violations (
                p_test_code      in eba_stds_standard_tests.test_code%type default null,
                p_application_id in svt_plsql_apex_audit.application_id%type default null,
                p_page_id        in svt_plsql_apex_audit.page_id%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 8, 2023
-- Synopsis:
--
-- Procedure to initialize a standard such that all existing violations are categorized as 'legacy'
--
/*
begin
    SVT_ctx_util.set_review_schema (p_schema => svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA'));
    SVT_audit_util.initialize_standard(p_test_code => 'HTML_ESCAPING_COLS');
    commit;
end;
*/
------------------------------------------------------------------------------
procedure initialize_standard(p_test_code  in eba_stds_standard_tests.test_code%type);

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

end SVT_AUDIT_UTIL;
/

--rollback drop package SVT_AUDIT_UTIL;
