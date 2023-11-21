--liquibase formatted sql
--changeset package_script:SVT_COMPONENT_TYPES_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_COMPONENT_TYPES_API
--------------------------------------------------------

create or replace package SVT_COMPONENT_TYPES_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_COMPONENT_TYPES_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13 - created

/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P7_ID := svt_component_types_api.insert_cmp (
                    p_component_name    => :P7_COMPONENT_NAME,
                    p_component_code    => :P7_COMPONENT_CODE,
                    p_available_yn      => :P7_AVAILABLE_YN,
                    p_nt_type_id        => :P7_NT_TYPE_ID,
                    p_pk_value          => :P7_PK_VALUE,
                    p_parent_pk_value   => :P7_PARENT_PK_VALUE,
                    p_template_url      => :P7_TEMPLATE_URL,
                    p_friendly_name     => :P7_FRIENDLY_NAME,
                    p_name_column       => :P7_NAME_COLUMN,
                    p_addl_cols         => :P7_ADDL_COLS
                );
    when 'U' then
      svt_component_types_api.update_cmp (
            p_id                 => :P7_ID,
            p_component_name    => :P7_COMPONENT_NAME,
            p_component_code    => :P7_COMPONENT_CODE,
            p_available_yn      => :P7_AVAILABLE_YN,
            p_nt_type_id        => :P7_NT_TYPE_ID,
            p_pk_value          => :P7_PK_VALUE,
            p_parent_pk_value   => :P7_PARENT_PK_VALUE,
            p_template_url      => :P7_TEMPLATE_URL,
            p_friendly_name     => :P7_FRIENDLY_NAME,
            p_name_column       => :P7_NAME_COLUMN,
            p_addl_cols         => :P7_ADDL_COLS
        );
    when 'D' then
      svt_component_types_api.delete_cmp(p_id => :P7_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to insert records into SVT_COMPONENT_TYPES
--
------------------------------------------------------------------------------
    function insert_cmp (
       p_component_name    in svt_component_types.component_name%type,
       p_component_code    in svt_component_types.component_code%type,
       p_available_yn      in svt_component_types.available_yn%type,
       p_nt_type_id        in svt_component_types.nt_type_id%type,
       p_pk_value          in svt_component_types.pk_value%type,
       p_parent_pk_value   in svt_component_types.parent_pk_value%type,
       p_template_url      in svt_component_types.template_url%type,
       p_friendly_name     in svt_component_types.friendly_name%type,
       p_name_column       in svt_component_types.name_column%type,
       p_addl_cols         in svt_component_types.addl_cols%type
    ) return svt_component_types.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to update records into SVT_COMPONENT_TYPES
--
------------------------------------------------------------------------------
    procedure update_cmp (
       p_id                in svt_component_types.id%type,
       p_component_name    in svt_component_types.component_name%type,
       p_component_code    in svt_component_types.component_code%type,
       p_available_yn      in svt_component_types.available_yn%type,
       p_nt_type_id        in svt_component_types.nt_type_id%type,
       p_pk_value          in svt_component_types.pk_value%type,
       p_parent_pk_value   in svt_component_types.parent_pk_value%type,
       p_template_url      in svt_component_types.template_url%type,
       p_friendly_name     in svt_component_types.friendly_name%type,
       p_name_column       in svt_component_types.name_column%type,
       p_addl_cols         in svt_component_types.addl_cols%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to delete records into SVT_COMPONENT_TYPES
--
------------------------------------------------------------------------------
    procedure delete_cmp (
        p_id in svt_component_types.id%type
    );


end SVT_COMPONENT_TYPES_API;
/
--rollback drop package SVT_COMPONENT_TYPES_API;
