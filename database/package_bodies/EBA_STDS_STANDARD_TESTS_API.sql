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
  gc_n constant varchar2(1) := 'N';
  gc_y constant varchar2(1) := 'Y';



    function insert_test(p_id                    in eba_stds_standard_tests.id%type default null,
                         p_standard_id           in eba_stds_standard_tests.standard_id%type,
                         p_test_name             in eba_stds_standard_tests.test_name%type,
                         p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                         p_query_clob            in eba_stds_standard_tests.query_clob%type,
                         p_owner                 in eba_stds_standard_tests.owner%type,
                         p_test_code             in eba_stds_standard_tests.test_code%type,
                         p_active_yn             in eba_stds_standard_tests.active_yn%type,
                         p_level_id              in eba_stds_standard_tests.level_id%type,
                         p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                         p_svt_component_type_id in eba_stds_standard_tests.svt_component_type_id%type,
                         p_explanation           in eba_stds_standard_tests.explanation%type,
                         p_fix                   in eba_stds_standard_tests.fix%type,
                         p_version_number        in eba_stds_standard_tests.version_number%type default null)
   return eba_stds_standard_tests.id%type 
   as 
   c_scope constant varchar2(128) := gc_scope_prefix || 'insert_test';
   c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

   l_id eba_stds_standard_tests.id%type := p_id;
   c_default_version_number constant number := 0;
   begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    insert into eba_stds_standard_tests 
    (
      id,
      standard_id,
      test_name,
      display_sequence,
      query_clob,
      owner,
      test_code,
      active_yn,
      level_id,
      mv_dependency,
      SVT_component_type_id,
      explanation,
      fix,
      version_number
    )
    values (
      p_id,
      p_standard_id,
      p_test_name,
      p_display_sequence,
      p_query_clob,
      p_owner,
      p_test_code,
      p_active_yn,
      p_level_id,
      p_mv_dependency,
      p_svt_component_type_id,
      p_explanation,
      p_fix,
      coalesce(p_version_number,c_default_version_number)
    ) returning id into l_id;

    return l_id;
   
   exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
   end insert_test;

   procedure insert_test(p_id                    in eba_stds_standard_tests.id%type default null,
                         p_standard_id           in eba_stds_standard_tests.standard_id%type,
                         p_test_name             in eba_stds_standard_tests.test_name%type,
                         p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                         p_query_clob            in eba_stds_standard_tests.query_clob%type,
                         p_owner                 in eba_stds_standard_tests.owner%type,
                         p_test_code             in eba_stds_standard_tests.test_code%type,
                         p_active_yn             in eba_stds_standard_tests.active_yn%type,
                         p_level_id              in eba_stds_standard_tests.level_id%type,
                         p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                         p_svt_component_type_id in eba_stds_standard_tests.SVT_component_type_id%type,
                         p_explanation           in eba_stds_standard_tests.explanation%type,
                         p_fix                   in eba_stds_standard_tests.fix%type,
                         p_version_number        in eba_stds_standard_tests.version_number%type default null)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_id eba_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_standard_id', p_standard_id,
                                        'p_test_name', p_test_name,
                                        'p_display_sequence', p_display_sequence,
                                        'p_test_code', p_test_code,
                                        'p_active_yn', p_active_yn,
                                        'p_level_id', p_level_id,
                                        'p_mv_dependency', p_mv_dependency,
                                        'p_svt_component_type_id', p_svt_component_type_id
                                        );

    l_id := insert_test(p_id                    => p_id,
                        p_standard_id           => p_standard_id,
                        p_test_name             => p_test_name,
                        p_display_sequence      => p_display_sequence,
                        p_query_clob            => p_query_clob,
                        p_owner                 => p_owner,
                        p_test_code             => p_test_code,
                        p_active_yn             => p_active_yn,
                        p_level_id              => p_level_id,
                        p_mv_dependency         => p_mv_dependency,
                        p_svt_component_type_id => p_svt_component_type_id,
                        p_explanation           => p_explanation,
                        p_fix                   => p_fix,
                        p_version_number        => p_version_number
                        );

    apex_debug.message(c_debug_template, 'l_id', l_id);

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end insert_test;

  -- build md5 function for table eba_stds_standard_tests
  function build_test_md5 (
      p_standard_id           in eba_stds_standard_tests.standard_id%type,
      p_test_name             in eba_stds_standard_tests.test_name%type,
      p_query_clob            in eba_stds_standard_tests.query_clob%type,
      p_test_code             in eba_stds_standard_tests.test_code%type,
      p_active_yn             in eba_stds_standard_tests.active_yn%type,
      p_level_id              in eba_stds_standard_tests.level_id%type,
      p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
      p_svt_component_type_id in eba_stds_standard_tests.SVT_component_type_id%type,
      p_explanation           in eba_stds_standard_tests.explanation%type,
      p_fix                   in eba_stds_standard_tests.fix%type
  ) return varchar2 is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'build_test_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  begin
      apex_debug.message(c_debug_template,'build_test_md5', 'p_test_code', p_test_code);
      
      return apex_util.get_hash(apex_t_varchar2(
        p_standard_id,
        p_test_name,
        p_query_clob,
        p_test_code,
        p_active_yn,
        p_level_id,
        p_mv_dependency,
        p_svt_component_type_id,
        p_explanation,
        p_fix ));

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end build_test_md5;

  function current_md5(p_test_code in eba_stds_standard_tests.test_code%type)
  return varchar2
  as 
  l_test_rec eba_stds_standard_tests%rowtype;
  c_scope constant varchar2(128) := gc_scope_prefix || 'current_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    select *
    into l_test_rec
    from eba_stds_standard_tests
    where test_code = p_test_code;

    return build_test_md5(
                      l_test_rec.standard_id,
                      l_test_rec.test_name,
                      l_test_rec.query_clob,
                      l_test_rec.test_code,
                      l_test_rec.active_yn,
                      l_test_rec.level_id,
                      l_test_rec.mv_dependency,
                      l_test_rec.SVT_component_type_id,
                      l_test_rec.explanation,
                      l_test_rec.fix
                  );
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end current_md5;

  procedure publish_test(p_test_code in eba_stds_standard_tests.test_code%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'publish_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_lib_md5      varchar2(32767) := null;
  l_something_to_publish_yn varchar2(1) := gc_n;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    l_lib_md5 := coalesce(eba_stds_tests_lib_api.current_md5(p_test_code => p_test_code),'NA');

    l_something_to_publish_yn := case when p_test_code is null
                                      then gc_n
                                      when l_lib_md5 = 'NA'
                                      then gc_y
                                      when l_lib_md5 != current_md5(p_test_code => p_test_code)
                                      then gc_y
                                      else gc_n
                                      end;

    if l_something_to_publish_yn = gc_y then
      <<publish_block>>
      declare
      l_test_rec eba_stds_standard_tests%rowtype;
      l_version_number eba_stds_standard_tests.version_number%type;
      c_minor_version_increment number := 0.1;
      begin
        select *
        into l_test_rec
        from eba_stds_standard_tests
        where test_code = p_test_code;

        l_version_number := case when l_test_rec.version_number = 0
                                 then 1
                                 else l_test_rec.version_number + c_minor_version_increment
                                 end;
      
        update eba_stds_standard_tests
        set version_number = l_version_number
        where test_code = p_test_code;

        eba_stds_tests_lib_api.upsert (
          p_standard_id           => l_test_rec.standard_id,
          p_test_name             => l_test_rec.test_name,
          p_workspace             => svt_preferences.get_preference ('SVT_DEFAULT_WORKSPACE'),
          p_test_id               => l_test_rec.id,
          p_query_clob            => l_test_rec.query_clob,
          p_test_code             => l_test_rec.test_code,
          p_active_yn             => l_test_rec.active_yn,
          p_mv_dependency         => l_test_rec.mv_dependency,
          p_svt_component_type_id => l_test_rec.svt_component_type_id,
          p_explanation           => l_test_rec.explanation,
          p_fix                   => l_test_rec.fix,
          p_level_id              => l_test_rec.level_id,
          p_version_number        => l_version_number
        );
      end publish_block;
    else 
          apex_debug.message(c_debug_template, '. Nothing to upsert');
    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end publish_test;
  
  procedure update_test(p_id                    in eba_stds_standard_tests.id%type,
                        p_standard_id           in eba_stds_standard_tests.standard_id%type,
                        p_test_name             in eba_stds_standard_tests.test_name%type,
                        p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                        p_query_clob            in eba_stds_standard_tests.query_clob%type,
                        p_owner                 in eba_stds_standard_tests.owner%type,
                        p_test_code             in eba_stds_standard_tests.test_code%type,
                        p_active_yn             in eba_stds_standard_tests.active_yn%type,
                        p_level_id              in eba_stds_standard_tests.level_id%type,
                        p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                        p_svt_component_type_id in eba_stds_standard_tests.SVT_component_type_id%type,
                        p_explanation           in eba_stds_standard_tests.explanation%type,
                        p_fix                   in eba_stds_standard_tests.fix%type,
                        p_version_number        in eba_stds_standard_tests.version_number%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  
  l_current_md5  varchar2(32767) := null;
  l_new_md5      varchar2(32767) := null;
  begin
    apex_debug.message(c_debug_template,'START', 'p_id', p_id);


    l_current_md5 := current_md5(p_test_code => p_test_code);

    l_new_md5 := build_test_md5(
                      p_standard_id,
                      p_test_name,
                      p_query_clob,
                      p_test_code,
                      p_active_yn,
                      p_level_id,
                      p_mv_dependency,
                      p_svt_component_type_id,
                      p_explanation,
                      p_fix
                  );
 
    if l_current_md5 = l_new_md5 then
      apex_debug.message(c_debug_template, '. nothing to update');
    else 
      update eba_stds_standard_tests set
        standard_id           = p_standard_id,
        test_name             = p_test_name,
        display_sequence      = p_display_sequence,
        query_clob            = p_query_clob,
        owner                 = p_owner,
        test_code             = p_test_code,
        active_yn             = p_active_yn,
        level_id              = p_level_id,
        mv_dependency         = p_mv_dependency,
        SVT_component_type_id = p_svt_component_type_id,
        explanation           = p_explanation,
        fix                   = p_fix
      where id = p_id;
    end if;
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end update_test;

  procedure delete_test(p_id        in eba_stds_standard_tests.id%type,
                        p_test_code in eba_stds_standard_tests.test_code%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_test_code', p_test_code);

    delete from eba_stds_standard_tests
    where id = p_id;

    eba_stds_tests_lib_api.delete_test_from_lib (p_test_code => p_test_code);

    apex_debug.message(c_debug_template, 'sql%rowcount', sql%rowcount);
    
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end delete_test;

  function get_test_rec(p_test_code in eba_stds_standard_tests.test_code%type) 
  return eba_stds_standard_tests%rowtype
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_rec';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant eba_stds_standard_tests.test_code%type := upper(p_test_code);
  l_test_rec eba_stds_standard_tests%rowtype;
  begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

      select *
      into l_test_rec
      from eba_stds_standard_tests
      where test_code = c_test_code;

      return l_test_rec;
      
  exception
      when no_data_found then
          return null;
      when others then
          apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
          raise;
  end get_test_rec;

  procedure duplicate_standard (
                                    p_from_test_code in eba_stds_standard_tests.test_code%type,
                                    p_to_test_code   in eba_stds_standard_tests.test_code%type
                                )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'duplicate_standard';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_test_rec eba_stds_standard_tests%rowtype;
  c_new_test_code constant eba_stds_standard_tests.test_code%type := upper(p_to_test_code);
  l_new_test_id eba_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_from_test_code', p_from_test_code,
                                        'p_to_test_code', p_to_test_code);

    l_test_rec := get_test_rec(p_test_code => p_from_test_code);

    l_new_test_id := insert_test(
                        p_standard_id           => l_test_rec.standard_id,
                        p_test_name             => l_test_rec.test_name||' [COPY]',
                        p_display_sequence      => l_test_rec.display_sequence,
                        p_query_clob            => l_test_rec.query_clob,
                        p_owner                 => l_test_rec.owner,
                        p_test_code             => c_new_test_code,
                        p_active_yn             => gc_n,
                        p_level_id              => l_test_rec.level_id,
                        p_mv_dependency         => l_test_rec.mv_dependency,
                        p_svt_component_type_id => l_test_rec.SVT_component_type_id,
                        p_explanation           => l_test_rec.explanation,
                        p_fix                   => l_test_rec.fix
                      );

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end duplicate_standard;

  function get_test_id (p_test_code in eba_stds_standard_tests.test_code%type)
  return eba_stds_standard_tests.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant eba_stds_standard_tests.test_code%type := upper(replace(p_test_code, ' ', '_'));
  l_id eba_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    
    select id
    into l_id
    from eba_stds_standard_tests
    where test_code = c_test_code;
    
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
         level_id,
         urgency, 
         urgency_level,
         test_name,
         test_code,
         standard_name,
         active_yn,
         nt_name,
         query_clob,
         std_creation_date,
         mv_dependency,
         SVT_component_type_id,
         component_name,
         standard_active_yn,
         explanation,
         fix,
         version_number
  from v_eba_stds_standard_tests;

  type r_aa is record (
    standard_id             number,
    test_id                 number,
    level_id                number,
    urgency                 varchar2(255),
    urgency_level           number,
    test_name               varchar2(64),
    test_code               varchar2(100),
    standard_name           varchar2(64),
    active_yn               varchar2(1),
    nt_name                 varchar2(255 char),
    query_clob              clob,
    std_creation_date       timestamp(6) with local time zone,
    mv_dependency           varchar2(100),
    SVT_component_type_id   number,
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
        c_file_blob constant blob := svt_deployment.json_content_blob (p_table_name => 'EBA_STDS_STANDARD_TESTS',
                                                                       p_test_code => l_aat (rec).test_code);
        c_file_size constant pls_integer := sys.dbms_lob.getlength(c_file_blob);
        c_mime_type constant varchar2(25) := 'application/json';
        c_character_set constant varchar2(10) := 'UTF-8';
        c_md5 constant varchar2(250) := build_test_md5 (
                                          p_standard_id           => l_aat (rec).standard_id,
                                          p_test_name             => l_aat (rec).test_name,
                                          p_query_clob            => l_aat (rec).query_clob,
                                          p_test_code             => l_aat (rec).test_code,
                                          p_active_yn             => l_aat (rec).active_yn,
                                          p_level_id              => l_aat (rec).level_id,
                                          p_mv_dependency         => l_aat (rec).mv_dependency,
                                          p_svt_component_type_id => l_aat (rec).SVT_component_type_id,
                                          p_explanation           => l_aat (rec).explanation,
                                          p_fix                   => l_aat (rec).fix
                                      );
        begin
        pipe row (v_eba_stds_standard_tests_ot (
                      l_aat (rec).standard_id,
                      l_aat (rec).test_id,
                      l_aat (rec).level_id,
                      l_aat (rec).urgency, 
                      l_aat (rec).urgency_level,
                      l_aat (rec).test_name,
                      l_aat (rec).test_code,
                      l_aat (rec).standard_name,
                      l_aat (rec).active_yn,
                      l_aat (rec).nt_name,
                      l_aat (rec).query_clob,
                      l_aat (rec).std_creation_date,
                      l_aat (rec).mv_dependency,
                      l_aat (rec).SVT_component_type_id,
                      l_aat (rec).component_name,
                      l_aat (rec).standard_active_yn,
                      l_aat (rec).explanation,
                      l_aat (rec).fix,
                      c_file_size,  --DOWNLOAD
                      c_file_blob,
                      c_mime_type,
                      apex_string.format('%s.json',upper(l_aat (rec).test_code)), --FILE_NAME
                      c_character_set,
                      l_aat (rec).version_number,
                      c_md5 --  RECORD_MD5
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
  end v_eba_stds_standard_tests;

end eba_stds_standard_tests_api;
/
--rollback drop package body eba_stds_standard_tests_api;