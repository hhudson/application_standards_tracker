--liquibase formatted sql
--changeset package_script:AST_APEX_VIEW stripComments:false endDelimiter:/ runOnChange:true
create or replace package ast_apex_view authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   ast_apex_view
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
-- from ast_apex_view.apex_applications() 
------------------------------------------------------------------------------
function apex_applications(p_user in all_users.username%type default null)
return ast_apex_applications_nt pipelined;


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
-- from ast_apex_view.apex_application_page_ir_col() 
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
-- from ast_apex_view.apex_appl_page_ig_columns() 
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
from ast_apex_view.apex_workspace_preferences() 
*/
------------------------------------------------------------------------------
function apex_workspace_preferences
return ast_apex_preferences_nt pipelined;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 5, 2023
-- Synopsis:
--
-- Function to determine whether a given display_position_code is 'legacy' or 'deprecated'
--
/*
select ast_apex_view.display_position_is_violation (
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



end ast_apex_view;
/

--rollback drop package AST_APEX_VIEW;
