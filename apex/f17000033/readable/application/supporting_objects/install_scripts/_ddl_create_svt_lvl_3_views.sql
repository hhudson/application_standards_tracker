  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_DB_TBL_ALL" ("PASS_YN", "TEST_NAME", "TABLE_NAME", "URGENCY", "URGENCY_LEVEL", "TEST_ID", "TEST_CODE", "UNQID", "CODE") AS 
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
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_SVT_DB_VIEW_ALL" ("PASS_YN", "TEST_NAME", "VIEW_NAME", "URGENCY", "URGENCY_LEVEL", "TEST_ID", "TEST_CODE", "UNQID") AS 
  select  a.pass_yn,
        asrc.test_name,
        a.view_name, 
        asrc.urgency,
        asrc.urgency_level,
        asrc.test_id,
        a.test_code,
        a.unqid
from V_SVT_DB_VIEW__0 a
inner join v_svt_stds_standard_tests asrc on a.test_code = asrc.test_code
; 