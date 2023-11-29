--liquibase formatted sql
--changeset package_script:svt_stds_standards_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package svt_stds_standards_api
--------------------------------------------------------

create or replace package svt_stds_standards_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_standards_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-17 - created

/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P11_ID := svt_stds_standards_api.insert_std (
                p_standard_name         => :P11_STANDARD_NAME,
                p_description           => :P11_DESCRIPTION,
                p_primary_developer     => :P11_PRIMARY_DEVELOPER,
                p_implementation        => :P11_IMPLEMENTATION,
                p_date_started          => :P11_DATE_STARTED,
                p_standard_group        => :P11_STANDARD_GROUP,
                p_active_yn             => :P11_ACTIVE_YN,
                p_compatibility_mode_id => :P11_COMPATIBILITY_MODE_ID,
                p_parent_standard_id    => :P11_PARENT_STANDARD_ID
        );
    when 'U' then
       svt_stds_standards_api.updated_std (
            p_id                    => :P11_ID,
            p_standard_name         => :P11_STANDARD_NAME,
            p_description           => :P11_DESCRIPTION,
            p_primary_developer     => :P11_PRIMARY_DEVELOPER,
            p_implementation        => :P11_IMPLEMENTATION,
            p_date_started          => :P11_DATE_STARTED,
            p_standard_group        => :P11_STANDARD_GROUP,
            p_active_yn             => :P11_ACTIVE_YN,
            p_compatibility_mode_id => :P11_COMPATIBILITY_MODE_ID,
            p_parent_standard_id    => :P11_PARENT_STANDARD_ID
        );
    when 'D' then
      svt_stds_standards_api.delete_std(p_standard_id => :P11_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- function to created a record
--
/*
begin
    :P11_ID := svt_stds_standards_api.insert_std (
                p_standard_name         => :P11_STANDARD_NAME,
                p_description           => :P11_DESCRIPTION,
                p_primary_developer     => :P11_PRIMARY_DEVELOPER,
                p_implementation        => :P11_IMPLEMENTATION,
                p_date_started          => :P11_DATE_STARTED,
                p_standard_group        => :P11_STANDARD_GROUP,
                p_active_yn             => :P11_ACTIVE_YN,
                p_compatibility_mode_id => :P11_COMPATIBILITY_MODE_ID,
                p_parent_standard_id    => :P11_PARENT_STANDARD_ID
    );
end;
*/
------------------------------------------------------------------------------
function insert_std (
    p_standard_name         in svt_stds_standards.standard_name%type,
    p_description           in svt_stds_standards.description%type,
    p_primary_developer     in svt_stds_standards.primary_developer%type,
    p_implementation        in svt_stds_standards.implementation%type,
    p_date_started          in svt_stds_standards.date_started%type,
    p_standard_group        in svt_stds_standards.standard_group%type,
    p_active_yn             in svt_stds_standards.active_yn%type,
    p_compatibility_mode_id in svt_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in svt_stds_standards.parent_standard_id%type
) return svt_stds_standards.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to update a record
--
/*
begin
    svt_stds_standards_api.updated_std (
        p_id                    => :P11_ID,
        p_standard_name         => :P11_STANDARD_NAME,
        p_description           => :P11_DESCRIPTION,
        p_primary_developer     => :P11_PRIMARY_DEVELOPER,
        p_implementation        => :P11_IMPLEMENTATION,
        p_date_started          => :P11_DATE_STARTED,
        p_standard_group        => :P11_STANDARD_GROUP,
        p_active_yn             => :P11_ACTIVE_YN,
        p_compatibility_mode_id => :P11_COMPATIBILITY_MODE_ID,
        p_parent_standard_id    => :P11_PARENT_STANDARD_ID
    );
end;
*/
------------------------------------------------------------------------------
procedure updated_std (
    p_id                    in svt_stds_standards.id%type,
    p_standard_name         in svt_stds_standards.standard_name%type,
    p_description           in svt_stds_standards.description%type,
    p_primary_developer     in svt_stds_standards.primary_developer%type,
    p_implementation        in svt_stds_standards.implementation%type,
    p_date_started          in svt_stds_standards.date_started%type,
    p_standard_group        in svt_stds_standards.standard_group%type,
    p_active_yn             in svt_stds_standards.active_yn%type,
    p_compatibility_mode_id in svt_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in svt_stds_standards.parent_standard_id%type
);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- function to retrieve a row of svt_stds_standards for a given standard id.  
--
/*
set serveroutput on
declare
l_rec svt_stds_standards%rowtype;
begin
    l_rec := svt_stds_standards_api.get_rec (p_standard_id => 1);
    dbms_output.put_line('standard name :'||l_rec.standard_name);
end;
*/
------------------------------------------------------------------------------
    function get_rec (p_standard_id in svt_stds_standards.id%type)
    return svt_stds_standards%rowtype;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to delete a standard 
--
/*
begin
    svt_stds_standards_api.delete_std(p_standard_id => :P11_ID);
end;
*/
------------------------------------------------------------------------------
    procedure delete_std (p_standard_id in svt_stds_standards.id%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 18, 2023
-- Synopsis:
--
-- Function to get the full name (including compatibility description) for a given standard_id 
--
/*
    select svt_stds_standards_api.get_full_name(p_standard_id => 1) fname
    from dual;
*/
------------------------------------------------------------------------------
    function get_full_name (p_standard_id in svt_stds_standards.id%type)
    return svt_stds_standards.standard_name%type
    deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 9, 2023
-- Synopsis:
--
-- procedure to update svt_stds_standard_tests.avg_exctn_scnds from v_svt_test_timing
--
/*
begin
    svt_stds_standards_api.update_test_avg_time;
end;
*/
------------------------------------------------------------------------------
    procedure update_test_avg_time;

  
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 20, 2023
-- Synopsis:
--
-- Function to return a random but deterministic hex color for a given standard
--
/*
select svt_stds_standards_api.hex_color(p_standard_id => 1) hex
from dual
*/
------------------------------------------------------------------------------
  function hex_color(p_standard_id in svt_stds_standards.id%type)
  return varchar2
  deterministic 
  result_cache;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Function to return the count of active standards
--
/*
select svt_stds_standards_api.active_standard_count
from dual
*/
------------------------------------------------------------------------------
  function active_standard_count return pls_integer;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2023
-- Synopsis:
--
-- Function to return a comma separated list of active standards
--
/*
select svt_stds_standards_api.active_standard_list
from dual
*/
------------------------------------------------------------------------------
    function active_standard_list return varchar2;

end svt_stds_standards_api;
/
--rollback drop package svt_stds_standards_api;
