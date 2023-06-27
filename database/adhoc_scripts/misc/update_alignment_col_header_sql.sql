-- 
-- Update column and header alignments (Bug 35187867)
--
--------------------------------------------------
-- INTERACTIVE REPORTS
--------------------------------------------------
--
-- Update column alignment to LEFT for date columns that are not LEFT aligned (99)
--
update wwv_flow_worksheet_columns
set column_alignment = 'LEFT'
where security_group_id = 10
  and column_type = 'DATE'
  and column_alignment <> 'LEFT'
;
--
-- Update column alignment to LEFT for numerical identifiers that are not LEFT aligned. (429)
--
update wwv_flow_worksheet_columns
set column_alignment = 'LEFT'
where column_alignment <> 'LEFT'
  and security_group_id = 10
  and db_column_name like '%ID'
  and column_type = 'NUMBER'
;
--
-- Update heading alignment to match column alignment (3103)
--
update wwv_flow_worksheet_columns
set heading_alignment = column_alignment
where column_alignment <> heading_alignment
  and security_group_id = 10
;
--
--------------------------------------------------
-- INTERACTIVE GRIDS
--------------------------------------------------
--
-- Update Date column that are not LEFT aligned (5)
--
update wwv_flow_region_columns
set value_alignment = 'LEFT'
where security_group_id = 10
  and data_type = 'DATE'
  and item_type <> 'NATIVE_HIDDEN'
  and value_alignment <> 'LEFT'
;
--
-- Update ID numerical columns that are not LEFT aligned (16)
--
update wwv_flow_region_columns
set value_alignment = 'LEFT'
where value_alignment <> 'LEFT'
  and security_group_id = 10
  and name like '%ID'
  and data_type = 'NUMBER'
;
--
-- Update heading alignment to match column alignment (28 + any from above)
--
update wwv_flow_region_columns
set heading_alignment = value_alignment
where value_alignment <> heading_alignment
  and security_group_id = 10
;
--
--------------------------------------------------
-- CLASSIC REPORTS
--------------------------------------------------
--
-- Update CRs to match header and column alignment: wwv_flow_region_report_column (2672)
--
update wwv_flow_region_report_column
set heading_alignment = column_alignment
where column_alignment <> heading_alignment
  and security_group_id = 10
;
--
--
--------------------------------------------------
-- IRs:
-- Update non-identifier NUMBER columns that are not RIGHT aligned.
--
update wwv_flow_worksheet_columns
set column_alignment = 'RIGHT'
where column_alignment <> 'RIGHT'
  and security_group_id = 10
  and db_column_name not like '%ID'
  and column_type = 'NUMBER'
;
--
-- Update column_alignment for columns that should not be centered. e.g.: yes/no columns
--
update wwv_flow_worksheet_columns
set column_alignment = 'LEFT'
where column_alignment <> 'LEFT'
  and security_group_id = 10
  and column_type <> 'DATE'
  and column_type <> 'NUMBER'
  and column_link is null
  and column_html_expression is null
  and column_label not like '%CHECKBOX%' -- columns containing checkboxes
  and db_column_name != 'CB'
  and db_column_name not like '%ACTION%'
  and upper(column_label) not in ('RUN', 'EDIT', 'COPY')
  and length(db_column_name) > 1
;
--
--
--------------------------------------------------
-- IG: Update CENTER column alignment for any non-special columns
update wwv_flow_region_report_column
set column_alignment = 'LEFT'
where security_group_id = 10
  and hidden_column = 'N'
  and column_alignment = 'CENTER'
  and column_alias like '%_ID'
  and column_alias like '%DATE%'
  and column_alias like '%COUNT%'
  and column_alias like '%NUMBER%'
  and column_alias like '%CREATED%'
  and column_alias like '%TIMESTAMP%'
  and ( column_alias not like '%ACTION%' and
        upper(column_heading) not like '%ACTION%' and
        column_alias <> 'C' and
        column_alias <> 'CB' and
        upper(column_alias) not like '%CHECK%' and
        upper(column_heading) not like '%CHECKBOX%' and
        column_heading not like '%Save%' and
        column_alias not like '%SELECT%' and
        upper(column_heading) not like '%SELECT%' and
        upper(column_heading) <> 'REFRESH' and
        upper(column_heading) <> 'TRANSLATE_TITLE' )