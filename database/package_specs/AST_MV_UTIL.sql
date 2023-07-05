--liquibase formatted sql
--changeset package_script:AST_MV_UTIL stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package AST_MV_UTIL
--------------------------------------------------------

create or replace package AST_MV_UTIL authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   AST_MV_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jul-5 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 5, 2023
-- Synopsis:
--
-- function to return the SQL for a view that unions all the mv_ast_* views together
--
/*
select AST_MV_UTIL.mv_ast_query
from dual
*/
------------------------------------------------------------------------------
function mv_ast_query return clob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 10, 2023
-- Synopsis:
--
-- Procedure to refresh a colon-delimited list of materialized views on demand 
--
/*
begin
    AST_MV_UTIL.refresh_mv('MV_AST_BC_ENTRIES:MV_AST_BUTTONS');
end;
*/
------------------------------------------------------------------------------
procedure refresh_mv(p_mv_list in eba_stds_standard_tests.mv_dependency%type default null);

end AST_MV_UTIL;
/
--rollback drop package AST_MV_UTIL;
