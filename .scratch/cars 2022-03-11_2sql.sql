SELECT *
FROM apex_200100.apex_debug_messages
WHERE application_id = 261
   AND page_id = 19
   AND message LIKE 'eba_stds_parser.load_collection%'
   and id > 22641879199
ORDER BY message_timestamp DESC
/
/*
eba_stds_parser.update_standard_status save_status 
p_standard_id 289715532569441572852919041764230868604 
p_application_id 289715532569399260449232529743116152444 
p_test_id 289715532569443990704558271022580280956 
p_status 73.46938775510204081632653061224489795918 
p_duration 31.297          2897155325694415728529190417642308686040
*/
merge into eba_stds_standard_statuses dest
using ( select :p_application_id app_id,
               :p_standard_id standard_id,
               :p_test_id test_id,
               :p_status pass_fail_pct,
               :p_duration duration
        from dual ) src
on ( dest.application_id = src.app_id
    and dest.standard_id = src.standard_id
    and dest.test_id = src.test_id )
when matched then
    update set dest.pass_fail_pct = src.pass_fail_pct, dest.test_duration = src.duration
when not matched then
    insert ( dest.application_id, dest.standard_id, dest.test_id, dest.pass_fail_pct, dest.test_duration )
    values ( src.app_id, src.standard_id, src.test_id, src.pass_fail_pct, src.duration )
/
delete
from eba_stds_standard_statuses
/
create table eba_stds_standard_statuses (
    id             number not null
                   constraint eba_stds_standard_statuses_pk
                   primary key,
    standard_id     number
                   constraint eba_stds_standard_statuses_fk1
                   references eba_stds_standards(id) on delete cascade,
    application_id number
                   constraint eba_stds_standard_statuses_fk2
                   references eba_stds_applications(id) on delete cascade,
    test_id        number
                   constraint eba_stds_standard_statuses_fk3
                   references eba_stds_standard_tests(id) on delete cascade,
    pass_fail_pct  number,
    test_duration  number,
    updated        timestamp with local time zone not null
);

create index eba_stds_standard_statuses_n1 on eba_stds_standard_statuses( application_id );
create index eba_stds_standard_statuses_n2 on eba_stds_standard_statuses( standard_id );
create index eba_stds_standard_statuses_n3 on eba_stds_standard_statuses( test_id );
/
drop table eba_stds_standard_statuses
/
begin
eba_stds_parser.update_standard_status;
end;
/
select ap.id application_id,
                ap.apex_app_id,
                aa.last_updated_on app_update,
                st_stat.updated test_run,
                st_stat.pass_fail_pct
            from eba_stds_applications ap,
                eba_stds_standards s,
                eba_stds_standard_type_ref st_type,
                eba_stds_standard_statuses st_stat,
                apex_applications aa
            where s.id = :d_standard_id
                and st_type.standard_id = s.id
                and st_type.type_id = ap.type_id
                and aa.application_id = ap.apex_app_id
                and st_stat.standard_id(+) = :d_standard_id --289715532569441572852919041764230868604
                and st_stat.test_id(+) = :d_test_id --289715532569443990704558271022580280956
                and st_stat.application_id(+) = ap.id
/
select eba_stds_parser.is_valid_query( eba_stds_parser.view_sql (p_view_name => :query_view)) blerg --V_AST_APEX_ACCESSIBILITY_THEME
from dual
/
select standard_id,
                id test_id,
                test_type,
                name,
                query_view,
                app_bind_variable,
                failure_help_text
            from eba_stds_standard_tests;
/
select * 
from eba_stds_standard_statuses
/
select * 
from eba_stds_standard_tests
/
select * 
from eba_stds_test_validations
/
select * 
from eba_stds_applications
/
select apex_string.format('drop view %0;',lower(view_name)) stmt
from user_views
where (lower(view_name) like '%ast%' ) or  (lower(view_name) like 'v_eba%' )
/
drop view V_AST_DB_PLSQL_COMMENTED_SPECS;
drop view V_AST_DB_PLSQL_DEPRECATED_CODE;
drop view V_AST_DB_PLSQL_DUPLICATE_STATEMENTS;
drop view V_AST_DB_PLSQL_IDENTIFIER_NAMING;
drop view V_AST_DB_PLSQL_UNUSUED_IDENTIFIERS;
drop view V_AST_VIEW_LOV;