--liquibase formatted sql
--changeset package_script:ast_plsql_apex_audit_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package ast_plsql_apex_audit_api
--------------------------------------------------------

create or replace package ast_plsql_apex_audit_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   ast_plsql_apex_audit_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-29- created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 29, 2023
-- Synopsis:
--
-- Procedure to update a violation as an exception
--
/*
begin
    ast_plsql_apex_audit_api.mark_as_exception (p_audit_id  => p_audit_id);
end;
*/
------------------------------------------------------------------------------
procedure mark_as_exception (p_audit_id in ast_plsql_apex_audit.id%type);


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 29, 2023
-- Synopsis:
--
-- Procedure to remove a pointer to an apex issue
--
/*
begin
    ast_plsql_apex_audit_api.null_out_apex_issue (p_audit_id  => p_audit_id);
end;
*/
------------------------------------------------------------------------------
procedure null_out_apex_issue (p_audit_id in ast_plsql_apex_audit.id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 29, 2023
-- Synopsis:
--
-- Procedure to assign a given violation to someone
--
/*
begin
    ast_plsql_apex_audit_api.assign_violation (
                                p_audit_id  => 123,
                                p_assignee  => hayden.h.hudson@oracle.com);
end;
*/
------------------------------------------------------------------------------
procedure assign_violation (p_audit_id in ast_plsql_apex_audit.id%type,
                            p_assignee in ast_plsql_apex_audit.assignee%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 29, 2023
-- Synopsis:
--
-- Procedure to bulk reassign violation 
--
/*
begin
    ast_plsql_apex_audit_api.bulk_reassign (
                         p_audit_ids  => :P1_SELECTED_IDS,
                         p_assignee   => :P1_NEW_ASSIGNEE ); 
end;
*/
------------------------------------------------------------------------------
procedure bulk_reassign (p_audit_ids in varchar2,
                         p_assignee  in ast_plsql_apex_audit.assignee%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 1, 2023
-- Synopsis:
--
-- Get a row of ast_plsql_apex_audit for a given audit id
--
/*
declare
l_rec ast_plsql_apex_audit%rowtype;
begin
    l_rec := ast_plsql_apex_audit_api.get_audit_record(p_audit_id) 
end;
*/
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

end ast_plsql_apex_audit_api;
/
--rollback drop package ast_plsql_apex_audit_api;
