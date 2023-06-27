/* This view is referenced in v_ast_db_plsql_all 
 * https://gbuconfluence.us.oracle.com/display/HCGBUDev/SQL+and+PLSQL
 * Checking for Discouraged Code
 */
create or replace force view v_ast_db_plsql_2_discouraged_code as
select  pass_yn,
        object_name,
        object_type,
        line,
        code,
        unqid
from ast_standard_view.v_ast_db_plsql(p_standard_code => 'DISCOURAGED_CODE',
                                      p_failures_only => 'Y')
/