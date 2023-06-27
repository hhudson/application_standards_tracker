--------------------------------------------------------
--  DDL for View v_ast_db_tbl_fk_missing_index
--------------------------------------------------------

create or replace force view v_ast_db_tbl_fk_missing_index as
select pass_yn,
       table_name,
       unqid,
       code
from ast_standard_view.v_ast_db_tbl__0(p_standard_code => 'FK_INDEXED',
                                       p_failures_only => 'Y')
/