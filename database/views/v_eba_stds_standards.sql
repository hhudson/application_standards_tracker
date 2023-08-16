--liquibase formatted sql
--changeset view_script:V_EBA_STDS_STANDARDS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_EBA_STDS_STANDARDS
--------------------------------------------------------

create or replace force editionable view V_EBA_STDS_STANDARDS as
select ess.id,
       ess.standard_name,
       ess.description,
       ess.primary_developer,
       ess.implementation,
       ess.date_started,
       ess.created,
       ess.created_by,
       ess.updated,
       ess.updated_by,
       ess.standard_group,
       ess.active_yn,
       ess.compatibility_mode_id,
       sc.compatibility_mode,
       sc.compatibility_desc,
       sc.type_name,
       apex_string.format('%0%1',
                          p0 => case when sc.type_name = 'NA'
                                     then 'N/A'
                                     when sc.type_name = 'DB'
                                     then 'Database'
                                     else sc.type_name
                                     end,
                          p1 => case when sc.type_name != 'NA'
                                     then ' Version '||sc.compatibility_desc
                                     end) compatibility_text,
       apex_string.format('%0%1%2',
                          p0 => case when sc.type_name != 'NA'
                                     then sc.type_name||' '
                                     end,
                          p1 => ess.standard_name,
                          p2 => case when sc.type_name != 'NA'
                                     then ' ('||sc.compatibility_desc||')'
                                     end
                          ) full_standard_name,
       ess.parent_standard_id
from eba_stds_standards ess
inner join svt_compatibility sc on ess.compatibility_mode_id = sc.id
/

--rollback drop view V_EBA_STDS_STANDARDS;