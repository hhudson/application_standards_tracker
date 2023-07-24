/* this view is referenced in v_SVT_db_plsql_all 
Checking for : This identifier has been declared but is not referenced anywhere.
*/
create or replace force view v_SVT_db_plsql_5_unusued_identifiers as
select  pass_yn,
        object_name,
        object_type,
        line,
        code,
        unqid
from SVT_standard_view.v_SVT_db_plsql(p_standard_code => 'UNUSED_IDENTIFIERS',
                                     p_failures_only => 'Y')
/