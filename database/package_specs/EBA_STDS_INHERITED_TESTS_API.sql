--liquibase formatted sql
--changeset package_script:eba_stds_inherited_tests_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package eba_stds_inherited_tests_api
--------------------------------------------------------

create or replace package eba_stds_inherited_tests_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   eba_stds_inherited_tests_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-17 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- procedure to add a record to eba_stds_inherited_tests
--
/*
declare
c_standard_id eba_stds_standards.id%type := 4064835866137640665977205961047451272;
l_parent_standard_id eba_stds_standards.parent_standard_id%type;
l_test_id eba_stds_standard_tests.id%type;
begin
    select parent_standard_id
    into l_parent_standard_id
    from  eba_stds_standards
    where id = c_standard_id;
    
    select id 
    into l_test_id
    from eba_stds_standard_tests
    where standard_id = l_parent_standard_id
    fetch first 1 rows only;
    
    eba_stds_inherited_tests_api.inherit_test (
        p_test_id            => l_test_id,
        p_standard_id        => c_standard_id
    );
end;
*/
------------------------------------------------------------------------------
procedure inherit_test (
    p_test_id            in eba_stds_inherited_tests.test_id%type,
    p_standard_id        in eba_stds_inherited_tests.standard_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure sever the relationship between a standard and a test from it's parent standard  
--
/*
begin
    eba_stds_inherited_tests_api.disinherit (
        p_test_id            => l_test_id,
        p_standard_id        => c_standard_id
    );
end;
*/
------------------------------------------------------------------------------
procedure disinherit (
    p_test_id            in eba_stds_inherited_tests.test_id%type,
    p_standard_id        in eba_stds_inherited_tests.standard_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to delete all records for a given standard_id  
--
/*
begin
    eba_stds_inherited_tests_api.delete_std (p_standard_id => p_standard_id);
end;
*/
------------------------------------------------------------------------------
procedure delete_std (p_standard_id  in eba_stds_inherited_tests.standard_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Aug-21
-- Synopsis:
--
-- Procedure to delete all records for a given test_id  
--
/*
begin
    eba_stds_inherited_tests_api.delete_test (p_test_id => p_test_id);
end;
*/
------------------------------------------------------------------------------
procedure delete_test (p_test_id  in eba_stds_inherited_tests.test_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to add colon-delimited test_ids to eba_stds_inherited_tests
--
/*
begin
    eba_stds_inherited_tests_api.bulk_add(
                    p_test_ids    => :P65_SELECTED_IDS,
                    p_standard_id => :P65_STANDARD_ID
                );
end;
*/
------------------------------------------------------------------------------
procedure bulk_add(p_test_ids    in varchar2,
                   p_standard_id in eba_stds_inherited_tests.standard_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to remove colon-delimited test_ids to eba_stds_inherited_tests
--
/*
begin
    eba_stds_inherited_tests_api.bulk_remove(
                    p_test_ids    => :P65_SELECTED_IDS,
                    p_standard_id => :P65_STANDARD_ID
                );
end;
*/
------------------------------------------------------------------------------
procedure bulk_remove(p_test_ids    in varchar2,
                      p_standard_id in eba_stds_inherited_tests.standard_id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 18, 2023
-- Synopsis:
--
-- Procedure to pass on every test from one standard to another 
--
/*
begin
    eba_stds_inherited_tests_api.inherit_all(
                      p_parent_standard_id => p_parent_standard_id,
                      p_standard_id        => p_standard_id
                    );
end;
*/
------------------------------------------------------------------------------
procedure inherit_all(p_parent_standard_id in eba_stds_inherited_tests.parent_standard_id%type,
                      p_standard_id        in eba_stds_inherited_tests.standard_id%type);

end eba_stds_inherited_tests_api;
/
--rollback drop package eba_stds_inherited_tests_api;
