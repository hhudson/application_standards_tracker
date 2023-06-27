select 
case when aa.application_group = 'TO BE ARCHIVED'
     then 'N'
     when aa.availability_status = 'Unavailable'
     then 'N'
     else 'Y'
     end pass_fail,
aa.application_id,
aa.application_name,
aa.application_group,
aa.availability_status
from apex_applications aa
where aa.application_id = 714000
/
SELECT *
FROM apex_200100.apex_debug_messages
WHERE 1=1
    AND application_id = 17000033
    AND page_id = 19
   -- AND message LIKE '%eba_stds_parser.assert_exception%'
 --  AND id > 23065753104
ORDER BY message_timestamp DESC
/
select apex_string.format(p_message => '<tr><td>Invalid List Entry link</td><td>%0</td><td>N/A</td><td>%2</td><td colspan="1">%3</td><td>%4</td></tr>',
                            p0 => application_id, 
                            p1 => null,
                            p2 => list_name||'/'||entry_text, 
                            p3 => 'added "NEVER" build option', 
                            p4 => 'The list entry link was invalid') as htmltr
from v_ast_apex_valid_build_list_entry
where last_updated_by = 'HAYHUDSO'
and pass_fail = 'N'
/

/
/*
Exception in "IR Test Results":
Error Stack: ORA-06533: Subscript beyond count
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC", line 2684
ORA-06512: at "APEX_200100.WWV_FLOW_DYNAMIC_EXEC", line 1223
ORA-06512: at "CARS.EBA_STDS_PARSER", line 690
ORA-06512: at "CARS.EBA_STDS_PARSER", line 514
ORA-06512: at "CARS.EBA_STDS_PARSER", line 669
ORA-06512: at "CARS.EBA_STDS_PARSER", line 669
ORA-06512: at "SYS.DBMS_SQL", line 1726
ORA-06512: at "APEX_200100.WWV_FLOW_DYNAMIC_EXEC", line 1219
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 414
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 656
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 790
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 835
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 1412
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC", line 2675
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC", line 2356
ORA-06512: at "APEX_200100.WWV_FLOW_IR_RENDER", line 6650
Backtrace: ORA-06512: at "APEX_200100.WWV_FLOW_EXEC", line 2684
ORA-06512: at "APEX_200100.WWV_FLOW_DYNAMIC_EXEC", line 1223
ORA-06512: at "CARS.EBA_STDS_PARSER", line 690
ORA-06512: at "CARS.EBA_STDS_PARSER", line 514
ORA-06512: at "CARS.EBA_STDS_PARSER", line 669
ORA-06512: at "CARS.EBA_STDS_PARSER", line 669
ORA-06512: at "SYS.DBMS_SQL", line 1726
ORA-06512: at "APEX_200100.WWV_FLOW_DYNAMIC_EXEC", line 1219
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 414
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 656
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 790
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 835
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC_LOCAL", line 1412
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC", line 2675
ORA-06512: at "APEX_200100.WWV_FLOW_EXEC", line 2356
ORA-06512: at "APEX_200100.WWV_FLOW_IR_RENDER", line 6650
ORA-06512: at "APEX_200100.WWV_FLOW_IR_RENDER", line 12911

*/
/
select *
from all_tab_cols
where column_name = 'BUILD_OPTION'
and table_name not in ('APEX_APPLICATION_PAGES')
AND OWNER = 'APEX_200100'
order by table_name
/
select * 
from v_ast_apex_valid_build_list_entry
where pass_fail = 'N'
/
select
case when ale.build_option = 'NEVER' 
     then 'N'
     when ale.build_option is null
     then 'Y'
     when validate_conversion(ale.build_option as number) = 1 
     then 'N'
     else 'Y'
     end pass_fail,
ale.application_id,
ale.list_entry_id,
ale.list_name,
ale.entry_text,
ale.entry_target,
ale.build_option
from APEX_APPLICATION_LIST_ENTRIES ale

/
select validate_conversion('a' as number)
from dual
/
select * 
from APEX_APPLICATION_PAGES
/
select * 
from (
    select object_name, procedure_name
    from user_procedures
    where object_name not like '%/_UT' escape '/'
    minus
        select ui.declared_object_name, ui.name
        from all_identifiers ui
        where ui.object_type = 'PACKAGE BODY'
        and ui.object_name like '%/_UT' escape '/' 
        and ui.declared_object_name not like '%/_UT' escape '/' 
        and ui.declared_object_name not in ('STANDARD')
        and ui.type in ('FUNCTION','PROCEDURE')
) z
where object_name = 'EBA_STDS_PARSER'
--order by ui.type
/
with tested_procs as (
    select ui.declared_object_name, ui.name, ui.object_name, ui.line
        from all_identifiers ui
        where ui.object_type = 'PACKAGE BODY'
        and ui.object_name like '%/_UT' escape '/' 
        and ui.declared_object_name not like '%/_UT' escape '/' 
        and ui.declared_object_name not in ('STANDARD')
        and ui.type in ('FUNCTION','PROCEDURE')
), test_needing_procs as (
    select object_name, procedure_name
        from user_procedures
        where object_name not like '%/_UT' escape '/'
)
select np.object_name, np.procedure_name
from test_needing_procs np
where np.procedure_name is not null
minus
select tp.declared_object_name, tp.name
from tested_procs tp 
/
select *
from tested_procs tp 
where tp.declared_object_name = 'EBA_STDS_PARSER'
order by declared_object_name, object_name, name
/
select * 
from all_identifiers
/
select * 
from mv_eba_stds_parsed_urls
where destination_page_id = 250
and destination_app_id  = 702000
/
begin
dbms_mview.refresh ('MV_EBA_STDS_PARSED_URLS');
end;
/

DECLARE
    l_string  varchar2(32767) := 'http://oracle.com i foo.com like https://carbuzz.com '||
                                 'and <a href="https://dpreview.com"> and http://google.com';
    l_results apex_t_varchar2;
BEGIN 
    l_results := apex_string_util.find_links(l_string,false);
END;
/
/
select * 
from v_ast_apex_html_escaping_cols
where pass_fail = 'N'
and report_label like '%link%' collate binary_ci
/
select * 
from apex_application_page_ir_col
where region_id = :region_id --1712818314037867876
/
select query_type, region_source
from apex_application_page_regions
where region_id = :region_id