select * 
from eba_stds_types
/
update eba_stds_applications
set status_id = 1
where status_id is null
and apex_app_id < 700000
/
--select *
delete
from eba_stds_types
where id not in (10,80)
/
update eba_stds_applications
set type_id = 10
where apex_app_id = 105
/
/
select * 
from eba_stds_applications
where type_id is null
/
select * 
from EBA_STDS_APPLICATIONS
where 1=1
and status_id is null
--and apex_app_id > 15000000 -- 720000
/
select * from table(ut.run('ut_ast_create_and_run_tests'));
/
drop package ut_stds_parser
/
select * 
from all_source
where 1=1
--and text like '--%suite' collate binary_ci
and name = 'UTT_TEST_COVERAGE_PKG'
/
select * 
from  all_objects
where object_type  = 'PACKAGE'
AND object_name like '%UTT%'
--and object_name = 'UTT_TEST_COVERAGE_PKG'
/
begin
execute immediate q'[ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL']';
end;
/
ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:NONE';
/
begin
    dbms_utility.compile_schema(schema => user, compile_all => true);
end;
/
select * 
from all_tab_cols
where column_name like '%SCOPE%'
/
select os.*, os.PLSCOPE_SETTINGS
from USER_PLSQL_OBJECT_SETTINGS os
--where name = 'PLSCOPE_SETTINGS'
;