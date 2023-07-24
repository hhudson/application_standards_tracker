--liquibase formatted sql
--changeset view_script:v_SVT_component_types stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_SVT_component_types
--------------------------------------------------------

create or replace force editionable view v_SVT_component_types as
select id, 
       component_name, 
       component_code, 
       apex_string.format('%0 %1', 
                          p0 => friendly_name, 
                          p1 => '('||component_name||')'
                        ) description
from SVT_component_types
where available_yn = 'Y'
/

--rollback drop view v_SVT_component_types;