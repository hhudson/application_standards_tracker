--liquibase formatted sql
--changeset view_script:V_DEV_TABLE_ABBREVIATIONS stripComments:false endDelimiter:/ runOnChange:true

----------------------------------------------------------------------------
-- DDL for View V_DEV_TABLE_ABBREVIATIONS                                
--                                                                       
-- View Description:
-- Reports the expected table abbreviations as per the                       
-- DEV_TABLE_ABBREVIATIONS register. Any tables not in the register are      
-- also listed, but the REGISTERED column displays as 'No'. For non          
-- registered tables a suggested abbreviation is provided, which is not      
-- currently in use.                                                         
---------------------------------------------------------------------------- 

create or replace force view v_dev_table_abbreviations
as
select nvl(r.schema_name, u.owner) schema_name
    , u.table_name
    , coalesce(table_domain, dev_support_utils.table_abbreviation(p_table_name => nvl(r.table_name, u.table_name), p_attribute => 'domain')) as table_domain
    , coalesce(table_alias, dev_support_utils.table_abbreviation(p_table_name => nvl(r.table_name, u.table_name), p_attribute => 'alias'))   as table_alias
    , coalesce(table_abbreviation, dev_support_utils.table_abbreviation(p_table_name => nvl(r.table_name, u.table_name)))                    as table_abbreviation
    , cast(decode(r.table_name, null, 'No','Yes') as varchar2(3)) as registered
    , decode(regexp_substr(u.table_name, '^[[A-Z0-9]{3}(_[A-Z]([A-Z0-9])*)*'), u.table_name, 'Yes', 'No') as valid_name_format
    , r.review_status
    , r.system_config_table
    , r.inc_cssap_compliance
    , r.production_table
    , r.comments
    , o.created, o.LAST_ddl_time
    , r.created_on
    , r.created_by
    , r.updated_on
    , r.updated_by
from all_tables              u
   , dev_table_abbreviations r
   , all_objects             o
where u.table_name  = r.table_name(+)
  and u.owner       = r.schema_name (+) 
  and u.owner       = sys_context( 'userenv', 'current_schema' )
  and o.owner       = u.owner
  and o.object_name = u.table_name
  and o.object_type = 'TABLE'
  and (u.owner, u.table_name) not in (select owner, mview_name
                                        from all_mviews l
                                      union all
                                      select log_owner, log_table
                                        from all_mview_logs)
  and u.table_name not like 'SYS_FBA%'
  and u.table_name not like 'APEX$%'
  and u.table_name not like 'EBA%'
  and u.table_name not like 'XXX%'
  and not regexp_like (u.table_name, '^.*_ERR[$][0-9]*')
/
--rollback drop view V_DEV_TABLE_ABBREVIATIONS;