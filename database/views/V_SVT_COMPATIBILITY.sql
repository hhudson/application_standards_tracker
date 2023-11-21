--liquibase formatted sql
--changeset view_script:v_svt_compatibility stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_svt_compatibility
--------------------------------------------------------

create or replace force editionable view v_svt_compatibility as
select sc.id,
       sc.compatibility_mode,
       sc.compatibility_desc,
       sc.display_order,
       sc.type_name,
       apex_string.format(
        '%0%1',
        p0 => sc.type_name,
        p1 => case when sc.type_name != 'NA'
                   then ' ('||sc.compatibility_desc||')'
                   end
       ) compatibility_name,
       sc.created,
       sc.created_by,
       sc.updated,
       sc.updated_by
from svt_compatibility sc
/

--rollback drop view v_svt_compatibility;