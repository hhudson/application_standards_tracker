/*
 * Enforcing standards from https://gbuconfluence.us.oracle.com/display/HCGBUDev/SQL+and+PLSQL
 */
create or replace force view v_ast_db_plsql__0 as
select  dp.pass_yn,
        dp.object_name,
        dp.object_type,
        dp.line,
        dp.code,
        dp.unqid,
        esst.standard_code,
        dp.child_code,
        dp.ref_code
from v_eba_stds_standard_tests esst
join ast_standard_view.v_ast_db_plsql(p_standard_code => esst.standard_code, p_failures_only => 'Y') dp
        on  esst.nt_name = 'V_AST_DB_PLSQL_NT'
        and esst.query_clob is not null
        and esst.active_yn = 'Y'
/