--------------------------------------------------------
--  DDL for View V_APEX_289_SV_PS_BROWSER_CACHE
--------------------------------------------------------

create or replace force editionable view V_APEX_289_SV_PS_BROWSER_CACHE as
INSERT INTO sv_sec_collection_data
  (
  collection_name,
  collection_id,
  category_key,
  application_id,
  attribute_id,
  page_id,
  last_updated_by,
  last_updated_on,
  component_signature,
  edit,
  link_page,
  link_req,
  link_cc,
  link,
  link_desc,
  c001,
  c002,
  c003,
  d001,
  c004,
  result,
  val,
  checksum
  )
SELECT
  '#COLLECTION_NAME#',
  #COLLECTION_ID#,
  (SELECT category_key FROM sv_sec_categories WHERE category_id = 
    (SELECT category_id FROM sv_sec_attributes WHERE attribute_key = 'SV_PS_BROWSER_CACHE')) 
    category_key,
  application_id,
  (SELECT attribute_id FROM sv_sec_attributes WHERE attribute_key = 'SV_PS_BROWSER_CACHE') 
    attribute_id,
  page_id,
  last_updated_by,
  last_updated_on,
  component_signature,
  'Edit' edit,
  link_page,
  NULL link_req,
  link_cc,
  link,
  'Settings - Browser Cache' link_desc,
  page_name,
  page_name,
  last_updated_by,
  last_updated_on,
  browser_cache,
  sv_sec.get_result 
    (
    'SV_PS_BROWSER_CACHE',
    #ATTRIBUTE_SET_ID#,
    browser_cache,
    NULL,
    'N',
    'Y',
    NULL
    ) result,
  browser_cache val,
  sv_sec_util.get_checksum(browser_cache) checksum
FROM
  (
  SELECT
    ap.application_id,
    ap.page_id,
    page_name,
    CASE 
      WHEN ap.browser_cache = 'Application Default' THEN aa.browser_cache 
      ELSE ap.browser_cache END browser_cache,
    4500 link_page,
    NULL link_req,
    '1,4150' link_cc,
    'FB_FLOW_ID,FB_FLOW_PAGE_ID,F4000_P1_FLOW,F4000_P4150_GOTO_PAGE,F4000_P1_PAGE:'
      || ap.application_id||',' || ap.page_id || ',' || ap.application_id||',' || ap.page_id 
      || ',' || ap.page_id link,
    ap.last_updated_by,
    ap.last_updated_on,
    ap.component_signature
  FROM
    apex_application_pages ap,
    apex_applications aa
  WHERE
    aa.application_id = #APPLICATION_ID#
    AND ap.application_id = aa.application_id
  )
/