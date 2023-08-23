--liquibase formatted sql
--changeset package_script:svt_nested_table_types_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package svt_nested_table_types_api
--------------------------------------------------------

create or replace package svt_nested_table_types_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_nested_table_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-23 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- Synopsis:
--
-- Overloaded function to return the issue_category for a given nt_name
--
/*
select svt_nested_table_types_api.issue_category(p_nt_name => 'V_SVT_APEX__0_NT') ic
from dual
*/
------------------------------------------------------------------------------
    function issue_category (p_nt_name in svt_nested_table_types.nt_name%type)
    return svt_plsql_apex_audit.issue_category%type
    deterministic;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- Synopsis:
--
-- Overloaded function to return the issue_category for a given test_code
--
/*
select svt_nested_table_types_api.issue_category(p_test_code => 'APP_AUTH') ic
from dual
*/
------------------------------------------------------------------------------
    function issue_category (p_test_code in eba_stds_standard_tests.test_code%type)
    return svt_plsql_apex_audit.issue_category%type
    deterministic;

end svt_nested_table_types_api;
/
--rollback drop package svt_nested_table_types_api;
