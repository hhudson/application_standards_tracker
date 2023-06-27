/*
 * Enforcing standards from https://gbuconfluence.us.oracle.com/display/HCGBUDev/SQL+and+PLSQL
 */
create or replace force view v_ast_db_table_naming as
with deflt as (
   select eba_stds_parser.default_app_id() application_id,
          'PLS-DB-0001' src,
          'https://gbuconfluence.us.oracle.com/display/HCGBUDev/APEX+Security+Coding+Standards#APEXSecurityCodingStandards-' base_url
   from dual),
   tabbv as (
      select r.schema_name
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
         , o.created, o.last_ddl_time
         , r.created_on
         , r.created_by
         , r.updated_on
         , r.updated_by
         , o.object_type
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
   )
select 
case when ta.valid_name_format = 'Yes'
     then 'Y'
     else 'N'
     end as pass_yn,
apex_string.format('%0:%1:%2:%3', 
                   s.application_id, 
                   ta.table_name, 
                   ta.object_type, 
                   1
                  ) reference_code,
s.application_id,
s.src src,
s.base_url||s.src standard_ref_link,
ta.table_name,
ta.table_domain,
ta.table_alias,
ta.table_abbreviation,
ta.registered,
ta.production_table,
ta.inc_cssap_compliance,
ta.system_config_table,
ta.created,
ta.last_ddl_time,
sysdate - ta.created as table_days_old
from tabbv ta --v_dev_table_abbreviations ta
cross join deflt s
where ta.registered    = 'No'
and ta.table_name not in (select table_name
                          from dev_blacklisted_tables)
and ta.table_name not like '%XXX%'
;