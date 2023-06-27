--liquibase formatted sql
--changeset view_script:V_AST_FLOW_DICTIONARY_VIEWS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_AST_FLOW_DICTIONARY_VIEWS
--------------------------------------------------------

create or replace force editionable view V_AST_FLOW_DICTIONARY_VIEWS as
select apex_string.format('%0 (%1)', pk_column_name, view_name) component_desc, 
      component_type_id,
      pk_column_name, 
      display_expression,
      link_url,
      view_name
from ast_flow_dictionary_views
where (link_url is not null or component_type_id is not null)
/

--rollback drop view V_AST_FLOW_DICTIONARY_VIEWS;