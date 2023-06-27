--liquibase formatted sql
--changeset package_body_script:AST_APEX_ISSUE_LINK stripComments:false endDelimiter:/ runOnChange:true
create or replace package body ast_apex_issue_link as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   ast_apex_issue_link
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jan-27 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix      constant varchar2(31) := lower($$plsql_unit) || '.';

  function build_link_to_apex_issue (
      p_app_id in apex_applications.application_id%type,
      p_id     in apex_issues.issue_id%type  
    )
  return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'build_link_to_apex_issue';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_builder_session constant number := v('APX_BLDR_SESSION'); 
  c_team_dev_app    constant number := 4600;
  c_issue_page      constant number := 100;
  l_link            varchar2(2000); 
  begin
    apex_debug.message(c_debug_template,'START', 'p_app_id', p_app_id, 'p_id', p_id);

    l_link := case when p_app_id is null 
                   then 'p_app_id_is_null'
                   when p_id is null 
                   then 'p_id_is_null'
                   when eba_stds_parser.is_logged_into_builder() = false
                   then 'not_logged_into_builder'
                   when eba_stds_parser.app_in_current_workspace(p_app_id) = false 
                   then 'app_not_in_current_workspace'
                   else apex_string.format(
                          p_message => '%0f?p=%1:%2:%3:::RP:P100_ISSUE_ID:%4',
                          p0 => eba_stds_parser.get_base_url(),
                          p1 => c_team_dev_app,
                          p2 => c_issue_page,
                          p3 => c_builder_session,
                          p4 => p_id
                        )
                   end;
    apex_debug.info(c_debug_template, 'l_link', l_link);

    return l_link;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end build_link_to_apex_issue;


end ast_apex_issue_link;
/

--rollback drop package AST_APEX_ISSUE_LINK;
