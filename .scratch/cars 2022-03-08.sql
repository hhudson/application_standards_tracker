SELECT *
FROM apex_200100.apex_debug_messages
WHERE 1=1
--and application_id = 261
    --AND page_id = 19
    --AND message LIKE '%eba_stds_parser.assert_exception%'
    --and session_id = 14968770091107
ORDER BY message_timestamp DESC
/
select * from apex_debug_messages where session_id = 14968770091107 order by message_timestamp
/
set serveroutput on
begin
  apex_session.create_session(p_app_id=>261,p_page_id=>19,p_username=>'HAYDEN.H.HUDSON@ORACLE.COM');   
    
  apex_debug.enable(p_level => apex_debug.c_log_level_info); 

  dbms_output.put_line('To view debug messages:');
  dbms_output.put_line('select * from apex_debug_messages where session_id = '
    ||apex_util.get_session_state('APP_SESSION') ||' order by message_timestamp');

end;

/
begin
--eba_stds_parser.assert_exception START p_result_identifier +289002266828385404649548380751352491367:261:REL_RELEASE_UTILS:PACKAGE BODY:1149 p_test_id 289002266828385404649548380751352491367 p_app_id 261 p_exception_type LEGACY  
    eba_stds_parser.assert_exception (
                p_result_identifier => '+289002266828385404649548380751352491367:261:REL_RELEASE_UTILS:PACKAGE BODY:1149',
                p_test_id           => '289002266828385404649548380751352491367',
                p_app_id            => '261',
                p_exception_type    => 'LEGACY'
                );
end;
/
select *
from all_views
where view_name like '%DEBUG%'
/
select st.test_type, st.name, st.link_type, tv.false_positive_yn, tv.legacy_yn
from eba_stds_test_validations tv
inner join eba_stds_standard_tests st on tv.test_id = st.id
--where tv.application_id  = 105
/
delete from eba_stds_test_validations
/
commit;
/
alter table eba_stds_test_validations add (legacy_yn varchar2(1)
constraint eba_stds_test_val_ck2 check( legacy_yn in ('Y','N')))
/
alter table eba_stds_test_validations drop column legacy_yn
/
select st.test_type, st.name, st.link_type, tv.*
from eba_stds_test_validations tv
inner join eba_stds_standard_tests st on tv.test_id = st.id
--where tv.application_id  = 105
/

select eba_stds_parser.default_application_id() def_app
from dual
/
with deflt as (
   select eba_stds_parser.default_application_id() app_id
   from dual)
select 
case when a.issue is null 
     then 'Y'
     else 'N'
     end as pass_fail,
apex_string.format('%0:%1:%2:%3', deflt.app_id, a.object_name, a.object_type, a.line) reference_code,
a.issue,
a.object_name, 
a.object_type, 
a.line,
a.code,
a.check_type
from
(select cs.issue, cs.object_name, cs.object_type, cs.line, cs.code, cs.check_type
    from v_ast_db_plsql_commented_specs cs
 union all
 select dc.issue, dc.object_name, dc.object_type, dc.line, dc.code, dc.check_type
    from v_ast_db_plsql_deprecated_code dc
 union all 
 select ds.issue, ds.object_name, ds.object_type, ds.line, ds.code, ds.check_type
    from v_ast_db_plsql_duplicate_statements ds
 union all 
 select inm.issue, inm.object_name, inm.object_type, inm.line, inm.code, inm.check_type
   from v_ast_db_plsql_identifier_naming inm
 union all 
 select ui.issue, ui.object_name, ui.object_type, ui.line, ui.code, ui.check_type
   from v_ast_db_plsql_unusued_identifiers ui 
) a
cross join deflt
where a.issue is not null
order by a.check_type, a.issue, a.object_name, a.line
;
/
select st.test_type, st.name, st.link_type, tv.*
from eba_stds_test_validations tv
inner join eba_stds_standard_tests st on tv.test_id = st.id
--where tv.application_id  = 105
/
delete from eba_stds_test_validations
/
commit;
/
select * 
from eba_stds_standard_tests
/
--2022-03-08
/
declare
    l_standard_id number;
    l_test_id     number;
    l_app_id      number;
begin
eba_stds_parser.assert_exception (
                p_result_identifier => :P20_VALIDATE,
                p_test_id           => null,
                p_app_id            => null
                );
l_standard_id := :P20_ID;
    l_test_id     := substr(:P20_VALIDATE,2,instr(:P20_VALIDATE,'.')-2);
    l_app_id      := substr(:P20_VALIDATE,instr(:P20_VALIDATE,'.')+1);
    
    if substr(:P20_VALIDATE,1,1) = '+' then
        merge into eba_stds_test_validations dest
            using ( select l_test_id test_id,
                        l_app_id application_id
                    from dual ) src
            on ( dest.test_id = src.test_id
                and dest.application_id = src.application_id
                and dest.result_identifier is null
               )
        when matched then
            update set dest.false_positive_yn = 'Y'
        when not matched then
            insert ( test_id, application_id, result_identifier, false_positive_yn )
            values ( src.test_id, src.application_id, null, 'Y' );
    else
        update eba_stds_test_validations tv
        set tv.false_positive_yn = 'N'
        where tv.test_id = l_test_id
            and tv.application_id = l_app_id
            and tv.result_identifier is null;
    end if;

    delete from eba_stds_standard_statuses
    where standard_id = l_standard_id
        and test_id = l_test_id;

    eba_stds_parser.update_standard_status();
end;