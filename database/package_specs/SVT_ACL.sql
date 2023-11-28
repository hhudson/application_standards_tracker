    --liquibase formatted sql
--changeset package_script:SVT_ACL stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_ACL
--------------------------------------------------------

create or replace package SVT_ACL authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_ACL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Sep-21 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to add an administrator 
--
/*
    svt_acl.add_admin(p_user_name => 'hayden.h.hudson@oracle.com',
                      p_application_id => :APP_ID);
*/
------------------------------------------------------------------------------
procedure add_admin (p_user_name      in apex_workspace_developers.user_name%type,
                     p_application_id in apex_applications.application_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to add a contributor 
--
/*
    svt_acl.add_contributor(p_user_name => 'hayden.h.hudson@oracle.com',
                           p_application_id => :APP_ID);
*/
------------------------------------------------------------------------------
procedure add_contributor (p_user_name      in apex_workspace_developers.user_name%type,
                           p_application_id in apex_applications.application_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to add a reader 
--
/*
    svt_acl.add_reader(p_user_name => 'hayden.h.hudson@oracle.com',
                       p_application_id => :APP_ID);
*/
------------------------------------------------------------------------------
procedure add_reader (p_user_name      in apex_workspace_developers.user_name%type,
                      p_application_id in apex_applications.application_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 21, 2023
-- Synopsis:
--
-- Procedure to add all APEX_WORKSPACE_DEVELOPERS as ACL Readers
--
/*
begin
    svt_acl.add_awd_users(p_application_id => :APP_ID);
end;
*/
------------------------------------------------------------------------------
procedure add_awd_users(p_application_id in apex_applications.application_id%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Procedure to add a default admin if none exists
--
/*
begin
    svt_acl.add_default_admin(p_user_name      => :APP_USER,
                              p_application_id => :APP_ID);
end;
*/
------------------------------------------------------------------------------
procedure add_default_admin(p_user_name      in apex_workspace_developers.user_name%type,
                            p_application_id in apex_applications.application_id%type);

end SVT_ACL;
/
--rollback drop package SVT_ACL;
