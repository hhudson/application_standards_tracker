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
        p_test_code             => p_test_code,
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
        p_test_code             in eba_stds_tests_lib.test_code%type,
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
    -- procedure take_snapshot;


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
-- Overloaded procedure to delete a given test from the test library and zip file
-- for a given id 
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
--     Date: August 7, 2023
-- Synopsis:
--
-- Procedure to delete a given test from the test library and zip file
-- for a test_code
--
/*
begin  
    eba_stds_tests_lib_api.delete_test_from_lib (p_test_code => p_test_code);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test_from_lib (p_test_code in eba_stds_tests_lib.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 11, 2023
-- Synopsis:
--
-- Function to get the primary key of eba_stds_tests_lib from a given test_code
--
/*
        select eba_stds_tests_lib_api.get_id(:P60_TEST_CODE)
        from dual
*/
------------------------------------------------------------------------------
   function get_id(p_test_code in eba_stds_tests_lib.test_code%type)
   return eba_stds_tests_lib.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 13, 2023
-- Synopsis:
--
-- Function to return the md5 of a eba_stds_tests_lib for comparison with a eba_stds_standard_tests record
--
/*
select eba_stds_tests_lib_api.current_md5(p_test_code)
from dual
*/
------------------------------------------------------------------------------
   function current_md5(p_test_code in eba_stds_tests_lib.test_code%type)
   return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 16, 2023
-- Synopsis:
--
-- Procedure to get the md5 and version number for a given test_code 
--
/*
set serveroutput on
declare
p_test_code eba_stds_tests_lib.test_code%type := 'RW_BUTTON_PLACEMENT';
l_md5 varchar2(250);
l_version_number  eba_stds_tests_lib.version_number%type;
begin
    EBA_STDS_TESTS_LIB_API.md5_imported_vsn_num (
                p_test_code      => p_test_code,
                p_md5            => l_md5,
                p_version_number => l_version_number
        );
    dbms_output.put_line('l_md5 :'||l_md5);
    dbms_output.put_line('l_version_number :'||l_version_number);
end;
*/
------------------------------------------------------------------------------
   procedure md5_imported_vsn_num (
                p_test_code      in  eba_stds_tests_lib.test_code%type,
                p_md5            out nocopy varchar2,
                p_version_number out nocopy eba_stds_tests_lib.version_number%type
   );

end EBA_STDS_TESTS_LIB_API;
/
--rollback drop package EBA_STDS_TESTS_LIB_API;
