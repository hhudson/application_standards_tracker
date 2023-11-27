--liquibase formatted sql
--changeset view_script:V_SVT_MISSING_BASE_DATA stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_svt_missing_base_data
--------------------------------------------------------

create or replace force editionable view V_SVT_MISSING_BASE_DATA as
with std as (select count(*) rwcount, 'eba_stds_types' tbl_name from sys.dual where exists ( select 1 from eba_stds_types)
             union all
             select count(*) rwcount, 'svt_audit_actions' tbl_name from sys.dual where exists ( select 1 from svt_audit_actions)
             union all
             select count(*) rwcount, 'svt_compatibility' tbl_name from sys.dual where exists ( select 1 from svt_compatibility)
             union all
             select count(*) rwcount, 'svt_component_types' tbl_name from sys.dual where exists ( select 1 from svt_component_types)
             union all
             select count(*) rwcount, 'svt_nested_table_types' tbl_name from sys.dual where exists ( select 1 from svt_nested_table_types)
             union all
             select count(*) rwcount, 'svt_standards_urgency_level' tbl_name from sys.dual where exists ( select 1 from svt_standards_urgency_level)
            )
select tbl_name
from std 
where rwcount = 0
/

--rollback drop view V_SVT_MISSING_BASE_DATA;