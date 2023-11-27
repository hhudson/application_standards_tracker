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

/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P64_ID := svt_nested_table_types_api.insert_nt (
                    p_nt_name       => :P64_NT_NAME,
                    p_example_query => :P64_EXAMPLE_QUERY,
                    p_object_type   => :P64_OBJECT_TYPE
                );
    when 'U' then
      svt_nested_table_types_api.update_nt (
            p_id            => :P64_ID,
            p_nt_name       => :P64_NT_NAME,
            p_example_query => :P64_EXAMPLE_QUERY,
            p_object_type   => :P64_OBJECT_TYPE
        );
    when 'D' then
      svt_nested_table_types_api.delete_nt(p_id => :P64_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 10, 2023
-- Synopsis:
--
-- Procedure to insert records into SVT_NESTED_TABLE_TYPES
--
------------------------------------------------------------------------------
    function insert_nt (
        p_nt_name       in svt_nested_table_types.nt_name%type,
        p_example_query in svt_nested_table_types.example_query%type,
        p_object_type   in svt_nested_table_types.object_type%type
    ) return svt_nested_table_types.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 10, 2023
-- Synopsis:
--
-- Procedure to update records into SVT_NESTED_TABLE_TYPES
--
------------------------------------------------------------------------------
    procedure update_nt (
        p_id            in svt_nested_table_types.id%type,
        p_nt_name       in svt_nested_table_types.nt_name%type,
        p_example_query in svt_nested_table_types.example_query%type,
        p_object_type   in svt_nested_table_types.object_type%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 10, 2023
-- Synopsis:
--
-- Procedure to delete records into SVT_NESTED_TABLE_TYPES
--
------------------------------------------------------------------------------
    procedure delete_nt (
        p_id in svt_nested_table_types.id%type
    );

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
    deterministic
    result_cache;


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
    function issue_category (p_test_code in svt_stds_standard_tests.test_code%type)
    return svt_plsql_apex_audit.issue_category%type
    deterministic;

end svt_nested_table_types_api;
/
--rollback drop package svt_nested_table_types_api;
