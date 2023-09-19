--liquibase formatted sql
--changeset view_script:v_svt_nested_table_types stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_svt_nested_table_types
--------------------------------------------------------

create or replace force editionable view v_svt_nested_table_types as
select id, 
       nt_name, 
       object_type, 
       svt_nested_table_types_api.issue_category(p_nt_name => nt_name) issue_category
from svt_nested_table_types
/

--rollback drop view v_svt_nested_table_types;