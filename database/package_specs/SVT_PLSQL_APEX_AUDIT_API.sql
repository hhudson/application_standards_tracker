--liquibase formatted sql
--changeset package_script:svt_plsql_apex_audit_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_PLSQL_APEX_AUDIT_API
--------------------------------------------------------

create or replace package SVT_PLSQL_APEX_AUDIT_API authid definer as
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
return svt_plsql_apex_audit.unqid%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 16, 2023
-- Synopsis:
--
-- procedure to assign apex violations to developers according to v_eba_stds_applications.default_developer
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
 svt_ctx_util.set_review_schema (p_schema => svt_preferences.get_preference ('svt_default_schema'));
 svt_plsql_apex_audit_api.merge_audit_tbl(p_issue_category => 'APEX');
 commit;
end;
*/
------------------------------------------------------------------------------
    procedure merge_audit_tbl (p_application_id in svt_plsql_apex_audit.application_id%type default null,
                               p_page_id        in svt_plsql_apex_audit.page_id%type default null,
                               p_test_code      in eba_stds_standard_tests.test_code%type default null,
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
begin
    svt_plsql_apex_audit_api.delete_stale;
end;
*/
------------------------------------------------------------------------------
    procedure delete_stale;

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
              p_validation_failure_message in svt_plsql_apex_audit.validation_failure_message%type);


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

end SVT_PLSQL_APEX_AUDIT_API;
/
--rollback drop package svt_plsql_apex_audit_api;
