--liquibase formatted sql
--changeset package_script:SVT_STANDARDS_URGENCY_LEVEL_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_STANDARDS_URGENCY_LEVEL_API
--------------------------------------------------------

create or replace package SVT_STANDARDS_URGENCY_LEVEL_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STANDARDS_URGENCY_LEVEL_API
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
      :P50_ID := svt_standards_urgency_level_api.insert_ul (
                    p_urgency_level => :P50_URGENCY_LEVEL,
                    p_urgency_name  => :P50_URGENCY_NAME
                );
    when 'U' then
      svt_standards_urgency_level_api.update_ul(
            p_id            => :P50_ID,
            p_urgency_level => :P50_URGENCY_LEVEL,
            p_urgency_name  => :P50_URGENCY_NAME
        );
    when 'D' then
      svt_standards_urgency_level_api.delete_ul(p_id => :P50_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to insert records into SVT_STANDARDS_URGENCY_LEVEL
--
------------------------------------------------------------------------------
    function insert_ul (
        p_id            in svt_standards_urgency_level.id%type default null,
        p_urgency_level in svt_standards_urgency_level.urgency_level%type,
        p_urgency_name  in svt_standards_urgency_level.urgency_name%type
    ) return svt_standards_urgency_level.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to update records into SVT_STANDARDS_URGENCY_LEVEL
--
------------------------------------------------------------------------------
    procedure update_ul (
        p_id            in svt_standards_urgency_level.id%type,
        p_urgency_level in svt_standards_urgency_level.urgency_level%type,
        p_urgency_name  in svt_standards_urgency_level.urgency_name%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-9
-- Synopsis:
--
-- Procedure to delete records into SVT_STANDARDS_URGENCY_LEVEL
--
------------------------------------------------------------------------------
    procedure delete_ul (
        p_id in svt_standards_urgency_level.id%type
    );

end SVT_STANDARDS_URGENCY_LEVEL_API;
/
--rollback drop package SVT_STANDARDS_URGENCY_LEVEL_API;
