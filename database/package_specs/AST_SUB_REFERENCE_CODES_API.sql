--liquibase formatted sql
--changeset package_script:AST_SUB_REFERENCE_CODES_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package AST_SUB_REFERENCE_CODES_api
--------------------------------------------------------

create or replace package AST_SUB_REFERENCE_CODES_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   AST_SUB_REFERENCE_CODES_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 31, 2023
-- Synopsis:
--
-- Function to duplicate a standard's help (p14) 
--
/*
begin
  AST_SUB_REFERENCE_CODES_API.duplicate_standard_help (
                                    p_from_test_id  => 123,
                                    p_to_test_id    => 234
                                );
end;
*/
------------------------------------------------------------------------------
    procedure duplicate_standard_help (
                                        p_from_test_id in eba_stds_standard_tests.id%type,
                                        p_to_test_id   in eba_stds_standard_tests.id%type
                                    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- insert into ast_sub_reference_codes
--
/*
begin
    ast_sub_reference_codes_api.insert_help (
            p_sub_code    => p_sub_code,
            p_explanation => p_explanation,
            p_fix         => p_fix,
            p_test_id     => p_test_id
        );
end;
*/
------------------------------------------------------------------------------
    procedure insert_help (p_sub_code    in ast_sub_reference_codes.sub_code%type,
                           p_explanation in ast_sub_reference_codes.explanation%type,
                           p_fix         in ast_sub_reference_codes.fix%type,
                           p_test_id     in ast_sub_reference_codes.test_id%type
    );

end AST_SUB_REFERENCE_CODES_API;
/
--rollback drop package AST_SUB_REFERENCE_CODES_api;
