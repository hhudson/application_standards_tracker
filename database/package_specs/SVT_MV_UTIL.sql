--liquibase formatted sql
--changeset package_script:SVT_MV_UTIL stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_MV_UTIL
--------------------------------------------------------

create or replace package SVT_MV_UTIL authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_MV_UTIL
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
-- function to return the sql for a view that unions all the mv_svt_* views together
--
/*
select svt_mv_util.mv_svt_query
from dual
*/
------------------------------------------------------------------------------
function mv_svt_query return clob;

------------------------------------------------------------------------------
--  creator: hayden hudson
--     date: may 10, 2023
-- synopsis:
--
-- procedure to refresh a colon-delimited list of materialized views on demand 
--
/*
begin
    svt_mv_util.refresh_mv('MV_SVT_BC_ENTRIES:MV_SVT_BUTTONS');
end;
*/
------------------------------------------------------------------------------
procedure refresh_mv(p_mv_list in svt_stds_standard_tests.mv_dependency%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 4, 2023
-- Synopsis:
--
-- Function to answer whether v_svt_problem_assignees returns any rows
--
/*
select svt_mv_util.problem_assignments_yn
from dual
*/
------------------------------------------------------------------------------
  function problem_assignments_yn
  return varchar2;

end SVT_MV_UTIL;
/
--rollback drop package SVT_MV_UTIL;
