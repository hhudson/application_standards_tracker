--liquibase formatted sql
--changeset package_script:SVT_PREFERENCES stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_PREFERENCES
--------------------------------------------------------

create or replace package SVT_PREFERENCES authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_PREFERENCES
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes  
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Apr-3 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: April 3, 2023
-- Synopsis:
--
-- Generic function to retrieve preference values 
--
/*

Instructions : Set the values of these preference in the Admin section of the application (p36)

select svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA') default_schema,
       svt_preferences.get_preference ('SVT_DEFAULT_WORKSPACE') default_workspace,
       svt_preferences.get_preference ('SVT_DB_NAME') db_name,
       svt_preferences.get_preference ('SVT_EMAIL_API') email_api,
       svt_preferences.get_preference ('SVT_BASE_URL') base_url,
       svt_preferences.get_preference ('SVT_SERT_YN') sert_yn,
       svt_preferences.get_preference ('SVT_APEX_ISSUES_YN') apex_issues_yn,
       svt_preferences.get_preference ('SVT_SCM_YN') scm_yn,
       svt_preferences.get_preference ('SVT_FROM_EMAIL') from_email,
       svt_preferences.get_preference ('SVT_DEFAULT_ASSIGNEE') default_assignee,
       svt_preferences.get_preference ('SVT_SRC_EDIT_DELAY') src_edit_delay,
       svt_preferences.get_preference ('SVT_CLEANUP_DELAY') cleanup_delay,
       svt_preferences.get_preference ('SVT_REVIEW_SCHEMAS') review_schemas,
       svt_preferences.get_preference ('SVT_DO_NOT_ASSIGN') do_not_assign
from dual;
*/
------------------------------------------------------------------------------
function get_preference (p_preference_name in apex_workspace_preferences.preference_name%type)
return apex_workspace_preferences.preference_value%type;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: April 17, 2023
-- Synopsis:
--
-- Procedure to set preferences (done through app on p45) 
--
/*
begin
    apex_util.set_workspace('REDWOOD');
    apex_session.create_session(p_app_id=>17000033,p_page_id=>1,p_username=>'hayden.h.hudson@oracle.com');   
    svt_preferences.set_preference (p_preference_name  => 'SVT_DEFAULT_SCHEMA',
                                    p_value => 'REDWOOD'); 
end;
*/
------------------------------------------------------------------------------
procedure set_preference (p_preference_name in apex_workspace_preferences.preference_name%type,
                          p_value           in apex_workspace_preferences.preference_value%type);

end SVT_PREFERENCES;
/
--rollback drop package SVT_PREFERENCES;
