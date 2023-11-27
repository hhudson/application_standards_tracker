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

comment on table SVT_COMPONENT_TYPES is q'[a table to complement / replace apex_xxxxxx.wwv_flow_dictionary_views]';
comment on column SVT_COMPONENT_TYPES.component_name  is q'[apex_xxxxxx.wwv_flow_dictionary_views.view_name]';
comment on column SVT_COMPONENT_TYPES.nt_type_id  is q'[svt_nested_table_types.id]';
comment on column SVT_COMPONENT_TYPES.pk_value  is q'[apex_xxxxxx.wwv_flow_dictionary_views.pk_column_name with some overwriting]';
comment on column SVT_COMPONENT_TYPES.parent_pk_value  is q'[column in apex_xxxxxx.wwv_flow_dictionary_views.view_name which refs the pk of the parent view]';
comment on column SVT_COMPONENT_TYPES.template_url  is q'[apex_xxxxxx.wwv_flow_dictionary_views.link_url - no overwriting]';
comment on column SVT_COMPONENT_TYPES.friendly_name  is q'[a human-readable, short name]';
comment on column SVT_COMPONENT_TYPES.name_column  is q'[apex_xxxxxx.wwv_flow_dictionary_views.display_expression with some overwriting]';
comment on column SVT_COMPONENT_TYPES.addl_cols  is q'[additional columns to bring into the default query]';
comment on column SVT_COMPONENT_TYPES.component_type_id  is q'[apex_xxxxxx.wwv_flow_dictionary_views.component_type_id]';
comment on column SVT_COMPONENT_TYPES.fdv_id  is q'[apex_xxxxxx.wwv_flow_dictionary_views.id]';
comment on column SVT_COMPONENT_TYPES.fdv_parent_view_id  is q'[apex_xxxxxx.wwv_flow_dictionary_views.parent_view_id]';
