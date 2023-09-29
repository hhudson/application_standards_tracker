--liquibase formatted sql
--changeset view_script:V_SVT_WCAG_TEST_CODES_LISTAGG stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_WCAG_TEST_CODES_LISTAGG
--------------------------------------------------------

create or replace force editionable view V_SVT_WCAG_TEST_CODES_LISTAGG as
select test_id, 
       apex_string.format('This test is tied to the following WCAG Codes : </br> <ol>%s</ol>',
       listagg(apex_string.format('<li>%s(%s) : %s</li>',wcag_code, conformance_level, description)) within group (order by conformance_level, wcag_code)
       ) wcag_conformance,
       listagg(apex_string.format('%s:',wcag_code)) within group (order by wcag_code) wcag_delimited
from v_svt_wcag_test_codes
group by test_id
/

--rollback drop view V_SVT_WCAG_TEST_CODES_LISTAGG;