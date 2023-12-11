--liquibase formatted sql
--changeset package_script:SVT_STDS_TESTS_LIB_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_STDS_TESTS_LIB_API
--------------------------------------------------------

create or replace package SVT_STDS_TESTS_LIB_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_TESTS_LIB_API
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
-- Procedure to insert / update / merge a record into svt_stds_tests_lib
--
/*
begin
    svt_stds_tests_lib_api.upsert (
        p_standard_id           => p_standard_id,
        p_test_name             => p_test_name,
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
        p_standard_id           in svt_stds_tests_lib.standard_id%type,
        p_test_name             in svt_stds_tests_lib.test_name%type,
        p_test_id               in svt_stds_tests_lib.test_id%type,
        p_query_clob            in svt_stds_tests_lib.query_clob%type,
        p_test_code             in svt_stds_tests_lib.test_code%type,
        p_active_yn             in svt_stds_tests_lib.active_yn%type,
        p_mv_dependency         in svt_stds_tests_lib.mv_dependency%type,
        p_svt_component_type_id in svt_stds_tests_lib.svt_component_type_id%type,
        p_explanation           in svt_stds_tests_lib.explanation%type,
        p_fix                   in svt_stds_tests_lib.fix%type,
        p_level_id              in svt_stds_tests_lib.level_id%type,
        p_version_number        in svt_stds_tests_lib.version_number%type,
        p_version_db            in svt_stds_tests_lib.version_db%type
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
    svt_stds_tests_lib_api.take_snapshot;
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
-- Procedure to insert from svt_stds_tests_lib into svt_stds_standard_tests
--
/*
begin
    svt_stds_tests_lib_api.install_standard_test(
                        p_id => :P60_ID,
                        p_urgency_level_id =>  :P60_URGENCY_LEVEL_ID);
end;
*/
------------------------------------------------------------------------------
    procedure install_standard_test(p_id               in svt_stds_tests_lib.id%type,
                                    p_standard_id      in svt_stds_standard_tests.standard_id%type,
                                    p_urgency_level_id in svt_stds_standard_tests.level_id%type
                                    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 17, 2023
-- Synopsis:
--
-- Procedure to install all the tests for a given standard
--
/*
declare
l_message varchar2(250);
begin
    svt_stds_tests_lib_api.auto_install_standard_test(
                                p_standard_id => :P81_STANDARD_ID,
                                p_message => l_message);
end;
*/
------------------------------------------------------------------------------
    procedure auto_install_standard_test (
                      p_standard_id in svt_stds_standard_tests.standard_id%type default null,
                      p_test_code   in svt_stds_standard_tests.test_code%type   default null,
                      p_message     out nocopy varchar2);

    
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
    svt_stds_tests_lib_api.delete_test_from_lib (p_id => :P60_ID);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test_from_lib (p_id in svt_stds_tests_lib.id%type);


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
    svt_stds_tests_lib_api.delete_test_from_lib (p_test_code => p_test_code);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test_from_lib (p_test_code in svt_stds_tests_lib.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 11, 2023
-- Synopsis:
--
-- Function to get the primary key of svt_stds_tests_lib from a given test_code
--
/*
        select svt_stds_tests_lib_api.get_id(:P60_TEST_CODE)
        from dual
*/
------------------------------------------------------------------------------
   function get_id(p_test_code in svt_stds_tests_lib.test_code%type)
   return svt_stds_tests_lib.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 13, 2023
-- Synopsis:
--
-- Function to return the md5 of a svt_stds_tests_lib for comparison with a svt_stds_standard_tests record
--
/*
select svt_stds_tests_lib_api.current_md5(p_test_code)
from dual
*/
------------------------------------------------------------------------------
   function current_md5(p_test_code in svt_stds_tests_lib.test_code%type)
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
p_test_code svt_stds_tests_lib.test_code%type := 'RW_BUTTON_PLACEMENT';
l_md5 varchar2(250);
l_version_number  svt_stds_tests_lib.version_number%type;
begin
    SVT_STDS_TESTS_LIB_API.md5_imported_vsn_num (
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
                p_test_code      in  svt_stds_tests_lib.test_code%type,
                p_md5            out nocopy varchar2,
                p_version_number out nocopy svt_stds_tests_lib.version_number%type
   );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 8, 2023
-- Synopsis:
--
-- Function to answer whether a given testcode will be overwritten on import of a test json file automatically 
--
/*
select svt_stds_tests_lib_api.autoinstall_lib_yn(p_test_code => 'ACC_AUTOCOMPLETE')
from dual
*/
------------------------------------------------------------------------------
  function autoinstall_lib_yn (p_test_code in svt_stds_standard_tests.test_code%type)
  return varchar2;

end SVT_STDS_TESTS_LIB_API;
/
--rollback drop package SVT_STDS_TESTS_LIB_API;
