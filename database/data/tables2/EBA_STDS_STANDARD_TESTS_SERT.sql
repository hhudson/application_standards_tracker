--liquibase formatted sql
--changeset data_script:EBA_STDS_STANDARD_TESTS_SERT.sql stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from EBA_STDS_STANDARD_TESTS where nt_type_id = 21;
--precondition-sql-check expectedResult:Y select ast_preferences.get_preference ('AST_SERT_YN') from dual;
--REM INSERTING into EBA_STDS_STANDARD_TESTS
--SET DEFINE OFF;
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011584655334339956935211225951,322950935720896440537821070669755633745,'FAIL_REPORT','More Data Found',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select r.application_id,
          r.page_id,
          r.sert_component_id,
          r.last_updated_by,
          r.last_updated_on,
          r.component_signature,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link,
          r.page_name,
          r.region_name,
          r.region_name_esc,
          r.sert_component_name,
          'Interactive' report_type,
          'XSS: More Data Found - Interactive Reports' link_desc,
           sv_sert_ape]')
|| TO_CLOB(q'[x.sv_sec_rules.check_item_syntax(apr.max_row_count_message) result,
           apr.max_row_count_message val,
           sv_sert_apex.sv_sec_util.get_checksum(apr.max_row_count_message) checksum
     from apex_application_page_ir apr,
          sert_application_page_regions r
    where apr.region_id = r.region_id
and 1=1
   union all
   select r.application_id,
          r.page_id,
          r.sert_component_id,
          r.last_updated_by,
          r.last_updated_on,
          r.component_sign]')
|| TO_CLOB(q'[ature,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link,
          r.page_name,
          r.region_name,
          r.region_name_esc,
          r.sert_component_name,
          'Classic' report_type,
          'XSS: More Data Found - Classic Reports' link_desc,
          sv_sert_apex.sv_sec_rules.check_item_syntax(r.more_data_found_message) result,
          r.more_data_found_message val,
          sv_sert_apex.sv_sec_util.get_checksum(r.more_data_found_message) checks]')
|| TO_CLOB(q'[um
     from sert_application_page_regions r
where 1=1
      and r.source_type = 'Report'
)
select 'SV_XSS_MORE_DATA'    collection_name,
       1        collection_id,
       'SV_XSS_MORE_DATA'       category_key,
       d.application_id,
       31         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
    ]')
|| TO_CLOB(q'[   d.sert_link            link,
       d.link_desc,
       d.page_name            c001,
       d.region_name          c002,
       d.region_name_esc      c003,
       d.report_type          c004,
       d.val                  c005,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name  component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.region_name_esc: `%3`
- d.report_typ]')
|| TO_CLOB(q'[e: `%4`
- d.sert_component_name: `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.region_name_esc,
p4=>d.report_type,
p5=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: More Data Found violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_MORE_DATA','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011559267892128049722542396255,322950935720896440537821070669755633745,'FAIL_REPORT','Turn off Deep Linking',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select ap.application_id,
          ap.page_id,
          ap.page_name,
          case when ap.deep_linking = 'Application Default' then aa.deep_linking else ap.deep_linking end deep_linking,
          ap.last_updated_by,
          ap.last_updated_on,
          ap.component_signature,
          ap.sert_link_page,
          ap.sert_link_cc,
          ap.sert_link
     from sert_application_pages ap,
          apex_applications aa
    where ap.application_id = aa.a]')
|| TO_CLOB(q'[pplication_id
and 1=1
)
select 'SV_PS_DEEP_LINKING'    collection_name,
       1        collection_id,
       'SV_PS_DEEP_LINKING'       category_key,
       d.application_id,
       20         attribute_id,
       d.page_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'Settings - Deep Linking' link_desc,
       d.page_na]')
|| TO_CLOB(q'[me            c001,
       d.page_name            c002,
       d.last_updated_by      c003,
       d.last_updated_on      d001,
       d.deep_linking         c004,
       sv_sert_apex.sv_sec.check_attribute_rule(d.deep_linking, 'COLLECTION','COMPARISON','FAIL','Disabled:Enabled','PASS:FAIL') result,
       d.deep_linking val,
       sv_sert_apex.sv_sec_util.get_checksum(d.deep_linking) checksum
,apex_string.format(p_message => 'Violation details:
- d.component_signature: `%0`',
p0=>d.c]')
|| TO_CLOB(q'[omponent_signature) validation_failure_message,
apex_string.format(
    p_message=> 
    'Page Settings: Deep Linking violation for `%0` (APP_ID %1)',
    p0 => page_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_PS_DEEP_LINKING','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011585864260159571564385932127,322950935720896440537821070669755633745,'FAIL_REPORT','No Data Found',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select r.application_id,
          r.page_id,
          r.sert_component_id,
          r.last_updated_by,
          r.last_updated_on,
          r.component_signature,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link,
          r.page_name,
          r.region_name,
          r.region_name_esc,
          r.sert_component_name,
          'XSS: More Data Found - Interactive Reports' link_desc,
          'Interactive' report_type,
          sv_sert_apex]')
|| TO_CLOB(q'[.sv_sec_rules.check_item_syntax(apr.no_data_found_message) result,
          apr.no_data_found_message val,
          sv_sert_apex.sv_sec_util.get_checksum(apr.no_data_found_message) checksum
     from apex_application_page_ir apr,
          SERT_APPLICATION_PAGE_REGIONS r
    where apr.region_id = r.region_id
and 1=1
   union all
   select r.application_id,
          r.page_id,
          r.sert_component_id,
          r.last_updated_by,
          r.last_updated_on,
          r.component_signatu]')
|| TO_CLOB(q'[re,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link,
          r.page_name,
          r.region_name,
          r.region_name_esc,
          r.sert_component_name,
          'XSS: More Data Found - Classic Reports' link_desc,
          'Classic' report_type,
          sv_sert_apex.sv_sec_rules.check_item_syntax(r.no_data_found_message) result,
          r.no_data_found_message      val,
          sv_sert_apex.sv_sec_util.get_checksum(r.no_data_found_message) checksum
 ]')
|| TO_CLOB(q'[    from SERT_APPLICATION_PAGE_REGIONS r
    where r.source_type = 'Report'
and 1=1
)
select 'SV_XSS_NO_DATA'    collection_name,
       1        collection_id,
       'SV_XSS_NO_DATA'       category_key,
       d.application_id,
       32         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_]')
|| TO_CLOB(q'[link            link,
       d.link_desc,
       d.page_name            c001,
       d.region_name          c002,
       d.region_name_esc      c003,
       d.report_type          c004,
       d.val                  c005,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.region_name_esc: `%3`
- d.report_type: `%4`
- d]')
|| TO_CLOB(q'[.sert_component_name: `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.region_name_esc,
p4=>d.report_type,
p5=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: No Data Found violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_XSS_NO_DATA','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011561685743767278980891808607,322950935720896440537821070669755633745,'FAIL_REPORT','Browser Cache should be disabled',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[with data as (
   select ap.application_id,
          ap.page_id,
          ap.page_name,
          case when ap.browser_cache = 'Application Default' then aa.browser_cache else ap.browser_cache end browser_cache,
          ap.last_updated_by,
          ap.last_updated_on,
          ap.component_signature,
          ap.sert_link_page,
          ap.sert_link_cc,
          ap.sert_link
     from sert_application_pages ap,
          apex_applications aa
    where ap.application_id = aa]')
|| TO_CLOB(q'[.application_id
and 1=1
)
select 'SV_PS_BROWSER_CACHE'    collection_name,
       1        collection_id,
       'SV_PS_BROWSER_CACHE'       category_key,
       d.application_id,
       148         attribute_id,
       d.page_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'Settings - Browser Cache' link_desc,
       d.p]')
|| TO_CLOB(q'[age_name            c001,
       d.page_name            c002,
       d.last_updated_by      c003,
       d.last_updated_on      c004,
       d.browser_cache        c005,
       sv_sert_apex.sv_sec.check_attribute_rule(d.browser_cache, 'COLLECTION','COMPARISON','FAIL','Disabled','PASS') result,
       d.browser_cache val,
       sv_sert_apex.sv_sec_util.get_checksum(d.browser_cache) checksum
,apex_string.format(p_message => 'Violation details:
- d.component_signature: `%0`
- d.browser_c]')
|| TO_CLOB(q'[ache: `%1`
- d.browser_cache: `%2`',
p0=>d.component_signature,
p1=>d.browser_cache,
p2=>d.browser_cache) validation_failure_message,
apex_string.format(
    p_message=> 
    'Page Settings: Browser Cache violation for `%0` (APP_ID %1)',
    p0 => page_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_PS_BROWSER_CACHE','Y',21,'APEX SERT violation (Browser Cache should be disabled)',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011570148224504581385114751839,322950935720896440537821070669755633745,'FAIL_REPORT','Turn on Page Access Protection',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select x.*,
          htf.escape_sc(x.page_name) page_name_esc,
          /** Custom Link to bulk editing: Set Page and Item Protection */
          515 link_page,
          515 link_cc,
          'FB_FLOW_ID,P515_FLOW_ID,P515_ID:' || x.application_id ||','|| x.application_id ||','|| x.page_id link,
          sv_sert_apex.sv_sec.check_attribute_rule(x.page_access_protection, 'COLLECTION','COMPARISON','FAIL','Arguments Must Have Checksum:No Arguments Allowed:No URL Acce]')
|| TO_CLOB(q'[ss','PASS:PASS:PASS') result,
          x.page_access_protection val,
          sv_sert_apex.sv_sec_util.get_checksum(x.page_access_protection) checksum
     from apex_application_pages x
where 1=1
)
select 'SV_URL_PAGE_PROTECT'  collection_name,
       1      collection_id,
       'SV_URL_PAGE_PROTECTION'     category_key,
       d.application_id,
       155       attribute_id,
       d.page_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
   ]')
|| TO_CLOB(q'[    d.link_page,
       d.link_cc,
       d.link,
       'URL - Page Protection' link_desc,
       d.page_name              c001,
       d.page_name_esc          c002,
       d.page_access_protection c003,
       d.result,
       d.val,
       d.checksum
,apex_string.format(p_message => 'Violation details:
- d.component_signature: `%0`',
p0=>d.component_signature) validation_failure_message,
apex_string.format(
    p_message=> 
    'URL Tampering: Page Access Protection violation ]')
|| TO_CLOB(q'[for `%0` (APP_ID %1)',
    p0 => page_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_URL_PAGE_PROTECT','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011571357150324196014289458015,322950935720896440537821070669755633745,'FAIL_REPORT','Enable SSP for Application Items',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select x.*,
          case session_state_protection
               when 'B' then 'Checksum Required - Application Level'
               when 'P' then 'Checksum Required - User Level'
               when 'S' then 'Checksum Required - Session Level'
               when 'I' then 'Restricted - May not be set from browser'
               else 'Unrestricted'
               end ssp_text
     from sert_application_items x
where 1=1
)
select 'SV_XSS_APP_ITEMS'          col]')
|| TO_CLOB(q'[lection_name,
       1              collection_id,
       'SV_XSS_APPLICATION_ITEMS'             category_key,
       d.application_id,
       116               attribute_id,
       d.sert_page_id               page_id,
       d.sert_component_id          component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page             link_page,
       d.sert_link_cc               link_cc,
       d.sert_link                  link,
 ]')
|| TO_CLOB(q'[      'XSS - Application Items' link_desc,
       d.sert_component_name        c001,
       d.ssp_text                   c002,
       sv_sert_apex.sv_sec.check_attribute_rule(d.ssp_text, 'COLLECTION','COMPARISON','PASS','Unrestricted','FAIL') result,
       d.ssp_text val,
       sv_sert_apex.sv_sec_util.get_checksum(d.ssp_text) checksum,
       d.sert_component_name        component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_sign]')
|| TO_CLOB(q'[ature: `%1`
- d.sert_component_name: `%2`
- d.ssp_text: `%3`
- d.ssp_text: `%4`
- d.sert_component_name: `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.sert_component_name,
p3=>d.ssp_text,
p4=>d.ssp_text,
p5=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Application Items violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_APP_ITEMS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011574983927783039901813576543,322950935720896440537821070669755633745,'FAIL_REPORT','Hidden Items at Risk',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select x.*,
          sv_sert_apex.sv_sec.check_attribute_rule(x.attribute_01, 'COLLECTION','COMPARISON','FAIL','Y','PASS') result,
          x.attribute_01 val,
          sv_sert_apex.sv_sec_util.get_checksum(x.attribute_01) checksum
     from sert_application_page_items x
where 1=1
      and x.display_as = 'Hidden'
)
select 'SV_XSS_HIDDEN_ITEMS'    collection_name,
       1        collection_id,
       'SV_XSS_HIDDEN_ITEMS'       category_key,
       d.application_id,
     ]')
|| TO_CLOB(q'[  82         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - Regions' link_desc,
       d.page_name            c001,
       d.item_name            c002,
       d.display_as           c003,
       d.attribute_01         c004,
       d.result,
       d.val,
    ]')
|| TO_CLOB(q'[   d.checksum,
       d.sert_component_name  component_name,
       d.sert_column_name     column_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.item_name: `%2`
- d.display_as: `%3`
- d.sert_component_name: `%4`
- d.sert_column_name: `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.item_name,
p3=>d.display_as,
p4=>d.sert_component_name,
p5=>d.sert_column_name) validation_failure_message,
apex_string.format(
]')
|| TO_CLOB(q'[    p_message=> 
    'XSS: Hidden Items violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_HIDDEN_ITEMS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011576192853602654530988282719,322950935720896440537821070669755633745,'FAIL_REPORT','Escape HTML in Interactive Grid Columns',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select c.*,
          initcap(replace(c.item_type, '_', ' ')) display_as,
          r.component_signature ||','|| c.name component_signature,
          sv_sert_apex.sv_sec.check_attribute_rule(nvl(c.escape_on_http_output, 'Yes'), 'COLLECTION','COMPARISON','PASS','No:Yes','FAIL:PASS') result,
          nvl(c.escape_on_http_output, 'Yes') val,
          sv_sert_apex.sv_sec_util.get_checksum(nvl(c.escape_on_http_output, 'Yes')) checksum
     from sert_appl_page_ig_columns]')
|| TO_CLOB(q'[ c,
          apex_application_page_regions r
    where c.region_id = r.region_id
      and c.application_id = r.application_id
and 1=1
)
select 'SV_XSS_IG_RPT_COLS'    collection_name,
       1        collection_id,
       'SV_XSS_IG_RPT_COLS'       category_key,
       application_id,
       167         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.sert_column_id       column_id,
       d.last_updated_by,
       d.last_updated_on,
       d]')
|| TO_CLOB(q'[.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - Interactive Grid Columns' link_desc,
       d.page_name            c001,
       d.sert_component_name  c002,
       d.sert_column_name     c003,
       d.sert_column_label    c004,
       d.display_as           c005,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name  component_name,
       d.sert_column_]')
|| TO_CLOB(q'[name     column_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.sert_column_id: `%1`
- d.component_signature: `%2`
- d.sert_component_name: `%3`
- d.sert_column_name: `%4`
- d.sert_column_label: `%5`
- d.display_as: `%6`
- d.sert_component_name: `%7`
- d.sert_column_name: `%8`',
p0=>d.sert_component_id,
p1=>d.sert_column_id,
p2=>d.component_signature,
p3=>d.sert_component_name,
p4=>d.sert_column_name,
p5=>d.sert_column_label,
p6=>d.displ]')
|| TO_CLOB(q'[ay_as,
p7=>d.sert_component_name,
p8=>d.sert_column_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Interactive Grid Columns violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_IG_RPT_COLS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011577401779422269160162988895,322950935720896440537821070669755633745,'FAIL_REPORT','Escape HTML in Interactive Report Columns',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select c.*,
          p.page_name,
          initcap(replace(c.display_text_as, '_', ' ')) display_as_str,
          sv_sert_apex.sv_sec.check_attribute_rule(c.display_text_as, 'COLLECTION','COMPARISON','PASS','WITHOUT_MODIFICATION','FAIL') result,
          c.display_text_as val,
          sv_sert_apex.sv_sec_util.get_checksum(c.display_text_as) checksum
     from sert_application_page_ir_col c,
          apex_application_pages p
    where c.application_id = p.appli]')
|| TO_CLOB(q'[cation_id
      and c.page_id = p.page_id
and 1=1
)
select 'SV_XSS_IR_RPT_COLS'    collection_name,
       1        collection_id,
       'SV_XSS_IR_RPT_COLS'       category_key,
       d.application_id,
       156         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.sert_column_id       column_id,
       d.updated_by           last_updated_by,
       d.updated_on           last_updated_on,
       d.component_signature,
       d.sert_link_pa]')
|| TO_CLOB(q'[ge       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link link,
       'XSS - Report Columns' link_desc,
       d.page_name            c001,
       d.sert_component_name  c002,
       d.sert_column_name     c003,
       d.sert_column_label    c004,
       d.display_as_str       c005,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name  component_name,
       d.sert_column_name     column_name
,apex_string.format(p_message => 'Violation]')
|| TO_CLOB(q'[ details:
- d.sert_component_id: `%0`
- d.sert_column_id: `%1`
- d.component_signature: `%2`
- d.sert_component_name: `%3`
- d.sert_column_name: `%4`
- d.sert_column_label: `%5`
- d.display_as_str: `%6`
- d.sert_component_name: `%7`
- d.sert_column_name: `%8`',
p0=>d.sert_component_id,
p1=>d.sert_column_id,
p2=>d.component_signature,
p3=>d.sert_component_name,
p4=>d.sert_column_name,
p5=>d.sert_column_label,
p6=>d.display_as_str,
p7=>d.sert_component_name,
p8=>d.sert_column_nam]')
|| TO_CLOB(q'[e) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Interactive Report Columns violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_IR_RPT_COLS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011579819631061498418512401247,322950935720896440537821070669755633745,'FAIL_REPORT','Escape Special characters in Link Icon',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select r.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(apr.detail_link_text) result,
          apr.detail_link_text val,
          sv_sert_apex.sv_sec_util.get_checksum(apr.detail_link_text) checksum
     from apex_application_page_ir apr,
          sert_application_page_regions r
    where apr.region_id = r.region_id
and 1=1
)
select 'SV_XSS_LINK_ICON'    collection_name,
       1        collection_id,
       'SV_XSS_LINK_ICON'       category_key,
   ]')
|| TO_CLOB(q'[    d.application_id,
       29         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - IR Link Icon' link_desc,
       d.page_name            c001,
       d.region_name          c002,
       d.val                  c003,
       d.result,
       ]')
|| TO_CLOB(q'[d.val,
       d.checksum,
       d.sert_component_name  component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.sert_component_name: `%3`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Link Icon violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
]')
|| TO_CLOB(q'[    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_LINK_ICON','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011581028556881113047687107423,322950935720896440537821070669755633745,'FAIL_REPORT','List Entry Attribute Warning',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select x.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(
               x.entry_attribute_01 || x.entry_attribute_02 || x.entry_attribute_03 || x.entry_attribute_04 || x.entry_attribute_05 ||
               x.entry_attribute_06 || x.entry_attribute_07 || x.entry_attribute_08 || x.entry_attribute_09 || x.entry_attribute_10) result,
          x.entry_target val,
          sv_sert_apex.sv_sec_util.get_checksum(
               x.entry_attribute_01 || x.entry_attr]')
|| TO_CLOB(q'[ibute_02 || x.entry_attribute_03 || x.entry_attribute_04 || x.entry_attribute_05 ||
               x.entry_attribute_06 || x.entry_attribute_07 || x.entry_attribute_08 || x.entry_attribute_09 || x.entry_attribute_10) checksum
     from sert_application_list_entries x
where 1=1
)
select 'SV_XSS_LIST_ATTR'    collection_name,
       1        collection_id,
       'SV_XSS_LIST_ATTR'       category_key,
       application_id,
       34         attribute_id,
       d.sert_page_id         pa]')
|| TO_CLOB(q'[ge_id,
       d.list_entry_id        component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - List Entry Attributes' link_desc,
       d.sert_component_name  c001,
       d.sert_column_name     c002,
       d.sert_column_name_esc c003,
       d.entry_attribute_01   c004,
       d.entry_attribute_02   c005,
       d.]')
|| TO_CLOB(q'[entry_attribute_03   c006,
       d.entry_attribute_04   c007,
       d.entry_attribute_05   c008,
       d.entry_attribute_06   c009,
       d.entry_attribute_07   c010,
       d.entry_attribute_08   c011,
       d.entry_attribute_09   c012,
       d.entry_attribute_10   c013,
       d.result,
       d.val,
       checksum,
       sert_component_name    component_name,
       sert_column_name       column_name
,apex_string.format(p_message => 'Violation details:
- d.list_entry_id:]')
|| TO_CLOB(q'[ `%0`
- d.component_signature: `%1`
- d.sert_component_name: `%2`
- d.sert_column_name: `%3`
- d.sert_column_name_esc: `%4`
- d.entry_attribute_02: `%5`
- d.entry_attribute_03: `%6`
- d.entry_attribute_04: `%7`
- d.entry_attribute_05: `%8`
- d.entry_attribute_06: `%9`
- d.entry_attribute_07: `%10`
- d.entry_attribute_08: `%11`
- d.entry_attribute_09: `%12`
- sert_component_name: `%13`
- sert_column_name: `%14`',
p0=>d.list_entry_id,
p1=>d.component_signature,
p2=>d.sert_componen]')
|| TO_CLOB(q'[t_name,
p3=>d.sert_column_name,
p4=>d.sert_column_name_esc,
p5=>d.entry_attribute_02,
p6=>d.entry_attribute_03,
p7=>d.entry_attribute_04,
p8=>d.entry_attribute_05,
p9=>d.entry_attribute_06,
p10=>d.entry_attribute_07,
p11=>d.entry_attribute_08,
p12=>d.entry_attribute_09,
p13=>sert_component_name,
p14=>sert_column_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: List Entry Attributes violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    ]')
|| TO_CLOB(q'[p1 => application_id
    ) issue_title
  from data d

]'),'AST','SV_XSS_LIST_ATTR','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011582237482700727676861813599,322950935720896440537821070669755633745,'FAIL_REPORT','List Entry Contains &ITEM. Syntax',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select x.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(x.entry_text) result,
          x.entry_text val,
          sv_sert_apex.sv_sec_util.get_checksum(x.entry_text) checksum
     from sert_application_list_entries x
where 1=1
)
select 'SV_XSS_LIST_ENTRIES'    collection_name,
       1        collection_id,
       'SV_XSS_LIST_ENTRIES'       category_key,
       d.application_id,
       86         attribute_id,
       d.sert_page_id         page_id,
       d.sert_]')
|| TO_CLOB(q'[component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - List Entries' link_desc,
       d.sert_component_name  c001,
       d.sert_column_name_esc c002,
       d.sert_column_name     c003,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name  component_name,
       d.sert_column_name    ]')
|| TO_CLOB(q'[ column_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.sert_component_name: `%2`
- d.sert_column_name_esc: `%3`
- d.sert_column_name: `%4`
- d.sert_component_name: `%5`
- d.sert_column_name: `%6`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.sert_component_name,
p3=>d.sert_column_name_esc,
p4=>d.sert_column_name,
p5=>d.sert_component_name,
p6=>d.sert_column_name) validation_failure_message,
apex_string.format(]')
|| TO_CLOB(q'[
    p_message=> 
    'XSS: List Entries violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_XSS_LIST_ENTRIES','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011583446408520342306036519775,322950935720896440537821070669755633745,'FAIL_REPORT','List Entry URL Warning',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select x.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(x.entry_target) result,
          x.entry_target val,
          sv_sert_apex.sv_sec_util.get_checksum(x.entry_target) checksum
     from sert_application_list_entries x
where 1=1
)
select 'SV_XSS_LIST_URL'    collection_name,
       1        collection_id,
       'SV_XSS_LIST_URL'       category_key,
       d.application_id,
       35         attribute_id,
       d.sert_page_id         page_id,
  ]')
|| TO_CLOB(q'[     d.list_entry_id        component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - List Entry URL' link_desc,
       d.sert_component_name  c001,
       d.sert_column_name     c002,
       d.sert_column_name_esc c003,
       d.entry_target         c004,
       d.result,
       d.val,
       d.checksum,
       d.s]')
|| TO_CLOB(q'[ert_component_name  component_name,
       d.sert_column_name     column_name
,apex_string.format(p_message => 'Violation details:
- d.list_entry_id: `%0`
- d.component_signature: `%1`
- d.sert_component_name: `%2`
- d.sert_column_name: `%3`
- d.sert_column_name_esc: `%4`
- d.entry_target: `%5`
- d.sert_component_name: `%6`
- d.sert_column_name: `%7`',
p0=>d.list_entry_id,
p1=>d.component_signature,
p2=>d.sert_component_name,
p3=>d.sert_column_name,
p4=>d.sert_column_name_esc,
p5]')
|| TO_CLOB(q'[=>d.entry_target,
p6=>d.sert_component_name,
p7=>d.sert_column_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: List Entry URL violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_XSS_LIST_URL','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011587073185979186193560638303,322950935720896440537821070669755633745,'FAIL_REPORT','Escape special characters in PL/SQL Output',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select x.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(x.attribute_03) result,
          x.attribute_03 val,
          sv_sert_apex.sv_sec_util.get_checksum(x.attribute_03) checksum
     from sert_application_page_items x
where 1=1
      and x.display_as_code = 'NATIVE_DISPLAY_ONLY'
      and x.attribute_02 = 'PLSQL'
)
select 'SV_XSS_PLSQL_OUTPUT'   collection_name,
       1       collection_id,
       'SV_XSS_PLSQL_OUTPUT'      category_key,
       d.]')
|| TO_CLOB(q'[application_id,
       28        attribute_id,
       d.page_id,
       d.sert_component_id   component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - Display Only PL/SQL Output' link_desc,
       d.page_name            c001,
       d.item_name            c002,
       d.val                  c003,
       d.result,
 ]')
|| TO_CLOB(q'[      d.val,
       d.checksum,
       d.sert_component_name  component_name,
       d.sert_column_name     column_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.item_name: `%2`
- d.sert_component_name: `%3`
- d.sert_column_name: `%4`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.item_name,
p3=>d.sert_component_name,
p4=>d.sert_column_name) validation_failure_message,
apex_string.format(
    p_]')
|| TO_CLOB(q'[message=> 
    'XSS: PL/SQL Output violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_XSS_PLSQL_OUTPUT','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011588282111798800822735344479,322950935720896440537821070669755633745,'FAIL_REPORT','Parent Tab Label Contains &ITEM. Syntax',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select x.*,
          htf.escape_sc(x.tab_label) tab_label_esc,
          sv_sert_apex.sv_sec_rules.check_item_syntax(x.tab_label) result,
          x.tab_label val,
          sv_sert_apex.sv_sec_util.get_checksum(x.tab_label) checksum
     from sert_application_parent_tabs x
where 1=1
)
select 'SV_XSS_PTAB_LABELS'    collection_name,
       1        collection_id,
       'SV_XSS_PTAB_LABELS'       category_key,
       d.application_id,
       153         attribute_id,
      ]')
|| TO_CLOB(q'[ 0                      page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - Parent Tabs' link_desc,
       d.tab_name             c001,
       d.tab_label            c002,
       d.tab_label_esc        c003,
       d.tab_set              c004,
       d.result,
       d.val,
       d.che]')
|| TO_CLOB(q'[cksum,
       d.sert_component_name  component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.tab_name: `%2`
- d.tab_label: `%3`
- d.tab_label_esc: `%4`
- d.tab_set: `%5`
- d.sert_component_name: `%6`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.tab_name,
p3=>d.tab_label,
p4=>d.tab_label_esc,
p5=>d.tab_set,
p6=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: P]')
|| TO_CLOB(q'[arent Tab Labels violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_PTAB_LABELS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011564103595406508239241220959,322950935720896440537821070669755633745,'FAIL_REPORT','Disable `Rejoin Existing Sessions`',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select ap.*,
          case when ap.rejoin_existing_sessions = 'Application Default' then aa.rejoin_existing_sessions
               else ap.rejoin_existing_sessions
               end rejoin_value
     from sert_application_pages ap,
          apex_applications aa
where 1=1
      and ap.application_id = aa.application_id
)
select 'SV_PS_REJOIN_SESSION'    collection_name,
       1        collection_id,
       'SV_PS_REJOIN_SESSION'       category_key,
       d.a]')
|| TO_CLOB(q'[pplication_id,
       163         attribute_id,
       d.page_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'Settings - Rejoin Existing Sessions' link_desc,
       d.page_name            c001,
       d.page_name            c002,
       d.last_updated_by      c003,
       d.last_updated_on      d001,
       d.rejoin_value ]')
|| TO_CLOB(q'[        c004,
       sv_sert_apex.sv_sec.check_attribute_rule(d.rejoin_value, 'COLLECTION','COMPARISON','FAIL','Disabled','PASS') result,
       d.rejoin_value val,
       sv_sert_apex.sv_sec_util.get_checksum(d.rejoin_value) checksum
,apex_string.format(p_message => 'Violation details:
- d.component_signature: `%0`',
p0=>d.component_signature) validation_failure_message,
apex_string.format(
    p_message=> 
    'Page Settings: Rejoin Sessions violation for `%0` (APP_ID %1)',
    p0 =>]')
|| TO_CLOB(q'[ page_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_PS_REJOIN_SESSION','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011565312521226122868415927135,322950935720896440537821070669755633745,'FAIL_REPORT','Disable `Export Report Data`',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select r.application_id,
          r.page_id,
          r.sert_component_id,
          r.page_name,
          r.region_name,
          r.region_name_esc,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link,
          r.source_type,
          r.last_updated_by,
          r.last_updated_on,
          r.component_signature,
          sv_sert_apex.sv_sec.check_attribute_rule(nvl(r.enable_csv_output,'No'), 'COLLECTION','COMPARISON','FAIL','No']')
|| TO_CLOB(q'[,'PASS') result,
          nvl(r.enable_csv_output,'No') val,
          sv_sert_apex.sv_sec_util.get_checksum(nvl(r.enable_csv_output,'No')) checksum
     from sert_application_page_regions r
where 1=1
      and r.source_type_code in ('UPDATABLE_SQL_QUERY', 'SQL_QUERY', 'FUNCTION_RETURNING_SQL_QUERY', 'STRUCTURED_QUERY')
   union all
   select r.application_id,
          r.page_id,
          r.sert_component_id,
          r.page_name,
          r.region_name,
          r.region_name_]')
|| TO_CLOB(q'[esc,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link,
          'Interactive Report' source_type,
          ir.updated_by last_updated_by,
          ir.updated_on last_updated_on,
          ir.component_signature,
          sv_sert_apex.sv_sec.check_attribute_rule(ir.show_download, 'COLLECTION','COMPARISON','FAIL','No','PASS') result,
          ir.show_download val,
          sv_sert_apex.sv_sec_util.get_checksum(ir.show_download) checksum
     from apex_ap]')
|| TO_CLOB(q'[plication_page_ir ir,
          sert_application_page_regions r
    where ir.region_id = r.region_id
and 1=1
   union all
   select r.application_id,
          r.page_id,
          r.sert_component_id,
          r.page_name,
          r.region_name,
          r.region_name_esc,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link,
          'Interactive Grid' source_type,
          ig.last_updated_by last_updated_by,
          ig.last_updated_on last_update]')
|| TO_CLOB(q'[d_on,
          r.component_signature,
          sv_sert_apex.sv_sec.check_attribute_rule(ig.enable_download, 'COLLECTION','COMPARISON','FAIL','No','PASS') result,
          ig.enable_download val,
          sv_sert_apex.sv_sec_util.get_checksum(ig.enable_download) checksum
     from apex_appl_page_igs ig,
          sert_application_page_regions r
    where ig.region_id = r.region_id
and 1=1
)
select 'SV_PS_RPT_EXP_DATA'    collection_name,
       1        collection_id,
       'SV_P]')
|| TO_CLOB(q'[S_RPT_EXP_DATA'       category_key,
       d.application_id,
       143         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'Settings - Export Report Data' link_desc,
       d.page_name            c001,
       d.region_name          c002,
       d.r]')
|| TO_CLOB(q'[egion_name_esc      c003,
       d.source_type          c004,
       d.val                  c005,
       d.result,
       d.val,
       d.checksum
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.region_name_esc: `%3`
- d.source_type: `%4`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.region_name_esc,
p4=>d.source_type) validation_failure_message,
apex_string.]')
|| TO_CLOB(q'[format(
    p_message=> 
    'Page Settings: Export Report Data violation for `%0` (APP_ID %1)',
    p0 => region_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_PS_RPT_EXP_DATA','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011566521447045737497590633311,322950935720896440537821070669755633745,'FAIL_REPORT','Minimize Maximum Row Count',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select r.application_id,
          r.page_id,
          r.page_name,
          r.sert_component_id,
          r.region_name,
          r.region_name_esc,
          r.enable_csv_output export_to_csv,
          'Standard' report_type,
          to_number(nvl(r.maximum_row_count,500)) max_row_count,
          r.last_updated_by,
          r.last_updated_on,
          r.component_signature,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link
]')
|| TO_CLOB(q'[
     from sert_application_page_regions r
where 1=1
      and r.source_type_code in ('SQL_QUERY','UPDATABLE_SQL_QUERY','FUNCTION_RETURNING_SQL_QUERY', 'STRUCTURED_QUERY')
   union all
   select r.application_id,
          r.page_id,
          r.page_name,
          r.sert_component_id,
          r.region_name,
          r.region_name_esc,
          pi.show_download export_to_csv,
          'Interactive Report' report_type,
          to_number(nvl(pi.max_row_count,10000)) max_row_cou]')
|| TO_CLOB(q'[nt,
          pi.updated_by last_updated_by,
          pi.updated_on updated_on,
          pi.component_signature,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link
     from apex_application_page_ir pi,
          sert_application_page_regions r
    where pi.region_id = r.region_id
and 1=1
   union all
   select r.application_id,
          r.page_id,
          r.page_name,
          r.sert_component_id,
          r.region_name,
          r.region_name_e]')
|| TO_CLOB(q'[sc,
          ig.enable_download export_to_csv,
          'Interactive Grid' report_type,
          to_number(nvl(ig.max_row_count,100)) max_row_count,
          ig.last_updated_by last_updated_by,
          ig.last_updated_on updated_on,
          r.component_signature,
          r.sert_link_page,
          r.sert_link_cc,
          r.sert_link
     from apex_appl_page_igs ig,
          sert_application_page_regions r
    where ig.region_id = r.region_id
and 1=1
)
select 'SV_PS_R]')
|| TO_CLOB(q'[PT_MAX_ROWS'    collection_name,
       1        collection_id,
       'SV_PS_RPT_MAX_ROWS'       category_key,
       d.application_id,
       144         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'Settings - Maximum Row Count' link_desc,
       ]')
|| TO_CLOB(q'[d.page_name            c001,
       d.region_name          c002,
       d.region_name_esc      c003,
       d.report_type          c004,
       '#RECOMMENDED_VALUE#'  c005,
       d.max_row_count        n001,
       sv_sert_apex.sv_sec.check_attribute_rule(d.max_row_count, 'COLLECTION','LESS_THAN','FAIL','1000','FAIL') result,
       d.max_row_count val,
       sv_sert_apex.sv_sec_util.get_checksum(to_char(d.max_row_count)) checksum
,apex_string.format(p_message => 'Violation details:
]')
|| TO_CLOB(q'[- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.region_name_esc: `%3`
- d.report_type: `%4`
- d.max_row_count: `%5`
- d.max_row_count: `%6`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.region_name_esc,
p4=>d.report_type,
p5=>d.max_row_count,
p6=>d.max_row_count) validation_failure_message,
apex_string.format(
    p_message=> 
    'Page Settings: Maximum Row Count violation for `%0` (APP_ID %1)',
    p0 => regi]')
|| TO_CLOB(q'[on_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_PS_RPT_MAX_ROWS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011567730372865352126765339487,322950935720896440537821070669755633745,'FAIL_REPORT','Enable item-level encryption',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select x.*,
          htf.escape_sc(x.label) label_esc,
          case when x.maintain_session_state like 'Do Not Save Session State' then x.encrypt_session_state||' (memory only)'
               else x.encrypt_session_state
          end c006,
          sv_sert_apex.sv_sec.check_attribute_rule(case when x.maintain_session_state like 'Do Not Save Session State' then 'Yes' else x.encrypt_session_state end, 'COLLECTION','COMPARISON','FAIL','Yes','PASS') result,
         ]')
|| TO_CLOB(q'[ x.encrypt_session_state val,
          sv_sert_apex.sv_sec_util.get_checksum(x.encrypt_session_state) checksum
     from sert_application_page_items x
where 1=1
      and x.display_as not like 'File Browse...'
)
select 'SV_URL_ITEM_ENCRYPT'    collection_name,
       1        collection_id,
       'SV_URL_ITEM_ENCRYPTION'       category_key,
       d.application_id,
       113         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_]')
|| TO_CLOB(q'[by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'URL - Encrypted Items' link_desc,
       d.page_name            c001,
       d.region               c002,
       d.item_name            c003,
       d.label                c004,
       d.label_esc            c005,
       d.c006                 c006,
       d.result,
       d.val,
       d.checksum,
]')
|| TO_CLOB(q'[       d.sert_component_name  component_name,
       d.sert_column_name     column_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region: `%2`
- d.item_name: `%3`
- d.label: `%4`
- d.label_esc: `%5`
- d.c006: `%6`
- d.sert_component_name: `%7`
- d.sert_column_name: `%8`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region,
p3=>d.item_name,
p4=>d.label,
p5=>d.label_esc,
p6=>d.c006,
p7=>d.sert]')
|| TO_CLOB(q'[_component_name,
p8=>d.sert_column_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'URL Tampering: Item Encryption violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_URL_ITEM_ENCRYPT','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011568939298684966755940045663,322950935720896440537821070669755633745,'FAIL_REPORT','Enable Item Protection Level',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[
with data as (
   select x.*,
          htf.escape_sc(label) label_esc,
          /** Custom Link to bulk editing: Set Page and Item Protection */
          515 link_page,
          515 link_cc,
          'FB_FLOW_ID,P515_FLOW_ID,P515_ID:' || x.application_id ||','|| x.application_id ||','|| x.page_id link,
          sv_sert_apex.sv_sec.check_attribute_rule(item_protection_level, 'COLLECTION','COMPARISON','PASS','Unrestricted','FAIL') result,
          item_protection_level val,
     ]')
|| TO_CLOB(q'[     sv_sert_apex.sv_sec_util.get_checksum(item_protection_level) checksum
     from apex_application_page_items x
where 1=1
)
select 'SV_URL_ITEM_PROTECT'       collection_name,
       1           collection_id,
       'SV_URL_ITEM_PROTECTION'          category_key,
       d.application_id,
       103            attribute_id,
       d.page_id,
       d.item_id                 component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.l]')
|| TO_CLOB(q'[ink_page,
       d.link_cc,
       d.link,
       'URL - Item Protection' link_desc,
       d.page_name               c001,
       d.region                  c002,
       d.item_name               c003,
       d.label                   c004,
       d.label_esc               c005,
       d.display_as              c006,
       d.item_protection_level   c007,
       d.result,
       d.val,
       d.checksum,
       d.region                  component_name,
       d.item_name          ]')
|| TO_CLOB(q'[     column_name
,apex_string.format(p_message => 'Violation details:
- d.item_id: `%0`
- d.component_signature: `%1`
- d.region: `%2`
- d.item_name: `%3`
- d.label: `%4`
- d.label_esc: `%5`
- d.display_as: `%6`
- d.item_protection_level: `%7`
- d.region: `%8`
- d.item_name: `%9`',
p0=>d.item_id,
p1=>d.component_signature,
p2=>d.region,
p3=>d.item_name,
p4=>d.label,
p5=>d.label_esc,
p6=>d.display_as,
p7=>d.item_protection_level,
p8=>d.region,
p9=>d.item_name) validation_fail]')
|| TO_CLOB(q'[ure_message,
apex_string.format(
    p_message=> 
    'URL Tampering: Item Protection violation for `%0` (APP_ID %1)',
    p0 => item_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_URL_ITEM_PROTECT','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011594326740896873968608875359,322950935720896440537821070669755633745,'FAIL_REPORT','Static Region Contains &ITEM. Syntax',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select r.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(r.region_source) result,
          r.region_source val,
          sv_sert_apex.sv_sec_util.get_checksum(r.region_source) checksum
     from sert_application_page_regions r
where 1=1
      and r.source_type not in (
                'HTML/Text (escape special characters)',
                'Report',
                'Interactive Report',
                'PL/SQL',
                'Tabular Form',
                'Cal]')
|| TO_CLOB(q'[endar',
                'List')
      and length(r.region_source) > 0
)
select 'SV_XSS_STATIC_REGION'    collection_name,
       1        collection_id,
       'SV_XSS_STATIC_REGIONS'       category_key,
       d.application_id,
       117         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_]')
|| TO_CLOB(q'[link            link,
       'XSS - Regions' link_desc,
       d.page_name            c001,
       d.region_name          c002,
       d.region_name_esc      c003,
       d.source_type          c004,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name  component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.region_name_esc: `%3`
- d.source_type: `%4`
- d.sert_component_name:]')
|| TO_CLOB(q'[ `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.region_name_esc,
p4=>d.source_type,
p5=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Static Regions violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_STATIC_REGION','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011595535666716488597783581535,322950935720896440537821070669755633745,'FAIL_REPORT','Item Contains Unescaped Output',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select x.*,
          sv_sert_apex.sv_sec.check_attribute_rule(x.escape_on_http_output, 'COLLECTION','COMPARISON','FAIL','No:Yes','FAIL:PASS') result,
          x.escape_on_http_output val,
          sv_sert_apex.sv_sec_util.get_checksum(x.escape_on_http_output) checksum
     from sert_application_page_items x
where 1=1
      and x.display_as_code in ('NATIVE_CHECKBOX', 'NATIVE_RADIOGROUP', 'NATIVE_AUTO_COMPLETE')
)
select 'SV_XSS_UNESCAPED_ITEMS'    collection_name,
       1]')
|| TO_CLOB(q'[        collection_id,
       'SV_XSS_UNESCAPED_ITEMS'       category_key,
       d.application_id,
       22         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - Unescaped Items' link_desc,
       d.page_name            c001,
       d.item_name            ]')
|| TO_CLOB(q'[c002,
       d.display_as           c003,
       d.val                  c004,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name  component_name,
       d.sert_column_name     column_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.item_name: `%2`
- d.display_as: `%3`
- d.sert_component_name: `%4`
- d.sert_column_name: `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.item_name,
p3=>]')
|| TO_CLOB(q'[d.display_as,
p4=>d.sert_component_name,
p5=>d.sert_column_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Unescaped Items violation for `%0` (APP_ID %1)',
    p0 => sert_column_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_XSS_UNESCAPED_ITEMS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011596744592536103226958287711,322950935720896440537821070669755633745,'FAIL_REPORT','Process Contains Unescaped Output',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select x.*,
          sv_sert_apex.sv_sec_rules.check_unescaped_htp(x.process_source) result,
          x.process_source val,
          sv_sert_apex.sv_sec_util.get_checksum(x.process_source) checksum
     from sert_application_page_proc x
where 1=1
      and x.process_type_code = 'PLSQL'
)
select 'SV_XSS_UNESCAPED_PROCESSES'       collection_name,
       1           collection_id,
       'SV_XSS_UNESCAPED_PROCESSES'          category_key,
       d.application_id,
       157 ]')
|| TO_CLOB(q'[           attribute_id,
       d.page_id,
       d.sert_component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page          link_page,
       d.sert_link_cc            link_cc,
       d.sert_link               link,
       'XSS - Unescaped Output - Process' link_desc,
       d.page_name               c001,
       d.sert_component_name     c002,
       d.sert_component_name_esc c003,
       d.process_type            c004,
       d.resu]')
|| TO_CLOB(q'[lt,
       d.val,
       d.checksum,
       d.sert_component_name     component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.sert_component_name: `%2`
- d.sert_component_name_esc: `%3`
- d.process_type: `%4`
- d.sert_component_name: `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.sert_component_name,
p3=>d.sert_component_name_esc,
p4=>d.process_type,
p5=>d.sert_component_name) validation_failure_message,
]')
|| TO_CLOB(q'[apex_string.format(
    p_message=> 
    'XSS: Unescaped Processes violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_UNESCAPED_PROCESSES','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011597953518355717856132993887,322950935720896440537821070669755633745,'FAIL_REPORT','Region Contains Unescaped Output',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select r.*,
          sv_sert_apex.sv_sec_rules.check_unescaped_htp(r.region_source) result,
          r.region_source val,
          sv_sert_apex.sv_sec_util.get_checksum(r.region_source) checksum
     from sert_application_page_regions r
where 1=1
      and r.source_type in ('Report', 'PL/SQL', 'Tabular Form', 'Calendar')
)
select 'SV_XSS_UNESCAPED_REGIONS'    collection_name,
       1        collection_id,
       'SV_XSS_UNESCAPED_REGIONS'       category_key,
       d.appl]')
|| TO_CLOB(q'[ication_id,
       158         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - Unescaped Output - Region' link_desc,
       d.page_name            c001,
       d.region_name          c002,
       d.region_name_esc      c003,
       d.source_type          c004,]')
|| TO_CLOB(q'[
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name  component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.region_name_esc: `%3`
- d.source_type: `%4`
- d.sert_component_name: `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.region_name_esc,
p4=>d.source_type,
p5=>d.sert_component_name) validation_failure_message,
apex_string.format(
   ]')
|| TO_CLOB(q'[ p_message=> 
    'XSS: Unescaped Regions violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_UNESCAPED_REGIONS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011589491037618415451910050655,322950935720896440537821070669755633745,'FAIL_REPORT','Region Title Contains &ITEM. Syntax',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select x.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(x.region_name) result,
          x.region_name val,
          sv_sert_apex.sv_sec_util.get_checksum(x.region_name) checksum
     from sert_application_page_regions x
where 1=1
)
select 'SV_XSS_REGION_TITLES'       collection_name,
       1           collection_id,
       'SV_XSS_REGION_TITLES'          category_key,
       d.application_id,
       87            attribute_id,
       d.page_id,
       d.sert_comp]')
|| TO_CLOB(q'[onent_id       component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page          link_page,
       d.sert_link_cc            link_cc,
       d.sert_link               link,
       'XSS - Regions' link_desc,
       d.page_name               c001,
       d.sert_component_name     c002,
       d.sert_component_name_esc c003,
       d.source_type             c004,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_]')
|| TO_CLOB(q'[name     component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.sert_component_name: `%2`
- d.sert_component_name_esc: `%3`
- d.source_type: `%4`
- d.sert_component_name: `%5`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.sert_component_name,
p3=>d.sert_component_name_esc,
p4=>d.source_type,
p5=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Region Titles vi]')
|| TO_CLOB(q'[olation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d
]'),'AST','SV_XSS_REGION_TITLES','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011590699963438030081084756831,322950935720896440537821070669755633745,'FAIL_REPORT','Escape content in Region Header and Footer',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[with data as (
   select r.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(r.region_header_text || r.region_footer_text) result,
          r.region_name val,
          sv_sert_apex.sv_sec_util.get_checksum(r.region_header_text || r.region_footer_text) checksum
     from sert_application_page_regions r
where 1=1
)
select 'SV_XSS_REG_HEAD_FOOT'    collection_name,
       1        collection_id,
       'SV_XSS_REG_HEAD_FOOT'       category_key,
       d.application_id,
       3]')
|| TO_CLOB(q'[3         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - Region Header and Footer' link_desc,
       d.page_name            c001,
       d.region_name          c002,
       d.region_name_esc      c003,
       d.region_header_text   c004,
       ]')
|| TO_CLOB(q'[d.region_footer_text   c005,
       d.result,
       d.val,
       d.checksum,
       d.sert_component_name  component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.region_name_esc: `%3`
- d.region_header_text: `%4`
- d.region_footer_text: `%5`
- d.sert_component_name: `%6`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.region_name_esc,
p4=>d.region_hea]')
|| TO_CLOB(q'[der_text,
p5=>d.region_footer_text,
p6=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Region Header & Footer violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_XSS_REG_HEAD_FOOT','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011591908889257644710259463007,322950935720896440537821070669755633745,'FAIL_REPORT','Show NULL',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select r.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(apr.show_nulls_as) result,
          apr.show_nulls_as val,
          sv_sert_apex.sv_sec_util.get_checksum(apr.show_nulls_as) checksum
     from apex_application_page_ir apr,
          sert_application_page_regions r
    where apr.region_id = r.region_id
and 1=1
)
select 'SV_XSS_SHOW_NULL'    collection_name,
       1        collection_id,
       'SV_XSS_SHOW_NULL'       category_key,
       application_id,
  ]')
|| TO_CLOB(q'[     30         attribute_id,
       d.page_id,
       d.sert_component_id    component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page       link_page,
       d.sert_link_cc         link_cc,
       d.sert_link            link,
       'XSS - IR Show NULL As' link_desc,
       d.page_name            c001,
       d.region_name          c002,
       d.region_name_esc      c003,
       d.val                  c004,
       d.result,
       ]')
|| TO_CLOB(q'[d.val,
       d.checksum,
       d.sert_component_name  component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.region_name: `%2`
- d.region_name_esc: `%3`
- d.sert_component_name: `%4`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.region_name,
p3=>d.region_name_esc,
p4=>d.sert_component_name) validation_failure_message,
apex_string.format(
    p_message=> 
    'XSS: Show NULL violation for `%0` (APP_ID %1)',]')
|| TO_CLOB(q'[
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d]'),'AST','SV_XSS_SHOW_NULL','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
Insert into EBA_STDS_STANDARD_TESTS (ID,STANDARD_ID,TEST_TYPE,NAME,DISPLAY_SEQUENCE,LINK_TYPE,FAILURE_HELP_TEXT,QUERY_CLOB,OWNER,STANDARD_CODE,ACTIVE_YN,NT_TYPE_ID,ISSUE_DESC,LEVEL_ID) values (323062163011593117815077259339434169183,322950935720896440537821070669755633745,'FAIL_REPORT','Standard Tab Label Contains &ITEM. Syntax',null,'DB_SUPPORTING_OBJECT',null,TO_CLOB(q'[

with data as (
   select x.*,
          sv_sert_apex.sv_sec_rules.check_item_syntax(x.tab_label) result,
          x.tab_label val,
          sv_sert_apex.sv_sec_util.get_checksum(x.tab_label) checksum
     from sert_application_tabs x
where 1=1
)
select 'SV_XSS_STAB_LABELS'       collection_name,
       1           collection_id,
       'SV_XSS_STAB_LABELS'          category_key,
       d.application_id,
       152            attribute_id,
       d.sert_page_id            page_id,
       d.se]')
|| TO_CLOB(q'[rt_component_id       component_id,
       d.last_updated_by,
       d.last_updated_on,
       d.component_signature,
       d.sert_link_page          link_page,
       d.sert_link_cc            link_cc,
       d.sert_link               link,
       'XSS - Standard Tabs' link_desc,
       d.tab_name                c001,
       d.sert_component_name     c002,
       d.sert_component_name_esc c003,
       d.tab_set                 c004,
       d.result,
       d.val,
       d.checksum,
       d.se]')
|| TO_CLOB(q'[rt_component_name     component_name
,apex_string.format(p_message => 'Violation details:
- d.sert_component_id: `%0`
- d.component_signature: `%1`
- d.tab_name: `%2`
- d.sert_component_name: `%3`
- d.sert_component_name_esc: `%4`
- d.tab_set: `%5`
- d.sert_component_name: `%6`',
p0=>d.sert_component_id,
p1=>d.component_signature,
p2=>d.tab_name,
p3=>d.sert_component_name,
p4=>d.sert_component_name_esc,
p5=>d.tab_set,
p6=>d.sert_component_name) validation_failure_message,
apex_string.format(
   ]')
|| TO_CLOB(q'[ p_message=> 
    'XSS: Standard Tab Labels violation for `%0` (APP_ID %1)',
    p0 => sert_component_name, 
    p1 => application_id
    ) issue_title
  from data d

]'),'AST','SV_XSS_STAB_LABELS','Y',21,'APEX SERT violation',299712008894512822497793744324816171149);
