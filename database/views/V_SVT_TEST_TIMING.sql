--liquibase formatted sql
--changeset view_script:V_SVT_TEST_TIMING stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_TEST_TIMING
--------------------------------------------------------

create or replace force editionable view V_SVT_TEST_TIMING as
select test_code, avg(elapsed_seconds) avg_seconds
from svt_test_timing
group by test_code
/

--rollback drop view V_SVT_TEST_TIMING;