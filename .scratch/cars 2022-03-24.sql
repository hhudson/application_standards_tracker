select * 
from v_ast_db_plsql_all
where object_name = 'UT_AST_CREATE_AND_RUN_TESTS'
and issue is not null
/
with decs as (select type, name, line, object_name, object_type, signature
              from user_identifiers ui
              where ui.type = 'VARIABLE'
              and ui.usage = 'DECLARATION'
              and ui.implicit = 'NO'),
     assgn as (select signature, max(line) last_line
              from user_identifiers ui
              where ui.type = 'VARIABLE'
              and ui.usage = 'ASSIGNMENT'
              group by signature)
select
case when ds.line = ag.last_line
     then case when ds.name like 'C_%'
               then 'Y'
               else 'N'
               end
     else 'Y'
     end as pass_fail, ag.last_line,
ds.*
from decs ds
inner join assgn ag on ds.signature = ag.signature
where 1=1
and ds.object_name = 'UT_AST_CREATE_AND_RUN_TESTS'
--and ds.name = 'L_NUM'
/
select * 
from user_identifiers
where name = 'WORKSPACE_ID'
and object_name = 'UT_AST_CREATE_AND_RUN_TESTS'
and type = 'VARIABLE'
AND USAGE = 'DECLARATION'
/
select * 
from v_ast_db_plsql_5_unusued_identifiers ds
where ds.object_name = 'UT_AST_CREATE_AND_RUN_TESTS'

/
select
ui.*
from   all_identifiers ui
where  1=1
--and ui.usage = 'DECLARATION'
and ui.object_type = 'PACKAGE BODY' 
--and ui.type = 'CONSTANT'
and ui.object_name  = 'UT_AST_CREATE_AND_RUN_TESTS'
and ui.name = 'L_TEST_COUNT'
--and ui.usage_context_id = 52
--and ui.usage_context_id  = 1
order by ui.object_name, ui.object_type, ui.line  
/
ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL';

begin
    dbms_utility.compile_schema(schema => user, compile_all => true);
end;
/
select * 
from v_ast_apex_valid_list_links
where pass_fail = 'N'
/
select * 
from eba_stds_applications
/
set define off
/
with tapps as (
        select
        le.application_id, 
        le.application_name,
        le.list_name,
        le.list_id, 
        le.list_entry_parent_id,
        le.list_entry_id,
        le.display_sequence,
        le.entry_target, 
        substr(et.column_value, 5) target_app_id
        from apex_application_list_entries le
        cross join table(apex_string.split(le.entry_target,':')) et where et.column_value like 'f?p=%'
                                                                    and et.column_value not like 'f?p=&%'
        )
select
*
from tapps t
/
with tapps as (
        select
        a.application_id, 
        a.application_name,
        a.list_name,
        a.list_id, 
        a.list_entry_parent_id,
        a.list_entry_id,
        a.display_sequence,
        a.entry_target, 
        substr(b.column_value, 5) target_app_id,
        a.entry_text
        from APEX_APPLICATION_LIST_ENTRIES a
        cross join table(apex_string.split(a.entry_target,':')) b
        where application_id = 700000
        and b.column_value like 'f?p=%'
        and b.column_value not like 'f?p=&%')
select
case when aa2.availability_status = 'Unavailable'
     then 'N'
     else 'Y'
     end as pass_fail,
t.application_id, 
t.entry_target, t.target_app_id, aa2.availability_status, t.application_name,
t.list_name, t.entry_text
from tapps t
inner join apex_applications aa1 on t.application_id = aa1.application_id
                                 and aa1.availability_status != 'Unavailable'
left join apex_applications aa2 on t.target_app_id = aa2.application_id
/
select *
from APEX_APPLICATION_LIST_ENTRIES
where application_id = 700000
and list_id = 12886937366863613
and list_entry_id = 88326937892674767
--RP,4050,4052:F4000_P4052_ID,F4000_P4050_LIST_ID,FB_FLOW_ID:88326937892674767,12886937366863613,700000
/
select * 
from all_tab_cols
where table_name like 'APEX%'
and table_name like '%LIST%'
/
select *
from apex_applications
where 1=1
--and application_id like '714%'
and availability_status = 'Unavailable'
/
select * 
from v_ast_apex_theme_refresh
--where application_id like '714%'
/
select * 
from v_ast_apex_page_item_naming
where application_id like '714%'
/
select * 
from v_ast_apex_page_help
where application_id like '714%'
/
select * 
from v_ast_apex_page_auth
where application_id like '714%'
/
select * 
from v_ast_apex_item_help
where application_id like '714%'
/
select * 
from v_ast_apex_html_escaping_cols
where application_id like '714%'
/
select * 
from v_ast_apex_app_item_naming
where application_id like '714%'
/
select * 
from v_ast_apex_app_auth
where application_id like '714%'
/
select * 
from v_ast_apex_accessibility_theme
where application_id like '714%'
/
select * 
from v_ast_apex_accessibility_theme_subscription
where application_id like '714%'
/
select * 
from v_ast_apex_accessibility_page_title
where application_id like '714%'
/
select * 
from v_ast_apex_accessibility_nav_bar_template
where application_id like '714%'
/
select * 
from v_ast_apex_accessibility_item_label
where application_id like '714%'