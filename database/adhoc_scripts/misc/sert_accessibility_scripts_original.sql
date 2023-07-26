---*************************************************************************
---- WCAG 2.0/2.1 - 1.1.1
---- searching images and if they have alt text set in html
---*************************************************************************
--- page region level

select case
         when (coalesce((length(lower(region_source)) - length(replace(lower(region_source),'<img',null)))/4, length(lower(region_source)), 0) > 
              coalesce((length(lower(region_source)) - length(replace(lower(region_source),'alt="',null)))/5, length(lower(region_source)), 0)) or
              lower(replace(region_source,' ','')) like '%alt=""%' or
              lower(region_source) like '% alt %'
           then 1  ---fail
         else 0  --- pass
       end pf_result,
       substr(region_source,1,32737) src,
       application_id,application_name,page_id,page_name,region_name
from apex_application_page_regions
where application_id = :app_id
  and lower(region_source) like '%<img%'
union
select case
         when (coalesce((length(lower(region_header_text)) - length(replace(lower(region_header_text),'<img',null)))/4, length(lower(region_header_text)), 0) > 
              coalesce((length(lower(region_header_text)) - length(replace(lower(region_header_text),'alt="',null)))/5, length(lower(region_header_text)), 0)) or
              lower(replace(region_header_text,' ','')) like '%alt=""%' or
              lower(region_header_text) like '% alt %'
           then 1  ---fail
         else 0  --- pass
       end pf_result,
       region_header_text,
       application_id,application_name,page_id,page_name,region_name
from apex_application_page_regions
where application_id = :app_id
  and lower(REGION_HEADER_TEXT) like '%<img%'
union
select case
         when (coalesce((length(lower(region_footer_text)) - length(replace(lower(region_footer_text),'<img',null)))/4, length(lower(region_footer_text)), 0) > 
              coalesce((length(lower(region_footer_text)) - length(replace(lower(region_footer_text),'alt="',null)))/5, length(lower(region_footer_text)), 0)) or
              lower(replace(region_footer_text,' ','')) like '%alt=""%' or
              lower(region_footer_text) like '% alt %'
           then 1  ---fail
         else 0  --- pass
       end pf_result,
       region_footer_text,application_id,application_name,page_id,page_name,region_name
from apex_application_page_regions
where application_id = :app_id
  and lower(REGION_FOOTER_TEXT) like '%<img%'
;

--- page item level
select case
         when attribute_01 = 'DB_COLUMN' and 
              trim(attribute_03) is null
           then 1  ---fail
         when attribute_01 = 'SQL' and 
              (coalesce((length(lower(HTML_FORM_ELEMENT_ATTRIBUTES)) - length(replace(lower(HTML_FORM_ELEMENT_ATTRIBUTES),'<img',null)))/4, length(lower(HTML_FORM_ELEMENT_ATTRIBUTES)), 0) > 
              coalesce((length(lower(HTML_FORM_ELEMENT_ATTRIBUTES)) - length(replace(lower(HTML_FORM_ELEMENT_ATTRIBUTES),'alt="',null)))/5, length(lower(HTML_FORM_ELEMENT_ATTRIBUTES)), 0)) or
              lower(replace(HTML_FORM_ELEMENT_ATTRIBUTES,' ','')) like '%alt=""%' or
              lower(HTML_FORM_ELEMENT_ATTRIBUTES) like '% alt %' or
              trim(HTML_FORM_ELEMENT_ATTRIBUTES) is null
           then 1
         when attribute_01 = 'URL' and
              trim(attribute_02) is null
         then 1
        else 0
       end pf_result, 
       application_id,application_name,page_id,page_name,region,item_name
       --application_id,application_name, page_id, page_name, item_name 
  from apex_application_page_items a
 where application_id = :app_id
  and display_as = 'Display Image'
union
select case
         when (coalesce((length(lower(item_source)) - length(replace(lower(item_source),'<img',null)))/4, length(lower(item_source)), 0) > 
              coalesce((length(lower(item_source)) - length(replace(lower(item_source),'alt="',null)))/5, length(lower(item_source)), 0)) or
              lower(replace(item_source,' ','')) like '%alt=""%' or
              lower(item_source) like '% alt %'
           then 1  ---fail
         else 0  --- pass
       end pf_result,
       application_id,application_name,page_id,page_name,region,item_name
       --application_id,application_name, page_id, page_name, item_name 
  from apex_application_page_items a
 where application_id = :app_id
   and lower(item_source) like '%<img%'
union
select case
         when (coalesce((length(lower(pre_element_text)) - length(replace(lower(pre_element_text),'<img',null)))/4, length(lower(pre_element_text)), 0) > 
              coalesce((length(lower(pre_element_text)) - length(replace(lower(pre_element_text),'alt="',null)))/5, length(lower(pre_element_text)), 0)) or
              lower(replace(pre_element_text,' ','')) like '%alt=""%' or
              lower(pre_element_text) like '% alt %'
           then 1  ---fail
         else 0  --- pass
       end pf_result,
       application_id,application_name,page_id,page_name,region,item_name
       --application_id,application_name, page_id, page_name, item_name 
  from apex_application_page_items a
 where application_id = :app_id
   and lower(pre_element_text) like '%<img%'
union
select case
         when (coalesce((length(lower(post_element_text)) - length(replace(lower(post_element_text),'<img',null)))/4, length(lower(post_element_text)), 0) > 
              coalesce((length(lower(post_element_text)) - length(replace(lower(post_element_text),'alt="',null)))/5, length(lower(post_element_text)), 0)) or
              lower(replace(post_element_text,' ','')) like '%alt=""%' or
              lower(post_element_text) like '% alt %'
           then 1  ---fail
         else 0  --- pass
       end pf_result,
       application_id,application_name,page_id,page_name,region,item_name
       --application_id,application_name, page_id, page_name, item_name 
  from apex_application_page_items a
 where application_id = :app_id
   and lower(post_element_text) like '%<img%';
   
--- Classic Report col check
--- this option has no way of including alt text for the image
select case
         when format_mask like 'IMAGE%' then 1
         when (coalesce((length(trim(lower(HTML_EXPRESSION))) - length(replace(trim(lower(HTML_EXPRESSION)),'<img',null)))/4, length(trim(lower(HTML_EXPRESSION))), 0) > 
              coalesce((length(trim(lower(HTML_EXPRESSION))) - length(replace(trim(lower(HTML_EXPRESSION)),'alt="',null)))/5, length(trim(lower(HTML_EXPRESSION))), 0)) or
              replace(trim(lower(HTML_EXPRESSION)),' ','') like '%alt=""%' or
              trim(lower(HTML_EXPRESSION)) like '% alt %' then 1
         else 0
       end pf_result,
       application_id,application_name,page_id,page_name,region_id,region_name, column_alias
from apex_application_page_rpt_cols a
where application_id = :app_id
  and (format_mask like 'IMAGE%' or
       trim(lower(HTML_EXPRESSION)) like '%<img%')
  ;
  
--- Interactive Report col check
--- this option has no way of including alt text for the image
select case
         when format_mask like 'IMAGE%' then 1
         when (coalesce((length(trim(lower(HTML_EXPRESSION))) - length(replace(trim(lower(HTML_EXPRESSION)),'<img',null)))/4, length(trim(lower(HTML_EXPRESSION))), 0) > 
              coalesce((length(trim(lower(HTML_EXPRESSION))) - length(replace(trim(lower(HTML_EXPRESSION)),'alt="',null)))/5, length(trim(lower(HTML_EXPRESSION))), 0)) or
              replace(trim(lower(HTML_EXPRESSION)),' ','') like '%alt=""%' or
              trim(lower(HTML_EXPRESSION)) like '% alt %' then 1
         else 0
       end pf_result,
       application_id,application_name,page_id,region_id,region_name,a.column_alias,a.*
from apex_application_page_ir_col a
where application_id = :app_id
  and (format_mask like 'IMAGE%' or
       trim(lower(HTML_EXPRESSION)) like '%<img%');
  
--- Interactive Grid col check
select case
         when (coalesce((length(lower(attribute_01)) - length(replace(lower(attribute_01),'<img',null)))/4, length(lower(attribute_01)), 0) > 
              coalesce((length(lower(attribute_01)) - length(replace(lower(attribute_01),'alt="',null)))/5, length(lower(attribute_01)), 0)) or
              lower(replace(attribute_01,' ','')) like '%alt=""%' or
              lower(attribute_01) like '% alt %'
           then 1  ---fail
         else 0  --- pass
       end pf_result,
       application_id,application_name,page_id,region_id,region_name
from apex_appl_page_ig_columns a
where application_id = :app_id
  and attribute_01 like '%<img%';
  
  
---*************************************************************************
---- WCAG 2.0/2.1 - 1.3.1 Info and Relationships, 
----                2.4.6 Headings and Labels,
----                2.5.3 Label in Name,
----                3.3.2 Labels or Instructions,
----                4.1.2 Name, Role, Value
---- Checking that all apex object (regions, items, report column headings) 
----  are labeled appropriately
---*************************************************************************
---- confirm all pages have name, title and not a blank space
set define off;
select case
         when (trim(page_name) is null or lower(trim(page_name)) = '&nbsp;'
               or trim(page_title) is null or lower(trim(page_title)) = '&nbsp;') then 1
         else 0
       end pf_result,
       a.application_id, page_id,page_name,page_title
  from apex_application_pages a
 where application_id = :app_id
   and page_function != 'Global Page';
            
--- confirm all Regions have and not a blank space
select case
         when (trim(region_name) is null or
               lower(trim(region_name)) = '&nbsp;' or
               lower(trim(region_name)) = 'new') then 1
         else 0
       end pf_result,
       application_id,application_name,page_id,page_name,region_name
  from apex_application_page_regions
 where application_id = :app_id
 order by pf_result desc, page_id asc;
    
--- confirm all Regions on a page are unique
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,application_name,page_id,page_name,region_name,DISPLAY_SEQUENCE
 from (select application_id,application_name,page_id,page_name,region_name,DISPLAY_SEQUENCE,--a.*--count(*) cnt
       ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(region_name)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt
  from apex_application_page_regions a
 where application_id = :app_id)
 --group by application_id,application_name,page_id,page_name,region_name
 order by application_id,page_id,DISPLAY_SEQUENCE
 ;

-- Confirm all page items have unique labels by default apex force unique item names
select case
         when (trim(label) is null
           or lower(trim(label)) = '&nbsp;') then 1
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,application_name, page_id, page_name, item_name,label
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(label)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt,
       application_id,application_name, page_id, page_name, item_name,label,DISPLAY_SEQUENCE
  from apex_application_page_items a
 where application_id = :app_id
   and DISPLAY_AS_CODE not in ('NATIVE_HIDDEN') )
 order by application_id, page_id, display_sequence
;

--- Confirm all page items have valid label and no blank spaces;
select case
         when (trim(label) is null
           or lower(trim(label)) = '&nbsp;') then 1
         else 0
       end pf_result,
       application_id,application_name, page_id, page_name, item_name,label,display_sequence
  from apex_application_page_items a
 where application_id = :app_id
   and DISPLAY_AS_CODE not in ('NATIVE_HIDDEN') 
 order by application_id, page_id, display_sequence
;
set define off;
--- Classic Report col header check - all columns have a header defined
select case
         when (trim(heading) is null or
               lower(trim(heading)) = '&nbsp;') then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,heading,display_sequence
from apex_application_page_rpt_cols
where application_id = :app_id
order by application_id,page_id,region_id,display_sequence
;


--- Classic Report col header check - column headings are unqiue per region
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,heading,DISPLAY_SEQUENCE
   from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(heading)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt,
       application_id,page_id,region_id,region_name,heading,DISPLAY_SEQUENCE
from apex_application_page_rpt_cols
where application_id = :app_id
and COLUMN_IS_HIDDEN = 'No')
order by application_id, page_id, region_id,heading,display_sequence
;

--- Classic Report col header check - column alias are unqiue per region
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,column_alias,heading,DISPLAY_SEQUENCE
   from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(column_alias)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt,
       application_id,page_id,region_id,region_name,column_alias,heading,DISPLAY_SEQUENCE
from apex_application_page_rpt_cols
where application_id = :app_id
and COLUMN_IS_HIDDEN = 'No')
order by application_id, page_id, region_id,column_alias,display_sequence
;

--- Classic Report col header check - column alias are unqiue per page
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,column_alias,heading,DISPLAY_SEQUENCE
   from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(column_alias)) ORDER BY DISPLAY_SEQUENCE NULLS LAST) value_dup_cnt,
       application_id,page_id,region_id,region_name,column_alias,heading,DISPLAY_SEQUENCE
from apex_application_page_rpt_cols
where application_id = :app_id
and COLUMN_IS_HIDDEN = 'No')
order by application_id, page_id, region_id,heading,display_sequence
;

  
--- Interactive Report all columns have a header defined
select case
         when (trim(report_label) is null
        or lower(trim(report_label)) = '&nbsp;'
        or trim(form_label) is null
        or lower(trim(form_label)) = '&nbsp;') then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,report_label,form_label,display_order
from apex_application_page_ir_col a
where application_id = :app_id
order by application_id,page_id,region_id,display_order
;

--- Interactive Report all column_alias per page are unique (this determines html id value)
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,column_alias,report_label,display_order
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(column_alias)) ORDER BY display_order NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,report_label,column_alias,display_order
          from apex_application_page_ir_col a
         where application_id = :app_id)
order by application_id,page_id,column_alias,region_id,display_order;

--- Interactive Report all report labels(column headers) per region are unique
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,report_label,display_order
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(report_label)) ORDER BY display_order NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,report_label,display_order
          from apex_application_page_ir_col a
         where application_id = :app_id)
order by application_id,page_id,region_id,display_order
;

--- Interactive Report all form labels(column headers) per region are unique
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,form_label,COLUMN_ALIAS,display_order
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(form_label)) ORDER BY display_order NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,form_label,COLUMN_ALIAS,display_order
          from apex_application_page_ir_col a
         where application_id = :app_id)
order by application_id,page_id,region_id,display_order
;
  
--- Interactive Grid column headers all have a value defined
select case
         when (trim(heading) is null
        or lower(trim(heading)) = '&nbsp;') then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,heading,display_sequence
  from apex_appl_page_ig_columns a
 where application_id = :app_id
order by application_id,page_id,region_id,heading,display_sequence
;

--- Interactive Grid column headers for a region are unique
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,heading,SOURCE_EXPRESSION,display_sequence
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(heading)) ORDER BY display_sequence NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,heading,SOURCE_EXPRESSION,display_sequence
          from apex_appl_page_ig_columns
         where application_id = :app_id)
order by application_id,page_id,region_id,heading,display_sequence
;

--- Interactive Grid column alias for the page (across all IGs) are unique
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,heading,SOURCE_EXPRESSION,display_sequence
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,trim(lower(SOURCE_EXPRESSION)) ORDER BY display_sequence NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,heading,SOURCE_EXPRESSION,display_sequence
          from apex_appl_page_ig_columns
         where application_id = :app_id)
order by application_id,page_id,SOURCE_EXPRESSION,display_sequence
;
--- Interactive Grid form labels for a region are unique
select case
         when value_dup_cnt > 1 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name,label,SOURCE_EXPRESSION,display_sequence
  from (select ROW_NUMBER( ) OVER (PARTITION BY application_id,page_id,region_id,trim(lower(nvl(label,heading))) ORDER BY display_sequence NULLS LAST) value_dup_cnt,
               application_id,page_id,region_id,region_name,nvl(label,heading) label,SOURCE_EXPRESSION,display_sequence
          from apex_appl_page_ig_columns
         where application_id = :app_id)
order by application_id,page_id,region_id,label,display_sequence
;

--- Check that IG has at least one column set as a row header per region ; 
--- ***( Will be available in 22.1 for IR and classic report
select case
         when USE_AS_ROW_HEADER_cnt = 0 then 1
         else 0
       end pf_result,
       application_id,page_id,page_name,region_id,region_name
  from (select sum(case
               when USE_AS_ROW_HEADER = 'Yes' then 1
               else 0
             end) USE_AS_ROW_HEADER_cnt, 
       application_id,page_id,page_name,region_id,region_name
  from apex_appl_page_ig_columns
 where application_id = :app_id
 group by application_id,page_id,page_name,region_id,region_name)
order by pf_result desc, page_id,region_id
;


--- check that IR report has at least one column flag as row header
select case
         when USE_AS_ROW_HEADER_cnt = 0 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name
  from (select sum(case
               when upper(USE_AS_ROW_HEADER) = 'YES' then 1
               else 0
             end) USE_AS_ROW_HEADER_cnt, 
       application_id,page_id,region_id,region_name
  from apex_application_page_ir_col
 where application_id = :app_id
 group by application_id,page_id,region_id,region_name)
order by pf_result desc, page_id,region_id
;

--- check classic report has at least one column flaged as row header
select case
         when USE_AS_ROW_HEADER_cnt = 0 then 1
         else 0
       end pf_result,
       application_id,page_id,region_id,region_name
  from (select sum(case
               when upper(USE_AS_ROW_HEADER) = 'Y' then 1
               else 0
             end) USE_AS_ROW_HEADER_cnt, 
       application_id,page_id,region_id,region_name
  from APEX_APPLICATION_PAGE_RPT_COLS
 where application_id = :app_id
 group by application_id,page_id,region_id,region_name)
order by pf_result desc, page_id,region_id
;


---*************************************************************************
---- WCAG 2.1 - 1.3.5 Identify Input Purpose
---- Checking that inputs fields have autocomplete where appropriate
---*************************************************************************
-- Not supported unless manual entered in Custom Attributes
-- Once autocomplete added as option will likely have to check that column directly
-- if autocomplete is not present then fail.  add exception to items that don't need it
--    this approach my have big impacts and require many overrides.  may have to change in future
select --* 
       case
         when (lower(trim(HTML_FORM_ELEMENT_ATTRIBUTES)) not like '%autocomplete%'
               or trim(HTML_FORM_ELEMENT_ATTRIBUTES) is null) then 1
         else 0
       end pf_result,
       application_id,application_name, page_id, page_name,region, item_name,HTML_FORM_ELEMENT_ATTRIBUTES
  from apex_application_page_items a
 where application_id = :app_id
   and display_as_code not in ('NATIVE_HIDDEN','NATIVE_CHECKBOX')
  -- and (lower(trim(HTML_FORM_ELEMENT_ATTRIBUTES)) not like '%autocomplete%'
    --   or trim(HTML_FORM_ELEMENT_ATTRIBUTES) is null)
;


---- Checking editable IG regions and columns that are not set as Query Only
select --b.*
       case
         when (lower(trim(b.item_attributes)) not like '%autocomplete%'
               or trim(b.item_attributes) is null) then 1
         else 0
       end pf_result,
       b.application_id,b.application_name, b.page_id, b.page_name,b.region_id,b.region_name, b.source_expression,b.item_attributes
from apex_appl_page_igs a,
     apex_appl_page_ig_columns b
where a.application_id = :app_id
  and b.application_id = :app_id
  and b.region_id = a.region_id
  and a.is_editable = 'Yes'
  and b.is_query_only = 'No'
;


---*************************************************************************
---- WCAG 2.1 - 2.1.4 Character Key Shortcuts
---- Checking if shortcut keys have been created
----  
---*************************************************************************
-- check IG javascript initialization code for references to keyboard shortcuts.
select case
         when lower(trim(javascript_code)) like '%shortcut%' then 1
         else 0
       end pf_result,
       region_source,region_header_text,region_footer_text,application_id,application_name,page_id,page_name,region_name
from apex_appl_page_igs
where application_id = :app_id
;




---*************************************************************************
---- WCAG 2.0/2.1 - 2.1.2 No Keyboard Trap
---- Checking for js blur listening events or 
---*************************************************************************
--- Checking page DAs for Lose Focus or Get Focus triggering events
select case
         when WHEN_EVENT_NAME in ('Lose Focus','Get Focus') then 1
         else 0
       end pf_result,
       application_id,application_name,page_id,page_name,dynamic_action_id,dynamic_action_name
from apex_application_page_da
where application_id = :app_id
;
  
  
--- Check page JS for on blur events
select case
         when (lower(trim(JAVASCRIPT_CODE)) like '%blur%'
               or lower(trim(JAVASCRIPT_CODE)) like '%focusout%'
               or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%blur%'
               or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%focusout%') then 1
         else 0
       end pf_result,
       page_name,application_name,application_id,JAVASCRIPT_CODE,JAVASCRIPT_CODE_ONLOAD
from apex_application_pages
where application_id = :app_id
;

---*************************************************************************
---- WCAG 2.0/2.1 - 2.2.2 Pause, Stop, Hide
----              - 2.3.1 Three Flashes or Below Threshold
---- Checking pages for inline CSS for blinking or animation logic
---*************************************************************************

--- Check page level for inline CSS
select case
         when (lower(trim(inline_css)) like '%blink%'
               or lower(trim(inline_css)) like '%animation%') then 1
         else 0
       end pf_result,
       page_id,page_name,inline_css
        -- add in additional that sert needs
  from apex_application_pages a
 where application_id = :app_id
;

--- Check classic report columns for CSS
 select case
          when (lower(trim(CSS_STYLE)) like '%blink%'
                or lower(trim(CSS_STYLE)) like '%animation%') then 1
          else 0
        end pf_result,
        page_id,page_name,a.region_name,a.column_alias, a.css_style
   from APEX_APPLICATION_PAGE_RPT_COLS a
  where application_id = :app_id
;

--- Check application temp pages
 select case
          when (lower(trim(inline_css)) like '%blink%'
                or lower(trim(inline_css)) like '%animation%') then 1
          else 0
        end pf_result,
        inline_css, application_id,template_name
   from APEX_APPLICATION_TEMP_PAGE a
  where application_id = :app_id
;

--- Check application temp lists
 select case
          when (lower(trim(inline_css)) like '%blink%'
                or lower(trim(inline_css)) like '%animation%') then 1
          else 0
        end pf_result,
        template_name, inline_css
   from APEX_APPLICATION_TEMP_LIST a
  where application_id = :app_id
;

--- Check CSS in theme roller
 select case
          when (lower(trim(THEME_ROLLER_CONFIG)) like '%blink%'
                 or lower(trim(THEME_ROLLER_CONFIG)) like '%animation%') then 1
          else 0
        end pf_result,
        theme_number,name, THEME_ROLLER_CONFIG
   from apex_application_theme_styles a
  where application_id = :app_id
;


---- check page for js that is setting intervals or timeouts
select case
          when ((lower(trim(JAVASCRIPT_CODE)) like '%setinterval%'
                 or lower(trim(JAVASCRIPT_CODE)) like '%settimeout%'
                 or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%setinterval%'
                 or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%settimeout%')) then 1
          else 0
        end pf_result,
        a.application_id,application_name,a.page_id,a.page_name
from apex_application_pages a
where application_id = :app_id;

--- checking DA for js that is setting intervals or timeouts
select case
          when ((lower(trim(attribute_01)) like '%setinterval%'
                 or lower(trim(attribute_01)) like '%settimeout%'
                 or lower(trim(attribute_01)) like '%setinterval%'
                 or lower(trim(attribute_01)) like '%settimeout%')) then 1
          else 0
        end pf_result,
        a.application_id,application_name,a.page_id,a.page_name,
        a.dynamic_action_name,a.action_pd_name,dynamic_action_event_result
from apex_application_page_da_acts a
where application_id = :app_id
  and action_code = 'NATIVE_JAVASCRIPT_CODE';

---*************************************************************************
---- WCAG 2.0/2.1 - 2.4.2 Page Titled
---- Checking page title for uniqueness and provide list of page titles
----  to be manual checked if they are descriptive of topic or purpose
----  ** trimming out whitespace and converting to lower case for uniqueness
---*************************************************************************
 select case
          when value_dup_cnt > 1 then 1
          else 0
        end pf_result,
        application_id,page_id,lower_case_page_name
    from (select application_id,page_id,lower(trim(page_name)) lower_case_page_name,
                 ROW_NUMBER( ) OVER (PARTITION BY application_id,lower(trim(page_name)) ORDER BY page_id NULLS LAST) value_dup_cnt
            from apex_application_pages
           where application_id = :app_id
           order by lower(trim(page_name)) asc);
  
---*************************************************************************
---- WCAG 2.0/2.1 - 2.4.3 Focus Order
---- Checking application where tabindex has been added to an attribute that
----   have negative impact on tab/focus order
---*************************************************************************
select case
         when (lower(trim(ENTRY_ATTRIBUTE_08)) like '%tabindex%'
                or lower(trim(ENTRY_IMAGE_ALT_ATTRIBUTE)) like '%tabindex%'
                or lower(trim(TRANSLATE_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_05)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_10)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_09)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_06)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_07)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_03)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_02)) like '%tabindex%'
                or lower(trim(ENTRY_IMAGE_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_01)) like '%tabindex%'
                or lower(trim(ENTRY_ATTRIBUTE_04)) like '%tabindex%') then 1
         else 0
       end pf_result,
       application_id,application_name,ENTRY_IMAGE_ATTRIBUTES,ENTRY_IMAGE_ALT_ATTRIBUTE,ENTRY_ATTRIBUTE_01,
       ENTRY_ATTRIBUTE_02,ENTRY_ATTRIBUTE_03,ENTRY_ATTRIBUTE_04,
       ENTRY_ATTRIBUTE_05,ENTRY_ATTRIBUTE_06,ENTRY_ATTRIBUTE_07,
       ENTRY_ATTRIBUTE_08,ENTRY_ATTRIBUTE_09,
       ENTRY_ATTRIBUTE_10,TRANSLATE_ATTRIBUTES
 from APEX_APPLICATION_LIST_ENTRIES
 where application_id = :app_id ;

---- checking pages for added tabindex attributes
select case
         when lower(trim(DIALOG_ATTRIBUTES)) like '%tabindex%' then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,DIALOG_ATTRIBUTES
 from APEX_APPLICATION_PAGES
 where application_id = :app_id ;

---- checking page buttons for added tabindex attributes
select case
         when (lower(trim(BUTTON_ATTRIBUTES)) like '%tabindex%'
               or lower(trim(GRID_COLUMN_ATTRIBUTES)) like '%tabindex%'
               or lower(trim(IMAGE_ATTRIBUTES)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,
       GRID_COLUMN_ATTRIBUTES,IMAGE_ATTRIBUTES,BUTTON_ATTRIBUTES
  from APEX_APPLICATION_PAGE_BUTTONS
 where application_id = :app_id ;

---- checking IR region for added tabindex attributes
select case
         when (lower(trim(DETAIL_LINK_ATTRIBUTES)) like '%tabindex%'
               or lower(trim(ICON_VIEW_IMG_ATTR_TEXT)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,application_id,application_name,
       DETAIL_LINK_ATTRIBUTES,ICON_VIEW_IMG_ATTR_TEXT
 from APEX_APPLICATION_PAGE_IR
 where application_id = :app_id ;

---- checking ir columns for added tabindex attributes
select case
         when (lower(trim(COLUMN_LINK_ATTR)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,application_id,application_name,COLUMN_LINK_ATTR
  from APEX_APPLICATION_PAGE_IR_COL
 where application_id = :app_id ;

select case
         when (lower(trim(HTML_FORM_ELEMENT_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_12)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_04)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_03)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_13)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_07)) like '%tabindex%'
                or lower(trim(ITEM_BUTTON_IMAGE_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_02)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_09)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_15)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_01)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_05)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_14)) like '%tabindex%'
                or lower(trim(HTML_TABLE_CELL_ATTR_LABEL)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_10)) like '%tabindex%'
                or lower(trim(QUICK_PICK_LINK_ATTR)) like '%tabindex%'
                or lower(trim(HTML_TABLE_CELL_ATTR_ELEMENT)) like '%tabindex%'
                or lower(trim(READ_ONLY_DISPLAY_ATTR)) like '%tabindex%'
                or lower(trim(GRID_COLUMN_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_11)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_08)) like '%tabindex%'
                or lower(trim(FORM_ELEMENT_OPTION_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_06)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,
       QUICK_PICK_LINK_ATTR,ATTRIBUTE_01,ATTRIBUTE_02,ATTRIBUTE_03,
       ATTRIBUTE_04,ATTRIBUTE_05,ATTRIBUTE_06,ATTRIBUTE_07,ATTRIBUTE_08,
       ATTRIBUTE_09,ATTRIBUTE_10,ATTRIBUTE_11,ATTRIBUTE_12,ATTRIBUTE_13,
       ATTRIBUTE_14,ATTRIBUTE_15,READ_ONLY_DISPLAY_ATTR,
       HTML_TABLE_CELL_ATTR_LABEL,HTML_TABLE_CELL_ATTR_ELEMENT,
       HTML_FORM_ELEMENT_ATTRIBUTES,FORM_ELEMENT_OPTION_ATTRIBUTES,
       ITEM_BUTTON_IMAGE_ATTRIBUTES,GRID_COLUMN_ATTRIBUTES
 from APEX_APPLICATION_PAGE_ITEMS
 where application_id = :app_id ;

select case
         when (lower(trim(ATTRIBUTE_22)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_20)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_09)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_21)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_03)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_11)) like '%tabindex%'
                or lower(trim(ASCENDING_IMAGE_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(DESCENDING_IMAGE_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_01)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_05)) like '%tabindex%'
                or lower(trim(GRID_COLUMN_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_13)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_06)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_25)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_24)) like '%tabindex%'
                or lower(trim(HTML_TABLE_CELL_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_12)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_18)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_07)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_19)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_16)) like '%tabindex%'
                or lower(trim(REGION_ATTRIBUTES_SUBSTITUTION)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_14)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_17)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_08)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_10)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_02)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_15)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_04)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_23)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,
       REGION_ATTRIBUTES_SUBSTITUTION,ATTRIBUTE_25,
       ATTRIBUTE_24,ASCENDING_IMAGE_ATTRIBUTES,
       DESCENDING_IMAGE_ATTRIBUTES,HTML_TABLE_CELL_ATTRIBUTES,
       ATTRIBUTE_01,ATTRIBUTE_02,ATTRIBUTE_03,ATTRIBUTE_04,
       ATTRIBUTE_05,ATTRIBUTE_06,ATTRIBUTE_07,ATTRIBUTE_08,
       ATTRIBUTE_09,ATTRIBUTE_10,ATTRIBUTE_11,ATTRIBUTE_12,
       ATTRIBUTE_13,ATTRIBUTE_14,ATTRIBUTE_15,ATTRIBUTE_16,
       ATTRIBUTE_17,ATTRIBUTE_18,ATTRIBUTE_19,ATTRIBUTE_20,
       ATTRIBUTE_21,ATTRIBUTE_22,ATTRIBUTE_23,GRID_COLUMN_ATTRIBUTES
  from APEX_APPLICATION_PAGE_REGIONS
 where application_id = :app_id ;

select case
         when (lower(trim(ATTRIBUTE_17)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_24)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_11)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_02)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_05)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_10)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_14)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_22)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_06)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_21)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_25)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_16)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_01)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_19)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_09)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_08)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_04)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_20)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_18)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_12)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_03)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_07)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_15)) like '%tabindex%'
                or lower(trim(VALUE_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_23)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_13)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,
       VALUE_ATTRIBUTES,ATTRIBUTE_01,ATTRIBUTE_02,ATTRIBUTE_03,
       ATTRIBUTE_04,ATTRIBUTE_05,ATTRIBUTE_06,ATTRIBUTE_07,
       ATTRIBUTE_08,ATTRIBUTE_09,ATTRIBUTE_10,ATTRIBUTE_11,
       ATTRIBUTE_12,ATTRIBUTE_13,ATTRIBUTE_14,ATTRIBUTE_15,
       ATTRIBUTE_16,ATTRIBUTE_17,ATTRIBUTE_18,ATTRIBUTE_19,
       ATTRIBUTE_20,ATTRIBUTE_21,ATTRIBUTE_22,ATTRIBUTE_23,
       ATTRIBUTE_24,ATTRIBUTE_25
 from APEX_APPLICATION_PAGE_REG_COLS
 where application_id = :app_id ;

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
                or lower(trim(ATTRIBUTE_05)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,
       COLUMN_LINK_ATTRIBUTES,FORM_ELEMENT_ATTRIBUTES,
       FORM_ELEMENT_OPTION_ATTRIBUTES,ATTRIBUTE_01,
       ATTRIBUTE_02,ATTRIBUTE_03,ATTRIBUTE_04,ATTRIBUTE_05,
       ATTRIBUTE_06,ATTRIBUTE_07,ATTRIBUTE_08,ATTRIBUTE_09,
       ATTRIBUTE_10,ATTRIBUTE_11,ATTRIBUTE_12,
       ATTRIBUTE_13,ATTRIBUTE_14,ATTRIBUTE_15
 from APEX_APPLICATION_PAGE_RPT_COLS
 where application_id = :app_id ;

select case
         when (lower(trim(IMAGE_ATTRIBUTES)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       application_id,application_name,IMAGE_ATTRIBUTES
 from APEX_APPLICATION_PARENT_TABS
 where application_id = :app_id ;

select case
         when (lower(trim(TAB_IMAGE_ATTRIBUTES)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       application_id,application_name,TAB_IMAGE_ATTRIBUTES
 from APEX_APPLICATION_TABS
 where application_id = :app_id ;

select case
         when (lower(trim(LINK_ATTRIBUTES)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,LINK_ATTRIBUTES
 from APEX_APPL_PAGE_CARD_ACTIONS
 where application_id = :app_id ;

select case
         when (lower(trim(ICON_VIEW_ICON_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ICON_VIEW_LINK_ATTRIBUTES)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,ICON_VIEW_LINK_ATTRIBUTES,ICON_VIEW_ICON_ATTRIBUTES
 from APEX_APPL_PAGE_IGS
 where application_id = :app_id ;

select case
         when (lower(trim(ATTRIBUTE_02)) like '%tabindex%'
                or lower(trim(LINK_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(VALUE_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_12)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_21)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_11)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_08)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_03)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_17)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_06)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_22)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_04)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_23)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_14)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_16)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_18)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_10)) like '%tabindex%'
                or lower(trim(ITEM_ATTRIBUTES)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_09)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_01)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_05)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_13)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_07)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_25)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_15)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_19)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_20)) like '%tabindex%'
                or lower(trim(ATTRIBUTE_24)) like '%tabindex%' ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,ATTRIBUTE_12,
       ATTRIBUTE_13,ATTRIBUTE_14,ATTRIBUTE_15,ATTRIBUTE_16,
       ATTRIBUTE_17,ATTRIBUTE_18,ATTRIBUTE_19,ATTRIBUTE_20,
       ATTRIBUTE_21,ATTRIBUTE_22,ATTRIBUTE_23,ATTRIBUTE_24,
       ATTRIBUTE_25,ITEM_ATTRIBUTES,LINK_ATTRIBUTES,
       VALUE_ATTRIBUTES,ATTRIBUTE_01,ATTRIBUTE_02,ATTRIBUTE_03,
       ATTRIBUTE_04,ATTRIBUTE_05,ATTRIBUTE_06,ATTRIBUTE_07,
       ATTRIBUTE_08,ATTRIBUTE_09,ATTRIBUTE_10,ATTRIBUTE_11
 from APEX_APPL_PAGE_IG_COLUMNS
 where application_id = :app_id ;
 


---*************************************************************************
---- WCAG 2.0/2.1 - 2.4.4 Link Purpose (In Context)
---- Checking link text is meaning as well as have alt setting.
---*************************************************************************

--- look into region source for href and column html expression areas

--- checking IR default links
select case
         when ((lower(trim(DETAIL_LINK_ATTRIBUTES)) not like '%aria-%'
                and lower(trim(DETAIL_LINK_ATTRIBUTES)) not like '%title%')
                or trim(DETAIL_LINK_ATTRIBUTES) is null ) then 1
         else 0
       end pf_result,
       --* alt tag could be in link icon
      page_id,application_id,application_name,region_name,DETAIL_LINK_ATTRIBUTES
 from APEX_APPLICATION_PAGE_IR
 where application_id = :app_id 
 and DETAIL_LINK_TARGET is not null;

--- checking IR column links 
select case
         when column_link is not null and ((lower(trim(COLUMN_LINK_ATTR)) not like '%aria-%'
                and lower(trim(COLUMN_LINK_ATTR)) not like '%title%')
                or trim(COLUMN_LINK_ATTR) is null) then 1
         when html_expression is not null and lower(trim(html_expression)) like '%<a%' then 1
         else 0
       end pf_result,
       page_id,application_id,application_name,COLUMN_LINK_ATTR,html_expression
 from APEX_APPLICATION_PAGE_IR_COL
 where application_id = :app_id 
 and (column_link is not null
     or html_expression is not null);

--- checking quick pick links 
select case
         when ((lower(trim(QUICK_PICK_LINK_ATTR)) not like '%aria-%'
                and lower(trim(QUICK_PICK_LINK_ATTR)) not like '%title%')
                or trim(QUICK_PICK_LINK_ATTR) is null ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,a.item_name,a.item_id,QUICK_PICK_LINK_ATTR
 from APEX_APPLICATION_PAGE_ITEMS a
 where application_id = :app_id 
 and show_quick_picks = 'Y';

--- checking Classic report column links 
select case
         when ((lower(trim(COLUMN_LINK_ATTRIBUTES)) not like '%aria-%'
                and lower(trim(COLUMN_LINK_ATTRIBUTES)) not like '%title%')
                or trim(COLUMN_LINK_ATTRIBUTES) is null ) then 1
         else 0
       end pf_result,
      page_id,page_name,application_id,application_name,a.region_name,a.column_alias, COLUMN_LINK_ATTRIBUTES
 from APEX_APPLICATION_PAGE_RPT_COLS a
 where application_id = :app_id 
 and COLUMN_LINK_URL is not null;

---- checking Card Region links
select case
         when ((lower(trim(LINK_ATTRIBUTES)) not like '%aria-%'
                and lower(trim(LINK_ATTRIBUTES)) not like '%title%')
                or trim(LINK_ATTRIBUTES) is null ) then 1
         else 0
       end pf_result,
       page_id,page_name,region_id,region_name,application_id,application_name,LINK_ATTRIBUTES
 from APEX_APPL_PAGE_CARD_ACTIONS a
 where application_id = :app_id;

select case
         when (lower(trim(ICON_VIEW_LINK_ATTRIBUTES)) not like '%aria-%'
                and lower(trim(ICON_VIEW_LINK_ATTRIBUTES)) not like '%title%') then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,ICON_VIEW_LINK_ATTRIBUTES
 from APEX_APPL_PAGE_IGS
 where application_id = :app_id 
 and ICON_VIEW_ICON_ATTRIBUTES is not null;

select case
         when ((item_type = 'NATIVE_LINK' 
                and ((lower(trim(LINK_ATTRIBUTES)) not like '%aria-%' or lower(trim(LINK_ATTRIBUTES)) not like '%title%')
                     or trim(LINK_ATTRIBUTES) is null))
                or (lower(trim(attribute_01)) like '%<a%' and 
                     (lower(trim(attribute_01)) not like '%aria-%' and lower(trim(attribute_01)) not like '%title%') ) ) then 1
         else 0
       end pf_result,
       page_id,page_name,application_id,application_name,LINK_ATTRIBUTES,attribute_01
 from APEX_APPL_PAGE_IG_COLUMNS
 where application_id = :app_id;
    
    

---*************************************************************************
---- WCAG 2.0/2.1 - 2.5.2 Pointer Cancellation
---- Checking DA and JS for on down clicks events
---*************************************************************************
--- Checking page DAs for mouse down or up triggering events
select case
         when WHEN_EVENT_NAME in ('Mouse Button Release','Mouse Button Press') then 1
         else 0
       end pf_result,
       a.application_id,application_name,page_id,page_name,dynamic_action_name,DYNAMIC_ACTION_ID
from apex_application_page_da a
where application_id = :app_id;
  
--- Check page JS for mouse down/up events
select case
         when (lower(trim(JAVASCRIPT_CODE)) like '%mousedown%'
           or lower(trim(JAVASCRIPT_CODE)) like '%mouseup%'
           or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%mousedown%'
           or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%mouseup%') then 1
         else 0
       end pf_result,
     a.application_id,application_name,page_id,page_name
from apex_application_pages a
where application_id = :app_id;


---- *************************************************************************
---- WCAG 2.0/2.1 - 3.2.1 On Focus
---- Check for onfocus events in javascript and dynamic actions
---- *************************************************************************
--- Checking page DAs for On Focus triggering events
select case
         when WHEN_EVENT_NAME in ('Get Focus') then 1
         else 0
       end pf_result,
       page_id,page_name,dynamic_action_name
 from apex_application_page_da a
where application_id = :app_id;
  
--- Check page JS for onfocus events
select case
         when (lower(trim(JAVASCRIPT_CODE)) like '%focus%'
                or lower(trim(JAVASCRIPT_CODE_ONLOAD)) like '%focus%') then 1
         else 0
       end pf_result,
       page_id,page_name,JAVASCRIPT_CODE,JAVASCRIPT_CODE_ONLOAD
  from apex_application_pages
 where application_id = :app_id
;



---- *************************************************************************
---- WCAG 2.0/2.1 - 3.2.3 Consistent Navigation
---- Check for onfocus events in javascript and dynamic actions
---- *************************************************************************

---  Checking if lists tagged as navigation menu and bar are dynamic.  
---   if so they need to be checked
select 1 pf_result, --always fail developer needs to run code and evaluate results
       list_name,
       list_type,
       list_id
from apex_application_lists a
where a.application_id = :app_id
  and a.LIST_TYPE_CODE != 'STATIC';

select 1 pf_result, --- always fail as each entry needs to be reviewed
       list_name,
       entry_text,
       list_id,
       list_entry_id
from apex_application_list_entries b
where b.application_id = :app_id;

---- *************************************************************************
---- WCAG 2.0/2.1 - 3.2.4 Consistent Identification
---- Provide list of components by type and name (strip off PXX_)
---- *************************************************************************
--   Get list of page items (non-buttons)
select 1 pf_result,
       'Page Items' type,
       substr(item_name,instr(item_name,'_')+1) adj_name, 
       item_name,label,item_label_template template, 
       item_icon_css_classes css_classes,
       application_id,application_name,page_id,page_name,region 
from apex_application_page_items a
where  application_id = :app_id
  --and page_id = :page_id
order by 1,2
;

select 1 pf_result,
       'Buttons',button_name, 
       label,button_template,icon_css_classes,
       page_id,page_name,region
 from APEX_APPLICATION_PAGE_BUTTONS
 where application_id = :app_id
order by 1,2
;

select 1 pf_result,
       'IR Region Links' type, DETAIL_LINK_TEXT, 
       DETAIL_LINK_ATTRIBUTES,
       page_id,
       region_name
 from APEX_APPLICATION_PAGE_IR a
 where application_id = :app_id 
 and DETAIL_LINK_TARGET is not null
 ;


select 1 pf_result,
       'IR Column Links' type, COLUMN_LINKTEXT, COLUMN_LINK_ATTR,
       page_id,application_id,application_name,page_id,region_name 
  from APEX_APPLICATION_PAGE_IR_COL
 where application_id = :app_id 
   and column_link is not null;

select 1 pf_result,
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
  where application_id = :app_id 
    and show_quick_picks = 'Y';

select 1 pf_result,
       'Classic Report Column Links' type, 
       column_alias, COLUMN_LINK_URL,COLUMN_LINK_ATTRIBUTES
       page_id,page_name
  from APEX_APPLICATION_PAGE_RPT_COLS
 where application_id = :app_id 
   and COLUMN_LINK_URL is not null;

select 1 pf_result,
       'Breadcrumbs' type,theme_class,
       template_name,BREADCRUMB_LINK_ATTRIBUTES
  from APEX_APPLICATION_TEMP_BC
 where application_id = :app_id;

select 1 pf_result,
       'Cards Actions' type,action_type,
       label,LINK_ATTRIBUTES,link_target, 
       page_id,page_name,region_name
  from APEX_APPL_PAGE_CARD_ACTIONS
 where application_id = :app_id
 order by 2,label;

select 1 pf_result,
       'IG Region Links' type, ICON_VIEW_LINK_ATTRIBUTES,
       page_id,page_name,application_id,application_name,region_name
  from APEX_APPL_PAGE_IGS
 where application_id = :app_id 
   and ICON_VIEW_ICON_ATTRIBUTES is not null;

select 1 pf_result,
       'IG Column Links' type,name column_name,heading,label, item_type,LINK_ATTRIBUTES,attribute_01,
       page_id,page_name,application_id,application_name,region_name
  from APEX_APPL_PAGE_IG_COLUMNS
 where application_id = :app_id 
  and ((item_type = 'NATIVE_LINK' and trim(LINK_ATTRIBUTES) is null)
    or (lower(trim(attribute_01)) like '%<a%' and lower(trim(attribute_01)) not like '%alt%') )
 order by name;



---- *************************************************************************
---- WCAG 2.0/2.1 - 3.3.1 Error Identification
---- Look for validations where Display Location is set to Inline with Field
---- *************************************************************************
 select case 
          when ERROR_DISPLAY_LOCATION = 'INLINE_WITH_FIELD' then 1
          else 0
        end pf_result,
        application_id,application_name,page_id,page_name, validation_name
   from apex_application_page_val
  where application_id = :app_id ;



---- *************************************************************************
---- WCAG 2.0/2.1 - 3.3.3 Error Suggestion
---- Look at validations and provide list of error messages
---- *************************************************************************
 select 1 pf_result,
        page_id,page_name, 
        validation_name,VALIDATION_FAILURE_TEXT
   from apex_application_page_val
  where application_id = :app_id ;



---- *************************************************************************
---- WCAG 2.0/2.1 - 4.1.1 Parsing
---- Look for custom html in html expression, source code fields and provide
----   list to be checked for open/close tags,brackets or quotes.
---- *************************************************************************
--- check region sources for html references
 select case
          when (REGION_SOURCE like '%<%') then 1
          else 0
        end pf_result,
        page_id,page_name,REGION_SOURCE,QUERY_TYPE_CODE
   from apex_application_page_regions
  where application_id = :app_id;

--- Check IR Columns in html_expression
select case
          when ((column_link is not null and lower(trim(COLUMN_LINK_ATTR)) is not null)
                 or lower(trim(html_expression)) is not null
                 or lower(trim(report_label)) like '%<%'
                 or lower(trim(report_label)) like '%"%'
                 or lower(trim(report_label)) like '%''%') then 1
          else 0
        end pf_result,
        page_id,
        html_expression,
        column_link,
        COLUMN_LINK_ATTR,
        report_label
 from APEX_APPLICATION_PAGE_IR_COL
 where application_id = :app_id ;
      
--- Check classic Columns in html_expression
select case
          when (lower(trim(html_expression)) is not null
                 or lower(trim(css_style)) is not null
                      or lower(trim(column_link_attributes)) is not null
                      or lower(trim(column_link_text)) is not null
                      or lower(trim(heading)) like '%<%'
                      or lower(trim(heading)) like '%"%'
                      or lower(trim(heading)) like '%''%') then 1
          else 0
        end pf_result,
        page_id,
        html_expression,
        css_style,
        column_link_attributes,
        column_link_text,
        heading
 from APEX_APPLICATION_PAGE_rpt_cols
 where application_id = :app_id ;

--- Check IG Columns in html_expression
select case
          when (item_type = 'NATIVE_HTML_EXPRESSION' 
                 or trim(link_text) is not null
                 or lower(trim(attribute_01)) like '%<%'
                 or lower(trim(attribute_01)) like '%"%'
                 or lower(trim(attribute_01)) like '%''%'
                 or lower(trim(heading)) like '%<%'
                 or lower(trim(heading)) like '%"%'
                 or lower(trim(heading)) like '%''%') then 1
          else 0
        end pf_result,
        page_id,
        item_type,
        link_text,
        attribute_01,
        heading
 from APEX_APPL_page_ig_columns
 where application_id = :app_id ;


