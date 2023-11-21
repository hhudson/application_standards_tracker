create or replace force view V_SVT_DB_VIEW_ALL as
select  a.pass_yn,
        asrc.test_name,
        a.view_name, 
        asrc.urgency,
        asrc.urgency_level,
        asrc.test_id,
        a.test_code,
        a.unqid
from V_SVT_DB_VIEW__0 a
inner join v_eba_stds_standard_tests asrc on a.test_code = asrc.test_code
/