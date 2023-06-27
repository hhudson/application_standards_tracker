--------------------------------------------------------
--  DDL for View v_ast_db_view_invalid
--------------------------------------------------------

create or replace force view v_ast_db_view_invalid as
select pass_yn,
       view_name,
       unqid
from ast_standard_view.v_ast_db_view__0(p_standard_code => 'VALID_VIEW',
                                        p_failures_only => 'Y')
/