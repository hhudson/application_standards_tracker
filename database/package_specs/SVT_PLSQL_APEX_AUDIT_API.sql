--liquibase formatted sql
--changeset package_script:SVT_plsql_apex_audit_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_PLSQL_APEX_AUDIT_API
--------------------------------------------------------

create or replace package SVT_PLSQL_APEX_AUDIT_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_plsql_apex_audit_api
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

end SVT_PLSQL_APEX_AUDIT_API;
/
--rollback drop package SVT_plsql_apex_audit_api;
