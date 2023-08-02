--liquibase formatted sql
--changeset view_script:V_SVT_SERT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_SERT
--------------------------------------------------------

create or replace force editionable view V_SVT_SERT as
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
from SVT_APEX_SERT_UTIL.V_SVT_SERT()
/

--rollback drop view v_svt_sert;