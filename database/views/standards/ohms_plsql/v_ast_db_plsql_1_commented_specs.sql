/* this view is referenced in v_ast_db_plsql_all 
 * Enforcing : https://gbuconfluence.us.oracle.com/display/HCGBUDev/SQL+and+PLSQL#SQLandPLSQL-Comments
 * Verifying procedures have comments in package specs
 */
create or replace force view v_ast_db_plsql_1_commented_specs as
select  pass_yn,
        object_name,
        object_type,
        line,
        code,
        unqid,
        standard_code
from ast_standard_view.v_ast_db_plsql(p_standard_code => 'MISSING_COMMENT',
                                      p_failures_only => 'Y')
/