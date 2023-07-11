create or replace force view v_ast_db_view_all as
select 
a.pass_yn,
asrc.test_name,
a.view_name, 
asrc.urgency,
asrc.urgency_level,
asrc.test_id,
a.standard_code,
a.unqid --a.reference_code
from v_ast_db_view__0 a
inner join v_eba_stds_standard_tests asrc on a.standard_code = asrc.standard_code
/