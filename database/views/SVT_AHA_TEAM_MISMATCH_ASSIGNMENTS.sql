--liquibase formatted sql
--changeset view_script:SVT_AHA_TEAM_MISMATCH_ASSIGNMENTS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View SVT_AHA_TEAM_MISMATCH_ASSIGNMENTS
-- Managed by app 111 in eod1
--------------------------------------------------------

create or replace force editionable view SVT_AHA_TEAM_MISMATCH_ASSIGNMENTS as
with valid_matches as (
    select ad.email, at.name, est.id app_type_id, est.type_code
    from aha_developers ad
    inner join aha_teams at on at.id = ad.aha_team_id
    inner join aha_team_app_types ahat on ahat.aha_team_id = at.id
    inner join eba_stds_types est on est.id = ahat.app_type_id
), intrsn as (
    select  spad.audit_id,
            spad.application_id,
            spad.assignee, 
            spad.application_type assigned_app_type, 
            case when vm.email is null
                then 'N'
                else 'Y'
                end valid_yn
    from v_svt_plsql_apex_audit spad
    inner join aha_team_app_types atat on atat.app_type_id = spad.app_type_id
    left outer join valid_matches vm on spad.assignee = vm.email
                                        and spad.app_type_id = vm.app_type_id
    where spad.issue_category = 'APEX'
)
select distinct assigned_app_type, assignee
from intrsn
where valid_yn = 'N'
/

--rollback drop view SVT_AHA_TEAM_MISMATCH_ASSIGNMENTS;