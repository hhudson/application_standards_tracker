/* this view is referenced in v_SVT_db_plsql_all 
 * https://gbuconfluence.us.oracle.com/display/HCGBUDev/SQL+and+PLSQL
 */
create or replace force view v_SVT_db_plsql_4_identifier_naming as
select  pass_yn,
        object_name,
        object_type,
        line,
        code,
        unqid,
        standard_code
from SVT_standard_view.v_SVT_db_plsql(p_standard_code => 'IDENTIFIER_NAMING',
                                      p_failures_only => 'Y')
/