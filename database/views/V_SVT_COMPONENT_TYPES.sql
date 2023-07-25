--liquibase formatted sql
--changeset view_script:v_SVT_component_types stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_COMPONENT_TYPES
--------------------------------------------------------

create or replace force editionable view V_SVT_COMPONENT_TYPES as
select id, 
       component_name, 
       component_code, 
       apex_string.format('%0 %1', 
                          p0 => friendly_name, 
                          p1 => '('||component_name||')'
                        ) description
from SVT_COMPONENT_TYPES
where available_yn = 'Y'
/

--rollback drop view V_SVT_COMPONENT_TYPES;