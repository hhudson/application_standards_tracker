
/*
- UTPLSQL packages should be in the 'UT_CARS' 
- they should be names after the concatenation of a package name + a procedure + '_UT'
*/

create or replace force view v_ast_db_utplsql_package_naming as
with deflt as (
   select eba_stds_parser.default_app_id() application_id
   from dual)
select 
case when ao.owner != 'UT_CARS'
     then 'N'
     else case when ap.object_name is not null
               then 'Y'
               else 'N'
               end
     end pass_yn,
apex_string.format('%0:%1:%2:%3', deflt.application_id, ao.object_name, ao.object_type, 1) reference_code,
deflt.application_id,
ao.owner, ao.object_name    
from all_objects ao
left join all_procedures ap on ap.object_name||'_'||ap.procedure_name||'_UT' = ao.object_name
cross join deflt
where ao.object_name like '%\_UT' escape '\'
and ao.object_type = 'PACKAGE'
order by ao.owner, ao.object_name
;

/* No need to :
 * - add application_name
 * - add application status
 * - add application type
 * - join on eba_stds_applications
 */