--liquibase formatted sql
--changeset view_script:V_SVT_DB_VIEW__0 stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_DB_VIEW__0
--------------------------------------------------------

create or replace force view V_SVT_DB_VIEW__0 as
select dv.view_name,
       esst.test_code,
       dv.pass_yn,
       dv.unqid 
from v_svt_stds_standard_tests esst
join SVT_STANDARD_VIEW.V_SVT_DB_VIEW__0(esst.test_code) dv
    on  esst.nt_name = 'V_SVT_DB_VIEW__0_NT'
    and esst.query_clob is not null
    and esst.active_yn = 'Y'
/