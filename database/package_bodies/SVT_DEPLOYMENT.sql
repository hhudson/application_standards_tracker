--liquibase formatted sql
--changeset package_body_script:SVT_DEPLOYMENT_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_DEPLOYMENT as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_DEPLOYMENT
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_y constant varchar2(1) := 'Y';
  gc_n constant varchar2(1) := 'N';
  gc_blob constant varchar2(4) := 'blob';
  gc_clob constant varchar2(4) := 'clob';

  function assemble_json_query (
                p_table_name    in user_tables.table_name%type,
                p_row_limit     in number default null,
                p_test_code     in svt_stds_standard_tests.test_code%type default null,
                p_standard_id   in svt_stds_standards.id%type default null,
                p_datatype      in varchar2 default 'blob')
  return clob 
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assemble_json_query';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_table_name constant varchar2(500)
              := case when upper(p_table_name) = 'SVT_STDS_STANDARD_TESTS'
                      then 'V_SVT_STDS_STANDARD_TESTS'
                      when upper(p_table_name) = 'V_SVT_STDS_STANDARD_TESTS_EXPORT'
                      then apex_string.format(
                              q'[svt_stds_standard_tests_api.v_svt_stds_standard_tests(%0p_published_yn => 'Y', p_active_yn => 'Y')]',
                              p0 => case when p_standard_id is not null 
                                         then 'p_standard_id => '||p_standard_id||', '
                                         end
                        )
                      else upper(p_table_name)
                      end;
  c_query_template constant varchar2(1000) := 
  'select json_arrayagg(json_object (jn.* returning %6) returning %6)
   from (select %7asrc.* %4
        from   except_cols (  
          %0,  
          columns ( %1 )  
        ) asrc
        %3
        %2) jn';
  c_test_code constant svt_stds_standard_tests.test_code%type := upper(p_test_code);
  l_query clob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name,
                                        'p_row_limit', p_row_limit,
                                        'p_test_code', p_test_code,
                                        'p_standard_id', p_standard_id);

    l_query := apex_string.format(
      p_message =>   c_query_template,
      p0 => c_table_name,
      p1 =>  'avg_execution_seconds, date_started, row_version_number, account_locked, '
           ||'download, file_blob, mime_type, file_name, character_set, record_md5, estl_md5, '
           ||'publish_button_html, dlclss, publish_clss, publish_text, vsn, imported_version_number, '
           ||'standard_active_yn, urgency, std_creation_date, owner, '
          --  ||'updated, updated_by '
          --  ||' urgency_level, display_sequence, ' --need to export for SVT_STANDARDS_URGENCY_LEVEL
           ||' full_standard_name'
           || case when c_table_name = 'V_SVT_STDS_STANDARD_TESTS' and p_standard_id is not null
                   then ', standard_id'
                   end,
      p2 => case when p_row_limit is not null
                 then 'fetch first '||p_row_limit||' rows only'
                 end,
      p3 => case when c_table_name = 'V_SVT_STDS_STANDARD_TESTS' and c_test_code is not null
                 then apex_string.format(q'[where test_code = '%s']', c_test_code)
                 when c_table_name = 'SVT_STDS_STANDARDS' and p_standard_id is not null
                 then apex_string.format(q'[where id = '%s']', p_standard_id)
                 when c_table_name = 'SVT_STDS_STANDARDS' and p_standard_id is null
                 then q'[where active_yn = 'Y']'
                 end,
      p4 => case when c_table_name in ('V_SVT_STDS_STANDARD_TESTS','V_SVT_STDS_STANDARD_TESTS_EXPORT')
                 then apex_string.format(q'[, '%s' workspace]', svt_preferences.get('SVT_WORKSPACE'))
                 end,
      p6 => p_datatype,
      p7 => case when c_table_name = 'V_SVT_STDS_STANDARD_TESTS' and p_standard_id is not null
                 then p_standard_id||' standard_id, '
                 end
    );
    
    return l_query;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end assemble_json_query;
  
  function assemble_json_tsts_qry (
                  p_standard_id   in svt_stds_standards.id%type default null,
                  p_test_code     in svt_stds_standard_tests.test_code%type default null,
                  p_datatype      in varchar2 default 'blob')
  return clob 
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'assemble_json_tsts_qry';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_query clob;
  c_datatype constant varchar2(4) := case when lower(p_datatype) = gc_blob
                                          then gc_blob
                                          else gc_clob
                                          end;
  c_standard_id constant svt_stds_standards.id%type
               := case when p_test_code is null 
                       then p_standard_id
                       else svt_stds_standard_tests_api.get_standard_id (p_test_code => p_test_code)
                       end;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'c_standard_id', c_standard_id,
                                        'p_test_code', p_test_code,
                                        'p_datatype', p_datatype);
   
   l_query := 
    apex_string.format(
    q'[
      with std as (
        select  json_object ( 
            'standard' value json_arrayagg (
              json_object (
                'standard_id'           value ess.id, 
                'standard_name'         value ess.standard_name,
                'description'           value ess.description,
                'compatibility_mode_id' value ess.compatibility_mode_id,
                'created'               value ess.created,
                'created_by'            value ess.created_by,
                'updated'               value ess.created,
                'updated_by'            value ess.created_by
                returning %1
              )  
              returning %1
            )
            returning %1
            ) thejson
        from svt_stds_standards ess
        where ess.active_yn = 'Y'
        %4
      ), tst as (
        select  json_object ( 
          'test' value json_arrayagg (
            json_object (
              'test_id'               value esst.test_id, 
              'test_name'             value esst.test_name,
              'standard_id'           value esst.standard_id,
              'display_sequence'      value esst.display_sequence,
              'query_clob'            value esst.query_clob,
              'test_code'             value esst.test_code,
              'level_id'              value esst.level_id,
              'mv_dependency'         value esst.mv_dependency,
              'svt_component_type_id' value esst.svt_component_type_id,
              'explanation'           value esst.explanation,
              'fix'                   value esst.fix,
              'version_number'        value esst.version_number,
              'version_db'            value esst.version_db
              returning %1
            )  
            returning %1
          )
          returning %1
          ) thejson
      from svt_stds_standards ess
      inner join v_svt_stds_standard_tests_w_inherited esst on ess.id = esst.standard_id
      where ess.active_yn = 'Y'
      and esst.active_yn = 'Y'
      %4
      and (esst.test_code = '%2' or '%2' is null)
      )
      select json_mergepatch(std.thejson, tst.thejson returning %1 %3) mjson
      from tst
      cross join std
    ]',
    p0 => c_standard_id,
    p1 => c_datatype,
    p2 => p_test_code,
    p3 => case when c_datatype = gc_clob
               then 'pretty'
               end,
    p4 => case when c_standard_id is not null
               then 'and ess.id = '||c_standard_id
               end
    );

    return l_query;
    
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end assemble_json_tsts_qry;

  function json_standard_tests_clob (
                  p_standard_id in svt_stds_standards.id%type default null,
                  p_test_code   in svt_stds_standard_tests.test_code%type default null
   ) return clob
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_standard_tests_clob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_tst_query     clob;
  l_tst_file_clob clob;
  c_test_code constant svt_stds_standard_tests.test_code%type := dbms_assert.noop(upper(p_test_code));
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_test_code', p_test_code
                                        );

    l_tst_query := assemble_json_tsts_qry (
                    p_standard_id   => p_standard_id,
                    p_test_code     => c_test_code,
                    p_datatype      => gc_clob);

    execute immediate l_tst_query into l_tst_file_clob;
    
    return l_tst_file_clob;

   exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end json_standard_tests_clob;
  
  function json_standard_tests_blob (
                  p_standard_id in svt_stds_standards.id%type default null,
                  p_test_code   in svt_stds_standard_tests.test_code%type default null
  ) return blob
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_standard_tests_blob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant svt_stds_standard_tests.test_code%type := dbms_assert.noop(upper(p_test_code));
  l_query     clob;
  l_file_blob blob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_test_code', p_test_code
                                        );

    l_query := assemble_json_tsts_qry (
                    p_standard_id   => p_standard_id,
                    p_test_code     => c_test_code,
                    p_datatype      => gc_blob);

    execute immediate l_query into l_file_blob;

    return l_file_blob;

  exception 
    when no_data_found then
      apex_debug.message(c_debug_template,' no data found');
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end json_standard_tests_blob;

  function json_content_blob (p_table_name    in user_tables.table_name%type,
                              p_row_limit     in number default null,
                              p_test_code     in svt_stds_standard_tests.test_code%type default null,
                              p_standard_id   in svt_stds_standards.id%type default null,
                              p_zip_yn        in varchar2 default null)
  return blob
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_content_blob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_table_name constant user_tables.table_name%type 
              := dbms_assert.sql_object_name (upper(p_table_name));
  l_query     clob;
  l_file_blob blob;
  c_zip_yn    constant varchar2(1) := case when upper(p_zip_yn) = gc_y
                               then gc_y
                               else gc_n
                               end;
  l_zip_file blob;
  l_final_blob blob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name,
                                        'p_row_limit', p_row_limit,
                                        'p_test_code', p_test_code,
                                        'p_standard_id', p_standard_id,
                                        'p_zip_yn', p_zip_yn);

    l_query := assemble_json_query (
                    p_table_name    => c_table_name,
                    p_row_limit     => p_row_limit,
                    p_test_code     => p_test_code,
                    p_standard_id   => p_standard_id,
                    p_datatype      => gc_blob);

    execute immediate l_query into l_file_blob;

    if c_zip_yn = gc_y then
      apex_zip.add_file (
              p_zipped_blob => l_zip_file,
              p_file_name   => 'hayden',
              p_content     => l_file_blob );
      l_final_blob := l_zip_file;
    else 
      l_final_blob := l_file_blob;
    end if;

    return l_final_blob;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end json_content_blob;

  function json_content_clob (p_table_name    in user_tables.table_name%type,
                              p_row_limit     in number default null,
                              p_test_code     in svt_stds_standard_tests.test_code%type default null,
                              p_standard_id   in svt_stds_standards.id%type default null)
  return clob
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_content_clob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_table_name constant user_tables.table_name%type 
              := dbms_assert.sql_object_name (upper(p_table_name));
  l_query     clob;
  l_file_clob clob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name,
                                        'p_row_limit', p_row_limit,
                                        'p_test_code', p_test_code,
                                        'p_standard_id', p_standard_id);

    l_query := assemble_json_query (
                    p_table_name    => c_table_name,
                    p_row_limit     => p_row_limit,
                    p_test_code     => p_test_code,
                    p_standard_id   => p_standard_id,
                    p_datatype      => gc_clob);

    execute immediate l_query into l_file_clob;

    return l_file_clob;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end json_content_clob;

  function sample_template_file (p_table_name in user_tables.table_name%type)
  return blob
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'sample_template_file'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_table_name', p_table_name);

    return json_content_blob (p_table_name => p_table_name,
                              p_row_limit => 5);

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end sample_template_file;

  procedure upsert_static_file(p_table_name in user_tables.table_name%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'upsert_static_file';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_zip_file blob;
  c_base_file_name constant user_tables.table_name%type := lower(p_table_name);
  c_json_file_name constant user_tables.table_name%type := c_base_file_name||'.json';
  c_zip_file_name  constant user_tables.table_name%type := 'data/'||c_base_file_name||'.zip';
  l_content_blob blob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name);

    l_content_blob := json_content_blob (p_table_name => p_table_name);
    
    apex_zip.add_file (
            p_zipped_blob => l_zip_file,
            p_file_name   => c_json_file_name,
            p_content     => l_content_blob );

    apex_zip.finish (
        p_zipped_blob => l_zip_file );
    
    wwv_flow_imp_shared.create_app_static_file (
       p_flow_id      => svt_apex_view.gc_svt_app_id,
       p_file_name    => c_zip_file_name,
       p_mime_type    => 'application/zip',
       p_file_charset =>' utf-8',
       p_file_content => l_zip_file
    );

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end upsert_static_file;

  procedure merge_from_zip (p_table_name in user_tables.table_name%type)
  as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'merge_from_zip';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_table_name constant user_tables.table_name%type := upper(p_table_name);
    l_content_blob blob;
    l_static_id apex_appl_data_loads.static_id%type;
    l_content_clob clob;
    l_load_result apex_data_loading.t_data_load_result;
  begin
    apex_debug.message(c_debug_template,'START');

    select apex_zip.get_file_content (
                    p_zipped_blob => aasf.file_content,
                    p_file_name   => lower(aadl.table_name)||'.json'
            ) thejson, aadl.static_id
    into l_content_blob, l_static_id
    from apex_appl_data_loads aadl
    inner join apex_application_static_files aasf on aasf.file_name = 'data/'||lower(aadl.table_name)||'.zip'
    where aadl.application_id = v('APP_ID')
    and aadl.table_name = c_table_name;

    l_content_clob := to_clob(utl_raw.cast_to_varchar2(dbms_lob.substr(l_content_blob,dbms_lob.getlength(l_content_blob)))); 
    
    -- 
    l_load_result := apex_data_loading.load_data (
                       p_static_id    => l_static_id,
                       p_data_to_load => l_content_clob );

    apex_debug.message(c_debug_template, 'Processed ' || l_load_result.processed_rows || ' rows.');

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end merge_from_zip;


  function table_last_updated_on (p_table_name in user_tables.table_name%type) return apex_application_static_files.created_on%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'table_last_updated_on';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  l_most_recent_date apex_application_static_files.created_on%type;
  c_query_template constant varchar2(1000) := 'select updated from %s order by updated desc fetch first 1 rows only';
  c_table_name constant user_tables.table_name%type 
              := dbms_assert.sql_object_name (upper(p_table_name));
  begin
    apex_debug.message(c_debug_template,'START', 'p_table_name', p_table_name);

    execute immediate apex_string.format(c_query_template, c_table_name) into l_most_recent_date;
    
    return l_most_recent_date;

  exception 
    when no_data_found then 
      apex_debug.message(c_debug_template, 'no data found for table : ', p_table_name);
      return null;
    when e_missing_field then
      apex_debug.message(c_debug_template, 'error for table : ', p_table_name);
      return null;
    when e_non_existent_tbl then
      apex_debug.message(c_debug_template, 'non-existent table : ', p_table_name);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end table_last_updated_on;

  function v_svt_table_data_load_def (p_application_id in apex_applications.application_id%type)
  return v_svt_table_data_load_def_nt pipelined
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_svt_table_data_load_def';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  
  cursor cur_aa
    is
  with std as (
    select ut.table_name, 
           'application/json' mime_type,
           apex_string.format('%s.json', lower(ut.table_name)) file_name,
           'UTF-8' character_set
    from user_tables ut
    where ut.table_name not like 'DATABASECHANGELOG%'
    and ut.table_name not like 'DEV%'
    and ut.table_name not like 'MV%'
    and ut.table_name not in ('SVT_STDS_STANDARD_TESTS','SVT_STDS_TESTS_LIB')
  )
    select std.table_name, 
          std.mime_type,
          std.file_name,
          aasf.file_name static_file_name,
          std.character_set,
          aadl.name data_load_definition_name,
          aasf.file_name static_application_file_name,
          case when aasf.file_name is not null 
                and aadl.name is not null
                then '<span aria-hidden="true" class="t-Icon fa fa-search-plus"></span>'
                end inspect_static_file_icon,
          aap.page_id,
          case when aap.page_id is not null
                then '<span aria-hidden="true" class="t-Icon fa fa-map-marker-o"></span>'
                end page_id_icon,
          aasf.application_file_id,
          aasf.file_content zip_blob,
          aasf.mime_type zip_mime_type, 
          aasf.file_charset zip_charset, 
          aasf.last_updated_on zip_updated_on,
          aasf.created_on static_file_created_on
    from std
    left outer join apex_appl_data_loads aadl on aadl.table_name = std.table_name
                                              and aadl.application_id = p_application_id
                                              and aadl.static_id = lower(std.table_name)
    left outer join apex_application_static_files aasf on  aasf.application_id = p_application_id
                                                      and aasf.file_name like 'data/%'
                                                      and aasf.file_name = 'data/'||lower(std.table_name)||'.zip'
    left outer join apex_application_pages aap on aap.application_id = p_application_id
                                              and aap.page_comment = std.table_name;

    type r_aa is record (
      table_name                   varchar2(128),
      mime_type                    char(16),
      file_name                    varchar2(4000), 
      static_file_name             varchar2(255),  
      character_set                char(5),        
      data_load_definition_name    varchar2(255),  
      static_application_file_name varchar2(255),  
      inspect_static_file_icon     char(65),       
      page_id                      number,
      page_id_icon                 char(66),       
      application_file_id          number,
      zip_blob                     blob,
      zip_mime_type                varchar2(255),  
      zip_charset                  varchar2(128),  
      zip_updated_on               date,
      static_file_created_on       date
    );
    type t_aa is table of r_aa index by pls_integer;
    l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START', 'p_application_id', p_application_id);

    open cur_aa;

    loop
      fetch cur_aa bulk collect into l_aat limit 1000;

      exit when l_aat.count = 0;

      for rec in 1 .. l_aat.count
      loop
        <<load_block>>
        declare
        c_overwrite_table_name constant varchar2(255) := l_aat (rec).table_name;
              -- := case when l_aat (rec).table_name = 'SVT_STDS_TESTS_LIB'
              --         then 'SVT_STDS_STANDARD_TESTS'
              --         else l_aat (rec).table_name
              --         end;
        c_file_blob constant blob := sample_template_file (p_table_name => l_aat (rec).table_name);
        c_file_size constant pls_integer := sys.dbms_lob.getlength(c_file_blob);
        c_zip_size  constant pls_integer := sys.dbms_lob.getlength(l_aat (rec).zip_blob);
        c_table_last_updated_on constant date := svt_deployment.table_last_updated_on(c_overwrite_table_name);
        begin
        pipe row (v_svt_table_data_load_def_ot (
                      c_overwrite_table_name,
                      l_aat (rec).table_name,
                      c_file_blob, --file_blob
                      l_aat (rec).mime_type,
                      l_aat (rec).file_name,
                      l_aat (rec).static_file_name,
                      l_aat (rec).character_set,
                      c_file_size, -- file_size
                      c_file_size, -- download
                      l_aat (rec).data_load_definition_name,
                      l_aat (rec).static_application_file_name,
                      l_aat (rec).inspect_static_file_icon,
                      l_aat (rec).page_id,
                      l_aat (rec).page_id_icon,
                      l_aat (rec).application_file_id,
                      l_aat (rec).zip_blob,
                      c_zip_size, --zip_file_size
                      c_zip_size, --zip_download
                      l_aat (rec).zip_mime_type,
                      l_aat (rec).zip_charset,
                      l_aat (rec).zip_updated_on,
                      c_table_last_updated_on,
                      l_aat (rec).static_file_created_on,
                      case when c_table_last_updated_on is not null 
                           and l_aat (rec).zip_updated_on is not null
                           then case when c_table_last_updated_on > l_aat (rec).zip_updated_on
                                     then gc_y
                                     else gc_n
                                     end
                           else gc_n
                           end --stale_yn
                    )
                );
          end load_block;
      end loop;
    end loop;  
  
  exception 
    when no_data_needed then
      apex_debug.message(c_debug_template, 'No data needed');
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt_table_data_load_def;

  function markdown_summary return clob
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'markdown_summary';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_md_clob clob;
  c_intro constant clob :=
  '# Standards and Tests available for download and import'
  ||chr(10)
  ||chr(10);
  c_summary constant clob :=
  '## Summary and instructions' 
  ||chr(10)
  || apex_string.format(q'[This page lists %0 published tests distributed across %1 standards (*%2*) and %3 issue categories (*%4*).]',
                          p0 => svt_stds_standard_tests_api.active_test_count,
                          p1 => svt_stds_standards_api.active_standard_count,
                          p2 => svt_stds_standards_api.active_standard_list,
                          p3 => svt_nested_table_types_api.nt_count,
                          p4 => svt_nested_table_types_api.nt_list)                
  ||' Download either the "consolidated test exports" or the individual tests for import into your Standard Violation Tracker instance.'
  ||chr(10)
  ||chr(10);
  c_headers_md constant clob := chr(10)||
   '| Test Code | Test Name | Version* | Component Type |'||
   chr(10)||
   '|-----------|-----------|---------|----------------|'||
   chr(10);
  c_addendum constant clob :=
  chr(10)
  ||'* Test versions are idenfied by an incrementing number and the name of the database on which they were developed.'
  ||' The addition of the database name allows us to distinguish between tests that have been imported and untouched and ones that have been modified locally after import.';
  begin
    apex_debug.message(c_debug_template,'START');

    l_md_clob := c_intro || c_summary;

    for srec in (select id, standard_name, svt_stds.file_name(full_standard_name) file_name, description, compatibility_text
                 from v_svt_stds_standards
                 where active_yn = gc_y
                 order by standard_name, display_order)
    loop 
      apex_debug.message(c_debug_template, 'file_name', srec.file_name);
      
      l_md_clob := l_md_clob
                   ||apex_string.format(
                      '## %0 (%2)',
                      p0 => srec.standard_name,
                      p2 => srec.compatibility_text)
                   ||chr(10)
                   ||srec.description
                   ||chr(10)
                   ||chr(10);
      l_md_clob := l_md_clob
                   ||apex_string.format(
                      ' - [Consolidated tests export for %0](%1/ALL_TESTS-%1.json)',
                      p0 => srec.standard_name,
                      p1 => srec.file_name,
                      p2 => srec.compatibility_text)
                   ||chr(10)
                   ||c_headers_md;
      <<test_sec>>
      declare
      l_test_md clob;
      begin
        
        for trec in (select test_code, test_name, vsn, component_name, file_name, version_db
                      from svt_stds_standard_tests_api.v_svt_stds_standard_tests(
                          p_standard_id => srec.id,
                          p_active_yn => gc_y,
                          p_standard_active_yn => gc_y,
                          p_published_yn => gc_y
                      ) order by test_code
                    )
        loop 
          apex_debug.message(c_debug_template, 'test_code', trec.test_code);
          l_test_md := l_test_md
          ||apex_string.format(
            '| [%1](%3/tests/%0) |  %4 | %2 [%6] | %5 |',
            p0 => trec.file_name,
            p1 => trec.test_code,
            p2 => trec.vsn,
            p3 => srec.file_name,
            p4 => trec.test_name,
            p5 => trec.component_name,
            p6 => trec.version_db
            )
          ||chr(10);
        end loop;

        l_md_clob := l_md_clob || l_test_md || chr(10);

      end test_sec;

    end loop;

      l_md_clob := l_md_clob || c_addendum;

    return l_md_clob;
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end markdown_summary;

  

end SVT_DEPLOYMENT;
/
--rollback drop package body SVT_DEPLOYMENT;