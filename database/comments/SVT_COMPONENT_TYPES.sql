--liquibase formatted sql
--changeset comment_script:SVT_COMPONENT_TYPES stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_COMPONENT_TYPES.sql
--        Date:  2023-Nov-9
--     Purpose:  Comment DDL for table SVT_COMPONENT_TYPES
--
--------------------------------------------------------------------------------

comment on table SVT_COMPONENT_TYPES is q'[]';
comment on column SVT_COMPONENT_TYPES.component_name  is q'[wwv_flow_dictionary_views.view_name]';
comment on column SVT_COMPONENT_TYPES.component_code  is q'[a way to bridge the gap from previous method]';
