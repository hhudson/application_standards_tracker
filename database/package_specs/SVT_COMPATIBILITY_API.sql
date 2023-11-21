--liquibase formatted sql
--changeset package_script:svt_compatibility_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package svt_compatibility_api
--------------------------------------------------------

create or replace package svt_compatibility_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_compatibility_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13- created

/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P46_ID := svt_compatibility_api.insert_cmp (
                    p_display_order      => :P46_DISPLAY_ORDER,
                    p_compatibility_mode => :P46_COMPATIBILITY_MODE,
                    p_compatibility_desc => :P46_COMPATIBILITY_DESC,
                    p_type_name          => :P46_TYPE_NAME
                );
    when 'U' then
      svt_compatibility_api.update_cmp (
            p_id                 => :P46_ID,
            p_display_order      => :P46_DISPLAY_ORDER,
            p_compatibility_mode => :P46_COMPATIBILITY_MODE,
            p_compatibility_desc => :P46_COMPATIBILITY_DESC,
            p_type_name          => :P46_TYPE_NAME
        );
    when 'D' then
      svt_compatibility_api.delete_cmp(p_id => :P46_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to insert records into SVT_COMPATIBILITY
--
------------------------------------------------------------------------------
    function insert_cmp (
        p_display_order      in svt_compatibility.display_order%type,
        p_compatibility_mode in svt_compatibility.compatibility_mode%type,
        p_compatibility_desc in svt_compatibility.compatibility_desc%type,
        p_type_name          in svt_compatibility.type_name%type
    ) return svt_compatibility.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to update records into SVT_COMPATIBILITY
--
------------------------------------------------------------------------------
    procedure update_cmp (
        p_id                 in svt_compatibility.id%type,
        p_display_order      in svt_compatibility.display_order%type,
        p_compatibility_mode in svt_compatibility.compatibility_mode%type,
        p_compatibility_desc in svt_compatibility.compatibility_desc%type,
        p_type_name          in svt_compatibility.type_name%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to delete records into SVT_COMPATIBILITY
--
------------------------------------------------------------------------------
    procedure delete_cmp (
        p_id in svt_compatibility.id%type
    );

end svt_compatibility_api;
/
--rollback drop package svt_compatibility_api;
