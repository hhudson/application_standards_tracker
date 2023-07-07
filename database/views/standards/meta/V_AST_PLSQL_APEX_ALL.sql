--------------------------------------------------------
--  DDL for View v_ast_db_apex_all
-- used in eba_stds_data.merge_audit_tbl to populate the ast_plsql_apex_audit table
--------------------------------------------------------

create or replace force editionable view V_AST_PLSQL_APEX_ALL as
select aaa.unqid,  
       'APEX' issue_category,
       'NA' issue_subcategory,
       aaa.application_id, 
       aaa.application_name, 
       aaa.issue_desc, 
       aaa.page_id, 
       aaa.pass_yn, 
       aaa.urgency, 
       aaa.urgency_level, 
       0 line, 
       null object_name, 
       null object_type,
       null code,
       aaa.validation_failure_message,
       aaa.issue_title,
       aaa.created_by apex_created_by, 
       aaa.created_on apex_created_on, 
       aaa.last_updated_by apex_last_updated_by, 
       aaa.last_updated_on apex_last_updated_on,
       aaa.standard_code
from v_ast_apex_all aaa
union all
select asa.unqid, 
       'SERT' issue_category,
       asa.sert_attribute_key issue_subcategory,
       asa.application_id, 
       asa.application_name, 
       asa.issue_desc, 
       asa.page_id, 
       asa.pass_yn, 
       asa.urgency, 
       asa.urgency_level, 
       0 line, 
       null object_name, 
       null object_type,
       null code,
       asa.validation_failure_message,
       asa.issue_title,
       asa.created_by apex_created_by, 
       asa.created_on apex_created_on, 
       asa.last_updated_by apex_last_updated_by, 
       asa.last_updated_on apex_last_updated_on,
       asa.standard_code
from v_ast_sert__all asa
union all
select dpa.unqid, 
       'DB_PLSQL' issue_category,
       'NA' issue_subcategory,
       0 application_id, 
       null application_name, 
       dpa.issue_desc, 
       0 page_id, 
       dpa.pass_yn, 
       dpa.urgency, 
       dpa.urgency_level,
       dpa.line, 
       dpa.object_name, 
       dpa.object_type,
       dpa.code,
       null validation_failure_message,
       null issue_title,
       null apex_created_by, 
       null apex_created_on, 
       null apex_last_updated_by, 
       null apex_last_updated_on,
       dpa.standard_code
from v_ast_db_plsql_all dpa
union all
select dva.unqid,
       'VIEW' issue_category,
       'NA' issue_subcategory,
       0 application_id, 
       null application_name, 
       dva.issue_desc, 
       0 page_id, 
       dva.pass_yn, 
       dva.urgency, 
       dva.urgency_level,
       null line, 
       dva.view_name object_name, 
       'VIEW' object_type,
       null code,
       null validation_failure_message,
       null issue_title,
       null apex_created_by, 
       null apex_created_on, 
       null apex_last_updated_by, 
       null apex_last_updated_on,
       dva.standard_code
from v_ast_db_view_all dva
/