---*************************************************************************
---- WCAG 2.0/2.1 - 1.1.1
---- searching images and if they have alt text set in html
---*************************************************************************
--- page region level
-- RGN_IMG_ALT_TEXT
select case
         when (coalesce((length(lower(region_source)) - length(replace(lower(region_source),'<img',null)))/4, length(lower(region_source)), 0) > 
              coalesce((length(lower(region_source)) - length(replace(lower(region_source),'alt="',null)))/5, length(lower(region_source)), 0)) or
              lower(replace(region_source,' ','')) like '%alt=""%' or
              lower(region_source) like '% alt %'
         then 'N'  
         else 'Y'  
       end pass_yn,
      to_char(substr(region_source,1,32737)) src,
       application_id,application_name,page_id,page_name,region_name
from apex_application_page_regions
where lower(region_source) like '%<img%'
union
select case
         when (coalesce((length(lower(region_header_text)) - length(replace(lower(region_header_text),'<img',null)))/4, length(lower(region_header_text)), 0) > 
              coalesce((length(lower(region_header_text)) - length(replace(lower(region_header_text),'alt="',null)))/5, length(lower(region_header_text)), 0)) or
              lower(replace(region_header_text,' ','')) like '%alt=""%' or
              lower(region_header_text) like '% alt %'
         then 'N'  
         else 'Y'  
       end pass_yn,
       region_header_text,
       application_id,application_name,page_id,page_name,region_name
from apex_application_page_regions
where lower(REGION_HEADER_TEXT) like '%<img%'
union
select case
         when (coalesce((length(lower(region_footer_text)) - length(replace(lower(region_footer_text),'<img',null)))/4, length(lower(region_footer_text)), 0) > 
              coalesce((length(lower(region_footer_text)) - length(replace(lower(region_footer_text),'alt="',null)))/5, length(lower(region_footer_text)), 0)) or
              lower(replace(region_footer_text,' ','')) like '%alt=""%' or
              lower(region_footer_text) like '% alt %'
         then 'N'
         else 'Y'  
       end pass_yn,
       region_footer_text,application_id,application_name,page_id,page_name,region_name
from apex_application_page_regions
where lower(REGION_FOOTER_TEXT) like '%<img%'
;
/

-- PI_IMG_ALT_TEXT
--- page item level
select case
         when attribute_01 = 'DB_COLUMN' and 
              trim(attribute_03) is null
         then 'N'   
         when attribute_01 = 'SQL' and 
              (coalesce((length(lower(HTML_FORM_ELEMENT_ATTRIBUTES)) - length(replace(lower(HTML_FORM_ELEMENT_ATTRIBUTES),'<img',null)))/4, length(lower(HTML_FORM_ELEMENT_ATTRIBUTES)), 0) > 
              coalesce((length(lower(HTML_FORM_ELEMENT_ATTRIBUTES)) - length(replace(lower(HTML_FORM_ELEMENT_ATTRIBUTES),'alt="',null)))/5, length(lower(HTML_FORM_ELEMENT_ATTRIBUTES)), 0)) or
              lower(replace(HTML_FORM_ELEMENT_ATTRIBUTES,' ','')) like '%alt=""%' or
              lower(HTML_FORM_ELEMENT_ATTRIBUTES) like '% alt %' or
              trim(HTML_FORM_ELEMENT_ATTRIBUTES) is null
         then 'N' 
         when attribute_01 = 'URL' and
              trim(attribute_02) is null
         then 'N'   
         else 'Y'  
         end pass_yn, 
       HTML_FORM_ELEMENT_ATTRIBUTES src,
       application_id,application_name,page_id,page_name,region,item_name
       --application_id,application_name, page_id, page_name, item_name 
  from apex_application_page_items a
 where display_as = 'Display Image'
union
select case
         when (coalesce((length(lower(item_source)) - length(replace(lower(item_source),'<img',null)))/4, length(lower(item_source)), 0) > 
              coalesce((length(lower(item_source)) - length(replace(lower(item_source),'alt="',null)))/5, length(lower(item_source)), 0)) or
              lower(replace(item_source,' ','')) like '%alt=""%' or
              lower(item_source) like '% alt %'
         then 'N'   
         else 'Y'  
         end pass_yn,
       item_source src,
       application_id,application_name,page_id,page_name,region,item_name
       --application_id,application_name, page_id, page_name, item_name 
  from apex_application_page_items a
 where lower(item_source) like '%<img%'
union
select case
         when (coalesce((length(lower(pre_element_text)) - length(replace(lower(pre_element_text),'<img',null)))/4, length(lower(pre_element_text)), 0) > 
              coalesce((length(lower(pre_element_text)) - length(replace(lower(pre_element_text),'alt="',null)))/5, length(lower(pre_element_text)), 0)) or
              lower(replace(pre_element_text,' ','')) like '%alt=""%' or
              lower(pre_element_text) like '% alt %'
         then 'N'    
         else 'Y'  
         end pass_yn,
       pre_element_text src,
       application_id,application_name,page_id,page_name,region,item_name
       --application_id,application_name, page_id, page_name, item_name 
  from apex_application_page_items a
 where lower(pre_element_text) like '%<img%'
union
select case
         when (coalesce((length(lower(post_element_text)) - length(replace(lower(post_element_text),'<img',null)))/4, length(lower(post_element_text)), 0) > 
              coalesce((length(lower(post_element_text)) - length(replace(lower(post_element_text),'alt="',null)))/5, length(lower(post_element_text)), 0)) or
              lower(replace(post_element_text,' ','')) like '%alt=""%' or
              lower(post_element_text) like '% alt %'
         then 'N'   
         else 'Y'  
         end pass_yn,
       post_element_text,
       application_id,application_name,page_id,page_name,region,item_name
       --application_id,application_name, page_id, page_name, item_name 
  from apex_application_page_items a
 where lower(post_element_text) like '%<img%';
   
--- Classic Report col check
--- this option has no way of including alt text for the image
-- C_COL_IMG_ALT_TEXT
select case
         when format_mask like 'IMAGE%' 
         then 'N' 
         when (coalesce((length(trim(lower(HTML_EXPRESSION))) - length(replace(trim(lower(HTML_EXPRESSION)),'<img',null)))/4, length(trim(lower(HTML_EXPRESSION))), 0) > 
              coalesce((length(trim(lower(HTML_EXPRESSION))) - length(replace(trim(lower(HTML_EXPRESSION)),'alt="',null)))/5, length(trim(lower(HTML_EXPRESSION))), 0)) or
              replace(trim(lower(HTML_EXPRESSION)),' ','') like '%alt=""%' or
              trim(lower(HTML_EXPRESSION)) like '% alt %' 
         then 'N' 
         else 'Y'
         end pass_yn,
       HTML_EXPRESSION src,
       application_id,application_name,page_id,page_name,region_id,region_name, column_alias
from apex_application_page_rpt_cols a
where (format_mask like 'IMAGE%' or
       trim(lower(HTML_EXPRESSION)) like '%<img%')
  ;
  
--- Interactive Report col check
--- this option has no way of including alt text for the image
-- IR_COL_IMG_ALT_TEXT
select case
         when format_mask like 'IMAGE%' 
         then 'N' 
         when (coalesce((length(trim(lower(HTML_EXPRESSION))) - length(replace(trim(lower(HTML_EXPRESSION)),'<img',null)))/4, length(trim(lower(HTML_EXPRESSION))), 0) > 
              coalesce((length(trim(lower(HTML_EXPRESSION))) - length(replace(trim(lower(HTML_EXPRESSION)),'alt="',null)))/5, length(trim(lower(HTML_EXPRESSION))), 0)) or
              replace(trim(lower(HTML_EXPRESSION)),' ','') like '%alt=""%' or
              trim(lower(HTML_EXPRESSION)) like '% alt %' 
         then 'N' 
         else 'Y'
       end pass_yn,
       application_id,application_name,page_id,region_id,region_name,a.column_alias,a.*
from apex_application_page_ir_col a
where (format_mask like 'IMAGE%' or
       trim(lower(HTML_EXPRESSION)) like '%<img%');
  
--- Interactive Grid col check
--  IG_COL_IMG_ALT_TEXT
select case
         when (coalesce((length(lower(attribute_01)) - length(replace(lower(attribute_01),'<img',null)))/4, length(lower(attribute_01)), 0) > 
              coalesce((length(lower(attribute_01)) - length(replace(lower(attribute_01),'alt="',null)))/5, length(lower(attribute_01)), 0)) or
              lower(replace(attribute_01,' ','')) like '%alt=""%' or
              lower(attribute_01) like '% alt %'
           then 'N'   
         else 'Y'  
       end pass_yn,
       attribute_01,
       application_id,application_name,page_id,region_id,region_name
from apex_appl_page_ig_columns a
where attribute_01 like '%<img%';
  
  
---*************************************************************************
/*
WCAG 2.0/2.1 - 'Y'.3.1 Info and Relationships, 
               2.4.6 Headings and Labels,
               2.5.3 Label in Name,
               3.3.2 Labels or Instructions,
               4.1.2 Name, Role, Value
Checking that all apex object (regions, items, report column headings) 
 are labeled appropriately
 */
---*************************************************************************
---- confirm all pages have name, title and not a blank space
set define off;
-- PG_NAME_TITLE
select case
         when (trim(page_name) is null or lower(trim(page_name)) = '&nbsp;'
               or trim(page_title) is null or lower(trim(page_title)) = '&nbsp;') 
          then 'N' 
         else 'Y'
       end pass_yn,
       a.application_id, page_id,page_name,page_title
  from apex_application_pages a
 where page_function != 'Global Page';
            
--- confirm all Regions have and not a blank space
-- RGN_NAME
select case
         when (trim(region_name) is null or
               lower(trim(region_name)) = '&nbsp;' or
               lower(trim(region_name)) = 'new') then 'N' 
         else 'Y'
       end pass_yn,
       application_id,application_name,page_id,page_name,region_name
  from apex_application_page_regions;
    
--- confirm all Regions on a page are unique
-- RGN_UNQ
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,application_name,page_id,page_name,region_name,DISPLAY_SEQUENCE
 from (select application_id,application_name,page_id,page_name,region_name,DISPLAY_SEQUENCE,--a.*--count(*) cnt
       ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(region_name)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt
  from apex_application_page_regions a
 )
 --group by application_id,application_name,page_id,page_name,region_name
 ;

-- Confirm all page items have unique labels by default apex force unique item names
--PI_LBL_UNQ
select case
         when (trim(label) is null
           or lower(trim(label)) = '&nbsp;') then 'N' 
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,application_name, page_id, page_name, item_name,label
  from (select row_number( ) over (partition by application_id,page_id,trim(lower(label)) order by display_sequence nulls last) value_dup_cnt,
       application_id,application_name, page_id, page_name, item_name,label,DISPLAY_SEQUENCE
  from apex_application_page_items a
 where DISPLAY_AS_CODE not in ('NATIVE_HIDDEN') )
;
-- missing : ACC_BTN_UNQ


--- Confirm all page items have valid label and no blank spaces;
-- PI_VLD_LBL
select case
         when (trim(label) is null
           or lower(trim(label)) = '&nbsp;') then 'N' 
         else 'Y'
       end pass_yn,
       application_id,application_name, page_id, page_name, item_name,label,display_sequence
  from apex_application_page_items a
 where display_as_code not in ('NATIVE_HIDDEN') 
;


set define off;
--- Classic Report col header check - all columns have a header defined
-- C_COL_VLD_HEADNG
select case
         when (trim(heading) is null or
               lower(trim(heading)) = '&nbsp;') then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,heading,display_sequence
from apex_application_page_rpt_cols
;


--- Classic Report col header check - column headings are unqiue per region
-- C_COL_UNQ_HEADNG
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,heading,DISPLAY_SEQUENCE
   from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(heading)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt,
       application_id,page_id,region_id,region_name,heading,DISPLAY_SEQUENCE
from apex_application_page_rpt_cols
where COLUMN_IS_HIDDEN = 'No')
;

--- Classic Report col header check - column alias are unqiue per region
-- REDUNDANT (NOTIMPLEMENTED) didn't do this one in favor of the one below (-- C_COL_UNQ_LBL)
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,column_alias,heading,DISPLAY_SEQUENCE
   from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(column_alias)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt,
       application_id,page_id,region_id,region_name,column_alias,heading,DISPLAY_SEQUENCE
from apex_application_page_rpt_cols
where COLUMN_IS_HIDDEN = 'No')
;

--- Classic Report col header check - column alias are unqiue per page
-- C_COL_UNQ_LBL
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,column_alias,heading,DISPLAY_SEQUENCE
   from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(column_alias)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt,
       application_id,page_id,region_id,region_name,column_alias,heading,DISPLAY_SEQUENCE
from apex_application_page_rpt_cols
where COLUMN_IS_HIDDEN = 'No')
;

  
--- Interactive Report all columns have a header defined
-- IR_COL_VLD_HEADNG
select case
         when (trim(report_label) is null
        or lower(trim(report_label)) = '&nbsp;'
        or trim(form_label) is null
        or lower(trim(form_label)) = '&nbsp;') then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,report_label,form_label,display_order
from apex_application_page_ir_col a
;

--- Interactive Report all column_alias per page are unique (this determines html id value)
-- IR_COL_UNQ
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,column_alias,report_label,display_order
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(column_alias)) ORDER BY display_order NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,report_label,column_alias,display_order
          from apex_application_page_ir_col a
         )
;
--- Interactive Report all report labels(column headers) per region are unique
-- REDUNDANT to IR_COL_UNQ (NOTIMPLEMENTED)
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,report_label,display_order
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(report_label)) ORDER BY display_order NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,report_label,display_order
          from apex_application_page_ir_col a
         )
;

--- Interactive Report all form labels(column headers) per region are unique
-- IR_COL_UNQ_LBL
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,form_label,COLUMN_ALIAS,display_order
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(form_label)) ORDER BY display_order NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,form_label,COLUMN_ALIAS,display_order
          from apex_application_page_ir_col a
         )
;
  
--- Interactive Grid column headers all have a value defined
-- IG_COL_VLD
select case
         when (trim(heading) is null
        or lower(trim(heading)) = '&nbsp;') then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,heading,display_sequence
  from apex_appl_page_ig_columns a
;

--- Interactive Grid column headers for a region are unique
-- IG_COL_UNQ_HEADNG
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,heading,SOURCE_EXPRESSION,display_sequence
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(heading)) ORDER BY display_sequence NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,heading,SOURCE_EXPRESSION,display_sequence
          from apex_appl_page_ig_columns
         )
;

--- Interactive Grid column alias for the page (across all IGs) are unique
-- IG_COL_UNQ_ALIAs
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,heading,SOURCE_EXPRESSION,display_sequence
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(SOURCE_EXPRESSION)) ORDER BY display_sequence NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,heading,SOURCE_EXPRESSION,display_sequence
          from apex_appl_page_ig_columns
         )
;
--- Interactive Grid form labels for a region are unique
-- REDUNDANT TO IG_COL_UNQ_ALIAS (NOTIMPLEMENTED)
select case
         when value_dup_cnt > 1 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name,label,SOURCE_EXPRESSION,display_sequence
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(nvl(label,heading))) ORDER BY display_sequence NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,nvl(label,heading) label,SOURCE_EXPRESSION,display_sequence
          from apex_appl_page_ig_columns
         )
;

--- Check that IG has at least one column set as a row header per region ; 
--- ***( Will be available in 22.1 for IR and classic report
-- ROW_HEADER
select case
         when USE_AS_ROW_HEADER_cnt = 0 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,page_name,region_id,region_name
  from (select sum(case
               when USE_AS_ROW_HEADER = 'Yes' then 'N' 
               else 'Y'
             end) USE_AS_ROW_HEADER_cnt, 
       application_id,page_id,page_name,region_id,region_name
  from apex_appl_page_ig_columns
 group by application_id,page_id,page_name,region_id,region_name)
;


--- check that IR report has at least one column flag as row header
-- ROW_HEADER
select case
         when USE_AS_ROW_HEADER_cnt = 0 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name
  from (select sum(case
               when upper(USE_AS_ROW_HEADER) = 'YES' then 'N' 
               else 'Y'
             end) USE_AS_ROW_HEADER_cnt, 
       application_id,page_id,region_id,region_name
  from apex_application_page_ir_col
 group by application_id,page_id,region_id,region_name)
;

--- check classic report has at least one column flaged as row header
-- ROW_HEADER
select case
         when USE_AS_ROW_HEADER_cnt = 0 then 'N' 
         else 'Y'
       end pass_yn,
       application_id,page_id,region_id,region_name
  from (select count(case
               when upper(USE_AS_ROW_HEADER) = 'Y' then 'N' 
               else 'Y'
             end) USE_AS_ROW_HEADER_cnt, 
       application_id,page_id,region_id,region_name
  from APEX_APPLICATION_PAGE_RPT_COLS
 group by application_id,page_id,region_id,region_name)
;


---*************************************************************************
---- WCAG 2.1 - 1.3.5 Identify Input Purpose
---- Checking that inputs fields have autocomplete where appropriate
---*************************************************************************
-- Not supported unless manual entered in Custom Attributes
-- Once autocomplete added as option will likely have to check that column directly
-- if autocomplete is not present then fail.  add exception to items that don't need it
--    this approach my have big impacts and require many overrides.  may have to change in future
--
/*
looking for autocomplete="given-name" in "custom attributes"
WCAG 2.1 - 1.3.5 Identify Input Purpose. Checking that inputs fields have autocomplete where appropriate
https://www.w3.org/WAI/WCAG21/Understanding/identify-input-purpose.html
https://www.w3.org/TR/WCAG21/#input-purposes 
ACC_AUTOCOMPLETE
*/
select --* 
       case
         when (lower(trim(HTML_FORM_ELEMENT_ATTRIBUTES)) not like '%autocomplete%'
               or trim(HTML_FORM_ELEMENT_ATTRIBUTES) is null) then 'N' 
         else 'Y'
       end pass_yn,
       application_id,application_name, page_id, page_name,region, item_name,HTML_FORM_ELEMENT_ATTRIBUTES
  from apex_application_page_items a
 where display_as_code not in ('NATIVE_HIDDEN','NATIVE_CHECKBOX')
  -- and (lower(trim(HTML_FORM_ELEMENT_ATTRIBUTES)) not like '%autocomplete%'
    --   or trim(HTML_FORM_ELEMENT_ATTRIBUTES) is null)
;


---- Checking editable IG regions and columns that are not set as Query Only
-- ACC_IG_COL_AUTOCOMPLETE
select case
         when (lower(trim(b.item_attributes)) not like '%autocomplete%'
               or trim(b.item_attributes) is null) 
         then 'N' 
         else 'Y'
         end pass_yn,
       b.application_id,
       b.page_id, 
       b.region_id,
       b.region_name, 
       b.source_expression,
       b.item_attributes
from apex_appl_page_igs a,
     apex_appl_page_ig_columns b
where a.application_id = b.application_id
  and b.region_id = a.region_id
  and a.is_editable = 'Yes'
  and b.is_query_only = 'No'
;


---*************************************************************************
/*
WCAG 2.1 - 2.1.4 Character Key Shortcuts
Checking if shortcut keys have been created
 check IG javascript initialization code for references to keyboard shortcuts.
you don't want to interfere with the shortcuts for screen readers
https://www.w3.org/WAI/WCAG21/Understanding/character-key-shortcuts.html
ACC_IG_JS_SHORTCUT
*/
select case
         when lower(trim(javascript_code)) like '%shortcut%' then 'N' 
         else 'Y'
       end pass_yn,
       region_source,region_header_text,region_footer_text,application_id,application_name,page_id,page_name,region_name
from apex_appl_page_igs
;




---*************************************************************************
---- WCAG 2.0/2.1 - 2.1.2 No Keyboard Trap
---- Checking for js blur listening events or 
---*************************************************************************
--- Checking page DAs for Lose Focus or Get Focus triggering events
-- DA_FOCUS
select case
         when WHEN_EVENT_NAME in ('Lose Focus','Get Focus') then 'N' 
         else 'Y'
       end pass_yn,
       application_id,application_name,page_id,page_name,dynamic_action_id,dynamic_action_name
from apex_application_page_da
;
  
  
--- Check page JS for on blur events
-- DA_BLUR
select case
         when (lower(trim(JAVASCRIPT_CODE)) like '%blur%'
               or lower(trim(JAVASCRIPT_CODE)) like '%focusout%'
               or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%blur%'
               or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%focusout%') then 'N' 
         else 'Y'
       end pass_yn,
       page_name,application_name,application_id,JAVASCRIPT_CODE,JAVASCRIPT_CODE_ONLOAD
from apex_application_pages
;

---*************************************************************************
/*
WCAG 2.0/2.1 - 2.2.2 Pause, Stop, Hide
             - 2.3.1 Three Flashes or Below Threshold
Checking pages for inline CSS for blinking or animation logic
*/
---*************************************************************************

--- Check page level for inline CSS
-- PAGE_INACC_CSS
select case
         when (lower(trim(inline_css)) like '%blink%'
               or lower(trim(inline_css)) like '%animation%') then 'N' 
         else 'Y'
       end pass_yn,
       page_id,page_name,inline_css
        -- add in additional that sert needs
  from apex_application_pages a
;

--- Check classic report columns for CSS
-- C_COL_INACC_CSS
 select case
          when (lower(trim(CSS_STYLE)) like '%blink%'
                or lower(trim(CSS_STYLE)) like '%animation%') then 'N' 
          else 'Y'
        end pass_yn,
        page_id,page_name,a.region_name,a.column_alias, a.css_style
   from APEX_APPLICATION_PAGE_RPT_COLS a
;

--- Check application temp pages
-- ACC_PG_TMP_CSS_ANMTN
 select case
          when (lower(trim(inline_css)) like '%blink%'
                or lower(trim(inline_css)) like '%animation%') then 'N' 
          else 'Y'
        end pass_yn,
        inline_css, application_id,template_name
   from APEX_APPLICATION_TEMP_PAGE a
;

--- Check application temp lists
-- ACC_LST_TMP_CSS_ANMTN
 select case
          when (lower(trim(inline_css)) like '%blink%'
                or lower(trim(inline_css)) like '%animation%') then 'N' 
          else 'Y'
        end pass_yn,
        template_name, inline_css
   from APEX_APPLICATION_TEMP_LIST a
;

--- Check CSS in theme roller
-- THEME_STL_INACC
 select case
          when (lower(trim(THEME_ROLLER_CONFIG)) like '%blink%'
                 or lower(trim(THEME_ROLLER_CONFIG)) like '%animation%') then 'N' 
          else 'Y'
        end pass_yn,
        theme_number,name, THEME_ROLLER_CONFIG
   from apex_application_theme_styles a
;


---- check page for js that is setting intervals or timeouts
-- PAGE_JS_INTRVL_TIMT
select case
          when ((lower(trim(JAVASCRIPT_CODE)) like '%setinterval%'
                 or lower(trim(JAVASCRIPT_CODE)) like '%settimeout%'
                 or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%setinterval%'
                 or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%settimeout%')) then 'N' 
          else 'Y'
        end pass_yn,
        a.application_id,application_name,a.page_id,a.page_name
from apex_application_pages a
;

--- checking DA for js that is setting intervals or timeouts
-- DA_JS_INTRVL_TIMT
select case
          when ((lower(trim(attribute_01)) like '%setinterval%'
                 or lower(trim(attribute_01)) like '%settimeout%'
                 or lower(trim(attribute_01)) like '%setinterval%'
                 or lower(trim(attribute_01)) like '%settimeout%')) then 'N' 
          else 'Y'
        end pass_yn,
        a.application_id,application_name,a.page_id,a.page_name,
        a.dynamic_action_name,a.action_pd_name,dynamic_action_event_result
from apex_application_page_da_acts a
where action_code = 'NATIVE_JAVASCRIPT_CODE';

---*************************************************************************
/*
WCAG 2.0/2.1 - 2.4.2 Page Titled
Checking page title for uniqueness and provide list of page titles
 to be manual checked if they are descriptive of topic or purpose
 ** trimming out whitespace and converting to lower case for uniqueness
 */
---*************************************************************************
-- PG_NAME_UNQ
 select case
          when value_dup_cnt > 1 then 'N' 
          else 'Y'
        end pass_yn,
        application_id,page_id,lower_case_page_name
    from (select application_id,page_id,lower(trim(page_name)) lower_case_page_name,
                 ROW_NUMBER( ) OVER (PARTITION BY application_id,lower(trim(page_name)) ORDER BY page_id NULLS LAST) value_dup_cnt
            from apex_application_pages
           ;
  
---*************************************************************************
/*
WCAG 2.0/2.1 - 2.4.3 Focus Order
Checking application where tabindex has been added to an attribute that
  have negative impact on tab/focus order
*/
---*************************************************************************
-- LE_TABINDX
select case
         when (lower(trim(entry_attribute_08)) like '%tabindex%'
                or lower(trim(entry_image_alt_attribute)) like '%tabindex%'
                or lower(trim(translate_attributes)) like '%tabindex%'
                or lower(trim(entry_attribute_05)) like '%tabindex%'
                or lower(trim(entry_attribute_10)) like '%tabindex%'
                or lower(trim(entry_attribute_09)) like '%tabindex%'
                or lower(trim(entry_attribute_06)) like '%tabindex%'
                or lower(trim(entry_attribute_07)) like '%tabindex%'
                or lower(trim(entry_attribute_03)) like '%tabindex%'
                or lower(trim(entry_attribute_02)) like '%tabindex%'
                or lower(trim(entry_image_attributes)) like '%tabindex%'
                or lower(trim(entry_attribute_01)) like '%tabindex%'
                or lower(trim(entry_attribute_04)) like '%tabindex%') then 'N' 
         else 'Y'
       end pass_yn,
       application_id,
       entry_image_attributes,
       entry_image_alt_attribute,
       entry_attribute_01,
       entry_attribute_02,
       entry_attribute_03,
       entry_attribute_04,
       entry_attribute_05,
       entry_attribute_06,
       entry_attribute_07,
       entry_attribute_08,
       entry_attribute_09,
       entry_attribute_10,
       translate_attributes
 from apex_application_list_entries
 ;

---- checking pages for added tabindex attributes
-- PAGE_TABINDX
select case
         when lower(trim(dialog_attributes)) like '%tabindex%' then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       page_name,
       application_id,
       dialog_attributes
 from apex_application_pages
 ;

---- checking page buttons for added tabindex attributes
-- BTN_TABINDX
select case
         when (lower(trim(button_attributes)) like '%tabindex%'
               or lower(trim(grid_column_attributes)) like '%tabindex%'
               or lower(trim(image_attributes)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       grid_column_attributes,
       image_attributes,
       button_attributes
  from apex_application_page_buttons
 ;

---- checking IR region for added tabindex attributes
-- IR_TABINDX
select case
         when (lower(trim(detail_link_attributes)) like '%tabindex%'
               or lower(trim(icon_view_img_attr_text)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       detail_link_attributes,
       icon_view_img_attr_text
 from apex_application_page_ir
 ;

---- checking ir columns for added tabindex attributes
-- IR_COL_TABINDX
select case
         when (lower(trim(column_link_attr)) like '%tabindex%' ) 
         then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       column_link_attr
  from apex_application_page_ir_col
 ;

-- PI_TABINDX
select case
         when (    lower(trim(html_form_element_attributes)) like '%tabindex%'
                or lower(trim(attribute_12)) like '%tabindex%'
                or lower(trim(attribute_04)) like '%tabindex%'
                or lower(trim(attribute_03)) like '%tabindex%'
                or lower(trim(attribute_13)) like '%tabindex%'
                or lower(trim(attribute_07)) like '%tabindex%'
                or lower(trim(item_button_image_attributes)) like '%tabindex%'
                or lower(trim(attribute_02)) like '%tabindex%'
                or lower(trim(attribute_09)) like '%tabindex%'
                or lower(trim(attribute_15)) like '%tabindex%'
                or lower(trim(attribute_01)) like '%tabindex%'
                or lower(trim(attribute_05)) like '%tabindex%'
                or lower(trim(attribute_14)) like '%tabindex%'
                or lower(trim(html_table_cell_attr_label)) like '%tabindex%'
                or lower(trim(attribute_10)) like '%tabindex%'
                or lower(trim(quick_pick_link_attr)) like '%tabindex%'
                or lower(trim(html_table_cell_attr_element)) like '%tabindex%'
                or lower(trim(read_only_display_attr)) like '%tabindex%'
                or lower(trim(grid_column_attributes)) like '%tabindex%'
                or lower(trim(attribute_11)) like '%tabindex%'
                or lower(trim(attribute_08)) like '%tabindex%'
                or lower(trim(form_element_option_attributes)) like '%tabindex%'
                or lower(trim(attribute_06)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       quick_pick_link_attr,
       attribute_01,
       attribute_02,
       attribute_03,
       attribute_04,
       attribute_05,
       attribute_06,
       attribute_07,
       attribute_08,
       attribute_09,
       attribute_10,
       attribute_11,
       attribute_12,
       attribute_13,
       attribute_14,
       attribute_15,
       read_only_display_attr,
       html_table_cell_attr_label,
       html_table_cell_attr_element,
       html_form_element_attributes,
       form_element_option_attributes,
       item_button_image_attributes,
       grid_column_attributes
 from apex_application_page_items
 ;

-- PG_RGN_TABINDX
select case
         when (    lower(trim(attribute_22)) like '%tabindex%'
                or lower(trim(attribute_20)) like '%tabindex%'
                or lower(trim(attribute_09)) like '%tabindex%'
                or lower(trim(attribute_21)) like '%tabindex%'
                or lower(trim(attribute_03)) like '%tabindex%'
                or lower(trim(attribute_11)) like '%tabindex%'
                or lower(trim(ascending_image_attributes)) like '%tabindex%'
                or lower(trim(descending_image_attributes)) like '%tabindex%'
                or lower(trim(attribute_01)) like '%tabindex%'
                or lower(trim(attribute_05)) like '%tabindex%'
                or lower(trim(grid_column_attributes)) like '%tabindex%'
                or lower(trim(attribute_13)) like '%tabindex%'
                or lower(trim(attribute_06)) like '%tabindex%'
                or lower(trim(attribute_25)) like '%tabindex%'
                or lower(trim(attribute_24)) like '%tabindex%'
                or lower(trim(html_table_cell_attributes)) like '%tabindex%'
                or lower(trim(attribute_12)) like '%tabindex%'
                or lower(trim(attribute_18)) like '%tabindex%'
                or lower(trim(attribute_07)) like '%tabindex%'
                or lower(trim(attribute_19)) like '%tabindex%'
                or lower(trim(attribute_16)) like '%tabindex%'
                or lower(trim(region_attributes_substitution)) like '%tabindex%'
                or lower(trim(attribute_14)) like '%tabindex%'
                or lower(trim(attribute_17)) like '%tabindex%'
                or lower(trim(attribute_08)) like '%tabindex%'
                or lower(trim(attribute_10)) like '%tabindex%'
                or lower(trim(attribute_02)) like '%tabindex%'
                or lower(trim(attribute_15)) like '%tabindex%'
                or lower(trim(attribute_04)) like '%tabindex%'
                or lower(trim(attribute_23)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       region_attributes_substitution,
       attribute_25,
       attribute_24,
       ascending_image_attributes,
       descending_image_attributes,
       html_table_cell_attributes,
       attribute_01,
       attribute_02,
       attribute_03,
       attribute_04,
       attribute_05,
       attribute_06,
       attribute_07,
       attribute_08,
       attribute_09,
       attribute_10,
       attribute_11,
       attribute_12,
       attribute_13,
       attribute_14,
       attribute_15,
       attribute_16,
       attribute_17,
       attribute_18,
       attribute_19,
       attribute_20,
       attribute_21,
       attribute_22,
       attribute_23,
       grid_column_attributes
  from apex_application_page_regions;

-- PG_RGN_COL_TABINDX
select case
         when (    lower(trim(attribute_17)) like '%tabindex%'
                or lower(trim(attribute_24)) like '%tabindex%'
                or lower(trim(attribute_11)) like '%tabindex%'
                or lower(trim(attribute_02)) like '%tabindex%'
                or lower(trim(attribute_05)) like '%tabindex%'
                or lower(trim(attribute_10)) like '%tabindex%'
                or lower(trim(attribute_14)) like '%tabindex%'
                or lower(trim(attribute_22)) like '%tabindex%'
                or lower(trim(attribute_06)) like '%tabindex%'
                or lower(trim(attribute_21)) like '%tabindex%'
                or lower(trim(attribute_25)) like '%tabindex%'
                or lower(trim(attribute_16)) like '%tabindex%'
                or lower(trim(attribute_01)) like '%tabindex%'
                or lower(trim(attribute_19)) like '%tabindex%'
                or lower(trim(attribute_09)) like '%tabindex%'
                or lower(trim(attribute_08)) like '%tabindex%'
                or lower(trim(attribute_04)) like '%tabindex%'
                or lower(trim(attribute_20)) like '%tabindex%'
                or lower(trim(attribute_18)) like '%tabindex%'
                or lower(trim(attribute_12)) like '%tabindex%'
                or lower(trim(attribute_03)) like '%tabindex%'
                or lower(trim(attribute_07)) like '%tabindex%'
                or lower(trim(attribute_15)) like '%tabindex%'
                or lower(trim(value_attributes)) like '%tabindex%'
                or lower(trim(attribute_23)) like '%tabindex%'
                or lower(trim(attribute_13)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       value_attributes,
       attribute_01,
       attribute_02,
       attribute_03,
       attribute_04,
       attribute_05,
       attribute_06,
       attribute_07,
       attribute_08,
       attribute_09,
       attribute_10,
       attribute_11,
       attribute_12,
       attribute_13,
       attribute_14,
       attribute_15,
       attribute_16,
       attribute_17,
       attribute_18,
       attribute_19,
       attribute_20,
       attribute_21,
       attribute_22,
       attribute_23,
       attribute_24,
       attribute_25
 from apex_application_page_reg_cols;

-- PG_RPT_COL_INDX
select case
         when (lower(trim(ATTRIBUTE_09)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_06)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_12)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_15)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_02)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_11)) like '%tabindex%'
                or lower(trim(FORM_ELEMENT_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(COLUMN_LINK_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_01)) like '%tabindex%'
                or lower(trim(FORM_ELEMENT_OPTION_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_13)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_07)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_10)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_14)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_08)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_03)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_04)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_05)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       column_link_attributes,
       form_element_attributes,
       form_element_option_attributes,
       attribute_01,
       attribute_02,
       attribute_03,
       attribute_04,
       attribute_05,
       attribute_06,
       attribute_07,
       attribute_08,
       attribute_09,
       attribute_10,
       attribute_11,
       attribute_12,
       attribute_13,
       attribute_14,
       attribute_15
 from apex_application_page_rpt_cols;

/*
WCAG 2.0/2.1 - 2.4.3 Focus Order
Checking application where tabindex has been added to an attribute that
  have negative impact on tab/focus order
  */
  -- PRNT_TAB_INDX
select case
         when (lower(trim(image_attributes)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       application_id,
       image_attributes
 from apex_application_parent_tabs;

/*
WCAG 2.0/2.1 - 2.4.3 Focus Order
Checking application where tabindex has been added to an attribute that
  have negative impact on tab/focus order
  ACC_TAB_TABINDEX
  */
select case
         when (lower(trim(tab_image_attributes)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       application_id,
       tab_image_attributes
 from apex_application_tabs ;

/*
WCAG 2.0/2.1 - 2.4.3 Focus Order
Checking application where tabindex has been added to an attribute that
  have negative impact on tab/focus order
  */
-- CRD_ACTNS_TAB_INDX
select case
         when (lower(trim(link_attributes)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       link_attributes
 from apex_appl_page_card_actions ;

/*
WCAG 2.0/2.1 - 2.4.3 Focus Order
Checking application where tabindex has been added to an attribute that
  have negative impact on tab/focus order
  */
-- IG_TABINDX
select case
         when (lower(trim(icon_view_icon_attributes)) like '%tabindex%'
                or lower(trim(icon_view_link_attributes)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       icon_view_link_attributes,
       icon_view_icon_attributes
 from apex_appl_page_igs ;

/*
WCAG 2.0/2.1 - 2.4.3 Focus Order
Checking application where tabindex has been added to an attribute that
  have negative impact on tab/focus order
  */
-- IG_COL_TABINDX
select case
         when (    lower(trim(attribute_02)) like '%tabindex%'
                or lower(trim(link_attributes)) like '%tabindex%'
                or lower(trim(value_attributes)) like '%tabindex%'
                or lower(trim(attribute_12)) like '%tabindex%'
                or lower(trim(attribute_21)) like '%tabindex%'
                or lower(trim(attribute_11)) like '%tabindex%'
                or lower(trim(attribute_08)) like '%tabindex%'
                or lower(trim(attribute_03)) like '%tabindex%'
                or lower(trim(attribute_17)) like '%tabindex%'
                or lower(trim(attribute_06)) like '%tabindex%'
                or lower(trim(attribute_22)) like '%tabindex%'
                or lower(trim(attribute_04)) like '%tabindex%'
                or lower(trim(attribute_23)) like '%tabindex%'
                or lower(trim(attribute_14)) like '%tabindex%'
                or lower(trim(attribute_16)) like '%tabindex%'
                or lower(trim(attribute_18)) like '%tabindex%'
                or lower(trim(attribute_10)) like '%tabindex%'
                or lower(trim(item_attributes)) like '%tabindex%'
                or lower(trim(attribute_09)) like '%tabindex%'
                or lower(trim(attribute_01)) like '%tabindex%'
                or lower(trim(attribute_05)) like '%tabindex%'
                or lower(trim(attribute_13)) like '%tabindex%'
                or lower(trim(attribute_07)) like '%tabindex%'
                or lower(trim(attribute_25)) like '%tabindex%'
                or lower(trim(attribute_15)) like '%tabindex%'
                or lower(trim(attribute_19)) like '%tabindex%'
                or lower(trim(attribute_20)) like '%tabindex%'
                or lower(trim(attribute_24)) like '%tabindex%' ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       attribute_12,
       attribute_13,
       attribute_14,
       attribute_15,
       attribute_16,
       attribute_17,
       attribute_18,
       attribute_19,
       attribute_20,
       attribute_21,
       attribute_22,
       attribute_23,
       attribute_24,
       attribute_25,
       item_attributes,
       link_attributes,
       value_attributes,
       attribute_01,
       attribute_02,
       attribute_03,
       attribute_04,
       attribute_05,
       attribute_06,
       attribute_07,
       attribute_08,
       attribute_09,
       attribute_10,
       attribute_11
 from apex_appl_page_ig_columns;
 


---*************************************************************************
/*
WCAG 2.0/2.1 - 2.4.4 Link Purpose (In Context)
Checking link text is meaning as well as have alt setting.
*/
---*************************************************************************

--- look into region source for href and column html expression areas

--- checking IR default links
-- IR_DETL_LINK
select case
         when ((lower(trim(detail_link_attributes)) not like '%aria-%'
                and lower(trim(detail_link_attributes)) not like '%title%')
                or trim(detail_link_attributes) is null ) then 'N' 
         else 'Y'
       end pass_yn,
       --* alt tag could be in link icon
      page_id,application_id,application_name,region_name,detail_link_attributes
 from apex_application_page_ir
 where detail_link_target is not null;

--- checking IR column links 
-- IR_COL_LINK
select case
         when column_link is not null and ((lower(trim(column_link_attr)) not like '%aria-%'
                and lower(trim(column_link_attr)) not like '%title%')
                or trim(column_link_attr) is null) then 'N' 
         when html_expression is not null and lower(trim(html_expression)) like '%<a%' then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       column_link_attr,
       html_expression
 from apex_application_page_ir_col
 where  (column_link is not null
     or html_expression is not null);

--- checking quick pick links 
-- ACC_PG_ITM_LINK
select case when ((lower(trim(quick_pick_link_attr)) not like '%aria-%'
                  and lower(trim(quick_pick_link_attr)) not like '%title%')
                  or trim(quick_pick_link_attr) is null ) 
            then 'N' 
            else 'Y'
            end pass_yn,
       page_id,
       application_id,
       item_name,
       item_id,
       quick_pick_link_attr
 from apex_application_page_items
 where show_quick_picks = 'Y';

--- checking Classic report column links 
-- C_COL_LINK
select case
         when ((lower(trim(column_link_attributes)) not like '%aria-%'
                and lower(trim(column_link_attributes)) not like '%title%')
                or trim(column_link_attributes) is null ) then 'N' 
         else 'Y'
       end pass_yn,
      page_id,
      application_id,
      region_name,
      column_alias, 
      column_link_attributes
 from apex_application_page_rpt_cols a
 where column_link_url is not null;

---- checking Card Region links
-- ACC_CARD_LINK
select case
         when ((lower(trim(link_attributes)) not like '%aria-%'
                and lower(trim(link_attributes)) not like '%title%')
                or trim(link_attributes) is null ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       region_id,
       region_name,
       application_id,
       link_attributes
 from apex_appl_page_card_actions;

-- ACC_IG_IV_LINK
select case when (lower(trim(icon_view_link_attributes)) not like '%aria-%'
                and lower(trim(icon_view_link_attributes)) not like '%title%') 
            then 'N' 
            else 'Y'
            end pass_yn,
       page_id,
       application_id,
       icon_view_link_attributes
 from apex_appl_page_igs
 where icon_view_icon_attributes is not null;

-- ACC_IG_COL_LINK
select case
         when ((item_type = 'NATIVE_LINK' 
                and ((lower(trim(link_attributes)) not like '%aria-%' or lower(trim(link_attributes)) not like '%title%')
                     or trim(link_attributes) is null))
                or (lower(trim(attribute_01)) like '%<a%' and 
                     (lower(trim(attribute_01)) not like '%aria-%' and lower(trim(attribute_01)) not like '%title%') ) ) then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       application_id,
       link_attributes,
       attribute_01
 from apex_appl_page_ig_columns;
    
    

---*************************************************************************
/*
WCAG 2.0/2.1 - 2.5.2 Pointer Cancellation
Checking DA and JS for on down clicks events
*/
---*************************************************************************
--- Checking page DAs for mouse down or up triggering events
-- ACC_DA_MOUSE_EVNT
select case
         when when_event_name in ('Mouse Button Release','Mouse Button Press') then 'N' 
         else 'Y'
       end pass_yn,
       application_id,
       page_id,
       dynamic_action_name,
       dynamic_action_id
from apex_application_page_da a;
  
--- Check page JS for mouse down/up events
-- ACC_PAGE_MOUSE_EVNT
select case
         when (lower(trim(javascript_code)) like '%mousedown%'
           or  lower(trim(javascript_code)) like '%mouseup%'
           or  lower(trim(javascript_code_onload)) like '%mousedown%'
           or  lower(trim(javascript_code_onload)) like '%mouseup%') then 'N' 
         else 'Y'
       end pass_yn,
     application_id,
     page_id
from apex_application_pages;


---- *************************************************************************
/*
WCAG 2.0/2.1 - 3.2.1 On Focus. Check for onfocus events in javascript and dynamic actions
*/
---- *************************************************************************
--- Checking page DAs for On Focus triggering events
--  ACC_DA_FOCUS
select case
         when when_event_name in ('Get Focus') then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       dynamic_action_name
 from apex_application_page_da a;
  
--- Check page JS for onfocus events
-- ACC_PG_JS_FOCUS
select case
         when (lower(trim(javascript_code)) like '%focus%'
                or lower(trim(javascript_code_onload)) like '%focus%') then 'N' 
         else 'Y'
       end pass_yn,
       page_id,
       javascript_code,
       javascript_code_onload
  from apex_application_pages
;



---- *************************************************************************
---- WCAG 2.0/2.1 - 3.2.3 Consistent Navigation
---- Check for onfocus events in javascript and dynamic actions
---- *************************************************************************

---  Checking if lists tagged as navigation menu and bar are dynamic.  
---   if so they need to be checked
-- NOTIMPLEMENTED ALWAYSFAIL
/*
menu should be consistent,
*/
select 1 pass_yn, --always fail developer needs to run code and evaluate results
       list_name,
       list_type,
       list_id
from apex_application_lists a
where a.LIST_TYPE_CODE != 'STATIC';

-- NOTIMPLEMENTED ALWAYSFAIL
-- make sure a given page is always refered to as the same thing
select 1 pass_yn, --- always fail as each entry needs to be reviewed
       list_name,
       entry_text,
       list_id,
       list_entry_id
from apex_application_list_entries b;

---- *************************************************************************
---- WCAG 2.0/2.1 - 3.2.4 Consistent Identification
---- Provide list of components by type and name (strip off PXX_)
---- *************************************************************************
--   Get list of page items (non-buttons)
-- NOTIMPLEMENTED ALWAYSFAIL
/*
eg consistent 'save' buttons 
*/
select 1 pass_yn,
       'Page Items' type,
       substr(item_name,instr(item_name,'_')+1) adj_name, 
       item_name,label,item_label_template template, 
       item_icon_css_classes css_classes,
       application_id,application_name,page_id,page_name,region 
from apex_application_page_items a
;

-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'Buttons',button_name, 
       label,button_template,icon_css_classes,
       page_id,page_name,region
 from APEX_APPLICATION_PAGE_BUTTONS
;

-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'IR Region Links' type, DETAIL_LINK_TEXT, 
       DETAIL_LINK_ATTRIBUTES,
       page_id,
       region_name
 from APEX_APPLICATION_PAGE_IR a
 where DETAIL_LINK_TARGET is not null
 ;


-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'IR Column Links' type, COLUMN_LINKTEXT, COLUMN_LINK_ATTR,
       page_id,application_id,application_name,page_id,region_name 
  from APEX_APPLICATION_PAGE_IR_COL
 where column_link is not null;

-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'Page Items Quick Links' type,
       substr(item_name,instr(item_name,'_')+1) adj_name, 
       item_name,label,item_label_template template, 
       item_icon_css_classes css_classes,
        QUICK_PICK_LINK_ATTR, QUICK_PICK_LABEL_01, 
        QUICK_PICK_VALUE_01, QUICK_PICK_LABEL_02, 
        QUICK_PICK_VALUE_02, QUICK_PICK_LABEL_03, 
        QUICK_PICK_VALUE_03, QUICK_PICK_LABEL_04, 
        QUICK_PICK_VALUE_04, QUICK_PICK_LABEL_05, 
        QUICK_PICK_VALUE_05, QUICK_PICK_LABEL_06, 
        QUICK_PICK_VALUE_06, QUICK_PICK_LABEL_07, 
        QUICK_PICK_VALUE_07, QUICK_PICK_LABEL_08, 
        QUICK_PICK_VALUE_08, QUICK_PICK_LABEL_09, 
        QUICK_PICK_VALUE_09, QUICK_PICK_LABEL_10,
        page_id, page_name,region 
   from APEX_APPLICATION_PAGE_ITEMS
  where show_quick_picks = 'Y';

-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'Classic Report Column Links' type, 
       column_alias, COLUMN_LINK_URL,COLUMN_LINK_ATTRIBUTES
       page_id,page_name
  from APEX_APPLICATION_PAGE_RPT_COLS
 where COLUMN_LINK_URL is not null;

-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'Breadcrumbs' type,theme_class,
       template_name,BREADCRUMB_LINK_ATTRIBUTES
  from APEX_APPLICATION_TEMP_BC;

-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'Cards Actions' type,action_type,
       label,LINK_ATTRIBUTES,link_target, 
       page_id,page_name,region_name
  from APEX_APPL_PAGE_CARD_ACTIONS
 ;

-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'IG Region Links' type, ICON_VIEW_LINK_ATTRIBUTES,
       page_id,page_name,application_id,application_name,region_name
  from APEX_APPL_PAGE_IGS
 where ICON_VIEW_ICON_ATTRIBUTES is not null;

-- NOTIMPLEMENTED ALWAYSFAIL
select 1 pass_yn,
       'IG Column Links' type,name column_name,heading,label, item_type,LINK_ATTRIBUTES,attribute_01,
       page_id,page_name,application_id,application_name,region_name
  from APEX_APPL_PAGE_IG_COLUMNS
 where ((item_type = 'NATIVE_LINK' and trim(LINK_ATTRIBUTES) is null)
    or (lower(trim(attribute_01)) like '%<a%' and lower(trim(attribute_01)) not like '%alt%') )
 ;



---- *************************************************************************
/*
WCAG 2.0/2.1 - 3.3.1 Error Identification
Look for validations where Display Location is set to Inline with Field
*/
---- *************************************************************************
/*
bug in apex? inline with field is insufficient (lacks proper aria tags)
hhh : this is where we left off 2023-Jul-26 (pause / stop)
ACC_VAL_DSPLY_LOCN
*/
 select case when error_display_location = 'INLINE_WITH_FIELD' 
             then 'N' 
             else 'Y'
             end pass_yn,
        application_id,
        page_id, 
        validation_name
   from apex_application_page_val;



---- *************************************************************************
---- WCAG 2.0/2.1 - 3.3.3 Error Suggestion
---- Look at validations and provide list of error messages
---- *************************************************************************
-- NOTIMPLEMENTED ALWAYSFAIL
/*
make sure error text is actionable
*/
 select 1 pass_yn,
        page_id,page_name, 
        validation_name,VALIDATION_FAILURE_TEXT
   from apex_application_page_val;



---- *************************************************************************
---- WCAG 2.0/2.1 - 4.1.1 Parsing
---- Look for custom html in html expression, source code fields and provide
----   list to be checked for open/close tags,brackets or quotes.
---- *************************************************************************
--- check region sources for html references
-- STTC_CNTNT_BAD_HTML
 select case
          when (REGION_SOURCE like '%<%') then 'N' 
          else 'Y'
        end pass_yn,
        page_id,page_name,REGION_SOURCE,QUERY_TYPE_CODE
   from apex_application_page_regions;

--- Check IR Columns in html_expression
-- IR_COL_BAD_HTML
select case
          when ((column_link is not null and lower(trim(COLUMN_LINK_ATTR)) is not null)
                 or lower(trim(html_expression)) is not null
                 or lower(trim(report_label)) like '%<%'
                 or lower(trim(report_label)) like '%"%'
                 or lower(trim(report_label)) like '%''%') then 'N' 
          else 'Y'
        end pass_yn,
        page_id,
        html_expression,
        column_link,
        COLUMN_LINK_ATTR,
        report_label
 from APEX_APPLICATION_PAGE_IR_COL;
      
--- Check classic Columns in html_expression
-- C_COL_BAD_HTML
select case
          when (lower(trim(html_expression)) is not null
                 or lower(trim(css_style)) is not null
                      or lower(trim(column_link_attributes)) is not null
                      or lower(trim(column_link_text)) is not null
                      or lower(trim(heading)) like '%<%'
                      or lower(trim(heading)) like '%"%'
                      or lower(trim(heading)) like '%''%') then 'N' 
          else 'Y'
        end pass_yn,
        page_id,
        html_expression,
        css_style,
        column_link_attributes,
        column_link_text,
        heading
 from APEX_APPLICATION_PAGE_rpt_cols;

--- Check IG Columns in html_expression
-- IG_COL_BAD_HTML
select case
          when (item_type = 'NATIVE_HTML_EXPRESSION' 
                 or trim(link_text) is not null
                 or lower(trim(attribute_01)) like '%<%'
                 or lower(trim(attribute_01)) like '%"%'
                 or lower(trim(attribute_01)) like '%''%'
                 or lower(trim(heading)) like '%<%'
                 or lower(trim(heading)) like '%"%'
                 or lower(trim(heading)) like '%''%') then 'N' 
          else 'Y'
        end pass_yn,
        page_id,
        item_type,
        link_text,
        attribute_01,
        heading
 from APEX_APPL_page_ig_columns;