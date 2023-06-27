ALTER PACKAGE EBA_STDS_PARSER COMPILE PACKAGE; 
ALTER PACKAGE EBA_STDS_PARSER COMPILE BODY; 
ALTER PACKAGE ut_ast_create_and_run_tests COMPILE PACKAGE; 
ALTER PACKAGE ut_ast_create_and_run_tests COMPILE BODY; 
select * from table(ut.run('ut_ast_create_and_run_tests'));

/
SELECT *
FROM apex_200100.apex_debug_messages
WHERE application_id = 261
    AND page_id = 19
    --AND message LIKE '%eba_stds_parser.assert_exception%'
    and id > 22867940000
    --29-MAR-22 12.30.15.921095000 PM US/PACIFIC
ORDER BY message_timestamp DESC
/
/*
eba_stds_parser.update_standard_status Unhandled Exception ORA-01403: no data found    100 ORA-01403: no data found
ORA-06512: at "CARS.EBA_STDS_PARSER", line 76
ORA-06512: at "CARS.EBA_STDS_PARSER", line 66
ORA-06512: at "CARS.EBA_STDS_PARSER", line 337
 ORA-06512: at "CARS.EBA_STDS_PARSER", line 76
ORA-06512: at "CARS.EBA_STDS_PARSER", line 66
ORA-06512: at "CARS.EBA_STDS_PARSER", line 337
ORA-06512: at "CARS.EBA_STDS_PARSER", line 337
             0
*/
/
select button_id
from apex_application_page_buttons
where application_id = 17562111
and page_id = 1

/
select * 
from apex_application_regions
/
 select 1
            --into l_dummy
            from apex_applications aa 
            where aa.application_id = :p_app_id --17562111
            and aa.workspace = (select workspace
                                from apex_applications
                                where application_id =  261); 
/
begin
apex_debug.enable(p_level => apex_debug.c_log_level_engine_trace); 
end;
/
select v('APP_ID'), v('APX_BLDR_SESSION')
from dual;
/
begin
     apex_util.set_session_state('APX_BLDR_SESSION', :gc_bldr_session);
end;
/
delete
      from eba_stds_applications
      where type_id  = (select id from eba_stds_types where name = :gc_dummy_name);
delete
      from eba_stds_standards 
      where name  = :gc_dummy_name;
delete from eba_stds_types
      where name = :gc_dummy_name;
DELETE
      from eba_stds_standard_tests 
      where name = :gc_dummy_name;

/
select * 
from eba_stds_standard_tests
/
select apex_string.format('drop view %s;',view_name) thecode
from user_views
where view_name like 'V_XXX_DROP_ME%';
/
drop view V_XXX_DROP_ME_DB6158F1390800E1E053FB290A0A493C;
/
set serveroutput on
declare
gc_valid_view_sql           constant varchar2(512) := 'select 1 pass_fail, 1 reference_code, 1 application_id from dual';
gc_fail_report              constant eba_stds_standard_tests.test_type%type := 'FAIL_REPORT';
gc_dummy_name               constant eba_stds_standard_tests.name%type := 'DUMMY';
gc_dummy_view_base          constant user_views.view_name%type := 'V_XXX_DROP_ME_';
gc_lang                     constant varchar2(8) := 'en';
gc_ast_app_id               constant apex_applications.application_id%type := 261;
gc_generic_app_id           constant apex_applications.application_id%type := 17562111; --An actual apex app in the cars_covid workpsace
gc_view_name1               constant user_views.view_name%type := gc_dummy_view_base||sys_guid();
gc_view_name2               constant user_views.view_name%type := gc_dummy_view_base||sys_guid();
gc_view_name3               constant user_views.view_name%type := gc_dummy_view_base||sys_guid();
gc_view_valid               constant user_views.view_name%type := gc_dummy_view_base||sys_guid();
gc_report_link_to_app_sql   constant varchar2(512) := apex_string.format(q'[select 'N' pass_fail, %s reference_code, %s as application_id from dual]', gc_generic_app_id, gc_generic_app_id);
gc_report_link_to_app       constant user_views.view_name%type := gc_dummy_view_base||sys_guid();
l_view_sql clob;
l_number   number;
l_test_id  eba_stds_standard_tests.id%type;
c_standard_id          constant eba_stds_standards.id%type := dbms_random.random;
c_type_id              constant eba_stds_types.id%type := dbms_random.random;
c_display_seq          constant eba_stds_types.display_sequence%type := dbms_random.random;
c_bldr_session         constant number := 123456789;
c_application_id       constant number := null;
c_test_results_page_id constant number := 19;
begin
execute immediate 'create or replace view '||gc_report_link_to_app||' as '||gc_report_link_to_app_sql;
insert into eba_stds_standards (id, name) values (c_standard_id, gc_dummy_name);
insert into eba_stds_types (id, display_sequence, name) values (c_type_id, c_display_seq, gc_dummy_name);
insert into eba_stds_standard_type_ref (standard_id, type_id) values (c_standard_id, c_type_id);
insert into eba_stds_standard_tests (standard_id, test_type, name, query_view) values (c_standard_id, gc_fail_report, gc_dummy_name, gc_report_link_to_app) returning id into l_test_id;
insert into eba_stds_applications(apex_app_id, type_id) values (gc_generic_app_id, c_type_id);

apex_session.create_session (
  p_app_id => gc_ast_app_id,
  p_page_id  => c_test_results_page_id,
  p_username  => 'HAYHUDSO');

eba_stds_parser.load_collection(  
                        p_page_id        => c_test_results_page_id,
                        p_application_id => null,
                        p_test_id        => l_test_id);

l_view_sql := 'begin select count(*) into :l_number from ('||eba_stds_parser.test_results_sql||'); end;';

execute immediate l_view_sql using in out l_number, l_test_id, c_bldr_session, gc_ast_app_id, c_application_id;
dbms_output.put_line(l_view_sql);
dbms_output.put_line(l_number);

execute immediate 'drop view '||gc_report_link_to_app;
delete
      from eba_stds_applications
      where type_id  = (select id from eba_stds_types where name = gc_dummy_name);
delete
      from eba_stds_standards 
      where name  = gc_dummy_name;
delete from eba_stds_types
      where name = gc_dummy_name;
DELETE
      from eba_stds_standard_tests 
      where name = gc_dummy_name;
end;
/
declare
l_view_sql clob;
l_number number;
l_test_id number := 290954809810138535748024902016765152078;
l_bldr_session number := 290954809810138535748024902016765152078;
l_app_id number := 261;
l_application_id number := null;
l_inner_sql clob := q'[select :test_id,:bldr_session,:app_id,:apppp
            from dual
            ]';
l_inner_sql2 clob := eba_stds_parser.test_results_sql;
l_page_id number := 19;
l_varchar varchar2(512);
begin
apex_session.create_session (
   p_app_id => l_app_id,
   p_page_id  => l_page_id,
   p_username  => 'HAYHUDSO');

eba_stds_parser.load_collection(  
                        p_page_id        => l_page_id,
                        p_application_id => null,
                        p_test_id        => l_test_id);
   
l_view_sql := 'begin select count(*) into :l_number from ('||l_inner_sql2||'); end;';
--l_view_sql := replace(l_view_sql, ''||:P19_TEST_ID||'', 123);

execute immediate l_view_sql using in out l_number, l_test_id,l_bldr_session,l_app_id,l_application_id;
--dbms_output.put_line(l_view_sql);
dbms_output.put_line(l_number);
end;
/
select 
     apex_item.checkbox(1,
                    case when ac.c001 = 'N' and tv.legacy_yn = 'Y'
                         then '-'||:P19_TEST_ID||':' ||ac.c002
                         when ac.c001 = 'N'
                         then '+'||:P19_TEST_ID||':'||ac.c002
                         else ''
                         end
                  ) cb,
    case when ac.c001 = 'Y' 
         then 'Pass'
         when tv.false_positive_yn = 'Y' 
         then 'False Negative'
         when tv.legacy_yn = 'Y'
         then 'Legacy'
         else 'Fail'
         end as status,
    case when ac.c001 = 'N' and tv.false_positive_yn = 'Y' 
         then
         '<a href="javascript:$s(''P19_VALIDATE'',''-'||:P19_TEST_ID||':'||ac.c002||''');" '
            ||'class="t-Button t-Button--success t-Button--stretch">'
            ||'Marked as Valid</a>'
            ||'<div style="text-align:center">'||apex_util.get_since(tv.updated)
            ||' by '||apex_escape.html(tv.updated_by)||'</div>'
         when ac.c001 = 'N' 
         then
            '<a href="javascript:$s(''P19_VALIDATE'',''+'||:P19_TEST_ID||':'||ac.c002||''');" '
            ||'class="t-Button t-Button--stretch">'
            ||'Mark as Valid</a>'
         else '&nbsp;' 
         end as false_neg_date,
    case when ac.c001 = 'N' and tv.legacy_yn = 'Y' 
         then '<a href="javascript:$s(''P19_LEGACY'',''-'||:P19_TEST_ID||':'||ac.c002||''');" 
               class="t-Button t-Button--primary t-Button--stretch">
               Marked as Legacy</a>
               <div style="text-align:center">'||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)||'</div>'
         when ac.c001 = 'N' 
         then '<a href="javascript:$s(''P19_LEGACY'',''+'||:P19_TEST_ID||':'||ac.c002||''');"
              class="t-Button t-Button--stretch"> Mark as Legacy</a>'
         else ' ' 
         end as legacy_date,
    case when :APX_BLDR_SESSION is not null
            and apex_util.get_build_option_status(p_application_id => :APP_ID,
                                                p_build_option_name => 'Link to Builder') = 'INCLUDE' 
         then
         'javascript:openInBuilder('''
            ||eba_stds_parser.build_link( :P19_TEST_ID, :P19_APPLICATION_ID, ac.c002 )
            ||''');'
         else 'javascript:null;'
         end as edit_link,
    ac.c002 reference_code , ac.c003 application_id, 
    ac.c004, ac.c005, ac.c006, ac.c007, ac.c008, ac.c009, ac.c010,
    ac.c011, ac.c012, ac.c013, ac.c014, ac.c015, ac.c016, ac.c017, ac.c018, ac.c019, ac.c020,
    ac.c021, ac.c022, ac.c023, ac.c024, ac.c025, ac.c026, ac.c027, ac.c028, ac.c029, ac.c030,
    ac.c031, ac.c032, ac.c033, ac.c034, ac.c035, ac.c036, ac.c037, ac.c038, ac.c039, ac.c040,
    ac.c041, ac.c042, ac.c043, ac.c044, ac.c045, ac.c046, ac.c047, ac.c048, ac.c049, ac.c050,
    ac.seq_id,
    case when length(''''||eba_stds_parser.build_link( :P19_TEST_ID, :P19_APPLICATION_ID, ac.c002 )||'''') > 2 -- only enable button if there is a link to follow
         then case when ac.c001 = 'Y' or tv.false_positive_yn = 'Y' 
                   then 'success'
                   when tv.legacy_yn = 'Y'
                   then 'primary'
                   else 'warning' 
                   end 
         else 'disabled'
         end as button_style,
    stat.name app_status, sty.name app_type, aa.application_name
from apex_collections ac
inner join eba_stds_applications sa on sa.apex_app_id = ac.c003
inner join apex_applications aa on aa.application_id = sa.apex_app_id
left join eba_stds_types sty on sa.type_id = sty.id
left join eba_stds_app_statuses stat on sa.status_id  = stat.id
left join eba_stds_test_validations tv on  tv.test_id = :P19_TEST_ID
                                       and tv.result_identifier = :P19_TEST_ID||':'||ac.c002
where ac.collection_name = 'EBA_STDS_P19_TEST_RESULTS'
and (sa.apex_app_id = :P19_APPLICATION_ID or :P19_APPLICATION_ID is null)
