select * from table(ut.run('ut_ast_create_and_run_tests'));
/
select apex_string.format('drop view %0;',lower(view_name)) stmt
from user_views
where view_name like 'V_XXX%'
order by view_name
/
declare
gc_dummy_view_base   constant user_views.view_name%type := 'V_XXX_DROP_ME_';
gc_valid_view_sql    constant varchar2(512) := 'select 1 pass_fail, 1 reference_code, 1 application_id from dual';
gc_dummy_name        constant eba_stds_standard_tests.name%type := 'DUMMY';
gc_fail_report       constant eba_stds_standard_tests.test_type%type := 'FAIL_REPORT';
  
c_view_name   constant user_views.view_name%type := gc_dummy_view_base||sys_guid();
c_standard_id constant eba_stds_standards.id%type := dbms_random.random;
c_type_id     constant eba_stds_types.id%type := dbms_random.random;
c_app_id      constant apex_applications.application_id%type := 17562111; --dbms_random.random;
l_test_count  number := 0;
begin

delete from eba_stds_standard_type_ref where standard_id in (select id from eba_stds_standards where name = gc_dummy_name);
delete from eba_stds_standard_tests where name = gc_dummy_name;
delete from eba_stds_standards where name = gc_dummy_name;
delete from eba_stds_applications where type_id in (select id from eba_stds_types where name = gc_dummy_name);
delete from eba_stds_types where name = gc_dummy_name;

end;
/
select * 
from eba_stds_types
/
drop view v_xxx_drop_me_918055512;
drop view v_xxx_drop_me_dae903520cabd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cadd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cb9d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520ccbd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cccd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520ccdd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cced7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520ccfd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cd0d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cd1d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cd3d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cd4d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cd6d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cd8d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cdad7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cddd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520ce0d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520ce3d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520ce6d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cead7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cebd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cefd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cf3d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cf7d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520cfbd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520d00d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520d71d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520dd7d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e3dd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e48d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e53d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e5ed7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e69d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e74d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e7fd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e8ad7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520e95d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520efdd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520efed7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520effd7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520f00d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520f61d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520f62d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520f63d7c1e053fb290a0a2b62;
drop view v_xxx_drop_me_dae903520f64d7c1e053fb290a0a2b62;
/
select *
from eba_stds_standards nf
inner join eba_stds_standard_type_ref nftr on nf.id = nftr.standard_id
inner join eba_stds_applications na on nftr.type_id = na.type_id
inner join apex_applications aa on aa.application_id = na.apex_app_id
inner join eba_stds_standard_statuses sss on sss.standard_id = nf.id and sss.application_id = na.id
inner join eba_stds_standard_tests sst on sss.test_id  = sst.id
--left  join eba_stds_types nt on nt.id = na.type_id
--left  join eba_stds_test_validations stv on stv.test_id = sss.test_id and stv.application_id = na.apex_app_id
where nf.id not in (1,2,3)
/
select * 
from eba_stds_standard_statuses
/
declare
gc_dummy_view_base   constant user_views.view_name%type := 'V_XXX_DROP_ME_';
gc_valid_view_sql    constant varchar2(512) := 'select 1 pass_fail, 1 reference_code, 1 application_id from dual';
gc_dummy_name        constant eba_stds_standard_tests.name%type := 'DUMMY';
gc_fail_report       constant eba_stds_standard_tests.test_type%type := 'FAIL_REPORT';
  
c_view_name   constant user_views.view_name%type := gc_dummy_view_base||sys_guid();
c_standard_id constant eba_stds_standards.id%type := dbms_random.random;
c_type_id     constant eba_stds_types.id%type := dbms_random.random;
c_app_id      constant apex_applications.application_id%type := 17562111; --dbms_random.random;
l_test_count  number := 0;
begin
execute immediate 'create or replace view '||c_view_name||' as '||gc_valid_view_sql;

delete from eba_stds_standard_type_ref where standard_id in (select id from eba_stds_standards where name = gc_dummy_name);
delete from eba_stds_standard_tests where name = gc_dummy_name;
delete from eba_stds_standards where name = gc_dummy_name;
delete from eba_stds_applications where type_id in (select id from eba_stds_types where name = gc_dummy_name);
delete from eba_stds_types where name = gc_dummy_name;


insert into eba_stds_standards (id, name) values (c_standard_id, gc_dummy_name);
insert into eba_stds_types (id, display_sequence, name) values (c_type_id, dbms_random.random, gc_dummy_name);
insert into eba_stds_standard_type_ref (standard_id, type_id) values (c_standard_id, c_type_id);
insert into eba_stds_standard_tests (standard_id, test_type, name, query_view) values (c_standard_id, gc_fail_report, gc_dummy_name, c_view_name);
insert into eba_stds_applications(apex_app_id, type_id) values (c_app_id, c_type_id);

eba_stds_parser.update_standard_status;
end;
/
select * 
from eba_stds_standard_type_ref
/
delete
from eba_stds_types
where name = 'DUMMY'
/
select * 
from eba_stds_standard_type_ref
/
select * 
from eba_stds_types
/
select distinct standard_id 
from v_eba_stds_application_test_pass_fail
/
delete
from eba_stds_standards
where id = -905857538
/
select DBMS_RANDOM.RANDOM
from dual
/
insert into eba_stds_standards (id, name, description)
select id, name, description
from eba_stds_standards AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_types (id, display_sequence, name)
select id, display_sequence, name
from eba_stds_types AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_applications (id, apex_app_id, status_id, type_id)
select id, apex_app_id, status_id, type_id
from eba_stds_applications AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_standard_type_ref (standard_id, type_id)
select standard_id, type_id
from eba_stds_standard_type_ref AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_standard_tests ( id, standard_id, test_type, name, display_sequence, query_view, link_type, failure_help_text)
select id, standard_id, test_type, name, display_sequence, query_view, link_type, failure_help_text
from eba_stds_standard_tests AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_test_validations (id, test_id, application_id, result_identifier, false_positive_yn, legacy_yn, created, created_by, updated, updated_by)
select id, test_id, application_id, result_identifier, false_positive_yn, legacy_yn, created, created_by, updated, updated_by
from eba_stds_test_validations AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
commit;
/
delete from eba_stds_standard_tests;
delete from eba_stds_standards;--
delete from eba_stds_applications;--
delete from eba_stds_standard_type_ref;--
delete from eba_stds_types;--
/
rollback;
/
select * 
from SCH_REGISTRANTS_AUD
where aud_operation  = 'D'
/
select *
from all_views
where view_name like 'V_XXX%'
/
select apex_string.format('drop view %0;',lower(view_name)) stmt
from user_views
where view_name like 'V_XXX%'
order by view_name
/
drop view v_xxx_drop_me_dad347f1c2099589e053fb290a0aa9e0;
drop view v_xxx_drop_me_dad347f1c20a9589e053fb290a0aa9e0;
drop view v_xxx_drop_me_dad347f1c20b9589e053fb290a0aa9e0;
drop view v_xxx_drop_me_dad347f1c2139589e053fb290a0aa9e0;
drop view v_xxx_drop_me_dad347f1c2149589e053fb290a0aa9e0;
drop view v_xxx_drop_me_dad347f1c2159589e053fb290a0aa9e0;
drop view v_xxx_drop_me_dad4322ba46bcfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba46ccfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba46dcfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba470cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba4afcfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba4b0cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba4b1cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba4b4cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba530cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba531cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba532cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba533cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba534cfbee053fb290a0a3efa;
drop view v_xxx_drop_me_dad4322ba537cfbee053fb290a0a3efa;