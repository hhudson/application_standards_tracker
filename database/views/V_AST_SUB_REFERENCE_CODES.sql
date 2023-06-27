--liquibase formatted sql
--changeset view_script:V_AST_SUB_REFERENCE_CODES stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_AST_SUB_REFERENCE_CODES
--------------------------------------------------------

create or replace force view V_AST_SUB_REFERENCE_CODES as 
select subr.id, 
       subr.sub_code child_code, 
       subr.explanation, 
       subr.fix, 
       subr.test_id,
       esst.standard_code
from ast_sub_reference_codes subr
inner join eba_stds_standard_tests esst on subr.test_id = esst.id
/
--rollback drop view V_AST_SUB_REFERENCE_CODES;