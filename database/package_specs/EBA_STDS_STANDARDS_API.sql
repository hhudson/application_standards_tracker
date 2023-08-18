--liquibase formatted sql
--changeset package_script:eba_stds_standards_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package eba_stds_standards_api
--------------------------------------------------------

create or replace package eba_stds_standards_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   eba_stds_standards_api
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
      :P11_ID := eba_stds_standards_api.insert_std (
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
       eba_stds_standards_api.updated_std (
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
      eba_stds_standards_api.delete_std(p_standard_id => :P11_ID);
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
    :P11_ID := eba_stds_standards_api.insert_std (
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
    p_standard_name         in eba_stds_standards.standard_name%type,
    p_description           in eba_stds_standards.description%type,
    p_primary_developer     in eba_stds_standards.primary_developer%type,
    p_implementation        in eba_stds_standards.implementation%type,
    p_date_started          in eba_stds_standards.date_started%type,
    p_standard_group        in eba_stds_standards.standard_group%type,
    p_active_yn             in eba_stds_standards.active_yn%type,
    p_compatibility_mode_id in eba_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in eba_stds_standards.parent_standard_id%type
) return eba_stds_standards.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to update a record
--
/*
begin
    eba_stds_standards_api.updated_std (
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
    p_id                    in eba_stds_standards.id%type,
    p_standard_name         in eba_stds_standards.standard_name%type,
    p_description           in eba_stds_standards.description%type,
    p_primary_developer     in eba_stds_standards.primary_developer%type,
    p_implementation        in eba_stds_standards.implementation%type,
    p_date_started          in eba_stds_standards.date_started%type,
    p_standard_group        in eba_stds_standards.standard_group%type,
    p_active_yn             in eba_stds_standards.active_yn%type,
    p_compatibility_mode_id in eba_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in eba_stds_standards.parent_standard_id%type
);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- function to retrieve a row of eba_stds_standards for a given standard id.  
--
/*
set serveroutput on
declare
l_rec eba_stds_standards%rowtype;
begin
    l_rec := eba_stds_standards_api.get_rec (p_standard_id => 1);
    dbms_output.put_line('standard name :'||l_rec.standard_name);
end;
*/
------------------------------------------------------------------------------
    function get_rec (p_standard_id in eba_stds_standards.id%type)
    return eba_stds_standards%rowtype;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 17, 2023
-- Synopsis:
--
-- Procedure to delete a standard 
--
/*
begin
    eba_stds_standards_api.delete_std(p_standard_id => :P11_ID);
end;
*/
------------------------------------------------------------------------------
    procedure delete_std (p_standard_id in eba_stds_standards.id%type);

end eba_stds_standards_api;
/
--rollback drop package eba_stds_standards_api;
