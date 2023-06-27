--liquibase formatted sql
--changeset package_script:AST_AUDIT_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package AST_AUDIT_UTIL authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   AST_AUDIT_UTIL
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
--     Date: April 11, 2023
-- Synopsis:
--
-- Function to query who has checked out db objects 
--
/*
select object_name,
       email,
       folder_name 
from ast_audit_util.v_ast_scm_object_assignee()
*/
------------------------------------------------------------------------------
function v_ast_scm_object_assignee
return v_ast_scm_object_assignee_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 28, 2022
-- Synopsis:
--
-- Recompile all objects that are not compiled into plscope 
-- requires the "alter package" privilege
/*
begin
    ast_audit_util.recompile_w_plscope;
end;
*/
------------------------------------------------------------------------------
    procedure recompile_w_plscope;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 26, 2022
-- Synopsis:
--
-- merge data into ast_plsql_apex_audit
/*
begin
 ast_ctx_util.set_review_schema (p_schema => ast_preferences.get_preference ('AST_DEFAULT_SCHEMA'));
 ast_audit_util.merge_audit_tbl(
                    p_standard_code => 'SERT',
                    p_application_id => 17000033,
                    p_page_id => 1);
 commit;
end;
*/
------------------------------------------------------------------------------
    procedure merge_audit_tbl (p_application_id in ast_plsql_apex_audit.application_id%type default null,
                               p_page_id        in ast_plsql_apex_audit.page_id%type default null,
                               p_standard_code  in eba_stds_standard_tests.standard_code%type default null,
                               p_legacy_yn      in ast_plsql_apex_audit.legacy_yn%type default 'N',
                               p_audit_id       in ast_plsql_apex_audit.id%type default null
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
    ast_ctx_util.set_review_schema (p_schema => ast_preferences.get_preference ('AST_DEFAULT_SCHEMA'));
    ast_audit_util.record_daily_issue_snapshot();
     commit;
end;
*/
--
------------------------------------------------------------------------------
   procedure record_daily_issue_snapshot(p_application_id in ast_plsql_apex_audit.application_id%type default null,
                                         p_page_id        in ast_plsql_apex_audit.page_id%type default null,
                                         p_standard_code  in eba_stds_standard_tests.standard_code%type default null
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
    ast_audit_util.assign_violations;
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
  ast_audit_util.delete_obsolete_violations;
  commit;
end;
*/
------------------------------------------------------------------------------
procedure delete_obsolete_violations (
                p_standard_code  in eba_stds_standard_tests.standard_code%type default null,
                p_application_id in ast_plsql_apex_audit.application_id%type default null,
                p_page_id        in ast_plsql_apex_audit.page_id%type default null);


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 1, 2023
-- Synopsis:
--
-- Get a row of ast_plsql_apex_audit for a given audit id
--
------------------------------------------------------------------------------
function get_audit_record (p_audit_id in ast_plsql_apex_audit.id%type) 
return ast_plsql_apex_audit%rowtype;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 2, 2023
-- Synopsis:
--
-- Function to get the audit_id for a give unqid
--
------------------------------------------------------------------------------
function get_unqid(p_audit_id in ast_plsql_apex_audit.id%type) 
return ast_plsql_apex_audit.unqid%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 8, 2023
-- Synopsis:
--
-- Procedure to initialize a standard such that all existing violations are categorized as 'legacy'
--
/*
begin
    ast_ctx_util.set_review_schema (p_schema => ast_preferences.get_preference ('AST_DEFAULT_SCHEMA'));
    ast_audit_util.initialize_standard(p_standard_code => 'HTML_ESCAPING_COLS');
    commit;
end;
*/
------------------------------------------------------------------------------
procedure initialize_standard(p_standard_code  in eba_stds_standard_tests.standard_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: April 13, 2023
-- Synopsis:
--
-- Procedure to set APEX workspace
--
/*
begin
    ast_audit_util.set_workspace;
end;
*/
------------------------------------------------------------------------------
procedure set_workspace (p_workspace in apex_workspaces.workspace%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 10, 2023
-- Synopsis:
--
-- Procedure to refresh a given materialized view on demand 
--
/*
begin
    AST_AUDIT_UTIL.refresh_mv(:P14_MV_DEPENDENCY);
end;
*/
------------------------------------------------------------------------------
procedure refresh_mv(p_mv_name in user_objects.object_name%type);

end AST_AUDIT_UTIL;
/

--rollback drop package AST_AUDIT_UTIL;
