--liquibase formatted sql
--changeset package_script:SVT_UTIL stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_UTIL
--------------------------------------------------------

create or replace package SVT_UTIL authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-21 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 21, 2023
-- Synopsis:
--
-- Function to get the application name  
--
/*
select svt_util.app_name
from dual
*/
------------------------------------------------------------------------------
    function app_name return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 4, 2023
-- Synopsis:
--
-- Function to answer whether any automations are currently disabled
--
/*
select svt_util.disabled_jobs_yn
from dual
*/
------------------------------------------------------------------------------
  function disabled_jobs_yn return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 4, 2023
-- Synopsis:
--
-- Function to answer whether v_svt_automations_problems returns any rows
--
/*
select svt_util.automation_issues_yn
from dual
*/
------------------------------------------------------------------------------
  function automation_issues_yn (p_except_static_id in apex_appl_automations.static_id%type default null) 
  return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Function to detect presence of alerts that need to be addressed
--
/*
select svt_util.alerts_yn
from dual
*/
------------------------------------------------------------------------------
    function alerts_yn return varchar2;

end SVT_UTIL;
/
--rollback drop package SVT_UTIL;
