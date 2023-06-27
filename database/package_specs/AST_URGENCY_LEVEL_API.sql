--liquibase formatted sql
--changeset package_script:AST_URGENCY_LEVEL_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package AST_URGENCY_LEVEL_API
--------------------------------------------------------

create or replace package AST_URGENCY_LEVEL_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   AST_URGENCY_LEVEL_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-14- created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- Function to return a default level id
--
/*
select AST_URGENCY_LEVEL_API.get_default_level_id
from dual
*/
------------------------------------------------------------------------------
function get_default_level_id return ast_standards_urgency_level.id%type;

end AST_URGENCY_LEVEL_API;
/
--rollback drop package AST_URGENCY_LEVEL_API;
