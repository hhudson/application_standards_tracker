--liquibase formatted sql
--changeset package_script:EBA_STDS_APPLICATIONS_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package EBA_STDS_APPLICATIONS_API
--------------------------------------------------------

create or replace package EBA_STDS_APPLICATIONS_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   EBA_STDS_APPLICATIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-9 - created
---------------------------------------------------------------------------- 
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P161_PK_ID := eba_stds_applications_api.insert_app (
                    p_apex_app_id       => :P161_APEX_APP_ID,
                    p_default_developer => :P161_DEFAULT_DEVELOPER,
                    p_type_id           => :P161_TYPE_ID,
                    p_notes             => :P161_NOTES,
                    p_active_yn         => :P161_ACTIVE_YN
                );
    when 'U' then
      eba_stds_applications_api.update_app(
            p_id                => :P161_PK_ID,
            p_apex_app_id       => :P161_APEX_APP_ID,
            p_default_developer => :P161_DEFAULT_DEVELOPER,
            p_type_id           => :P161_TYPE_ID,
            p_notes             => :P161_NOTES,
            p_active_yn         => :P161_ACTIVE_YN
        );
    when 'D' then
      eba_stds_applications_api.delete_app(p_id => :P161_PK_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to insert records into EBA_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    function insert_app (
        p_id                in eba_stds_applications.pk_id%type default null,
        p_apex_app_id       in eba_stds_applications.apex_app_id%type,
        p_default_developer in eba_stds_applications.default_developer%type,
        p_type_id           in eba_stds_applications.type_id%type,
        p_notes             in eba_stds_applications.notes%type,
        p_active_yn         in eba_stds_applications.active_yn%type default 'Y'
    ) return eba_stds_applications.pk_id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to update records into EBA_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    procedure update_app (
        p_id                in eba_stds_applications.pk_id%type,
        p_apex_app_id       in eba_stds_applications.apex_app_id%type,
        p_default_developer in eba_stds_applications.default_developer%type,
        p_type_id           in eba_stds_applications.type_id%type,
        p_notes             in eba_stds_applications.notes%type,
        p_active_yn         in eba_stds_applications.active_yn%type default 'Y'
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to delete records into EBA_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    procedure delete_app (
        p_id in eba_stds_applications.pk_id%type
    );


end EBA_STDS_APPLICATIONS_API;
/
--rollback drop package EBA_STDS_APPLICATIONS_API;
