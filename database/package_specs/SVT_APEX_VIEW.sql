--liquibase formatted sql
--changeset package_script:SVT_APEX_VIEW stripComments:false endDelimiter:/ runOnChange:true
create or replace package SVT_APEX_VIEW authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_apex_view
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Sep-16 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 16, 2022
-- Synopsis:
--
-- query apex_applications, regardless of apex version  
-- --
-- select application_id, 
--        application_name, 
--        application_group, 
--        availability_status, 
--        authorization_scheme, 
--        created_by, 
--        created_on, 
--        last_updated_by, 
--        last_updated_on
-- from svt_apex_view.apex_applications() 
------------------------------------------------------------------------------
function apex_applications(p_user in all_users.username%type default null)
return svt_apex_applications_nt pipelined;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2022-Oct-14
-- Synopsis:
--
-- query apex_application_page_ir_col, regardless of apex version  
-- --
-- select application_id, 
--        page_id, 
--        region_name, 
--        use_as_row_header,
--        region_id, 
--        created_by,
--        created_on,
--        updated_by,
--        updated_on
-- from svt_apex_view.apex_application_page_ir_col() 
------------------------------------------------------------------------------
function apex_application_page_ir_col
return apex_application_page_rpt_cols_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2022-Oct-14
-- Synopsis:
--
-- query apex_appl_page_ig_columns, regardless of apex version  
-- --
-- select application_id, 
--        page_id, 
--        region_name, 
--        use_as_row_header,
--        region_id, 
--        created_by,
--        created_on,
--        updated_by,
--        updated_on
-- from svt_apex_view.apex_appl_page_ig_columns() 
------------------------------------------------------------------------------
function apex_appl_page_ig_columns
return apex_application_page_rpt_cols_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 9, 2023
-- Synopsis:
--
-- pipeline the apex_workspace_preferences view
--
/*
select workspace_id,
       workspace_name,
       workspace_display_name,
       user_name,
       preference_id,
       preference_name,
       preference_value,
       preference_type,
       preference_comment
from svt_apex_view.apex_workspace_preferences() 
*/
------------------------------------------------------------------------------
function apex_workspace_preferences --deprecated bc slow(2023-Dec-8)
return svt_apex_preferences_nt pipelined 
deterministic;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 5, 2023
-- Synopsis:
--
-- Function to determine whether a given display_position_code is 'legacy' or 'deprecated'
--
/*
select svt_apex_view.display_position_is_violation (
                p_display_position_code => 'NEXT',  
                p_template_id           => 19073555195405988198,
                p_application_id        => 17000034) violation_yn
from dual;
*/
------------------------------------------------------------------------------
function display_position_is_violation (
                p_display_position_code in apex_application_page_buttons.display_position_code%type,
                p_template_id           in apex_application_page_regions.template_id%type,
                p_application_id        in apex_application_temp_region.application_id%type
  ) return varchar2 deterministic;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- Synopsis:
--
-- Function to return the necessary link request for directing to the requisite alternate IG or IR report 
--
/*
select svt_apex_view.rpt_link_request(
              p_issue_category => 'DB_PLSQL'
        )
from dual
*/
------------------------------------------------------------------------------
function rpt_link_request(
              p_issue_category   in svt_plsql_apex_audit.issue_category%type,
              p_report_type      in varchar2 default 'IR',
              p_dest_region_name in apex_appl_page_ig_rpts.region_name%type    default null,
              p_dest_page_id     in apex_appl_page_ig_rpts.page_id%type        default null,
              p_application_id   in apex_appl_page_ig_rpts.application_id%type default null
        )
return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- global constants
-- svt_apex_view.gc_svt_app_id
------------------------------------------------------------------------------
  gc_svt_app_id constant pls_integer := 17000033;


end SVT_APEX_VIEW;
/

--rollback drop package SVT_APEX_VIEW;
