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
  gc_app_id constant apex_applications.application_id%type := 17000033;

  function exclude_id_yn (p_table_name in user_tables.table_name%type)
  return varchar2 deterministic
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'exclude_id_yn';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_table_name constant user_tables.table_name%type := upper(p_table_name);
  l_exclude_id_yn varchar2(1) := 'N';
  begin
    apex_debug.message(c_debug_template,'START', 'p_table_name', p_table_name);
    
    -- select case when count(*) = 1
    --             then 'N'
    --             else 'Y'
    --             end into l_exclude_id_yn
    -- from sys.dual where exists (
    --    select ucp.table_name, ucp.constraint_name pk_constraint, ucr.constraint_name fk_constraint_name
    --     from user_constraints ucp
    --     inner join user_constraints ucr on ucr.r_constraint_name = ucp.constraint_name
    --     where ucp.table_name = c_table_name
    --     and ucp.constraint_type = 'P'
    -- );
    
    return l_exclude_id_yn;
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end exclude_id_yn;

  function json_content_blob (p_table_name    in user_tables.table_name%type,
                              p_row_limit     in number default null,
                              p_standard_code in eba_stds_standard_tests.standard_code%type default null,
                              p_standard_id   in eba_stds_standards.id%type default null)
  return blob
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'json_content_blob';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_table_name constant user_tables.table_name%type := upper(p_table_name);
  c_exclude_id_yn varchar2(1) := exclude_id_yn (p_table_name => c_table_name);
  c_query_template constant varchar2(1000) := 
  'select json_arrayagg(json_object (jn.* returning clob) returning blob)
   from (select asrc.* %4
        from   except_cols (  
          %0,  
          columns ( %1 )  
        ) asrc
        %3%5
        %2) jn';
  c_standard_code constant eba_stds_standard_tests.standard_code%type := upper(p_standard_code);
  l_query clob;
  l_file_blob blob;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_table_name', p_table_name,
                                        'p_row_limit', p_row_limit,
                                        'p_standard_code', p_standard_code,
                                        'p_standard_id', p_standard_id);
    

    l_query := apex_string.format(
      p_message =>   c_query_template,
      p0 => c_table_name,
      p1 => case when c_exclude_id_yn = 'Y'
                 then 'id, '
                 end||'created, created_by, updated, updated_by, date_started, row_version_number, account_locked',
      p2 => case when p_row_limit is not null
                 then 'fetch first '||p_row_limit||' rows only'
                 end,
      p3 => case when c_table_name = 'EBA_STDS_STANDARD_TESTS' and c_standard_code is not null
                 then apex_string.format(q'[where standard_code = '%s']', c_standard_code)
                 end,
      p4 => case when c_table_name = 'EBA_STDS_STANDARD_TESTS'
                 then apex_string.format(q'[, '%s' workspace]', svt_preferences.get_preference ('SVT_DEFAULT_WORKSPACE'))
                 end,
      p5 => case when c_table_name = 'EBA_STDS_STANDARD_TESTS' and p_standard_id is not null
                 then apex_string.format(q'[where standard_id = %s and active_yn = 'Y']', p_standard_id)
                 end
    );

    execute immediate l_query into l_file_blob;

    return l_file_blob;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end json_content_blob;

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

    if c_base_file_name = 'eba_stds_tests_lib' then
      eba_stds_tests_lib_api.take_snapshot;
    end if;

    l_content_blob := json_content_blob (p_table_name => p_table_name);
    
    apex_zip.add_file (
            p_zipped_blob => l_zip_file,
            p_file_name   => c_json_file_name,
            p_content     => l_content_blob );

    apex_zip.finish (
        p_zipped_blob => l_zip_file );
    
    wwv_flow_imp_shared.create_app_static_file (
       p_flow_id      => GC_APP_ID,
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
    -- l_content_clob := '[{"id":8,"action_name":"blerg","include_in_report_yn":"N"},{"id":2,"action_name":"Ignore - valid exception","include_in_report_yn":"N"},{"id":3,"action_name":"To be corrected","include_in_report_yn":"Y"},{"id":4,"action_name":"Old - but should be corrected","include_in_report_yn":"Y"},{"id":5,"action_name":"Fixed","include_in_report_yn":"N"}]';
    
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
  c_query_template varchar2(1000) := 'select updated from %s order by updated desc fetch first 1 rows only';
  begin
    apex_debug.message(c_debug_template,'START', 'p_table_name', p_table_name);

    execute immediate apex_string.format(c_query_template, p_table_name) into l_most_recent_date;
    
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
    and ut.table_name not in ('EBA_STDS_STANDARD_TESTS','EBA_STDS_TESTS_LIB')
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
                                              and aap.page_name = std.table_name;

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
              -- := case when l_aat (rec).table_name = 'EBA_STDS_TESTS_LIB'
              --         then 'EBA_STDS_STANDARD_TESTS'
              --         else l_aat (rec).table_name
              --         end;
        c_file_blob constant blob := svt_deployment.sample_template_file (p_table_name => l_aat (rec).table_name);
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
                                     then 'Y'
                                     else 'N'
                                     end
                           else 'N'
                           end --stale_yn
                    )
                );
          end load_block;
      end loop;
    end loop;  
  
  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end v_svt_table_data_load_def;

  

end SVT_DEPLOYMENT;
/
--rollback drop package body SVT_DEPLOYMENT;