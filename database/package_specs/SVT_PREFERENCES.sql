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

select svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA') schema,
       svt_preferences.get_preference ('SVT_DEFAULT_WORKSPACE') workspace
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
    SVT_preferences.set_preference (p_preference_name  => 'SVT_DEFAULT_SCHEMA',
                                    p_value => 'REDWOOD'); 
end;
*/
------------------------------------------------------------------------------
procedure set_preference (p_preference_name in apex_workspace_preferences.preference_name%type,
                          p_value           in apex_workspace_preferences.preference_value%type);

end SVT_PREFERENCES;
/
--rollback drop package SVT_PREFERENCES;
