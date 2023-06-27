create or replace force view v_ast_db_tbl_all as
select 
a.pass_yn,
asrc.issue_desc,
a.table_name, 
asrc.urgency,
asrc.urgency_level,
asrc.test_id,
a.standard_code,
a.unqid,
a.code
from v_ast_db_tbl__0 a
inner join v_eba_stds_standard_tests asrc on a.standard_code = asrc.standard_code
/