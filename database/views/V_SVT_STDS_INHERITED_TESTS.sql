--liquibase formatted sql
--changeset view_script:V_SVT_STDS_INHERITED_TESTS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_STDS_INHERITED_TESTS
--------------------------------------------------------

create or replace force editionable view v_svt_stds_inherited_tests as
select sit.id,
       sit.parent_standard_id,
       sit.test_id,
       sit.standard_id,
       sst.test_code
from svt_stds_inherited_tests sit
inner join svt_stds_standard_tests sst on sit.test_id = sst.id
/

--rollback drop view V_SVT_STDS_INHERITED_TESTS;