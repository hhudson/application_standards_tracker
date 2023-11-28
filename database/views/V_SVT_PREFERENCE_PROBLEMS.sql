--liquibase formatted sql
--changeset view_script:V_SVT_PREFERENCE_PROBLEMS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_PREFERENCE_PROBLEMS
--------------------------------------------------------

create or replace force editionable view V_SVT_PREFERENCE_PROBLEMS as
with ppref as (select replace(item_name, 'P45_') preference_name
                from apex_application_page_items
                where page_id = 45
                and application_name = 'Standard Violation Tracker'
                and item_name not in ('P45_SVT_TIME_ZONE')
                and coalesce(condition_type_code,'NA') != 'NEVER'),
    stmt as (select 'The following preferences have not been configured : ' intro, listagg(ppref.preference_name, ', ') within group (order by ppref.preference_name) prefs     
                from ppref
                left outer join v_apex_workspace_preferences awp on awp.preference_name = ppref.preference_name
                where awp.preference_value is null)
select intro||prefs stmt
from stmt
where prefs is not null
/

--rollback drop view V_SVT_PREFERENCE_PROBLEMS;