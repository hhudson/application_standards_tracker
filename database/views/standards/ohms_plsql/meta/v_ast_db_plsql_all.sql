--liquibase formatted sql
--changeset view_script:V_AST_DB_PLSQL_ALL stripComments:false endDelimiter:/ runOnChange:true
/*
 * Enforcing standards from https://gbuconfluence.us.oracle.com/display/HCGBUDev/SQL+and+PLSQL
 */
 
create or replace force view v_ast_db_plsql_all as
select 
'N' pass_yn,
a.unqid reference_code,
-- asrc.src,
-- asrc.link_to_doc standard_ref_link,
asrc.issue_desc,
a.object_name, 
a.object_type, 
a.line,
a.code,
-- asrc.check_type,
asrc.urgency,
asrc.urgency_level,
asrc.test_id,
a.standard_code,
a.child_code
from v_ast_db_plsql__0 a
inner join v_eba_stds_standard_tests_w_child_code asrc on a.standard_code = asrc.standard_code
                                                       and a.child_code = asrc.child_code
/
--rollback drop view V_AST_DB_PLSQL_ALL;