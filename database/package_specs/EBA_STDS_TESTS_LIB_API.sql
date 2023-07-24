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
        p_standard_id           => p_standard_id,
        p_test_name             => p_test_name,
        p_workspace             => p_workspace,
        p_test_id               => p_test_id,
        p_query_clob            => p_query_clob,
        p_standard_code         => p_standard_code,
        p_active_yn             => p_active_yn,
        p_mv_dependency         => p_mv_dependency,
        p_svt_component_type_id => p_svt_component_type_id,
        p_explanation           => p_explanation,
        p_fix                   => p_fix,
        p_level_id              => p_level_id,
        p_version_number        => p_version_number
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
        p_svt_component_type_id in eba_stds_tests_lib.svt_component_type_id%type,
        p_explanation           in eba_stds_tests_lib.explanation%type,
        p_fix                   in eba_stds_tests_lib.fix%type,
        p_level_id              in eba_stds_tests_lib.level_id%type,
        p_version_number        in eba_stds_tests_lib.version_number%type
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


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 11, 2023
-- Synopsis:
--
-- Function to get the primary key of eba_stds_tests_lib from a given standard_code
--
/*
        select eba_stds_tests_lib_api.get_id(:P60_STANDARD_CODE)
        from dual
*/
------------------------------------------------------------------------------
   function get_id(p_standard_code in eba_stds_tests_lib.standard_code%type)
   return eba_stds_tests_lib.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 13, 2023
-- Synopsis:
--
-- Function to return the md5 of a eba_stds_tests_lib for comparison with a eba_stds_standard_tests record
--
/*
select eba_stds_tests_lib_api.current_md5(p_standard_code)
from dual
*/
------------------------------------------------------------------------------
   function current_md5(p_standard_code in eba_stds_tests_lib.standard_code%type)
   return varchar2;

end EBA_STDS_TESTS_LIB_API;
/
--rollback drop package EBA_STDS_TESTS_LIB_API;
