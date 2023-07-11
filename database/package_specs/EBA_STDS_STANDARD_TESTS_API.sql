--liquibase formatted sql
--changeset package_script:eba_stds_standard_tests_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package eba_stds_standard_tests_api
--------------------------------------------------------

create or replace package eba_stds_standard_tests_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   eba_stds_standard_tests_api
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
      :P14_ID := eba_stds_standard_tests_api.insert_test(
                  p_id                    => :P14_ID,
                  p_standard_id           => :P14_STANDARD_ID,
                  p_test_type             => :P14_TEST_TYPE,
                  p_test_name                  => :P14_SHORT_NAME,
                  p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                  p_query_clob            => :P14_QUERY_CLOB,
                  p_owner                 => :P14_OWNER,
                  p_standard_code         => :P14_STANDARD_CODE,
                  p_active_yn             => :P14_ACTIVE_YN,
                  p_level_id              => :P14_LEVEL_ID,
                  p_mv_dependency         => :P14_MV_DEPENDENCY,
                  p_ast_component_type_id => :P14_AST_COMPONENT_TYPE_ID,
                  p_explanation           => :P14_EXPLANATION,
                  p_fix                   => :P14_FIX
                );
    when 'U' then
      eba_stds_standard_tests_api.update_test(
                          p_id                    => :P14_ID,
                          p_standard_id           => :P14_STANDARD_ID,
                          p_test_type             => :P14_TEST_TYPE,
                          p_test_name                  => :P14_SHORT_NAME,
                          p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                          p_query_clob            => :P14_QUERY_CLOB,
                          p_owner                 => :P14_OWNER,
                          p_standard_code         => :P14_STANDARD_CODE,
                          p_active_yn             => :P14_ACTIVE_YN,
                          p_level_id              => :P14_LEVEL_ID,
                          p_mv_dependency         => :P14_MV_DEPENDENCY,
                          p_ast_component_type_id => :P14_AST_COMPONENT_TYPE_ID,
                          p_explanation           => :P14_EXPLANATION,
                          p_fix                   => :P14_FIX
                        );
    when 'D' then
      eba_stds_standard_tests_api.delete_test(p_id => :P14_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jul-10
-- Synopsis:
--
-- Procedure to insert new record into  eba_stds_standard_tests
--
/*
begin
    eba_stds_standard_tests_api.insert_test(
                p_id                    => p_id,
                p_standard_id           => p_standard_id,
                p_test_type             => p_test_type,
                p_test_name             => p_test_name,
                p_display_sequence      => p_display_sequence,
                p_query_clob            => p_query_clob,
                p_owner                 => p_owner,
                p_standard_code         => p_standard_code,
                p_active_yn             => p_active_yn,
                p_level_id              => p_level_id,
                p_mv_dependency         => p_mv_dependency,
                p_ast_component_type_id => p_ast_component_type_id,
                p_explanation           => p_explanation,
                p_fix                   => p_fix
              );
end;
*/
------------------------------------------------------------------------------
  function insert_test(p_id                    in eba_stds_standard_tests.id%type default null,
                       p_standard_id           in eba_stds_standard_tests.standard_id%type,
                       p_test_type             in eba_stds_standard_tests.test_type%type,
                       p_test_name             in eba_stds_standard_tests.test_name%type,
                       p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                       p_query_clob            in eba_stds_standard_tests.query_clob%type,
                       p_owner                 in eba_stds_standard_tests.owner%type,
                       p_standard_code         in eba_stds_standard_tests.standard_code%type,
                       p_active_yn             in eba_stds_standard_tests.active_yn%type,
                       p_level_id              in eba_stds_standard_tests.level_id%type,
                       p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                       p_ast_component_type_id in eba_stds_standard_tests.ast_component_type_id%type,
                       p_explanation           in eba_stds_standard_tests.explanation%type,
                       p_fix                   in eba_stds_standard_tests.fix%type,
                       p_version_number        in eba_stds_standard_tests.version_number%type default null)
  return eba_stds_standard_tests.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- Procedure to insert new record into  eba_stds_standard_tests (called by EBA_STDS_TESTS_LIB_API.install_standard_test)
--
/*
begin
    eba_stds_standard_tests_api.insert_test(
                p_id                    => p_id,
                p_standard_id           => p_standard_id,
                p_test_type             => p_test_type,
                p_test_name             => p_test_name,
                p_display_sequence      => p_display_sequence,
                p_query_clob            => p_query_clob,
                p_owner                 => p_owner,
                p_standard_code         => p_standard_code,
                p_active_yn             => p_active_yn,
                p_level_id              => p_level_id,
                p_mv_dependency         => p_mv_dependency,
                p_ast_component_type_id => p_ast_component_type_id);
end;
*/
------------------------------------------------------------------------------
  procedure insert_test(p_id                    in eba_stds_standard_tests.id%type default null,
                        p_standard_id           in eba_stds_standard_tests.standard_id%type,
                        p_test_type             in eba_stds_standard_tests.test_type%type,
                        p_test_name             in eba_stds_standard_tests.test_name%type,
                        p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                        p_query_clob            in eba_stds_standard_tests.query_clob%type,
                        p_owner                 in eba_stds_standard_tests.owner%type,
                        p_standard_code         in eba_stds_standard_tests.standard_code%type,
                        p_active_yn             in eba_stds_standard_tests.active_yn%type,
                        p_level_id              in eba_stds_standard_tests.level_id%type,
                        p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                        p_ast_component_type_id in eba_stds_standard_tests.ast_component_type_id%type,
                        p_explanation           in eba_stds_standard_tests.explanation%type,
                        p_fix                   in eba_stds_standard_tests.fix%type,
                        p_version_number        in eba_stds_standard_tests.version_number%type default null);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Procedure to update eba_stds_standard_tests
--
/*
begin
  eba_stds_standard_tests_api.update_test(
                          p_id                    => :P14_ID,
                          p_standard_id           => :P14_STANDARD_ID,
                          p_test_type             => :P14_TEST_TYPE,
                          p_test_name             => :P14_SHORT_NAME,
                          p_display_sequence      => :P14_DISPLAY_SEQUENCE,
                          p_query_clob            => :P14_QUERY_CLOB,
                          p_owner                 => :P14_OWNER,
                          p_standard_code         => :P14_STANDARD_CODE,
                          p_active_yn             => :P14_ACTIVE_YN,
                          p_level_id              => :P14_LEVEL_ID,
                          p_mv_dependency         => :P14_MV_DEPENDENCY,
                          p_ast_component_type_id => :P14_AST_COMPONENT_TYPE_ID,
                          p_explanation           => :P14_EXPLANATION,
                          p_fix                   => :P14_FIX
end;
*/
------------------------------------------------------------------------------
    procedure update_test(p_id                    in eba_stds_standard_tests.id%type default null,
                          p_standard_id           in eba_stds_standard_tests.standard_id%type,
                          p_test_type             in eba_stds_standard_tests.test_type%type,
                          p_test_name             in eba_stds_standard_tests.test_name%type,
                          p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                          p_query_clob            in eba_stds_standard_tests.query_clob%type,
                          p_owner                 in eba_stds_standard_tests.owner%type,
                          p_standard_code         in eba_stds_standard_tests.standard_code%type,
                          p_active_yn             in eba_stds_standard_tests.active_yn%type,
                          p_level_id              in eba_stds_standard_tests.level_id%type,
                          p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                          p_ast_component_type_id in eba_stds_standard_tests.ast_component_type_id%type,
                          p_explanation           in eba_stds_standard_tests.explanation%type,
                          p_fix                   in eba_stds_standard_tests.fix%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Procedure to delete test
--
/*
begin
  eba_stds_standard_tests_api.delete_test(p_id => :P14_ID);
end;
*/
------------------------------------------------------------------------------
    procedure delete_test(p_id in eba_stds_standard_tests.id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 16, 2023
-- Synopsis:
--
-- function to get eba_stds_standard_tests record for a given standard code
--
/*
set serveroutput on;
declare
l_rec eba_stds_standard_tests%rowtype;
begin
    l_rec := eba_stds_standard_tests_api.get_test_rec(p_standard_code => 'UNREACHABLE_PAGE');
    dbms_output.put_line('code :'||l_rec.standard_code);
end;
*/
------------------------------------------------------------------------------
    function get_test_rec(p_standard_code in eba_stds_standard_tests.standard_code%type) 
    return eba_stds_standard_tests%rowtype;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 31, 2023
-- Synopsis:
--
-- Function to duplicate a standard (p14) 
--
/*
begin
  eba_stds_standard_tests_api.duplicate_standard (
                                    p_from_standard_code  => :P16_FROM_STANDARD_CODE,
                                    p_to_standard_code    => :P16_TO_STANDARD_CODE
                                );
end;
*/
------------------------------------------------------------------------------
  procedure duplicate_standard (
                                    p_from_standard_code in eba_stds_standard_tests.standard_code%type,
                                    p_to_standard_code   in eba_stds_standard_tests.standard_code%type
                                );


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 2, 2023
-- Synopsis:
--
-- Function to get the pk of a eba_stds_standard_tests record, given a standard code
--
/*
select eba_stds_standard_tests_api.get_test_id (p_standard_code => :P14_STANDARD_CODE)
from dual
*/
------------------------------------------------------------------------------
    function get_test_id (p_standard_code in eba_stds_standard_tests.standard_code%type)
    return eba_stds_standard_tests.id%type;

 
 ------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 10, 2023
-- Synopsis:
--
-- Function to query the V_EBA_STDS_STANDARD_TESTS view with some additional columns
-- namely the download test sample file
--
/*
select *
from eba_stds_standard_tests_api.v_eba_stds_standard_tests()
*/
------------------------------------------------------------------------------
  function v_eba_stds_standard_tests
  return v_eba_stds_standard_tests_nt pipelined;

end eba_stds_standard_tests_api;
/
--rollback drop package eba_stds_standard_tests_api;
