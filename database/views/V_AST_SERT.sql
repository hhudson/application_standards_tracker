--liquibase formatted sql
--changeset view_script:V_AST_SERT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_AST_SERT
--------------------------------------------------------

create or replace force editionable view v_ast_sert as
select 
      collection_name,
      collection_sql,
      category_name,
      category_short_name,
      attribute_name,
      attribute_key,
      attribute_id,
      rule_source,
      rule_type,
      when_not_found,
      table_name,
      column_name,
      fix,
      info,
      category_id,
      category_key
from ast_apex_sert_util.v_ast_sert()
/

--rollback drop view v_ast_sert;