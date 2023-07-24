create or replace force view V_SVT_DB_TBL__0 as
select dv.table_name,
       esst.standard_code,
       dv.pass_yn,
       dv.unqid,
       dv.code
from v_eba_stds_standard_tests esst
join svt_standard_view.v_svt_db_tbl__0(esst.standard_code) dv
    on  esst.nt_name = 'V_SVT_DB_TBL__0_NT'
    and esst.query_clob is not null
    and esst.active_yn = 'Y'
/