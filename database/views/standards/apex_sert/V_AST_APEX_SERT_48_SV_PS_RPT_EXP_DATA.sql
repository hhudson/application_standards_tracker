--------------------------------------------------------------------------------
--
--       
--      Author:  HAYDEN.H.HUDSON@ORACLE.COM
-- Script name:  V_AST_APEX_SERT_48_SV_PS_RPT_EXP_DATA.sql
--        Date:  23-Dec-2022 13:44
--     Purpose:  View creation DDL for view V_AST_APEX_SERT_48_SV_PS_RPT_EXP_DATA
--
--------------------------------------------------------------------------------


create or replace force editionable view V_AST_APEX_SERT_48_SV_PS_RPT_EXP_DATA as
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
                        p_standard_code => 'SV_PS_RPT_EXP_DATA',
                        p_failures_only => 'Y')
/