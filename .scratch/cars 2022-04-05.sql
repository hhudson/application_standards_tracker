select  cat_seq, category, sub_cat_seq, sub_category, fail_count
from mv_ast_fail_summary
order by cat_seq, sub_cat_seq
/
select * 
from mv_eba_stds_parsed_urls
/
select 4 cat_seq, 'PLSQL STANDARDS', 10 sub_cat_seq, check_type, count(*) fail_count
from v_ast_db_plsql_all
group by check_type
/
drop view v_eba_stds_fail_summary
/
drop materialized view mv_ast_fail_summary
/
create materialized view mv_ast_fail_summary
refresh complete
start   with sysdate
next  (trunc(sysdate) + 1 + 2/24) 
as
select 3 cat_sequence, 'APEX ACCESSIBILITY'           category,10  as sequence,'ACCESSIBILITY ITEM LABEL'         sub_cateogry, count(*) fail_count 
from V_AST_APEX_ACCESSIBILITY_ITEM_LABEL ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
/
select * 
from v_eba_stds_fail_summary
/
select 
apex_string.format(q'[select 'APEX' category,10 as sequence,'%s' sub_cateogry, count(*) fail_count from %s ast inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id where ast.pass_fail = 'N' union all]', replace(substr(view_name,12),'_',' '), view_name) thecode
from user_views
where view_name like 'V_AST_APEX%'
order by view_name
/
SELECT *
FROM apex_200100.apex_debug_messages
WHERE 1=1
    --AND application_id = 261
    --AND page_id = 19
    --AND message LIKE '%eba_stds_parser.assert_exception%'
   --AND id > 23065753104
   and session_id = 108160344295045
ORDER BY message_timestamp DESC
/
set define off
select * 
from apex_application_list_entries
where 1=1
and application_id = 700000
--and list_entry_id = 1571415607527135661
and entry_target = 'f?p=714000:100:&SESSION.::&DEBUG.::'
/
select * 
from v_eba_stds_parsed_urls
where destination_app_id = 700000
and destination_page_id = 974
/
select apa.* 
from v_ast_apex_page_auth apa
inner join eba_stds_applications esa on apa.application_id = esa.apex_app_id
where apa.pass_fail = 'N'
/
/*
eba_stds_parser.load_collection Unhandled Exception ORA-06502: PL/SQL: numeric or value error: character string buffer too small    -6502 ORA-06502: PL/SQL: numeric or value error: character string buffer too small
ORA-06512: at "SYS.DBMS_SQL", line 2084
 ORA-06512: at "SYS.DBMS_SQL", line 2084
ORA-06512: at "CARS.EBA_STDS_PARSER", line 773
   
*/
/
select 
                         spu.destination_app_id, spu.destination_page_id
                         , subtr(listagg(distinct spu.element_authorization       ,'/' on overflow truncate with count) within group (order by spu.element_authorization),32) origin_element_authorization
                         , subtr(listagg(distinct spu.parent_element_authorization,'/' on overflow truncate with count) within group (order by spu.parent_element_authorization),32) origin_parent_element_authorization
                         , subtr(listagg(distinct spu.page_authorization          ,'/' on overflow truncate with count) within group (order by spu.page_authorization),32) origin_page_authorization
                         from v_eba_stds_parsed_urls spu
                         where spu.destination_app_id is not null
                         and spu.destination_page_id is not null
                         group by spu.destination_app_id, spu.destination_page_id
/
select * 
from v_eba_stds_parsed_urls
/
with origin_auth as (select 
                         spu.destination_app_id, spu.destination_page_id
                         , listagg(distinct spu.element_authorization       ,'/' on overflow truncate with count) within group (order by spu.element_authorization) origin_element_authorization
                         , listagg(distinct spu.parent_element_authorization,'/' on overflow truncate with count) within group (order by spu.parent_element_authorization) origin_parent_element_authorization
                         , listagg(distinct spu.page_authorization          ,'/' on overflow truncate with count) within group (order by spu.page_authorization) origin_page_authorization
                         from v_eba_stds_parsed_urls spu
                         group by spu.destination_app_id, spu.destination_page_id)
select 
case when aap.page_requires_authentication = 'Yes'
     and aap.authorization_scheme is null
     then 'N'
     else 'Y'
     end as pass_fail, 
apex_string.format('%0:%1', aap.application_id, aap.page_id) reference_code,
aap.application_id,
aap.page_id, 
aap.page_name, 
aap.page_access_protection, 
aap.page_mode,
aap.page_requires_authentication,
oa.origin_element_authorization,
oa.origin_parent_element_authorization,
oa.origin_page_authorization
from apex_application_pages aap
inner join apex_applications aa on aap.application_id = aa.application_id
                                and aa.availability_status != 'Unavailable'
left join on origin_auth oa on oa.destination_app_id = aap.application_id
                            and oa.destination_page_id = aap.page_id
where aap.page_id != 0
order by aap.application_id, aap.page_id
/
select spu.destination_app_id, spu.destination_page_id, count(*)
from v_eba_stds_parsed_urls spu
where (    spu.element_authorization is not null 
        or spu.parent_element_authorization  is not null
        or spu.page_authorization is not null)
group by spu.destination_app_id, spu.destination_page_id
/
select 
spu.destination_app_id, spu.destination_page_id
, listagg(distinct spu.element_authorization       ,'/' on overflow truncate with count) within group (order by spu.element_authorization) origin_element_authorization
, listagg(distinct spu.parent_element_authorization,'/' on overflow truncate with count) within group (order by spu.parent_element_authorization) origin_parent_element_authorization
, listagg(distinct spu.page_authorization          ,'/' on overflow truncate with count) within group (order by spu.page_authorization) origin_page_authorization
from v_eba_stds_parsed_urls spu
group by spu.destination_app_id, spu.destination_page_id
--where spu.destination_app_id = 4500
--and spu.destination_page_id = 2200
--and page_id = 1045
--and url_type = 'COLUMN_URL'
/
select *
from v_eba_stds_parsed_urls
where element_authorization is not null
/
select * 
from v_ast_apex_val_col_authorization
/
select 
case when prc.authorization_scheme = prc.authorization_scheme_id
     then 'N'
     else 'Y'
     end as pass_fail,
prc.application_id,
prc.page_id,
prc.page_name,
prc.region_name,
prc.column_alias,
prc.heading,
prc.authorization_scheme,
prc.authorization_scheme_id
from apex_application_page_rpt_cols prc
where authorization_scheme = '12506407035221692'
/
select
    prc.application_id,
    prc.application_name,
    'COLUMN_URL' as url_type,
    prc.column_link_url element_url,
    prc.region_report_column_id as element_id,
    prc.heading element_label,
    prc.column_alias element_name,
    prc.authorization_scheme element_authorization,
    prc.region_id parent_element_id,
    prc.region_name parent_element_name,
    apr.authorization_scheme parent_element_authorization,
    prc.page_id,
    prc.page_name,
    pg.authorization_scheme as page_authorization_scheme,
    eba_stds_parser.app_from_url  (p_origin_app_id => prc.application_id, p_url => prc.column_link_url) destination_app_id,
    eba_stds_parser.page_from_url (p_origin_app_id => prc.application_id, p_url => prc.column_link_url) destination_page_id
from  apex_application_page_rpt_cols prc
inner join apex_application_page_regions apr on prc.application_id = apr.application_id
                                             and prc.region_id = apr.region_id
inner join apex_application_pages pg on  prc.application_id = pg.application_id
                                     and prc.page_id = pg.page_id
where prc.column_link_url is not null
--and destination_app_id = 820
--and destination_page_id = 1044
and prc.page_id = 1045
and prc.application_id = 820
/
select * from table(ut.run('eba_stds_parser_app_from_url_ut'));
alter package eba_stds_parser_app_from_url_ut compile;
alter package eba_stds_parser compile;
/