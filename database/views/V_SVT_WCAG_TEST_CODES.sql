--liquibase formatted sql
--changeset view_script:v_svt_wcag_test_codes stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_svt_wcag_test_codes
--------------------------------------------------------

create or replace force editionable view v_svt_wcag_test_codes as
select tc.id,
       sw.id wcag_id,
       tc.test_id,
       esst.test_code, 
       apex_string.format('%0.%1.%2', sw.c1st_digit, sw.c2nd_digit, sw.c3rd_digit) wcag_code, 
       sw.description,
       sw.conformance_level
from svt_wcag_test_codes tc
inner join eba_stds_standard_tests esst on esst.id = tc.test_id
inner join svt_wcag sw on sw.id = tc.wcag_id
/

--rollback drop view v_svt_wcag_test_codes;