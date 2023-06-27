create or replace force view v_ast_db_plsql_7_anchored_declarations as
select  pass_yn,
        object_name,
        object_type,
        line,
        code,
        unqid
from ast_standard_view.v_ast_db_plsql(p_standard_code => 'ANCHORED_DECLARATION',
                                      p_failures_only => 'Y')
/  