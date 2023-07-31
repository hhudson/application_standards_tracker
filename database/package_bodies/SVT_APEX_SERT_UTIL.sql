--liquibase formatted sql
--changeset package_body_script:SVT_APEX_SERT_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package body SVT_APEX_SERT_UTIL as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_apex_sert_util
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_sert_view_prefix constant varchar2(31) := 'V_SVT_APEX_SERT_';
  gc_select           constant varchar2(100) := 'select ';
  gc_final_slash      constant varchar2(10) := chr(10)||'/';


function v_SVT_sert
return v_SVT_sert_nt pipelined
is
c_scope constant varchar2(128) := gc_scope_prefix || 'v_SVT_sert';
c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

cursor cur_aa
is
    select  
    $if oracle_apex_version.c_sert_access
    $then 
      scol.collection_name, scol.collection_sql, ssc.category_name, 
      ssc.category_short_name, ssa.attribute_name, ssa.attribute_key, 
      ssa.attribute_id, ssa.rule_source, ssa.rule_type, ssa.when_not_found,
      ssa.table_name, ssa.column_name, ssa.fix, ssa.info, ssa.category_id, ssc.category_key
      from sv_sert_apex.sv_sec_attributes ssa 
      inner join sv_sert_apex.sv_sec_categories ssc on ssa.category_id = ssc.category_id
      inner join sv_sert_apex.sv_sec_score_collections scol on scol.category_id = ssc.category_id
                                                            and scol.collection_key = ssc.category_key
                                                            and scol.score_collection_id  = ssa.score_collection_id
      where ssa.active_flag = 'Y'
      and scol.collection_name not in ('SV_XSS_BC_ENTRIES','SV_XSS_ITEM_LABELS', 'SV_XSS_COL_HTML_EXPR')
    $else 
      null collection_name,
      null collection_sql,
      null category_name,
      null category_short_name,
      null attribute_name,
      null attribute_key,
      null attribute_id,
      null rule_source,
      null rule_type,
      null when_not_found,
      null table_name,
      null column_name,
      null fix,
      null info,
      null category_id,
      null category_key
      from dual
    $end
    ;

type r_aa is record (
  collection_name     varchar2(255),
  collection_sql      varchar2(4000),
  category_name       varchar2(255),
  category_short_name varchar2(255),
  attribute_name      varchar2(4000),
  attribute_key       varchar2(4000),
  attribute_id        number,
  rule_source         varchar2(255),
  rule_type           varchar2(255),
  when_not_found      varchar2(100),
  table_name          varchar2(255),
  column_name         varchar2(4000),
  fix                 clob,
  info                clob,
  category_id         number,
  category_key        varchar2(255)
);
type t_aa is table of r_aa index by pls_integer;
l_aat t_aa;
begin
  apex_debug.message(c_debug_template,'START');
  open cur_aa;

    loop
      fetch cur_aa bulk collect into l_aat limit 1000;

      exit when l_aat.count = 0;

      for rec in 1 .. l_aat.count
      loop
        pipe row (v_SVT_sert_ot (
                      l_aat (rec).collection_name,
                      l_aat (rec).collection_sql,
                      l_aat (rec).category_name,
                      l_aat (rec).category_short_name,
                      l_aat (rec).attribute_name,
                      l_aat (rec).attribute_key,
                      l_aat (rec).attribute_id,
                      l_aat (rec).rule_source,
                      l_aat (rec).rule_type,
                      l_aat (rec).when_not_found,
                      l_aat (rec).table_name,
                      l_aat (rec).column_name,
                      l_aat (rec).fix,
                      l_aat (rec).info,
                      l_aat (rec).category_id,
                      l_aat (rec).category_key
                    )
                );
      end loop;
    end loop;  
exception when others then
  apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
  raise;
end v_SVT_sert;


$if oracle_apex_version.c_sert_access
$then
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2022
-- Synopsis:
--
-- returns a row of sv_sec_score_collections
--
------------------------------------------------------------------------------
  function get_collection_row(p_collection_name in v_SVT_sert.collection_name%type)
  return v_SVT_sert%rowtype deterministic
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_collection_row';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_category_key constant v_SVT_sert.collection_name%type := upper(p_collection_name);
  l_coll_row v_SVT_sert%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_collection_name', p_collection_name);

    select *
    into l_coll_row
    from v_SVT_sert ssc
    where ssc.collection_name = c_category_key;

    return l_coll_row;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_collection_row;

  function generate_view_name(p_collection_name in v_SVT_sert.collection_name%type)
  return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_view_name';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_category_key constant v_SVT_sert.collection_name%type := upper(p_collection_name);
  l_coll_row v_SVT_sert%rowtype; 
  l_view_name    varchar2(50);
  begin
    apex_debug.message(c_debug_template,'START', 'p_collection_name', p_collection_name);

    l_coll_row := get_collection_row(p_collection_name => c_category_key);

    l_view_name := apex_string.format(gc_sert_view_prefix||'%0_%1', l_coll_row.category_id, c_category_key);

    apex_debug.message(c_debug_template, 'l_view_name', l_view_name);
    return l_view_name;

  exception when others then 
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_view_name;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 1, 2022
-- Synopsis:
--
-- Private function to generate a view banner for the script
--
------------------------------------------------------------------------------
  function generate_banner (p_view_name     in varchar2,
                            p_author        in varchar2,
                            p_function_name in varchar2)
  return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_banner';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_function_name constant varchar2(100) := upper(p_function_name);
  c_divider       constant varchar2(100) := lpad('-',80, '-') || chr(10);
  c_author        constant varchar2(50)  := coalesce(upper(p_author),user);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_view_name', p_view_name,
                                        'p_function_name', p_function_name,
                                        'p_author', p_author);

    return c_divider || '--' || chr(10) 
                     || '--      DO NOT EDIT - AUTOMATICALLY GENERATED BY SVT_APEX_SERT_UTIL'||'.'||c_function_name|| chr(10)
                     || '--      Author:  ' || c_author || chr(10)
                     || '-- Script name:  ' || upper(p_view_name) || '.sql' || chr(10)
                     || '--        Date:  ' || to_char(sysdate, 'DD-Mon-YYYY HH24:MI') || chr(10)
                     || '--     Purpose:  ' || 'View creation DDL for view ' 
                                             || upper(p_view_name) || chr(10) 
                     || '--' || chr(10) 
                     || c_divider;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_banner;

  function generate_create_stmt(p_collection_name in v_SVT_sert.collection_name%type,
                                p_author          in varchar2 default null)
  return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_create_stmt';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  l_banner       varchar2(2000);
  c_category_key constant v_SVT_sert.collection_name%type := upper(p_collection_name);
  l_coll_row     v_SVT_sert%rowtype; 
  l_insert_part  v_SVT_sert.collection_sql%type;
  c_view_name    constant varchar2(50) := generate_view_name(p_collection_name=> c_category_key);
  c_spaces       constant varchar2(10) := '   ';
  c_define_off   constant varchar2(50) := chr(10)||'set define off'||chr(10);
  begin
    apex_debug.message(c_debug_template,'START', 'p_collection_name', p_collection_name,
                                                  'p_author', p_author);

    l_banner := generate_banner (p_view_name     => c_view_name,
                                 p_author        => p_author,
                                 p_function_name => 'generate_SVT_view');


    l_coll_row := get_collection_row(p_collection_name => c_category_key);
    l_insert_part := substr(l_coll_row.collection_sql, 1, instr(l_coll_row.collection_sql, '#COLLECTION_NAME#',1));
    l_insert_part := substr(l_insert_part, instr(l_insert_part,'(',1)+1);
    l_insert_part := substr(l_insert_part, 1, instr(l_insert_part,')',1)-2);
    l_insert_part := trim(l_insert_part);
    l_insert_part := l_insert_part||','
                     ||chr(10)||c_spaces||'validation_failure_message, '
                     ||chr(10)||c_spaces||'issue_title';

    return l_banner || c_define_off || 
            apex_string.format('create or replace force editionable view %0 (%1) as %2', 
                                c_view_name, 
                                l_insert_part, 
                                chr(10)
                              );

  exception 
    when others then 
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end generate_create_stmt;

  function generate_select_stmt (p_collection_name in v_SVT_sert.collection_name%type)
  return v_SVT_sert.collection_sql%type
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_select_stmt';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_category_key constant v_SVT_sert.collection_name%type := upper(p_collection_name);
  l_coll_row    v_SVT_sert%rowtype; 
  l_rule_values  varchar2(500);
  l_rule_results varchar2(500);
  l_select_stmt v_SVT_sert.collection_sql%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_collection_name', p_collection_name);

    l_coll_row := get_collection_row(p_collection_name => c_category_key);
    l_select_stmt := case when instr(l_coll_row.collection_sql, 'with data as',1) > 1 
                   then substr(l_coll_row.collection_sql, instr(l_coll_row.collection_sql, 'with data as',1)-1)
                   else gc_select||substr(l_coll_row.collection_sql, instr(l_coll_row.collection_sql, '#COLLECTION_NAME#',1)-1)
                   end ;
    l_select_stmt := replace(l_select_stmt, '#COLLECTION_ID#', '1');
    l_select_stmt := replace(l_select_stmt, '#ATTRIBUTE_ID#', l_coll_row.attribute_id);
    l_select_stmt := replace(l_select_stmt, 'sv_sec_categories', 'sv_sert_apex.sv_sec_categories');
    l_select_stmt := replace(l_select_stmt, 'sv_sec_attributes', 'sv_sert_apex.sv_sec_attributes');
    l_select_stmt := replace(l_select_stmt, 'sv_sec_rules', 'sv_sert_apex.sv_sec_rules');
    l_select_stmt := replace(l_select_stmt, 'sv_sec_util', 'sv_sert_apex.sv_sec_util');
    l_select_stmt := replace(l_select_stmt, 'sv_sec.', 'sv_sert_apex.sv_sec.');
    l_select_stmt := replace(l_select_stmt, '#ATTRIBUTE_SET_ID#', '-1');
    l_select_stmt := replace(l_select_stmt, '#RULE_SOURCE#', l_coll_row.rule_source);
    l_select_stmt := replace(l_select_stmt, '#RULE_TYPE#', l_coll_row.rule_type);
    l_select_stmt := replace(l_select_stmt, '#WHEN_NOT_FOUND#', l_coll_row.when_not_found);
    l_select_stmt := replace(l_select_stmt, '#CATEGORY_KEY#', l_coll_row.category_key);

    select listagg(value, ':') within group (order by attribute_value_id) tval,
    listagg(result, ':') within group (order by attribute_value_id) tresult
    into l_rule_values, l_rule_results
    from sv_sert_apex.sv_sec_attribute_values
    where attribute_id = l_coll_row.attribute_id;

    l_select_stmt := replace(l_select_stmt, '#RULE_VALUES#', l_rule_values);
    l_select_stmt := replace(l_select_stmt, '#RULE_RESULTS#', l_rule_results);

    return l_select_stmt;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_select_stmt;

  function generate_SVT_view (p_collection_name     in sv_sert_apex.sv_sec_score_collections.collection_name%type,
                              p_author              in varchar2 default null,
                              p_select_stmt_only_yn in varchar2 default 'N'
                              )
  return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_SVT_view';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_author       constant varchar2(50) := coalesce(upper(p_author),user);
  l_create_stmt  v_SVT_sert.collection_sql%type;
  c_category_key constant v_SVT_sert.collection_name%type := upper(p_collection_name);
  l_coll_row     v_SVT_sert%rowtype; 
  l_select_stmt  v_SVT_sert.collection_sql%type;
  l_vf_msg_sgmt  varchar2(100);
  l_vf_message   varchar2(1000);
  l_issue_title  varchar2(500);
  type t_sql_segment is table of varchar2(1000);
  l_sql_segment     t_sql_segment;
  l_vf_attributes   t_sql_segment := t_sql_segment();
  l_corrected_view  v_SVT_sert.collection_sql%type;
  l_collection_field_idx number :=1;
  l_from_idx             number :=1;
  l_counter              number :=0;
  l_key_field            varchar2(100);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_collection_name', p_collection_name,
                                        'p_author', p_author,
                                        'p_select_stmt_only_yn', p_select_stmt_only_yn);


    l_create_stmt := generate_create_stmt(p_collection_name => c_category_key,
                                          p_author => c_author);


    l_select_stmt := generate_select_stmt (p_collection_name => c_category_key);

    begin <<sql_seg_block>>
      select column_value bulk collect into l_sql_segment
      from table(apex_string.split(l_select_stmt, chr(10)));
    exception when no_data_found then
      return 'missing sql segments';
    end sql_seg_block;

    apex_debug.message(c_debug_template, 'l_sql_segment.count', l_sql_segment.count);

    l_coll_row := get_collection_row(p_collection_name => c_category_key);

    for idx in 1..l_sql_segment.count
    loop
      l_collection_field_idx := case when l_sql_segment(idx) like q'[select '#COLLECTION_NAME#'%]'
                                     then idx
                                     else l_collection_field_idx
                                     end;
      l_from_idx := case when idx > l_collection_field_idx
                         then case when lower(l_sql_segment(idx)) like '%from%'
                                   then idx
                                   else l_from_idx
                                   end
                         else l_from_idx
                         end;
      l_key_field := case when idx > l_collection_field_idx
                          then case 
                               when lower(l_sql_segment(idx)) like '%page_name%' then 'page_name'
                               when lower(l_sql_segment(idx)) like '%item_name%' then 'item_name'
                               when lower(l_sql_segment(idx)) like '%sert_column_name%' then 'sert_column_name'
                               when lower(l_sql_segment(idx)) like '%region_name%' then 'region_name'
                               when lower(l_sql_segment(idx)) like '%sert_component_name%' then 'sert_component_name' -- not interesting
                               when lower(l_sql_segment(idx)) like '%component_name%' then 'component_name'
                               else l_key_field
                               end
                          else l_key_field
                          end ;
      l_sql_segment(idx) := case when lower(l_sql_segment(idx)) like '%application_id = #application_id#'
                                 then case when lower(l_sql_segment(idx)) like '%and%'
                                           then 'and 1=1'
                                           when lower(l_sql_segment(idx)) like '%where%'
                                           then 'where 1=1'
                                           else l_sql_segment(idx)
                                           end
                                 else l_sql_segment(idx)
                                 end;
    end loop;
    apex_debug.message(c_debug_template, 'l_collection_field_idx', l_collection_field_idx);
    apex_debug.message(c_debug_template, 'l_from_idx', l_from_idx);
    apex_debug.message(c_debug_template, 'l_key_field', l_key_field);

    for idx in l_collection_field_idx..l_from_idx-1
    loop
      -- apex_debug.message(c_debug_template, 'l_sql_segment(idx)', l_sql_segment(idx));
      select lower(trim(column_value)) 
      into l_vf_msg_sgmt
      from table(apex_string.split(l_sql_segment(idx), ' '))
      where column_value is not null
      fetch first 1 rows only;
      -- apex_debug.message(c_debug_template, 'l_vf_msg_sgmt', l_vf_msg_sgmt);

      case 
            when l_vf_msg_sgmt = ' ' then null;
            when l_vf_msg_sgmt like '%select%' then null;
            when l_vf_msg_sgmt like '%1%' then null;
            when validate_conversion(l_vf_msg_sgmt as number) = 1 then null;
            when l_vf_msg_sgmt like '%application_id%' then null;
            when l_vf_msg_sgmt like '%result%' then null;
            -- when l_vf_msg_sgmt like '%collection%' then null;
            -- when l_vf_msg_sgmt like '%sv_sert_apex%' then null;
            when l_vf_msg_sgmt like '%page%' then null;
            when l_vf_msg_sgmt like '%link%' then null;
            when l_vf_msg_sgmt like '%updated%' then null;
            -- when l_vf_msg_sgmt like '%category_key%' then null;
            when l_vf_msg_sgmt like '%null%' then null;
            when l_vf_msg_sgmt like '%(%' then null;
            when l_vf_msg_sgmt like '%-%' then null;
            when l_vf_msg_sgmt like '%)%' then null;
            -- when l_vf_msg_sgmt like '%attribute%' then null;
            -- when l_vf_msg_sgmt like '%c00%' then null;
            -- when l_vf_msg_sgmt like '%n00%' then null;
            when l_vf_msg_sgmt like '%val%' then null;
            when l_vf_msg_sgmt like '%checksum%' then null;
            -- when l_vf_msg_sgmt like '%sert_%' then null;
            -- when l_vf_msg_sgmt like '%component_id%' then null;
            when l_vf_msg_sgmt like q'[%'%]' then null;
            --'
            else
              l_vf_attributes.extend();
              l_counter := l_counter + 1; 
              l_vf_attributes(l_counter) := trim(replace(l_vf_msg_sgmt,','));
      end case;
    end loop;

    apex_debug.message(c_debug_template, 'l_vf_attributes.count', l_vf_attributes.count);
    l_counter := 0;
    l_vf_message := q'[apex_string.format(p_message => 'Violation details:]';
    --'
    for idx in 1..l_vf_attributes.count
    loop 
      l_vf_message := l_vf_message||chr(10)||'- '||
                      l_vf_attributes(idx)||': `%'||l_counter||'`'
                      -- ||case when l_counter < l_vf_attributes.count - 1
                      --      then chr(10)
                      --      end
                           ;
      l_counter := l_counter + 1;
    end loop;
    l_vf_message := l_vf_message ||q'[',]'||chr(10);
    --'
    l_counter := 0;
    for idx in 1..l_vf_attributes.count
    loop 
      l_vf_message := l_vf_message||
                      'p'||l_counter||'=>'||
                      l_vf_attributes(idx)||
                      case when l_counter < l_vf_attributes.count-1
                           then ','||chr(10)
                           end;
      l_counter := l_counter + 1;
    end loop;
    l_vf_message := l_vf_message ||') validation_failure_message';
    apex_debug.message(c_debug_template, 'l_vf_message', l_vf_message);


    l_issue_title := chr(10)||apex_string.format(p_message =>
    q'[apex_string.format(
    p_message=> 
    '%0 violation for `%1` (APP_ID %3)',
    p0 => %2, 
    p1 => application_id
    ) issue_title]',
    p0 => l_coll_row.category_name,
    p1 => '%0',
    p2 => coalesce(l_key_field,'page_id'),
    p3 => '%1'
    );

    apex_debug.message(c_debug_template, 'l_issue_title', l_issue_title);

    for idx in 1..l_sql_segment.count
    loop
      l_corrected_view := l_corrected_view||chr(10)||
                          case when idx = l_from_idx
                               then ','||l_vf_message||','||l_issue_title||chr(10)||l_sql_segment(idx)
                               else l_sql_segment(idx)
                               end;
    end loop;

    l_corrected_view := replace(l_corrected_view, '#COLLECTION_NAME#', l_coll_row.collection_name);

    return case when p_select_stmt_only_yn = 'Y'
                then l_corrected_view
                else l_create_stmt||l_corrected_view||gc_final_slash
                end;

  exception 
    when no_data_found then return 'No data found';
    when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_SVT_view;

  function generate_SVT_view (p_view_name in varchar2, 
                              p_author    in varchar2 default null)
  return varchar2
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_SVT_view (2)';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_view_name constant varchar2(100) := upper(p_view_name);
  l_collection_name v_SVT_sert.collection_name%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_view_name', p_view_name,
                                        'p_author', p_author);

    l_collection_name := substr(c_view_name, 17);
    l_collection_name := substr(l_collection_name, instr(l_collection_name, '_')+1);

    return generate_SVT_view (p_collection_name => l_collection_name,
                              p_author          => p_author
                              );

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end generate_SVT_view;

  function generate_union_view (p_author in varchar2)
  return clob
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'generate_union_view'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_view_name   constant varchar2(100) := 'v_SVT_sert__0';
  l_banner      varchar2(2000);
  c_create_stmt constant varchar2(1000) := apex_string.format('create or replace force view %s as'||chr(10),c_view_name);
  l_view_count  number;
  l_select_stmt varchar2(4000);
  l_sql         clob;
  l_counter     pls_integer := 0;
  begin 
    apex_debug.message(c_debug_template,'START', 'p_author', p_author);

    l_banner := generate_banner (p_view_name     => c_view_name,
                                 p_author        => p_author,
                                 p_function_name => 'generate_union_view');

    select count(*)
    into l_view_count
    from all_views
    where view_name like gc_sert_view_prefix||'%';
    apex_debug.message(c_debug_template, 'l_view_count', l_view_count);

    with cols as (select column_name thecol
                  from all_tab_cols
                  where table_name like 'V_SVT_APEX_SERT_%'
                  and lower(column_name) not in ('checksum', 'link_cc','link_page','val') -- problem fields
                  and lower(column_name) not in ('collection_id') -- uninteresting fields
                  and column_name not like '%00%'
                  having count(*) = l_view_count
                  group by column_name)
    select listagg(lower(c.thecol), ', ') within group (order by c.thecol) stmt
    into l_select_stmt
    from cols c;

    l_select_stmt := gc_select||l_select_stmt;

    for myv in (
      select view_name
      from all_views
      where view_name like gc_sert_view_prefix||'%'
      order by view_name
    )
    loop
      l_counter := l_counter + 1;
      l_sql := l_sql||l_select_stmt||chr(10)
               ||apex_string.format(p_message => 'from %0 hh %1%2%3 %4',
               p0 => lower(myv.view_name),
               p1 => case when l_counter < l_view_count
                          then chr(10)
                          end,
               p2 => 'inner join v_eba_stds_applications esa on esa.apex_app_id  = hh.application_id'||chr(10)||q'[where hh.result = 'FAIL']'||chr(10),
               p3 => case when l_counter < l_view_count
                          then 'union all'
                          end,
               p4 => case when l_counter < l_view_count
                          then chr(10)
                          else gc_final_slash
                          end
               );
    end loop;

    return l_banner||c_create_stmt||l_sql;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end generate_union_view;


  procedure populate_SVT_sert_how_to_fix_md5
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'populate_SVT_sert_how_to_fix_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');

    -- merge into (select attribute_id, source_info_fix_md5
    --             from SVT_sert_how_to_fix 
    --             where src_id = 666) e
    -- using (
    --   select 666 src_id, attribute_id, apex_util.get_hash(apex_t_varchar2(fix, info)) md5
    --   from sv_sert_apex.sv_sec_attributes
    -- ) h
    -- on (e.attribute_id = h.attribute_id)
    -- when matched then
    --   update set e.source_info_fix_md5 = h.md5;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;    
  end populate_SVT_sert_how_to_fix_md5;


  procedure populate_eba_stds_standard_tests_w_sert_queries
  is 
  c_scope          constant varchar2(128)  := gc_scope_prefix || 'populate_eba_stds_standard_tests_w_sert_queries';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  c_standard_id          constant eba_stds_standard_tests.standard_id%type := eba_stds.get_standard_id ('APEX SERT');
  c_nt_type_id           constant eba_stds_standard_tests.nt_type_id%type := svt_standard_view.get_nt_type_id('v_SVT_sert__0_nt');
  c_db_supporting_object constant eba_stds_standard_tests.SVT_component_type_id%type := 0; --'DB_SUPPORTING_OBJECT';
  c_y                    constant eba_stds_standard_tests.active_yn%type := 'Y';
  begin
    apex_debug.message(c_debug_template,'START');

      for rec in (select SVT_apex_sert_util.generate_SVT_view (
                          p_collection_name    => collection_name,
                          p_select_stmt_only_yn => 'Y'
                        ) stmt,
                        upper(collection_name) collection_name,
                        attribute_name
                  from v_SVT_sert
                  where collection_name is not null
                  and SVT_apex_sert_util.generate_select_stmt (
                            p_collection_name => collection_name) is not null
                  order by collection_name)
      loop
        apex_debug.message(c_debug_template, 'rec.collection_name', rec.collection_name);
        begin <<eba_merge>>
          insert into eba_stds_standard_tests 
                (standard_id,
                 name,
                 SVT_component_type_id,
                 query_clob,
                 test_code,
                 active_yn,
                 nt_type_id)
          values(c_standard_id,
                 rec.attribute_name,
                 c_db_supporting_object_id,
                 rec.stmt,
                 rec.collection_name,
                 c_y,
                 c_nt_type_id);
        exception when dup_val_on_index then
          update eba_stds_standard_tests
          set query_clob = rec.stmt, nt_type_id  = c_nt_type_id
          where test_code = rec.collection_name;
        end eba_merge;
      end loop;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end populate_eba_stds_standard_tests_w_sert_queries;
  $end --oracle_apex_version.c_sert_access

end SVT_APEX_SERT_UTIL;
/

--rollback drop package SVT_APEX_SERT_UTIL;
