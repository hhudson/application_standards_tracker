--liquibase formatted sql
--changeset view_script:SVT_AHA_APP_NUMBERS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View SVT_AHA_APP_NUMBERS

/*
merge into eba_stds_applications e
using (select application_id, type_id from svt_aha_app_numbers where type_id is not null) h
on (e.apex_app_id = h.application_id)
when matched then
update set e.type_id = h.type_id
when not matched then
insert (apex_app_id, type_id)
values (h.application_id, h.type_id);

eba_stds_types
*/
--------------------------------------------------------

create or replace force editionable view SVT_AHA_APP_NUMBERS as
with std as (
  select  eba_stds_types_api.get_type_id ('SCRATCH')    type_id,	'SCRATCH'    type_code,	101      lower_bound, 999      upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('DEVUTIL')    type_id,	'DEVUTIL'    type_code,	2000     lower_bound, 2999     upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('LIB_TEMPL')  type_id,	'LIB_TEMPL'  type_code,	9000     lower_bound, 9999     upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('DEMO')       type_id,	'DEMO'       type_code,	20000000 lower_bound, 20999999 upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('HUMANX')     type_id,	'HUMANX'     type_code,	10000000 lower_bound, 12999999 upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('COMMON')     type_id,	'COMMON'     type_code,	1400000 lower_bound,  1499999  upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('SCHEDULING') type_id,	'SCHEDULING' type_code,	1300000 lower_bound,  1399999  upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('DOCMGMT')    type_id,	'DOCMGMT'    type_code,	1200000 lower_bound,  1299999  upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('REGSTRN')    type_id,	'REGSTRN'    type_code,	1100000 lower_bound,  1199999  upper_bound from dual
  union all
  select  eba_stds_types_api.get_type_id ('SYSADMIN')   type_id,	'SYSADMIN'   type_code,	1000000 lower_bound,  1099999  upper_bound from dual
) 
  select aa.application_id, 
         aa.application_name, 
         std.type_code, 
         std.type_id, 
         est.type_name, 
         est.description,
         est.active_yn type_active_yn,
         esa.active_yn app_active_yn
  from apex_applications aa
  left join std on aa.application_id between std.lower_bound and std.upper_bound
  left join eba_stds_types est on est.id = std.type_id
  left join eba_stds_applications esa on esa.apex_app_id = aa.application_id
/

--rollback drop view SVT_AHA_APP_NUMBERS;