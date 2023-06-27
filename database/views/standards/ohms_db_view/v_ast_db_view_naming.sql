--------------------------------------------------------
--  DDL for View v_ast_db_view_naming
--------------------------------------------------------

create or replace force view v_ast_db_view_naming as
select pass_yn,
       view_name,
       unqid
from ast_standard_view.v_ast_db_view__0(p_standard_code => 'VIEW_NAME',
                                        p_failures_only => 'Y')
/