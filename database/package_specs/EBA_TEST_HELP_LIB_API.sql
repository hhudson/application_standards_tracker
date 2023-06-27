--liquibase formatted sql
--changeset package_script:EBA_TEST_HELP_LIB_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package EBA_TEST_HELP_LIB_API
--------------------------------------------------------

create or replace package EBA_TEST_HELP_LIB_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   EBA_TEST_HELP_LIB_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-15 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 15, 2023
-- Synopsis:
--
-- Procedure to merge into EBA_TEST_HELP_LIB
--
------------------------------------------------------------------------------
  procedure merge_help (
    p_workspace     in eba_test_help_lib.workspace%type,
    p_test_id       in eba_test_help_lib.test_id%type,
    p_standard_code in eba_test_help_lib.standard_code%type,
    p_sub_code      in eba_test_help_lib.sub_code%type,
    p_explanation   in eba_test_help_lib.explanation%type,
    p_fix           in eba_test_help_lib.fix%type
  );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 15, 2023
-- Synopsis:
-- Procedure to load current standards test help from AST_SUB_REFERENCE_CODES
--
/*
begin
    eba_test_help_lib_api.take_snapshot;
    commit;
end;
*/
------------------------------------------------------------------------------
procedure take_snapshot;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 15, 2023
-- Synopsis:
--
-- Procedure to load help from  eba_stds_tests_lib into ast_sub_reference_codes
--
/*
begin
    eba_test_help_lib_api.insert_help (p_test_id => :P44_TEST_ID);
end;
*/
------------------------------------------------------------------------------
    procedure insert_help (p_test_id in eba_stds_standard_tests.id%type);

end EBA_TEST_HELP_LIB_API;
/
--rollback drop package EBA_TEST_HELP_LIB_API;
