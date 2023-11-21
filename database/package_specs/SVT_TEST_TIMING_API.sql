--liquibase formatted sql
--changeset package_script:svt_test_timing_api stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package svt_test_timing_api
--------------------------------------------------------

create or replace package svt_test_timing_api authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_test_timing_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-9 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 9, 2023
-- Synopsis:
--
-- Procedure to insert an timing record into   svt_test_timing
--
/*
begin
    svt_test_timing_api.insert_timing('BLERG', 1);
end;
*/
------------------------------------------------------------------------------
    procedure insert_timing(p_test_code in svt_test_timing.test_code%type,
                            p_seconds   in svt_test_timing.elapsed_seconds%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 9, 2023
-- Synopsis:
--
-- Procedure to clear excessive timing records - deleting any records older than a month
--
/*
begin
    svt_test_timing_api.purge_old;
end;
*/
------------------------------------------------------------------------------
    procedure purge_old;

end svt_test_timing_api;
/
--rollback drop package svt_test_timing_api;
