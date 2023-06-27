--liquibase formatted sql
--changeset view_script:V_EBA_TEST_HELP_LIB stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_EBA_TEST_HELP_LIB
--------------------------------------------------------

create or replace force editionable view V_EBA_TEST_HELP_LIB as
select ethl.id,
       ethl.workspace,
       ethl.test_id,
       coalesce(esst.name, '[MISSING TEST]') test_name,
       ethl.standard_code,
       ethl.sub_code,
       ethl.explanation,
       ethl.fix,
       case when src.sub_code is null
            then 'N'
            else 'Y'
            end installed_yn
from eba_test_help_lib ethl
left outer join eba_stds_standard_tests esst on ethl.test_id = esst.id
left outer join ast_sub_reference_codes src on ethl.sub_code = src.sub_code
/

--rollback drop view V_EBA_TEST_HELP_LIB;