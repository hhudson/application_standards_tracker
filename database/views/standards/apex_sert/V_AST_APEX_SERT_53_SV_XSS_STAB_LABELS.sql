--------------------------------------------------------------------------------
--
--       
--      Author:  HAYDEN.H.HUDSON@ORACLE.COM
-- Script name:  V_AST_APEX_SERT_53_SV_XSS_STAB_LABELS.sql
--        Date:  23-Dec-2022 13:45
--     Purpose:  View creation DDL for view V_AST_APEX_SERT_53_SV_XSS_STAB_LABELS
--
--------------------------------------------------------------------------------


create or replace force editionable view V_AST_APEX_SERT_53_SV_XSS_STAB_LABELS as
select application_id, 
       attribute_id, 
       category_key, 
       collection_name, 
       component_signature, 
       issue_title, 
       last_updated_by, 
       last_updated_on, 
       link, 
       link_desc, 
       page_id, 
       result, 
       validation_failure_message
from ast_standard_view.v_ast_sert__0(
                        p_standard_code => 'SV_XSS_STAB_LABELS',
                        p_failures_only => 'Y')
/
