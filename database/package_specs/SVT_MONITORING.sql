--liquibase formatted sql
--changeset package_script:SVT_MONITORING stripComments:false endDelimiter:/ runOnChange:true
create or replace package SVT_MONITORING authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_MONITORING
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso   2022-Dec-16 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudsons
--     Date: December 20, 2022
-- Synopsis:
--
-- function to generate html table for email 
/*
select svt_monitoring.unassigned_src_html (
                  p_test_code  => 'DBMS_ASSERT',
                  p_days_since => 9,
                  p_fetch_rows => 2
              ) thehtml
from dual;
*/
------------------------------------------------------------------------------
function unassigned_src_html 
    (p_test_code     in eba_stds_standard_tests.test_code%type,
     p_days_since    in number default 1,
     p_fetch_rows    in number default null
    )
    return varchar2;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 16, 2022
-- Synopsis:
--
-- Send monitoring email
--
/*
begin
    apex_session.create_session(p_app_id=>17000033,p_page_id=>1,p_username=>'HAYHUDSO');
    svt_monitoring.send_update(
                p_days_since => 2,
                p_override_email => 'hayden.h.hudson@oracle.com');
end;
*/
------------------------------------------------------------------------------
procedure send_update(p_days_since     in number default 1,
                      p_override_email in varchar2 default null);

  ------------------------------------------------------------------------------
  --  Creator: Hayden Hudson
  --     Date: January 3, 2023
  -- Synopsis:
  --
  -- function to get the url to the SVT application
  --
  /*
  select svt_monitoring.app_url
  from dual;
  */
  ------------------------------------------------------------------------------
  function app_url return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 10, 2023
-- Synopsis:
--
--  function to get a human readable database name
--
/*
select svt_monitoring.get_db_name
from dual;
*/
------------------------------------------------------------------------------
  function get_db_name return varchar2;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 13, 2023
-- Synopsis:
--
-- Procedure to send an email  
--
/*
declare
l_to        varchar2(100) := 'hayden.h.hudson@oracle.com';
l_from      varchar2(100) := 'hayden.h.hudson@oracle.com';
l_subj      varchar2(100) := 'hello';
l_body      clob := 'hello';
l_body_html clob := 'hello';
begin
  svt_monitoring.send_email (
    p_to        => l_to,
    p_from      => l_from,
    p_subj      => l_subj,
    p_body      => l_body,
    p_body_html => l_body_html
  );
  svt_monitoring.push_email;
end;
*/
------------------------------------------------------------------------------
  procedure send_email (
              p_to        in varchar2,
              p_from      in varchar2,
              p_subj      in varchar2,
              p_body      in clob,
              p_body_html in clob
  );


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 13, 2023
-- Synopsis:
--
-- Procedure to push email;
--
------------------------------------------------------------------------------
  procedure push_email;

  ------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 11, 2023
-- Synopsis:
--
-- Public function to build html for unassigned issues
--
/*
select svt_monitoring.unassigned_html_by_src
                        (p_days_since => 2) uhbs
from dual;
*/
------------------------------------------------------------------------------
  function unassigned_html_by_src (
            p_days_since in number) return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 11, 2023
-- Synopsis:
--
-- Procedure to build html for assigned issues
--
/*
set serveroutput on
declare
l_assigned_report_html clob;
l_list_of_assignees clob;
begin
  svt_monitoring.assigned_html (
        p_days_since           => 2,
        p_assigned_report_html => l_assigned_report_html,
        p_list_of_assignees    => l_list_of_assignees);
  dbms_output.put_line('l_assigned_report_html :'||l_assigned_report_html);
  dbms_output.put_line('l_list_of_assignees :'||l_list_of_assignees);
end;
*/
------------------------------------------------------------------------------
  procedure assigned_html (
        p_days_since           in number,
        p_assigned_report_html out nocopy clob,
        p_list_of_assignees    out nocopy varchar2);
  
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 24, 2023
-- Synopsis:
--
-- function to return a value to uniquely identify the database
--
/*
select svt_monitoring.db_unique_name
from dual
*/
------------------------------------------------------------------------------
  function db_unique_name return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 18, 2023
-- Synopsis:
--
-- Procedure to enable SVT automations 
--
/*
begin
  svt_monitoring.enable_automations;
end;
*/
------------------------------------------------------------------------------
  procedure enable_automations;


end SVT_MONITORING;
/

--rollback drop package SVT_MONITORING;
