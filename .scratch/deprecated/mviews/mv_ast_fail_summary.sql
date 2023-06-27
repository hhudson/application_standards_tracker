--dbms_mview.refresh ('MV_AST_FAIL_SUMMARY');

create materialized view mv_ast_fail_summary 
refresh complete
start   with sysdate
next  (trunc(sysdate) + 1 + 2/24)
as
select 2 cat_seq, 'GENERAL APEX'                 category,10  as sub_cat_seq,'APP AUTH'                         sub_category, count(*) fail_count 
from V_AST_APEX_APP_AUTH ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
union all
select 2 cat_seq, 'GENERAL APEX'                 category,90  as sub_cat_seq,'APP ITEM NAMING'                  sub_category, count(*) fail_count 
from V_AST_APEX_APP_ITEM_NAMING ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
union all
select 2 cat_seq, 'GENERAL APEX'                 category,50  as sub_cat_seq,'HTML ESCAPING COLS'               sub_category, count(*) fail_count 
from V_AST_APEX_HTML_ESCAPING_COLS ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
union all
select 2 cat_seq, 'GENERAL APEX'                 category,20  as sub_cat_seq,'PAGE AUTH'                        sub_category, count(*) fail_count 
from V_AST_APEX_PAGE_AUTH ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
union all
select 2 cat_seq, 'GENERAL APEX'                 category,80  as sub_cat_seq,'PAGE ITEM NAMING'                 sub_category, count(*) fail_count 
from V_AST_APEX_PAGE_ITEM_NAMING ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
union all
select 1 cat_seq, 'BROKEN FUNCTIONALITY IN APEX' category,10  as sub_cat_seq,'VALID COL LINKS'                  sub_category, count(*) fail_count 
from V_AST_APEX_VALID_COL_LINKS ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
union all
select 1 cat_seq, 'BROKEN FUNCTIONALITY IN APEX' category,20  as sub_cat_seq,'VALID LINK BUTTONS'               sub_category, count(*) fail_count 
from V_AST_APEX_VALID_LINK_BUTTONS ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
union all
select 1 cat_seq, 'BROKEN FUNCTIONALITY IN APEX' category,30  as sub_cat_seq,'VALID LIST LINKS'                 sub_category, count(*) fail_count 
from V_AST_APEX_VALID_LIST_LINKS ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N' 
union all
select 1 cat_seq, 'BROKEN FUNCTIONALITY IN APEX' category,40  as sub_cat_seq,'VAL COL AUTHORIZATION'            sub_category, count(*) fail_count 
from V_AST_APEX_VAL_COL_AUTHORIZATION ast
inner join eba_stds_applications esa on ast.application_id = esa.apex_app_id 
where ast.pass_fail = 'N'
union all 
select 4 cat_seq, 'PLSQL STANDARDS'              category, 10 as sub_cat_seq, check_type                        sub_category, count(*) fail_count
from v_ast_db_plsql_all
group by check_type
;