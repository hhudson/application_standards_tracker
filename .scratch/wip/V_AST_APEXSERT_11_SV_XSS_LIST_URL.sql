--------------------------------------------------------
--  DDL for View V_AST_APEX_211_SV_XSS_LIST_URL
--------------------------------------------------------

-- drop view V_AST_APEX_211_SV_XSS_LIST_URL
create or replace force editionable view V_AST_APEXSERT_11_SV_XSS_LIST_URL as
select 
    (SELECT category_key FROM SV_SERT_APEX.sv_sec_categories WHERE category_id = 
        (SELECT category_id FROM SV_SERT_APEX.sv_sec_attributes WHERE attribute_key = 'SV_XSS_LIST_URL')) 
    category_key,
    application_id,
    (SELECT attribute_id FROM SV_SERT_APEX.sv_sec_attributes WHERE attribute_key = 'SV_XSS_LIST_URL') 
    attribute_id,
    0 page_id,
    list_entry_id component_id,
    last_updated_by,
    last_updated_on,
    component_signature,
    'Edit' edit,
    '4052' link_page,
    NULL link_req,
    '4050,4052' link_cc,
    'F4000_P4052_ID,F4000_P4050_LIST_ID,FB_FLOW_ID:' || list_entry_id || ',' 
        || list_id || ',' || application_id link,
    'XSS - List Entry URL' link_desc,
    list_name,
    entry_text,
    htf.escape_sc(entry_text) entry_text_esc,
    SV_SERT_APEX.sv_sec_rules.check_item_syntax(entry_target) result,
    entry_target val,
    SV_SERT_APEX.sv_sec_util.get_checksum(entry_target) checksum,
    entry_target
from apex_application_list_entries
/