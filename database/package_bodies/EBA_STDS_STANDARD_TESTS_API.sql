--liquibase formatted sql
--changeset package_body_script:eba_stds_standard_tests_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body eba_stds_standard_tests_api as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   eba_stds_standard_tests_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';



    function insert_test(p_id                    in eba_stds_standard_tests.id%type default null,
                         p_standard_id           in eba_stds_standard_tests.standard_id%type,
                         p_test_type             in eba_stds_standard_tests.test_type%type,
                         p_test_name             in eba_stds_standard_tests.test_name%type,
                         p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                         p_query_clob            in eba_stds_standard_tests.query_clob%type,
                         p_owner                 in eba_stds_standard_tests.owner%type,
                         p_standard_code         in eba_stds_standard_tests.standard_code%type,
                         p_active_yn             in eba_stds_standard_tests.active_yn%type,
                         p_level_id              in eba_stds_standard_tests.level_id%type,
                         p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                         p_ast_component_type_id in eba_stds_standard_tests.ast_component_type_id%type,
                         p_explanation           in eba_stds_standard_tests.explanation%type,
                         p_fix                   in eba_stds_standard_tests.fix%type)
   return eba_stds_standard_tests.id%type 
   as 
   c_scope constant varchar2(128) := gc_scope_prefix || 'insert_test';
   c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

   l_id eba_stds_standard_tests.id%type := p_id;
   c_default_version_number constant number := 1;
   begin
    apex_debug.message(c_debug_template,'START', 'p_standard_code', p_standard_code);

    insert into eba_stds_standard_tests 
    (
      id,
      standard_id,
      test_type,
      test_name,
      display_sequence,
      query_clob,
      owner,
      standard_code,
      active_yn,
      level_id,
      mv_dependency,
      ast_component_type_id,
      version_number
    )
    values (
      p_id,
      p_standard_id,
      p_test_type,
      p_test_name,
      p_display_sequence,
      p_query_clob,
      p_owner,
      p_standard_code,
      p_active_yn,
      p_level_id,
      p_mv_dependency,
      p_ast_component_type_id,
      c_default_version_number
    ) returning id into l_id;

    return l_id;
   
   exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
   end insert_test;

   procedure insert_test(p_id                    in eba_stds_standard_tests.id%type default null,
                         p_standard_id           in eba_stds_standard_tests.standard_id%type,
                         p_test_type             in eba_stds_standard_tests.test_type%type,
                         p_test_name                  in eba_stds_standard_tests.test_name%type,
                         p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                         p_query_clob            in eba_stds_standard_tests.query_clob%type,
                         p_owner                 in eba_stds_standard_tests.owner%type,
                         p_standard_code         in eba_stds_standard_tests.standard_code%type,
                         p_active_yn             in eba_stds_standard_tests.active_yn%type,
                         p_level_id              in eba_stds_standard_tests.level_id%type,
                         p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                         p_ast_component_type_id in eba_stds_standard_tests.ast_component_type_id%type,
                         p_explanation           in eba_stds_standard_tests.explanation%type,
                         p_fix                   in eba_stds_standard_tests.fix%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_id eba_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_standard_id', p_standard_id,
                                        'p_test_type', p_test_type,
                                        'p_test_name', p_test_name,
                                        'p_display_sequence', p_display_sequence,
                                        'p_standard_code', p_standard_code,
                                        'p_active_yn', p_active_yn,
                                        'p_level_id', p_level_id,
                                        'p_mv_dependency', p_mv_dependency,
                                        'p_ast_component_type_id', p_ast_component_type_id
                                        );

    l_id := insert_test(p_id                    => p_id,
                        p_standard_id           => p_standard_id,
                        p_test_type             => p_test_type,
                        p_test_name             => p_test_name,
                        p_display_sequence      => p_display_sequence,
                        p_query_clob            => p_query_clob,
                        p_owner                 => p_owner,
                        p_standard_code         => p_standard_code,
                        p_active_yn             => p_active_yn,
                        p_level_id              => p_level_id,
                        p_mv_dependency         => p_mv_dependency,
                        p_ast_component_type_id => p_ast_component_type_id,
                        p_explanation           => p_explanation,
                        p_fix                   => p_fix
                        );

    apex_debug.message(c_debug_template, 'l_id', l_id);

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end insert_test;

    -- build md5 function for table eba_stds_standard_tests
    function build_test_md5 (
        p_id                    in eba_stds_standard_tests.id%type,
        p_standard_id           in eba_stds_standard_tests.standard_id%type,
        p_test_type             in eba_stds_standard_tests.test_type%type,
        p_test_name                  in eba_stds_standard_tests.test_name%type,
        p_query_clob            in eba_stds_standard_tests.query_clob%type,
        p_standard_code         in eba_stds_standard_tests.standard_code%type,
        p_active_yn             in eba_stds_standard_tests.active_yn%type,
        p_level_id              in eba_stds_standard_tests.level_id%type,
        p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
        p_ast_component_type_id in eba_stds_standard_tests.ast_component_type_id%type,
        p_explanation           in eba_stds_standard_tests.explanation%type,
        p_fix                   in eba_stds_standard_tests.fix%type
    ) return varchar2 is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'build_test_md5';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    begin
        apex_debug.message(c_debug_template,'build_test_md5', 'p_id', p_id);
        
        return apex_util.get_hash(apex_t_varchar2(
          p_id,
          p_standard_id,
          p_test_type,
          p_test_name,
          p_query_clob,
          p_standard_code,
          p_active_yn,
          p_level_id,
          p_mv_dependency,
          p_ast_component_type_id,
          p_explanation,
          p_fix ));
  
    end build_test_md5;
  
  procedure update_test(p_id                    in eba_stds_standard_tests.id%type default null,
                        p_standard_id           in eba_stds_standard_tests.standard_id%type,
                        p_test_type             in eba_stds_standard_tests.test_type%type,
                        p_test_name             in eba_stds_standard_tests.test_name%type,
                        p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                        p_query_clob            in eba_stds_standard_tests.query_clob%type,
                        p_owner                 in eba_stds_standard_tests.owner%type,
                        p_standard_code         in eba_stds_standard_tests.standard_code%type,
                        p_active_yn             in eba_stds_standard_tests.active_yn%type,
                        p_level_id              in eba_stds_standard_tests.level_id%type,
                        p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                        p_ast_component_type_id in eba_stds_standard_tests.ast_component_type_id%type,
                        p_explanation           in eba_stds_standard_tests.explanation%type,
                        p_fix                   in eba_stds_standard_tests.fix%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_id', p_id);
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end update_test;

  procedure delete_test(p_id in eba_stds_standard_tests.id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_id', p_id);
    
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end delete_test;

  function get_test_rec(p_standard_code in eba_stds_standard_tests.standard_code%type) 
  return eba_stds_standard_tests%rowtype
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_rec';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_standard_code constant eba_stds_standard_tests.standard_code%type := upper(p_standard_code);
  l_test_rec eba_stds_standard_tests%rowtype;
  begin
      apex_debug.message(c_debug_template,'START', 'p_standard_code', p_standard_code);

      select *
      into l_test_rec
      from eba_stds_standard_tests
      where standard_code = c_standard_code;

      return l_test_rec;
      
  exception
      when no_data_found then
          return null;
      when others then
          apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
          raise;
  end get_test_rec;

  procedure duplicate_standard (
                                    p_from_standard_code in eba_stds_standard_tests.standard_code%type,
                                    p_to_standard_code   in eba_stds_standard_tests.standard_code%type
                                )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'duplicate_standard';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_test_rec eba_stds_standard_tests%rowtype;
  c_new_standard_code constant eba_stds_standard_tests.standard_code%type := upper(p_to_standard_code);
  l_new_test_id eba_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_from_standard_code', p_from_standard_code,
                                        'p_to_standard_code', p_to_standard_code);

    l_test_rec := get_test_rec(p_standard_code => p_from_standard_code);

    insert into eba_stds_standard_tests
    (
      standard_id,
      test_type,
      test_name,
      query_clob,
      owner,
      standard_code,
      active_yn,
      level_id,
      mv_dependency,
      ast_component_type_id
    )
    values 
    (
      l_test_rec.standard_id,
      l_test_rec.test_type,
      l_test_rec.test_name||' [COPY]',
      l_test_rec.query_clob,
      l_test_rec.owner,
      c_new_standard_code,
      'N',
      l_test_rec.level_id,
      l_test_rec.mv_dependency,
      l_test_rec.ast_component_type_id
    ) returning id into l_new_test_id;

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end duplicate_standard;

  function get_test_id (p_standard_code in eba_stds_standard_tests.standard_code%type)
  return eba_stds_standard_tests.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_standard_code constant eba_stds_standard_tests.standard_code%type := upper(replace(p_standard_code, ' ', '_'));
  l_id eba_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_code', p_standard_code);
    
    select id
    into l_id
    from eba_stds_standard_tests
    where standard_code = c_standard_code;
    
    return l_id;
  
  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_test_id;


  function v_eba_stds_standard_tests
  return v_eba_stds_standard_tests_nt pipelined
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_eba_stds_standard_tests';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 

  cursor cur_aa 
  is 
  select standard_id,
         test_id,
         urgency, 
         urgency_level,
         test_name,
         standard_code,
         test_type,
         standard_category_name,
         active_yn,
         nt_name,
         query_clob,
         std_creation_date,
         mv_dependency,
         ast_component_type_id,
         component_name,
         standard_active_yn,
         explanation,
         fix,
         version_number
  from v_eba_stds_standard_tests;

  type r_aa is record (
    standard_id             number,
    test_id                 number,
    urgency                 varchar2(255),
    urgency_level           number,
    test_name               varchar2(64),
    standard_code           varchar2(100),
    test_type               varchar2(16),
    standard_category_name  varchar2(64),
    active_yn               varchar2(1),
    nt_name                 varchar2(255 char),
    query_clob              clob,
    std_creation_date       timestamp(6) with local time zone,
    mv_dependency           varchar2(100),
    ast_component_type_id   number,
    component_name          varchar2(50),
    standard_active_yn      varchar2(1),
    explanation             varchar2(4000 char),
    fix                     clob,
    version_number          number
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
        <<load_block>>
        declare
        c_file_blob constant blob := ast_deployment.json_content_blob (p_table_name => 'EBA_STDS_STANDARD_TESTS',
                                                                       p_standard_code => l_aat (rec).standard_code);
        c_file_size constant pls_integer := sys.dbms_lob.getlength(c_file_blob);
        c_mime_type constant varchar2(25) := 'application/json';
        c_character_set constant varchar2(10) := 'UTF-8';
        begin
        pipe row (v_eba_stds_standard_tests_ot (
                      l_aat (rec).standard_id,
                      l_aat (rec).test_id,
                      l_aat (rec).urgency, 
                      l_aat (rec).urgency_level,
                      l_aat (rec).test_name,
                      l_aat (rec).standard_code,
                      l_aat (rec).test_type,
                      l_aat (rec).standard_category_name,
                      l_aat (rec).active_yn,
                      l_aat (rec).nt_name,
                      l_aat (rec).query_clob,
                      l_aat (rec).std_creation_date,
                      l_aat (rec).mv_dependency,
                      l_aat (rec).ast_component_type_id,
                      l_aat (rec).component_name,
                      l_aat (rec).standard_active_yn,
                      l_aat (rec).explanation,
                      l_aat (rec).fix,
                      c_file_size,  --DOWNLOAD
                      c_file_blob,
                      c_mime_type,
                      apex_string.format('%s.json',upper(l_aat (rec).standard_code)), --FILE_NAME
                      c_character_set,
                      l_aat (rec).version_number
                    )
                );
          end load_block;
      end loop;
    end loop;  

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end v_eba_stds_standard_tests;

end eba_stds_standard_tests_api;
/
--rollback drop package body eba_stds_standard_tests_api;