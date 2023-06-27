--liquibase formatted sql
--changeset package_script:CHANGEME stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package CHANGEME
--------------------------------------------------------

create or replace package CHANGEME authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   CHANGEME
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 


end CHANGEME;
/
--rollback drop package CHANGEME;
