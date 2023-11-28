--liquibase formatted sql
--changeset view_script:V_SVT_PROBLEM_ASSIGNEES stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_PROBLEM_ASSIGNEES
--------------------------------------------------------

create or replace force editionable view V_SVT_PROBLEM_ASSIGNEES as
select assignee, assignee display_assignee
from mv_svt_assignee_count
where assignee not like '%@%'
union all
select assignee, 'null' display_assignee
from mv_svt_assignee_count
where assignee is null
union all
select assignee, assignee display_assignee
from mv_svt_assignee_count
where assignee in (select lower(column_value)
                   from table(apex_string.split(svt_preferences.get('SVT_DO_NOT_ASSIGN'), ':'))
                   )
/

--rollback drop view V_SVT_PROBLEM_ASSIGNEES;