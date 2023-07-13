--liquibase formatted sql
--changeset package_script:AST_PREFERENCES stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package AST_PREFERENCES
--------------------------------------------------------

create or replace package AST_PREFERENCES authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   AST_PREFERENCES
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

select ast_preferences.get_preference ('AST_DEFAULT_SCHEMA') schema,
       ast_preferences.get_preference ('AST_DEFAULT_SCHEMA') workspace
from dual;
*/
------------------------------------------------------------------------------
function get_preference (p_preference_name in apex_workspace_preferences.preference_name%type)
return apex_workspace_preferences.preference_value%type deterministic;


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
    ast_preferences.set_preference (p_preference_name  => 'AST_DEFAULT_SCHEMA',
                                    p_value => 'REDWOOD'); 
end;
*/
------------------------------------------------------------------------------
procedure set_preference (p_preference_name in apex_workspace_preferences.preference_name%type,
                          p_value           in apex_workspace_preferences.preference_value%type);

end AST_PREFERENCES;
/
--rollback drop package AST_PREFERENCES;
