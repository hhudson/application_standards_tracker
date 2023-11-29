--liquibase formatted sql
--changeset view_script:v_svt_apex_workspace_developers stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--------------------------------------------------------
--  DDL for View V_SVT_APEX_WORKSPACE_DEVELOPERS
--------------------------------------------------------

create or replace view v_svt_apex_workspace_developers as 
select workspace_display_name, user_name, email
from apex_workspace_developers
where workspace_display_name = svt_preferences.get('SVT_WORKSPACE')
/