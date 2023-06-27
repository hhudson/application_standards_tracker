SELECT *
FROM apex_200100.apex_debug_messages
WHERE application_id = 261
    AND page_id = 5
    AND (message LIKE '%eba_stds_parser.update_standard_status%'
    or message like '%eba_stds_parser.view_sql_w_apex_filter%')
    --and (lower(message) like '%start%' or lower(message) like '%end%')
    and session_id = 4817867653480
    and id > 22834764400
ORDER BY message_timestamp DESC
/
/*
eba_stds_parser.view_sql_w_apex_filter START p_view_name V_AST_DB_PLSQL_ALL p_app_id 261                V_AST_DB_PLSQL_ALL0
*/
/
set serveroutput on
declare
l_sql_long  user_views.text%type;
l_clob clob;
    begin

      select text 
        into l_sql_long
        from user_views
        where view_name  = :l_view_name;
        
        l_clob :=  to_clob(l_sql_long);
        dbms_output.put_line(l_clob);
end;
/
select text 
       -- into l_sql_long
        from user_views
        where view_name  = :l_view_name;
/
with deflt as (
   select eba_stds_parser.default_app_id() application_id
   from dual)
select 
case when a.issue is null 
     then 'Y'
     else 'N'
     end as pass_fail,
apex_string.format('%0:%1:%2:%3', deflt.application_id, a.object_name, a.object_type, a.line) reference_code,
deflt.application_id,
a.issue,
a.object_name, 
a.object_type, 
a.line,
a.code,
a.check_type
from
(select cs.issue, cs.object_name, cs.object_type, cs.line, cs.code, cs.check_type
    from v_ast_db_plsql_1_commented_specs cs
 union all
 select dc.issue, dc.object_name, dc.object_type, dc.line, dc.code, dc.check_type
    from v_ast_db_plsql_2_discouraged_code dc
 union all 
 select ds.issue, ds.object_name, ds.object_type, ds.line, ds.code, ds.check_type
    from v_ast_db_plsql_3_duplicate_statements ds
 union all 
 select inm.issue, inm.object_name, inm.object_type, inm.line, inm.code, inm.check_type
   from v_ast_db_plsql_4_identifier_naming inm
 union all 
 select ui.issue, ui.object_name, ui.object_type, ui.line, ui.code, ui.check_type
   from v_ast_db_plsql_5_unusued_identifiers ui 
) a
cross join deflt
where a.issue is not null
order by a.check_type, a.issue, a.object_name, a.line
/
set serveroutput on
declare
l_sql clob;
begin

l_sql := apex_string.format(p_message => 'select * from (%0) where application_id = %1',
                            p0 => eba_stds_parser.view_sql (p_view_name => :p_view_name),
                            p1 => :p_app_id);
dbms_output.put_line(l_sql);
end;
/
select * from (select 
case when ic1.display_text_as = 'WITHOUT_MODIFICATION'
     then 'N'
     else 'Y'
     end as pass_fail,
apex_string.format('%0:%1', ic1.application_id, ic1.region_id) reference_code,
ic1.application_id, 
ic1.region_id, 
ic1.application_name,
ic1.page_id,
ic1.region_name, 
ic1.column_alias,
ic1.report_label,
'IR' report_type
from apex_application_page_ir_col ic1
inner join apex_applications aa on ic1.application_id = aa.application_id
                                and aa.availability_status != 'Unavailable'
union all
select 
case when ic2.escape_on_http_output ='Yes'
     then 'Y'
     else 'N'
     end as pass_fail, 
apex_string.format('%0:%1', ic2.application_id, ic2.region_id) reference_code,
ic2.region_id, 
ic2.application_id, 
ic2.application_name,
ic2.page_id,
ic2.region_name, 
ic2.name,
ic2.heading,
'IG' report_type
from apex_appl_page_ig_columns ic2
inner join apex_applications aa on ic2.application_id = aa.application_id
/
select *
from eba_stds_standards nf
    inner join eba_stds_standard_type_ref nftr on nf.id = nftr.standard_id
    inner join eba_stds_applications na on nftr.type_id = na.type_id
    inner join apex_applications aa on aa.application_id = na.apex_app_id
    --inner join eba_stds_standard_statuses sss on sss.standard_id = nf.id
    --                                          and sss.application_id = na.id
    --inner join eba_stds_standard_tests sst on sss.test_id  = sst.id
    --left  join eba_stds_types nt on nt.id = na.type_id
    --left  join eba_stds_test_validations stv on stv.test_id = sss.test_id
    --                                         and stv.application_id = na.apex_app_id 
    where nf.id = 4
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
                and st_stat.standard_id(+) = :d_standard_id -- 4, 1
                and st_stat.test_id(+) = :d_test_id --290934672085980425626077628758317791546, 290954809810138535748024902016765152078
                and st_stat.application_id(+) = ap.id
            order by ap.apex_app_id;
/
select standard_id,
                id test_id,
                test_type,
                name,
                query_view,
                failure_help_text
            from eba_stds_standard_tests;
/
select * 
from eba_stds_standard_statuses
where application_id = 290846383950421842887215473979648783060
/
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
                values ( src.app_id, src.standard_id, src.test_id, src.pass_fail_pct, src.duration );