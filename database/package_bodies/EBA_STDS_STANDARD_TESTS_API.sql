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
  gc_default_version_number constant number := 0;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 20, 2023
-- Synopsis:
--
-- Private function to uppercase and handle spaces in test codes  
--
------------------------------------------------------------------------------
    function format_test_code (p_test_code in eba_stds_standard_tests.test_code%type)
    return eba_stds_standard_tests.test_code%type
    deterministic
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'format_test_code';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

      return upper(replace(p_test_code, ' ', '_'));
      
   exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    end format_test_code;
    
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
                         p_version_number        in eba_stds_standard_tests.version_number%type default null,
                         p_version_db            in eba_stds_standard_tests.version_db%type default null
                         )
   return eba_stds_standard_tests.id%type 
   as 
   c_scope constant varchar2(128) := gc_scope_prefix || 'insert_test';
   c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
   c_test_code constant eba_stds_standard_tests.test_code%type := format_test_code(p_test_code);
   c_id constant eba_stds_standard_tests.id%type := coalesce(p_id, 
                                                            to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
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
      svt_component_type_id,
      explanation,
      fix,
      version_number,
      version_db,
      created,
      created_by,
      updated,
      updated_by
    )
    values (
      c_id,
      p_standard_id,
      p_test_name,
      p_display_sequence,
      p_query_clob,
      p_owner,
      c_test_code,
      p_active_yn,
      p_level_id,
      p_mv_dependency,
      p_svt_component_type_id,
      p_explanation,
      p_fix,
      coalesce(p_version_number,gc_default_version_number),
      coalesce(p_version_db,svt_preferences.get('SVT_DB_NAME')),
      localtimestamp,
      coalesce(wwv_flow.g_user,user),
      localtimestamp,
      coalesce(wwv_flow.g_user,user)
    );

    return c_id;
   
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
                         p_svt_component_type_id in eba_stds_standard_tests.svt_component_type_id%type,
                         p_explanation           in eba_stds_standard_tests.explanation%type,
                         p_fix                   in eba_stds_standard_tests.fix%type,
                         p_version_number        in eba_stds_standard_tests.version_number%type default null,
                         p_version_db            in eba_stds_standard_tests.version_db%type default null
                         )
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
                        p_version_number        => p_version_number,
                        p_version_db            => p_version_db
                        );

    apex_debug.message(c_debug_template, 'l_id', l_id);

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end insert_test;

  -- build md5 function for table eba_stds_standard_tests
  function build_test_md5 (
      p_test_name             in eba_stds_standard_tests.test_name%type,
      p_query_clob            in eba_stds_standard_tests.query_clob%type,
      p_test_code             in eba_stds_standard_tests.test_code%type,
      p_level_id              in eba_stds_standard_tests.level_id%type,
      p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
      p_svt_component_type_id in eba_stds_standard_tests.svt_component_type_id%type,
      p_explanation           in eba_stds_standard_tests.explanation%type,
      p_fix                   in eba_stds_standard_tests.fix%type,
      p_version_number        in eba_stds_standard_tests.version_number%type,
      p_version_db            in eba_stds_standard_tests.version_db%type
  ) return varchar2 deterministic
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'build_test_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  begin
      apex_debug.message(c_debug_template,'build_test_md5', 'p_test_code', p_test_code);
      
      return apex_util.get_hash(apex_t_varchar2(
        p_test_name,
        p_query_clob,
        p_test_code,
        p_level_id,
        p_mv_dependency,
        p_svt_component_type_id,
        p_explanation,
        p_fix,
        p_version_number,
        p_version_db ));

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end build_test_md5;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 13, 2023
-- Synopsis:
--
-- Private function to get the md5 for a given test_code
--
------------------------------------------------------------------------------ 
  function current_md5(p_test_code in eba_stds_standard_tests.test_code%type)
  return varchar2
  as 
  l_test_rec eba_stds_standard_tests%rowtype;
  c_scope constant varchar2(128) := gc_scope_prefix || 'current_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    l_test_rec := eba_stds_standard_tests_api.get_test_rec(p_test_code => p_test_code);

    return build_test_md5(
                      -- l_test_rec.standard_id,
                      l_test_rec.test_name,
                      l_test_rec.query_clob,
                      l_test_rec.test_code,
                      -- l_test_rec.active_yn,
                      l_test_rec.level_id,
                      l_test_rec.mv_dependency,
                      l_test_rec.svt_component_type_id,
                      l_test_rec.explanation,
                      l_test_rec.fix,
                      l_test_rec.version_number,
                      l_test_rec.version_db
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
  l_test_rec eba_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    l_test_rec := eba_stds_standard_tests_api.get_test_rec(p_test_code => p_test_code);

    if l_test_rec.active_yn = gc_y then
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
        l_version_number eba_stds_standard_tests.version_number%type;
        c_minor_version_increment constant number := 0.1;
        c_db_name constant eba_stds_standard_tests.version_db%type := svt_preferences.get('SVT_DB_NAME');
        begin

          l_version_number := case when l_test_rec.version_db != c_db_name
                                  then 1
                                  when l_test_rec.version_number = 0
                                  then 1
                                  else l_test_rec.version_number + c_minor_version_increment
                                  end;
        
          update eba_stds_standard_tests
          set version_number = l_version_number,
              version_db = c_db_name,
              updated = localtimestamp,
              updated_by = coalesce(wwv_flow.g_user,user)
          where test_code = p_test_code;

          eba_stds_tests_lib_api.upsert (
            p_standard_id           => l_test_rec.standard_id,
            p_test_name             => l_test_rec.test_name,
            p_test_id               => l_test_rec.id,
            p_query_clob            => l_test_rec.query_clob,
            p_test_code             => l_test_rec.test_code,
            p_active_yn             => l_test_rec.active_yn,
            p_mv_dependency         => l_test_rec.mv_dependency,
            p_svt_component_type_id => l_test_rec.svt_component_type_id,
            p_explanation           => l_test_rec.explanation,
            p_fix                   => l_test_rec.fix,
            p_level_id              => l_test_rec.level_id,
            p_version_number        => l_version_number,
            p_version_db            => c_db_name
          );
        end publish_block;
      else 
            apex_debug.message(c_debug_template, '. Nothing to upsert');
      end if;
    else 
      apex_debug.message(c_debug_template, '. Test is not active');
    end if;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end publish_test;

  procedure bulk_publish(p_selected_ids in varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_publish';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_selected_ids', p_selected_ids);

    for rec in (select column_value test_code
                from table(apex_string.split(p_selected_ids, ','))
    )
    loop
      publish_test(p_test_code => rec.test_code);
    end loop;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end bulk_publish;
  
  
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
                        p_svt_component_type_id in eba_stds_standard_tests.svt_component_type_id%type,
                        p_explanation           in eba_stds_standard_tests.explanation%type,
                        p_fix                   in eba_stds_standard_tests.fix%type,
                        p_version_number        in eba_stds_standard_tests.version_number%type default null,
                        p_version_db            in eba_stds_standard_tests.version_db%type default null
                        )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_test_code constant eba_stds_standard_tests.test_code%type := format_test_code(p_test_code);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_test_code', p_test_code,
                                        'p_standard_id', p_standard_id,
                                        'p_test_name', p_test_name,
                                        'p_active_yn', p_active_yn,
                                        'p_level_id', p_level_id,
                                        'p_svt_component_type_id', p_svt_component_type_id,
                                        'p_version_number', p_version_number,
                                        'p_version_db', p_version_db
                                        );


      update eba_stds_standard_tests set
        standard_id           = p_standard_id,
        test_name             = p_test_name,
        display_sequence      = coalesce(p_display_sequence, display_sequence),
        query_clob            = p_query_clob,
        owner                 = p_owner,
        test_code             = c_test_code,
        active_yn             = p_active_yn,
        level_id              = p_level_id,
        mv_dependency         = p_mv_dependency,
        svt_component_type_id = p_svt_component_type_id,
        explanation           = p_explanation,
        fix                   = p_fix,
        version_number        = coalesce(p_version_number, version_number, gc_default_version_number),
        version_db            = coalesce(p_version_db, version_db, svt_preferences.get('SVT_DB_NAME')),
        updated               = localtimestamp,
        updated_by            = coalesce(wwv_flow.g_user,user)
      where id = p_id;
  
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end update_test;

  procedure bulk_inactivate(p_selected_ids in varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_inactivate';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec eba_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_selected_ids', p_selected_ids);

    for rec in (select column_value test_code
                from table(apex_string.split(p_selected_ids, ','))
    )
    loop
      l_rec := eba_stds_standard_tests_api.get_test_rec(p_test_code => rec.test_code);
      update_test(p_id                    => l_rec.id,
                  p_standard_id           => l_rec.standard_id,
                  p_test_name             => l_rec.test_name,
                  p_display_sequence      => l_rec.display_sequence,
                  p_query_clob            => l_rec.query_clob,
                  p_owner                 => l_rec.owner,
                  p_test_code             => l_rec.test_code,
                  p_active_yn             => gc_n,
                  p_level_id              => l_rec.level_id,
                  p_mv_dependency         => l_rec.mv_dependency,
                  p_svt_component_type_id => l_rec.svt_component_type_id,
                  p_explanation           => l_rec.explanation,
                  p_fix                   => l_rec.fix,
                  p_version_number        => l_rec.version_number
                );
    end loop;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end bulk_inactivate;
  
  procedure bulk_delete(p_selected_ids in varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_delete';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec eba_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_selected_ids', p_selected_ids);

    for rec in (select column_value test_code
                from table(apex_string.split(p_selected_ids, ','))
    )
    loop
      l_rec := eba_stds_standard_tests_api.get_test_rec(p_test_code => rec.test_code);
      delete_test(p_id        => l_rec.id,
                  p_test_code => l_rec.test_code);
    end loop;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end bulk_delete;

  procedure bulk_activate(p_selected_ids in varchar2)
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_activate';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec eba_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_selected_ids', p_selected_ids);

    for rec in (select column_value test_code
                from table(apex_string.split(p_selected_ids, ','))
    )
    loop
      l_rec := eba_stds_standard_tests_api.get_test_rec(p_test_code => rec.test_code);
      update_test(p_id                    => l_rec.id,
                  p_standard_id           => l_rec.standard_id,
                  p_test_name             => l_rec.test_name,
                  p_display_sequence      => l_rec.display_sequence,
                  p_query_clob            => l_rec.query_clob,
                  p_owner                 => l_rec.owner,
                  p_test_code             => l_rec.test_code,
                  p_active_yn             => gc_y,
                  p_level_id              => l_rec.level_id,
                  p_mv_dependency         => l_rec.mv_dependency,
                  p_svt_component_type_id => l_rec.svt_component_type_id,
                  p_explanation           => l_rec.explanation,
                  p_fix                   => l_rec.fix,
                  p_version_number        => l_rec.version_number
                );
    end loop;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end bulk_activate;

  procedure delete_test(p_id        in eba_stds_standard_tests.id%type,
                        p_test_code in eba_stds_standard_tests.test_code%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_test_code', p_test_code);

    eba_stds_inherited_tests_api.delete_test (p_test_id => p_id);
    
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
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_rec 1';
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

  function get_test_rec(p_test_id in eba_stds_standard_tests.id%type) 
  return eba_stds_standard_tests%rowtype
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_test_rec 2';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_test_rec eba_stds_standard_tests%rowtype;
  begin
      apex_debug.message(c_debug_template,'START', 'p_test_id', p_test_id);

      select *
      into l_test_rec
      from eba_stds_standard_tests
      where id = p_test_id;

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
                        p_test_name             => substr(l_test_rec.test_name,1,57)||' [COPY]',
                        p_display_sequence      => l_test_rec.display_sequence,
                        p_query_clob            => l_test_rec.query_clob,
                        p_owner                 => l_test_rec.owner,
                        p_test_code             => c_new_test_code,
                        p_active_yn             => gc_n,
                        p_level_id              => l_test_rec.level_id,
                        p_mv_dependency         => l_test_rec.mv_dependency,
                        p_svt_component_type_id => l_test_rec.svt_component_type_id,
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
  l_rec eba_stds_standard_tests%rowtype;
begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    
    l_rec := eba_stds_standard_tests_api.get_test_rec(p_test_code => c_test_code);
    
    return l_rec.id;
  
  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_test_id;

  function get_standard_id (p_test_id in eba_stds_standard_tests.id%type)
  return eba_stds_standard_tests.standard_id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_standard_id'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec eba_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_id', p_test_id);

    l_rec := get_test_rec(p_test_id => p_test_id);
    
    return l_rec.standard_id;

  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_standard_id;

  function get_standard_id (p_test_code in eba_stds_standard_tests.test_code%type)
  return eba_stds_standard_tests.standard_id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_standard_id 2'; 
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec eba_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    l_rec := get_test_rec(p_test_code => p_test_code);
    
    return l_rec.standard_id;

  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_standard_id;


  function v_eba_stds_standard_tests (
                p_standard_id        in eba_stds_standard_tests.standard_id%type default null,
                p_active_yn          in eba_stds_standard_tests.active_yn%type default null,
                p_published_yn       in varchar2 default null,
                p_standard_active_yn in varchar2 default null
            )
  return v_eba_stds_standard_tests_nt pipelined
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'v_eba_stds_standard_tests';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10'; 

  cursor cur_aa (p_std_id          in number,
                 p_active          in varchar2,
                 p_standard_active in varchar2,
                 p_calling_std     in varchar2)
  is 
  select o.standard_id,
         o.test_id,
         o.level_id,
         o.urgency, 
         o.urgency_level,
         o.test_name,
         o.test_code,
         o.full_standard_name,
         o.active_yn,
         o.nt_name,
         o.query_clob,
         o.std_creation_date,
         o.mv_dependency,
         o.svt_component_type_id,
         o.component_name,
         o.standard_active_yn,
         o.explanation,
         o.fix,
         o.version_number,
         o.version_db,
         o.inherited_yn,
         o.full_standard_name,
         o.display_sequence
  from v_eba_stds_standard_tests_w_inherited o
  where (o.standard_id = p_std_id or p_std_id is null)
  and   (o.active_yn = p_active or p_active is null)
  and   (o.standard_active_yn = p_standard_active or p_standard_active is null)
  and   o.inherited_yn = case when p_std_id is null
                              then gc_n 
                              else o.inherited_yn
                              end;

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
    svt_component_type_id   number,
    component_name          varchar2(50),
    standard_active_yn      varchar2(1),
    explanation             varchar2(4000 char),
    fix                     clob,
    version_number          number,
    version_db              varchar2(55),
    inherited_yn            varchar2(1),
    calling_std_name        varchar2(64),
    display_sequence        number
  );
  type t_aa is table of r_aa index by pls_integer;
  l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_active_yn', p_active_yn,
                                        'p_published_yn', p_published_yn,
                                        'p_standard_active_yn', p_standard_active_yn
                                        );

    open cur_aa (p_std_id          => p_standard_id,
                 p_active          => p_active_yn,
                 p_standard_active => p_standard_active_yn,
                 p_calling_std     => eba_stds_standards_api.get_full_name (p_standard_id => p_standard_id));

    loop
      fetch cur_aa bulk collect into l_aat limit 1000;

      exit when l_aat.count = 0;

      for rec in 1 .. l_aat.count
      loop
        <<load_block>>
        declare
        c_file_blob constant blob := svt_deployment.json_standard_tests_blob (
                                                        p_standard_id => l_aat (rec).standard_id, 
                                                        p_test_code   => l_aat (rec).test_code);
        c_file_size constant pls_integer := sys.dbms_lob.getlength(c_file_blob);
        c_mime_type constant varchar2(25) := 'application/json';
        c_character_set constant varchar2(10) := 'UTF-8';
        c_md5 constant varchar2(250) := build_test_md5 (
                                          p_test_name             => l_aat (rec).test_name,
                                          p_query_clob            => l_aat (rec).query_clob,
                                          p_test_code             => l_aat (rec).test_code,
                                          p_level_id              => l_aat (rec).level_id,
                                          p_mv_dependency         => l_aat (rec).mv_dependency,
                                          p_svt_component_type_id => l_aat (rec).svt_component_type_id,
                                          p_explanation           => l_aat (rec).explanation,
                                          p_fix                   => l_aat (rec).fix,
                                          p_version_number        => l_aat (rec).version_number,
                                          p_version_db            => l_aat (rec).version_db
                                      );
        l_lib_md5 varchar2(250);
        l_lib_version_number eba_stds_tests_lib.version_number%type;
        l_published_yn varchar2(1) := gc_n;
        l_piperow_yn varchar2(1) := gc_y;
        begin
        eba_stds_tests_lib_api.md5_imported_vsn_num (
                p_test_code      => l_aat (rec).test_code,
                p_md5            => l_lib_md5,
                p_version_number => l_lib_version_number
        );
        l_published_yn := case  when l_aat (rec).active_yn = gc_n
                                then gc_n
                                when l_lib_md5 is null 
                                then gc_n
                                when c_md5 = l_lib_md5
                                then gc_y
                                else gc_n
                                end;
        l_piperow_yn := case when p_published_yn is null 
                             then gc_y 
                             when p_published_yn = gc_n
                             then case when l_published_yn = gc_n
                                       then gc_y
                                       else gc_n
                                       end
                             when p_published_yn = gc_y
                             then l_published_yn
                             else gc_y 
                             end;
        if l_piperow_yn = gc_y then 
          pipe row (v_eba_stds_standard_tests_ot (
                      l_aat (rec).standard_id,
                      l_aat (rec).test_id,
                      l_aat (rec).level_id,
                      l_aat (rec).urgency, 
                      l_aat (rec).urgency_level, --5
                      l_aat (rec).test_name,
                      l_aat (rec).test_code,
                      l_aat (rec).standard_name,
                      l_aat (rec).active_yn,
                      l_aat (rec).nt_name, --10
                      l_aat (rec).query_clob,
                      l_aat (rec).std_creation_date,
                      l_aat (rec).mv_dependency,
                      l_aat (rec).svt_component_type_id,
                      l_aat (rec).component_name,
                      l_aat (rec).standard_active_yn,
                      l_aat (rec).explanation,
                      l_aat (rec).fix,
                      c_file_size,  --download
                      c_file_blob,
                      c_mime_type,
                      apex_string.format('%s-%s.json',l_aat (rec).test_code, l_aat (rec).version_db), --file_name
                      c_character_set,
                      l_aat (rec).version_number,
                      l_aat (rec).version_db,
                      'v'||l_aat (rec).version_number, --vsn
                      c_md5, --  record_md5
                      l_lib_md5, --lib_md5
                      l_lib_version_number, --lib_imported_version
                      l_published_yn, --published_yn
                      case when l_published_yn = gc_n
                           then 'hide'
                           else 'show t-Button t-Button--icon t-Button--simple'
                           end, --download_css
                      l_aat (rec).inherited_yn, --inherited_yn,
                      l_aat (rec).calling_std_name, --calling standard
                      l_aat (rec).display_sequence
                    )
                );
              end if;
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

  function nt_name(p_test_code in eba_stds_standard_tests.test_code%type)
  return svt_nested_table_types.nt_name%type
  deterministic 
  result_cache
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'nt_name';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_nt_name svt_nested_table_types.nt_name%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

       select lower(nt_name)
        into l_nt_name
        from v_eba_stds_standard_tests
        where test_code = p_test_code;

      return l_nt_name;

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end nt_name;

end eba_stds_standard_tests_api;
/
--rollback drop package body eba_stds_standard_tests_api;