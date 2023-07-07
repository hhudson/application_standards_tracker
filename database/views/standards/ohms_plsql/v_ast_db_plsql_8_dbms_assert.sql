create or replace force view v_ast_db_plsql_8_dbms_assert as
select  pass_yn,
        object_name,
        object_type,
        line,
        code,
        unqid,
        standard_code
from ast_standard_view.v_ast_db_plsql(p_standard_code => 'DBMS_ASSERT',
                                      p_failures_only => 'Y')
/