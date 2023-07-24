--liquibase formatted sql
--changeset view_script:V_SVT_SERT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_SERT
--------------------------------------------------------

create or replace force editionable view v_SVT_sert as
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
from SVT_apex_sert_util.v_SVT_sert()
/

--rollback drop view v_SVT_sert;