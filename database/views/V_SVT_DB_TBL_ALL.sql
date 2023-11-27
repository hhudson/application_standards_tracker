--liquibase formatted sql
--changeset view_script:V_SVT_DB_TBL_ALL stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_DB_TBL_ALL
--------------------------------------------------------

create or replace force view V_SVT_DB_TBL_ALL as
select  a.pass_yn,
        asrc.test_name,
        a.table_name, 
        asrc.urgency,
        asrc.urgency_level,
        asrc.test_id,
        a.test_code,
        a.unqid,
        a.code
from V_SVT_DB_TBL__0 a
inner join v_svt_stds_standard_tests asrc on a.test_code = asrc.test_code
/