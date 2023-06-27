--liquibase formatted sql
--changeset view_script:v_dev_apex_table_references stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_dev_apex_table_references
--------------------------------------------------------

create or replace view v_dev_apex_table_references
as
select cast(replace(object_name, ' ','') as varchar2(60)) as object_name
       , application_id
       , application_name
       , page_id
       , process_point
       , region_name
       , cast(source_type as varchar2(12)) as source_type
       , cast(command_type as varchar2(6)) as command_type
  from
    (
      select upper( regexp_replace(translate(dbms_lob.substr(r.region_source, 3750,1), chr(10)||chr(11)||chr(13), ' ')
                    , 'select.*from[[:space:][:blank:]]+([\.a-z_0-9]*).*' , '\1' , 1 , 1 , 'i'))  object_name
           , r.application_id
           , r.application_name
           , r.page_id
           , '' as process_point
           , region_name
           , r.source_type 
           , 'SQL' as command_type
       from apex_application_page_regions    r
          , apex_applications                a
      where r.source_type in ('Form', 'Report', 'Interactive Report')
        and regexp_like(r.region_source,'select.*from[[:space:][:blank:]]+([\.a-z_0-9]*).*' , 'i')
        and query_type_code  = 'SQL'
        and table_name is null
        and r.application_id = a.application_id
      union
      select table_name
           , r.application_id
           , r.application_name
           , r.page_id
           , '' as process_point
           , region_name
           , r.source_type 
           , 'TABLE' as command_type
       from apex_application_page_regions    r
          , apex_applications                a
      where r.source_type in ('Form', 'Report', 'Interactive Report')
        and table_name       is not null
        and query_type_code  = 'TABLE'
        and r.application_id = a.application_id
      union
      select replace(upper(regexp_replace(translate(dbms_lob.substr(process_source, 3750,1), chr(10)||chr(11)||chr(13), ' ')
                     , '^.*[[:space:][:blank:]]*update[[:space:][:blank:]]+(["\.a-z_0-9]*).*', '\1', 1, 1, 'i')), '"','')  object_name
           , p.application_id
           , p.application_name
           , p.page_id
           , p.process_point
           , p.process_name
           , 'Page Process' as source_type 
           , 'UPDATE' as command_type
       from  apex_application_page_proc  p
           , apex_applications           a
      where regexp_like(process_source, '^.*[[:space:][:blank:]]*update[[:space:][:blank:]]+(["\.a-z_0-9]*).*', 'i')
        and p.application_id = a.application_id
      union
      select replace(upper(regexp_replace(translate(dbms_lob.substr(process_source, 3750,1), chr(10)||chr(11)||chr(13), ' ')
                     , '^.*[[:space:][:blank:]]*delete[[:space:][:blank:]]+from[[:space:][:blank:]]+(["\.a-z_0-9]*).*', '\1', 1, 1, 'i')), '"','')  object_name
           , p.application_id
           , p.application_name
           , p.page_id
           , p.process_point
           , p.process_name
           , 'Page Process' as source_type 
           , 'UPDATE' as command_type
       from  apex_application_page_proc  p
           , apex_applications           a
      where regexp_like(process_source, '^.*[[:space:][:blank:]]*delete[[:space:][:blank:]]+from[[:space:][:blank:]]+(["\.a-z_0-9]*).*', 'i') 
        and p.application_id = a.application_id
    )
where length(replace(object_name, ' ','')) < 61
  and not regexp_like(object_name, '[\(\)'']')
  and replace(object_name, ' ','') not in ('DUAL', 'SYS.DUAL', 'OR', 'V')
  and object_name not like 'WWV%'
  and object_name not like 'APEX%'
  and object_name not like 'EBA%'
  and object_name in (select object_name from all_objects)
/
--rollback drop view v_dev_apex_table_references;