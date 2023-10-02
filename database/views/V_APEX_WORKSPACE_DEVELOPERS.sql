--------------------------------------------------------
--  DDL for View V_APEX_WORKSPACE_DEVELOPERS
--------------------------------------------------------

create or replace view v_apex_workspace_developers as 
select workspace_display_name, user_name, email
from apex_workspace_developers
where workspace_display_name = svt_preferences.get_preference ('SVT_DEFAULT_WORKSPACE')
/