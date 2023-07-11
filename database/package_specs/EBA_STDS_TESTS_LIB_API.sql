--liquibase formatted sql
--changeset package_script:EBA_STDS_TESTS_LIB_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package EBA_STDS_TESTS_LIB_API
--------------------------------------------------------

create or replace package EBA_STDS_TESTS_LIB_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   EBA_STDS_TESTS_LIB_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-8 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 8, 2023
-- Synopsis:
--
-- Procedure to insert / update / merge a record into eba_stds_tests_lib
--
/*
begin
    eba_stds_tests_lib_api.upsert (
        p_standard_id           => 1,
        p_test_name             => 'blerg',
        p_workspace             => 'blerg',
        p_test_id               => 1,
        p_query_clob            => 'blerg',
        p_standard_code         => 'blerg',
        p_active_yn             => null,
        p_mv_dependency         => null,
        p_ast_component_type_id => 1
    );
end;
*/
------------------------------------------------------------------------------
    procedure upsert (
        p_standard_id           in eba_stds_tests_lib.standard_id%type,
        p_test_name             in eba_stds_tests_lib.test_name%type,
        p_workspace             in eba_stds_tests_lib.workspace%type,
        p_test_id               in eba_stds_tests_lib.test_id%type,
        p_query_clob            in eba_stds_tests_lib.query_clob%type,
        p_standard_code         in eba_stds_tests_lib.standard_code%type,
        p_active_yn             in eba_stds_tests_lib.active_yn%type,
        p_mv_dependency         in eba_stds_tests_lib.mv_dependency%type,
        p_ast_component_type_id in eba_stds_tests_lib.ast_component_type_id%type,
        p_explanation           in eba_stds_tests_lib.explanation%type,
        p_fix                   in eba_stds_tests_lib.fix%type,
        p_level_id              in eba_stds_tests_lib.level_id%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 8, 2023
-- Synopsis:
--
-- Procedure to load current standards tests
--
/*
begin
    eba_stds_tests_lib_api.take_snapshot;
    commit;
end;
*/
------------------------------------------------------------------------------
    procedure take_snapshot;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- Procedure to insert from eba_stds_tests_lib into eba_stds_standard_tests
--
/*
begin
    EBA_STDS_TESTS_LIB_API.install_standard_test(
                        p_id => :P60_ID,
                        p_urgency_level_id =>  :P60_URGENCY_LEVEL_ID);
end;
*/
------------------------------------------------------------------------------
    procedure install_standard_test(p_id               in eba_stds_tests_lib.id%type,
                                    p_standard_id      in eba_stds_standard_tests.standard_id%type,
                                    p_urgency_level_id in eba_stds_standard_tests.level_id%type
                                    );

    
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 26, 2023
-- Synopsis:
--
-- Procedure to delete a given test from the test library and zip file 
--
/*
begin  
    eba_stds_tests_lib_api.delete_test_from_lib (p_id => :P60_ID);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test_from_lib (p_id in eba_stds_tests_lib.id%type);

end EBA_STDS_TESTS_LIB_API;
/
--rollback drop package EBA_STDS_TESTS_LIB_API;
