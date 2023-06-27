--liquibase formatted sql
--changeset package_script:ast_menu_util stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package ast_menu_util
--------------------------------------------------------

create or replace package ast_menu_util authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   ast_menu_util
--
-- DESCRIPTION : https://apexdebug.com/making-the-most-of-a-navigation-menu
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 6, 2023
-- Synopsis:
--
-- simply a wrapper for apex_plugin_util.is_component_used
-- returning a Y or N instead of a boolean
--
/*
select ast_menu_util.
from dual
*/
------------------------------------------------------------------------------
function is_component_used_yn (
                p_build_option_id           IN NUMBER   DEFAULT NULL,
                p_authorization_scheme_id   IN VARCHAR2,
                p_condition_type            IN VARCHAR2,
                p_condition_expression1     IN VARCHAR2,
                p_condition_expression2     IN VARCHAR2,
                p_component                 IN VARCHAR2 DEFAULT NULL )
            return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 12, 2023
-- Synopsis:
--
-- Function  to convert boolean to y/n from apex_authorization.is_authorized
--
/*
select ast_menu_util.is_authorized_yn (p_authorization_name => 'CONTRIBUTION RIGHTS') is_authorized_yn
from dual
*/
------------------------------------------------------------------------------
function is_authorized_yn (
    p_authorization_name in apex_application_list_entries.authorization_scheme%type
) return varchar2;

end ast_menu_util;
/
--rollback drop package ast_menu_util;
