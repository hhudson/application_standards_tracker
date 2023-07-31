--liquibase formatted sql
--changeset package_script:SVT_URGENCY_LEVEL_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_URGENCY_LEVEL_API
--------------------------------------------------------

create or replace package SVT_URGENCY_LEVEL_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_URGENCY_LEVEL_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-14- created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 14, 2023
-- Synopsis:
--
-- Function to return a default level id
--
/*
select SVT_URGENCY_LEVEL_API.get_default_level_id
from dual
*/
------------------------------------------------------------------------------
function get_default_level_id return svt_standards_urgency_level.id%type;

end SVT_URGENCY_LEVEL_API;
/
--rollback drop package SVT_URGENCY_LEVEL_API;
