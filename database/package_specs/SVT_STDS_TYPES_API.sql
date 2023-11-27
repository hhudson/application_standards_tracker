--liquibase formatted sql
--changeset package_script:svt_stds_types_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package svt_stds_types_api
--------------------------------------------------------

create or replace package svt_stds_types_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-18 - created
---------------------------------------------------------------------------- 
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P24_ID := svt_stds_types_api.insert_typ (
                    p_display_sequence => :P24_DISPLAY_SEQUENCE,
                    p_type_name        => :P24_TYPE_NAME,
                    p_type_code        => :P24_TYPE_CODE,
                    p_description      => :P24_DESCRIPTION,
                    p_active_yn        => :P24_ACTIVE_YN
                );
    when 'U' then
      svt_stds_types_api.update_typ(
            p_id               => :P24_ID,
            p_display_sequence => :P24_DISPLAY_SEQUENCE,
            p_type_name        => :P24_TYPE_NAME,
            p_type_code        => :P24_TYPE_CODE,
            p_description      => :P24_DESCRIPTION,
            p_active_yn        => :P24_ACTIVE_YN
        );
    when 'D' then
      svt_stds_types_api.delete_typ(p_id => :P24_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to insert records into SVT_STDS_TYPES
--
------------------------------------------------------------------------------
    function insert_typ (
       p_id               in svt_stds_types.id%type default null,
       p_display_sequence in svt_stds_types.display_sequence%type,
       p_type_name        in svt_stds_types.type_name%type,
       p_type_code        in svt_stds_types.type_code%type,
       p_description      in svt_stds_types.description%type,
       p_active_yn        in svt_stds_types.active_yn%type
    ) return svt_stds_types.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to update records into SVT_STDS_TYPES
--
------------------------------------------------------------------------------
    procedure update_typ (
       p_id               in svt_stds_types.id%type,
       p_display_sequence in svt_stds_types.display_sequence%type,
       p_type_name        in svt_stds_types.type_name%type,
       p_type_code        in svt_stds_types.type_code%type,
       p_description      in svt_stds_types.description%type,
       p_active_yn        in svt_stds_types.active_yn%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to delete records into SVT_STDS_TYPES
--
------------------------------------------------------------------------------
    procedure delete_typ (
        p_id in svt_stds_types.id%type
    );
    
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 18, 2023
-- Synopsis:
--
-- function to return id for a given type code
--
/*
select svt_stds_types_api.get_type_id (p_type_code => 'HUMANX') type_id
from dual
*/
------------------------------------------------------------------------------
    function get_type_id (p_type_code in svt_stds_types.type_code%type)
    return svt_stds_types.id%type;

end svt_stds_types_api;
/
--rollback drop package svt_stds_types_api;
