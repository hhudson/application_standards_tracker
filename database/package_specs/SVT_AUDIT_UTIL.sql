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
                                         p_test_code      in eba_stds_standard_tests.test_code%type default null,
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
    svt_ctx_util.set_review_schema (p_schema => svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA'));
    svt_audit_util.initialize_standard(p_test_code => 'HTML_ESCAPING_COLS');
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

end SVT_AUDIT_UTIL;
/

--rollback drop package SVT_AUDIT_UTIL;
