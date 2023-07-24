/* this view is referenced in v_SVT_db_plsql_all 
 * Checking for duplicate statements
 */
create or replace force view v_SVT_db_plsql_3_duplicate_statements as
select  pass_yn,
        object_name,
        object_type,
        line,
        code,
        unqid
from SVT_standard_view.v_SVT_db_plsql(p_standard_code => 'DUPLICATE_STATEMENTS',
                                      p_failures_only => 'Y')
/