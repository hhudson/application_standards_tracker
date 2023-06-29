--------------------------------------------------------
--  DDL for View v_ast_apex__0
--------------------------------------------------------

create or replace force editionable view v_ast_apex__0 as
select pass_yn,
       unqid, --reference_code,
       application_id,
       page_id,
       created_by,
       created_on,
       last_updated_by,
       last_updated_on,
       validation_failure_message,
       issue_title,
       standard_code,
       child_code
from v_eba_stds_standard_tests esst
join ast_standard_view.v_ast_apex(p_standard_code => esst.standard_code, 
                                  p_failures_only => 'Y',
                                  p_production_apps_only => 'Y') 
                                          on  esst.nt_name = 'V_AST_APEX__0_NT'
                                          and esst.query_clob is not null
                                          and esst.active_yn = 'Y'
/