--liquibase formatted sql
--changeset package_script:SVT_ACL stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_ACL
--------------------------------------------------------

create or replace package SVT_ACL authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_ACL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Sep-21 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 21, 2023
-- Synopsis:
--
-- Procedure to add all APEX_WORKSPACE_DEVELOPERS as ACL Readers
--
/*
begin
    svt_acl.add_awd_users;
end;
*/
------------------------------------------------------------------------------
procedure add_awd_users;

end SVT_ACL;
/
--rollback drop package SVT_ACL;
