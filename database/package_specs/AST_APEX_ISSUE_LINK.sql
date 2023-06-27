--liquibase formatted sql
--changeset package_script:AST_APEX_ISSUE_LINK stripComments:false endDelimiter:/ runOnChange:true
create or replace package ast_apex_issue_link authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   ast_apex_issue_link
--
-- DESCRIPTION
-- This package requires : 
-- • grant APEX_ADMINISTRATOR_ROLE to ast
-- • create privileges on apex_220100.wwv_flow_issues
-- • read privileges on apex_issues
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Sep-28 - created
---------------------------------------------------------------------------- 


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- Build link to apex issue (must be run from an apex builder session)
--
/*
select ast_apex_issue_link.build_link_to_apex_issue(
          p_app_id => 100,
          p_id => 123
        )
from dual;
*/
------------------------------------------------------------------------------
   function build_link_to_apex_issue (
      p_app_id in apex_applications.application_id%type,
      p_id     in apex_issues.issue_id%type  
    )
   return varchar2;

end ast_apex_issue_link;
/

--rollback drop package AST_APEX_ISSUE_LINK;
