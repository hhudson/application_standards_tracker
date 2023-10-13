--liquibase formatted sql
--changeset view_script:SVT_AHA_APP_NUMBERS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View SVT_AHA_APP_NUMBERS

/*
merge into eba_stds_applications e
using (select application_id, type_id from svt_aha_app_numbers) h
on (e.apex_app_id = h.application_id)
when matched then
update set e.type_id = h.type_id
when not matched then
insert (apex_app_id, type_id)
values (h.application_id, h.type_id);
*/
--------------------------------------------------------

create or replace force editionable view SVT_AHA_APP_NUMBERS as
with std as (
  select 339973377783791440973984590018923235995 type_id,	'HUMANX'     type_code,	10000000 lower_bound, 12999999 upper_bound from dual
  union all
  select 10033952694170735173448321833219287270  type_id,	'COMMON'     type_code,	1400000 lower_bound,  1499999  upper_bound from dual
  union all
  select 339973605664314942879490287424334241260 type_id,	'SCHEDULING' type_code,	1300000 lower_bound,  1399999  upper_bound from dual
  union all
  select 10018934554691931300795225595364171098  type_id,	'DOCMGMT'    type_code,	1200000 lower_bound,  1299999  upper_bound from dual
  union all
  select 10032902030075269666556679979249838175  type_id,	'REGSTRN'    type_code,	1100000 lower_bound,  1199999  upper_bound from dual
  union all
  select 10018934554693140226614840224538877274  type_id,	'SYSADMIN'   type_code,	1000000 lower_bound,  1099999  upper_bound from dual
) 
  select aa.application_id, std.type_code, std.type_id
  from apex_applications aa
  join std on aa.application_id between std.lower_bound and std.upper_bound
/

--rollback drop view SVT_AHA_APP_NUMBERS;