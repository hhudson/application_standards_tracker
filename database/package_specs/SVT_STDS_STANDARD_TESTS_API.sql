--liquibase formatted sql
--changeset package_script:svt_stds_standard_tests_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package svt_stds_standard_tests_api
--------------------------------------------------------

create or replace package svt_stds_standard_tests_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_standard_tests_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P14_ID := svt_stds_standard_tests_api.insert_test(
                  p_id                    => :P14_ID,
                  p_standard_id           => :P14_STANDARD_ID,
                  p_test_name             => :P14_SHORT_NAME,
                  p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                  p_query_clob            => :P14_QUERY_CLOB,
                  p_owner                 => :P14_OWNER,
                  p_test_code             => :P14_TEST_CODE,
                  p_active_yn             => :P14_ACTIVE_YN,
                  p_level_id              => :P14_LEVEL_ID,
                  p_mv_dependency         => :P14_MV_DEPENDENCY,
                  p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID,
                  p_explanation           => :P14_EXPLANATION,
                  p_fix                   => :P14_FIX
                );
    when 'U' then
      svt_stds_standard_tests_api.update_test(
                          p_id                    => :P14_ID,
                          p_standard_id           => :P14_STANDARD_ID,
                          p_test_name             => :P14_SHORT_NAME,
                          p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                          p_query_clob            => :P14_QUERY_CLOB,
                          p_owner                 => :P14_OWNER,
                          p_test_code             => :P14_TEST_CODE,
                          p_active_yn             => :P14_ACTIVE_YN,
                          p_level_id              => :P14_LEVEL_ID,
                          p_mv_dependency         => :P14_MV_DEPENDENCY,
                          p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID,
                          p_explanation           => :P14_EXPLANATION,
                          p_fix                   => :P14_FIX
                        );
    when 'D' then
      svt_stds_standard_tests_api.delete_test(p_id => :P14_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jul-10
-- Synopsis:
--
-- Procedure to insert new record into  svt_stds_standard_tests
--
/*
declare 
l_id svt_stds_standard_tests.id%type;
begin
    l_id := svt_stds_standard_tests_api.insert_test(
                p_standard_id           => p_standard_id,
                p_test_name             => p_test_name,
                p_display_sequence      => p_display_sequence,
                p_query_clob            => p_query_clob,
                p_owner                 => p_owner,
                p_test_code             => p_test_code,
                p_active_yn             => p_active_yn,
                p_level_id              => p_level_id,
                p_mv_dependency         => p_mv_dependency,
                p_svt_component_type_id => p_svt_component_type_id,
                p_explanation           => p_explanation,
                p_fix                   => p_fix
              );
end;
*/
------------------------------------------------------------------------------
  function insert_test(p_id                    in svt_stds_standard_tests.id%type default null,
                       p_standard_id           in svt_stds_standard_tests.standard_id%type,
                       p_test_name             in svt_stds_standard_tests.test_name%type,
                       p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                       p_query_clob            in svt_stds_standard_tests.query_clob%type,
                       p_owner                 in svt_stds_standard_tests.owner%type,
                       p_test_code             in svt_stds_standard_tests.test_code%type,
                       p_active_yn             in svt_stds_standard_tests.active_yn%type,
                       p_level_id              in svt_stds_standard_tests.level_id%type,
                       p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                       p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                       p_explanation           in svt_stds_standard_tests.explanation%type,
                       p_fix                   in svt_stds_standard_tests.fix%type,
                       p_version_number        in svt_stds_standard_tests.version_number%type default null,
                       p_version_db            in svt_stds_standard_tests.version_db%type default null
                       )
  return svt_stds_standard_tests.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- Procedure to insert new record into  svt_stds_standard_tests (called by EBA_STDS_TESTS_LIB_API.install_standard_test)
--
/*
begin
    svt_stds_standard_tests_api.insert_test(
                p_id                    => p_id,
                p_standard_id           => p_standard_id,
                p_test_name             => p_test_name,
                p_display_sequence      => p_display_sequence,
                p_query_clob            => p_query_clob,
                p_owner                 => p_owner,
                p_test_code             => p_test_code,
                p_active_yn             => p_active_yn,
                p_level_id              => p_level_id,
                p_mv_dependency         => p_mv_dependency,
                p_svt_component_type_id => p_svt_component_type_id);
end;
*/
------------------------------------------------------------------------------
  procedure insert_test(p_id                    in svt_stds_standard_tests.id%type default null,
                        p_standard_id           in svt_stds_standard_tests.standard_id%type,
                        p_test_name             in svt_stds_standard_tests.test_name%type,
                        p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                        p_query_clob            in svt_stds_standard_tests.query_clob%type,
                        p_owner                 in svt_stds_standard_tests.owner%type,
                        p_test_code             in svt_stds_standard_tests.test_code%type,
                        p_active_yn             in svt_stds_standard_tests.active_yn%type,
                        p_level_id              in svt_stds_standard_tests.level_id%type,
                        p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                        p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                        p_explanation           in svt_stds_standard_tests.explanation%type,
                        p_fix                   in svt_stds_standard_tests.fix%type,
                        p_version_number        in svt_stds_standard_tests.version_number%type default null,
                        p_version_db            in svt_stds_standard_tests.version_db%type default null
                      );
  
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 13, 2023
-- Synopsis:
--
-- function to get md5 for a record of svt_stds_standard_tests
--
/*
select svt_stds_standard_tests_api.build_test_md5 (
        p_test_name             => esst.test_name,
        p_query_clob            => esst.query_clob,
        p_test_code             => esst.test_code,
        p_level_id              => esst.level_id,
        p_mv_dependency         => esst.mv_dependency,
        p_svt_component_type_id => esst.svt_component_type_id,
        p_explanation           => esst.explanation,
        p_fix                   => esst.fix,
        p_version_number        => esst.version_number,
        p_version_db            => esst.version_db
    ) esst_md5
from svt_stds_standard_tests esst;
*/
------------------------------------------------------------------------------
  function build_test_md5 (
      p_test_name             in svt_stds_standard_tests.test_name%type,
      p_query_clob            in svt_stds_standard_tests.query_clob%type,
      p_test_code             in svt_stds_standard_tests.test_code%type,
      p_level_id              in svt_stds_standard_tests.level_id%type,
      p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
      p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
      p_explanation           in svt_stds_standard_tests.explanation%type,
      p_fix                   in svt_stds_standard_tests.fix%type,
      p_version_number        in svt_stds_standard_tests.version_number%type,
      p_version_db            in svt_stds_standard_tests.version_db%type
  ) return varchar2 deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Procedure to update svt_stds_standard_tests
--
/*
begin
  svt_stds_standard_tests_api.update_test(
                          p_id                    => :P14_ID,
                          p_standard_id           => :P14_STANDARD_ID,
                          p_test_name             => :P14_TEST_NAME,
                          p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                          p_query_clob            => :P14_QUERY_CLOB,
                          p_owner                 => :P14_OWNER,
                          p_test_code             => :P14_TEST_CODE,
                          p_active_yn             => :P14_ACTIVE_YN,
                          p_level_id              => :P14_LEVEL_ID,
                          p_mv_dependency         => :P14_MV_DEPENDENCY,
                          p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID,
                          p_explanation           => :P14_EXPLANATION,
                          p_fix                   => :P14_FIX,
                          p_version_number        => :P14_VERSION_NUMBER
                        );
end;
*/
------------------------------------------------------------------------------
    procedure update_test(p_id                    in svt_stds_standard_tests.id%type default null,
                          p_standard_id           in svt_stds_standard_tests.standard_id%type,
                          p_test_name             in svt_stds_standard_tests.test_name%type,
                          p_display_sequence      in svt_stds_standard_tests.display_sequence%type default null,
                          p_query_clob            in svt_stds_standard_tests.query_clob%type,
                          p_owner                 in svt_stds_standard_tests.owner%type,
                          p_test_code             in svt_stds_standard_tests.test_code%type,
                          p_active_yn             in svt_stds_standard_tests.active_yn%type,
                          p_level_id              in svt_stds_standard_tests.level_id%type,
                          p_mv_dependency         in svt_stds_standard_tests.mv_dependency%type,
                          p_svt_component_type_id in svt_stds_standard_tests.svt_component_type_id%type,
                          p_explanation           in svt_stds_standard_tests.explanation%type,
                          p_fix                   in svt_stds_standard_tests.fix%type,
                          p_version_number        in svt_stds_standard_tests.version_number%type default null,
                          p_version_db            in svt_stds_standard_tests.version_db%type default null
                        );
    

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 13, 2023
-- Synopsis:
--
-- Publish a given svt_stds_standard_tests record 
--
/*
begin
  svt_stds_standard_tests_api.publish_test(p_test_code => :P14_TEST_CODE);
end;
*/
------------------------------------------------------------------------------
    procedure publish_test(p_test_code in svt_stds_standard_tests.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 16, 2023
-- Synopsis:
--
-- Procedure to publish tests in bulk
--
/*
begin
  svt_stds_standard_tests_api.bulk_publish(p_selected_ids => :P5_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
    procedure bulk_publish(p_selected_ids in varchar2);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Oct-31
-- Synopsis:
--
-- Procedure to inactivate tests in bulk
--
/*
begin
  svt_stds_standard_tests_api.bulk_inactivate(p_selected_ids => :P5_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
    procedure bulk_inactivate(p_selected_ids in varchar2);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-15
-- Synopsis:
--
-- Procedure to delete tests in bulk
--
/*
begin
  svt_stds_standard_tests_api.bulk_delete(p_selected_ids => :P5_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
    procedure bulk_delete(p_selected_ids in varchar2);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Oct-31
-- Synopsis:
--
-- Procedure to activate tests in bulk
--
/*
begin
  svt_stds_standard_tests_api.bulk_activate(p_selected_ids => :P5_SELECTED_IDS);
end;
*/
------------------------------------------------------------------------------
    procedure bulk_activate(p_selected_ids in varchar2);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Procedure to delete test
--
/*
begin
  svt_stds_standard_tests_api.delete_test(p_id => :P14_ID,
                                          p_test_code => :P14_TEST_CODE);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test(p_id        in svt_stds_standard_tests.id%type,
                          p_test_code in svt_stds_standard_tests.test_code%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 16, 2023
-- Synopsis:
--
-- overloaded function to get svt_stds_standard_tests record for a given test code
--
/*
set serveroutput on;
declare
l_rec svt_stds_standard_tests%rowtype;
begin
    l_rec := svt_stds_standard_tests_api.get_test_rec(p_test_code => 'UNREACHABLE_PAGE');
    dbms_output.put_line('code :'||l_rec.test_code);
end;
*/
------------------------------------------------------------------------------
    function get_test_rec(p_test_code in svt_stds_standard_tests.test_code%type) 
    return svt_stds_standard_tests%rowtype;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Aug-17
-- Synopsis:
--
-- overloaded function to get svt_stds_standard_tests record for a given test id
--
/*
set serveroutput on;
declare
l_rec svt_stds_standard_tests%rowtype;
begin
    l_rec := svt_stds_standard_tests_api.get_test_rec(p_test_id => :p_test_id);
    dbms_output.put_line('code :'||l_rec.test_code);
end;
*/
------------------------------------------------------------------------------
    function get_test_rec(p_test_id in svt_stds_standard_tests.id%type) 
    return svt_stds_standard_tests%rowtype;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 31, 2023
-- Synopsis:
--
-- Function to duplicate a standard (p14) 
--
/*
begin
  svt_stds_standard_tests_api.duplicate_standard (
                                    p_from_test_code  => :P16_FROM_TEST_CODE,
                                    p_to_test_code    => :P16_TO_TEST_CODE
                                );
end;
*/
------------------------------------------------------------------------------
  procedure duplicate_standard (
                                    p_from_test_code in svt_stds_standard_tests.test_code%type,
                                    p_to_test_code   in svt_stds_standard_tests.test_code%type
                                );


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 2, 2023
-- Synopsis:
--
-- Function to get the pk of a svt_stds_standard_tests record, given a test code
--
/*
select svt_stds_standard_tests_api.get_test_id (p_test_code => :P14_TEST_CODE)
from dual
*/
------------------------------------------------------------------------------
    function get_test_id (p_test_code in svt_stds_standard_tests.test_code%type)
    return svt_stds_standard_tests.id%type deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Aug-17
-- Synopsis:
--
-- Overloaded Function to get the standard_id of a svt_stds_standard_tests record, given a test id
--
/*
select svt_stds_standard_tests_api.get_standard_id (p_test_id => :p_test_id)
from dual
*/
------------------------------------------------------------------------------
    function get_standard_id (p_test_id in svt_stds_standard_tests.id%type)
    return svt_stds_standard_tests.standard_id%type deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-1
--
-- OVerloaded Function to get the standard_id of a svt_stds_standard_tests record, given a test code
--
/*
select svt_stds_standard_tests_api.get_standard_id (p_test_code => :p_test_code)
from dual
*/
------------------------------------------------------------------------------
    function get_standard_id (p_test_code in svt_stds_standard_tests.test_code%type)
    return svt_stds_standard_tests.standard_id%type deterministic;

 
 ------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Function to query the V_SVT_STDS_STANDARD_TESTS view with some additional columns
-- namely the download test sample file
--
/*
select *
from svt_stds_standard_tests_api.v_svt_stds_standard_tests()
*/
------------------------------------------------------------------------------
  function v_svt_stds_standard_tests (
                     p_standard_id        in svt_stds_standard_tests.standard_id%type default null,
                     p_active_yn          in svt_stds_standard_tests.active_yn%type default null,
                     p_published_yn       in varchar2 default null,
                     p_standard_active_yn in varchar2 default null
              )
  return v_svt_stds_standard_tests_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 23, 2023
-- Synopsis:
--
-- function to retrieve the nt_name for a given test_code
--
/*
select svt_stds_standard_tests_api.nt_name(p_test_code => 'APP_AUTH')
from dual
*/
------------------------------------------------------------------------------
  function nt_name(p_test_code in svt_stds_standard_tests.test_code%type)
  return svt_nested_table_types.nt_name%type
  deterministic 
  result_cache;

end svt_stds_standard_tests_api;
/
--rollback drop package svt_stds_standard_tests_api;
