--------------------------------------------------------
--  DDL for View v_ast_db_editionable_views
--------------------------------------------------------

create or replace force view v_ast_db_editionable_views as
select 
vuv.view_name,
vuv.editioning_view
from v_user_views vuv
where text_vc like '--%'
/