--liquibase formatted sql
--changeset package_script:SVT_STDS_APPLICATIONS_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_STDS_APPLICATIONS_API
--------------------------------------------------------

create or replace package SVT_STDS_APPLICATIONS_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_APPLICATIONS_API
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
      :P161_PK_ID := svt_stds_applications_api.insert_app (
                    p_apex_app_id       => :P161_APEX_APP_ID,
                    p_default_developer => :P161_DEFAULT_DEVELOPER,
                    p_type_id           => :P161_TYPE_ID,
                    p_notes             => :P161_NOTES,
                    p_active_yn         => :P161_ACTIVE_YN
                );
    when 'U' then
      svt_stds_applications_api.update_app(
            p_id                => :P161_PK_ID,
            p_apex_app_id       => :P161_APEX_APP_ID,
            p_default_developer => :P161_DEFAULT_DEVELOPER,
            p_type_id           => :P161_TYPE_ID,
            p_notes             => :P161_NOTES,
            p_active_yn         => :P161_ACTIVE_YN
        );
    when 'D' then
      svt_stds_applications_api.delete_app(p_id => :P161_PK_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to insert records into SVT_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    function insert_app (
        p_id                in svt_stds_applications.pk_id%type default null,
        p_apex_app_id       in svt_stds_applications.apex_app_id%type,
        p_default_developer in svt_stds_applications.default_developer%type,
        p_type_id           in svt_stds_applications.type_id%type,
        p_notes             in svt_stds_applications.notes%type,
        p_active_yn         in svt_stds_applications.active_yn%type default 'Y'
    ) return svt_stds_applications.pk_id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to update records into SVT_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    procedure update_app (
        p_id                in svt_stds_applications.pk_id%type,
        p_apex_app_id       in svt_stds_applications.apex_app_id%type,
        p_default_developer in svt_stds_applications.default_developer%type,
        p_type_id           in svt_stds_applications.type_id%type,
        p_notes             in svt_stds_applications.notes%type,
        p_active_yn         in svt_stds_applications.active_yn%type default 'Y'
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to delete records into SVT_STDS_APPLICATIONS
--
------------------------------------------------------------------------------
    procedure delete_app (
        p_id in svt_stds_applications.pk_id%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 29, 2023
-- Synopsis:
--
-- Function to return the number of active, registered applications to scan
--
/*
select svt_stds_applications_api.active_app_count
from dual
*/
------------------------------------------------------------------------------
    function active_app_count return pls_integer;

end SVT_STDS_APPLICATIONS_API;
/
--rollback drop package SVT_STDS_APPLICATIONS_API;
