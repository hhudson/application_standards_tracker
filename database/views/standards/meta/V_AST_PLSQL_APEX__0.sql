--------------------------------------------------------
--  DDL for View v_ast_db_apex__0
-- used in eba_stds_data.merge_audit_tbl to populate the ast_plsql_apex_audit table
--------------------------------------------------------

create or replace force editionable view v_ast_plsql_apex__0 as
select a.issue_category,
       -- a.reference_code, 
       a.application_id, 
       a.page_id, 
       a.pass_yn, 
       a.line, 
       a.object_name, 
       a.object_type,
       a.code,
       a.validation_failure_message,
       a.issue_title,
       a.apex_created_by, 
       a.apex_created_on, 
       a.apex_last_updated_by, 
       a.apex_last_updated_on,
       esst.standard_code,
       a.child_code,
       a.unqid
from v_eba_stds_standard_tests esst
join ast_standard_view.v_ast(p_standard_code        => esst.standard_code,
                             p_failures_only        => 'Y',
                             p_urgent_only          => 'Y',
                             p_production_apps_only => 'Y') a
        on  esst.query_clob is not null
        and esst.active_yn = 'Y'
/