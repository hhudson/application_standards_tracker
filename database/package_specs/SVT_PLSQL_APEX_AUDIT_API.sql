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
--rollback drop package svt_plsql_apex_audit_api;
