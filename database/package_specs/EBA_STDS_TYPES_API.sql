--liquibase formatted sql
--changeset package_script:eba_stds_types_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package eba_stds_types_api
--------------------------------------------------------

create or replace package eba_stds_types_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   eba_stds_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-18 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 18, 2023
-- Synopsis:
--
-- function to return id for a given type code
--
/*
select eba_stds_types_api.get_type_id (p_type_code => 'HUMANX') type_id
from dual
*/
------------------------------------------------------------------------------
function get_type_id (p_type_code in eba_stds_types.type_code%type)
return eba_stds_types.id%type;

end eba_stds_types_api;
/
--rollback drop package eba_stds_types_api;
