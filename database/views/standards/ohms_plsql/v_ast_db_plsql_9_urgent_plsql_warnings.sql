/* this view is referenced in v_ast_db_plsql_all 


Not all PLSQL_WARNINGS are equal. By and and large, the following holds true:
• 0-1919 errors are FATAL → will prevent your script from even compiling
• 5000 to 5999 warnings are SEVERE → be sure to fix these 
• 6000 to 6249 warnings are INFORMATIONAL → pay special attention to 6002 (unreachable code),  6009( OTHERS handler does not end in RAISE), 6017 (operation will raise an exception)
• 7000 to 7249 warnings are PERFORMANCE 
documentation : 
• 0-1919 docs : https://docs.oracle.com/en/database/oracle/oracle-database/21/errmg/PLS-00001.html#GUID-C2E95CDD-E8D5-4A63-90C2-41B66DD76B27
• 5000 - 7207 docs : https://docs.oracle.com/en/database/oracle/oracle-database/21/errmg/PLW-05000.html#GUID-CEC1E0B9-84FA-402B-918B-3DADFA012F26
*/

create or replace force view v_ast_db_plsql_9_urgent_plsql_warnings as
select  pass_yn,
        object_name,
        object_type,
        line,
        code,
        unqid,
        child_code
from ast_standard_view.v_ast_db_plsql(p_standard_code => 'URGENT_PLSQL_WARNINGS',
                                      p_failures_only => 'Y')
/