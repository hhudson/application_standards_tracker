--------------------------------------------------------------------------------
--
--       
--      Author:  HAYDEN.H.HUDSON@ORACLE.COM
-- Script name:  V_SVT_APEX_SERT_51_SV_PS_BROWSER_CACHE.sql
--        Date:  23-Dec-2022 13:45
--     Purpose:  View creation DDL for view V_SVT_APEX_SERT_51_SV_PS_BROWSER_CACHE
--
--------------------------------------------------------------------------------


create or replace force editionable view V_SVT_APEX_SERT_51_SV_PS_BROWSER_CACHE as 
select application_id, 
       attribute_id, 
       category_key, 
       collection_name, 
       component_signature, 
       issue_title, 
       LAST_updated_by, 
       LAST_updated_on, 
       link, 
       link_desc, 
       page_id, 
       result, 
       validation_failure_message
from SVT_standard_view.v_SVT_sert__0(
                        p_standard_code => 'SV_PS_BROWSER_CACHE',
                        p_failures_only => 'Y')
/