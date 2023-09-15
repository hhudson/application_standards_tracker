--liquibase formatted sql
--changeset view_script:v_svt_wcag_report_card stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_svt_wcag_report_card
--------------------------------------------------------

create or replace force editionable view v_svt_wcag_report_card as
select spad.application_id, wtc.conformance_level, wtc.wcag_code, spad.test_code, count(*) violation_count
from svt_plsql_apex_audit spad
inner join v_svt_wcag_test_codes wtc on wtc.test_code = spad.test_code
group by spad.application_id, wtc.conformance_level, wtc.wcag_code, spad.test_code
/

--rollback drop view v_svt_wcag_report_card;