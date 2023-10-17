--liquibase formatted sql
--changeset package_body_script:EBA_STDS_TESTS_LIB_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body EBA_STDS_TESTS_LIB_API as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   EBA_STDS_TESTS_LIB_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-8 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(51) := lower($$plsql_unit) || '.';


  procedure upsert (
        p_standard_id           in eba_stds_tests_lib.standard_id%type,
        p_test_name             in eba_stds_tests_lib.test_name%type,
        p_test_id               in eba_stds_tests_lib.test_id%type,
        p_query_clob            in eba_stds_tests_lib.query_clob%type,
        p_test_code             in eba_stds_tests_lib.test_code%type,
        p_active_yn             in eba_stds_tests_lib.active_yn%type,
        p_mv_dependency         in eba_stds_tests_lib.mv_dependency%type,
        p_svt_component_type_id in eba_stds_tests_lib.svt_component_type_id%type,
        p_explanation           in eba_stds_tests_lib.explanation%type,
        p_fix                   in eba_stds_tests_lib.fix%type,
        p_level_id              in eba_stds_tests_lib.level_id%type,
        p_version_number        in eba_stds_tests_lib.version_number%type,
        p_version_db            in eba_stds_tests_lib.version_db%type
    )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'upsert';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_version_number constant eba_stds_tests_lib.version_number%type
                           := case when p_version_number = 0
                                   then null -- you cannot import an unpublished test
                                   else p_version_number
                                   end;
  c_version_db     constant eba_stds_tests_lib.version_db%type 
                          := coalesce(p_version_db, svt_preferences.get_preference ('SVT_DB_NAME'));
  c_id constant eba_stds_tests_lib.id%type := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_standard_id', p_standard_id,
                                        'p_test_name', p_test_name,
                                        'p_test_code', p_test_code,
                                        'p_mv_dependency', p_mv_dependency,
                                        'p_svt_component_type_id', p_svt_component_type_id,
                                        'p_version_number',p_version_number,
                                        'p_version_db',p_version_db
                                        );

    merge into eba_stds_tests_lib e
    using (select p_standard_id           standard_id,
                  p_test_name             test_name,
                  p_test_id               test_id,
                  p_query_clob            query_clob,
                  p_test_code             test_code,
                  p_active_yn             active_yn,
                  p_mv_dependency         mv_dependency,
                  p_svt_component_type_id svt_component_type_id,
                  p_explanation           explanation,
                  p_fix                   fix,
                  p_level_id              level_id,
                  c_version_number        version_number,
                  c_version_db            version_db
           from dual) h
    on (e.test_code = h.test_code)
    when matched then
    update set e.standard_id           = h.standard_id,
               e.test_name             = h.test_name,
               e.test_id               = h.test_id,
               e.query_clob            = h.query_clob,
               e.active_yn             = h.active_yn,
               e.mv_dependency         = h.mv_dependency,
               e.svt_component_type_id = h.svt_component_type_id,
               e.explanation           = h.explanation,
               e.fix                   = h.fix,
               e.level_id              = h.level_id,
               e.version_number        = h.version_number,
               e.version_db            = h.version_db
    when not matched then
    insert (id,
            test_code,
            standard_id,
            test_name,
            test_id,
            query_clob,
            active_yn,
            mv_dependency,
            svt_component_type_id,
            explanation,
            fix,
            level_id,
            version_number,
            version_db
            )
    values (c_id,
            h.test_code,
            h.standard_id,
            h.test_name,
            h.test_id,
            h.query_clob,
            h.active_yn,
            h.mv_dependency,
            h.svt_component_type_id,
            h.explanation,
            h.fix,
            h.level_id,
            h.version_number,
            h.version_db
            );

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end upsert;

  -- procedure take_snapshot
  -- as 
  -- c_scope constant varchar2(128) := gc_scope_prefix || 'take_snapshot';
  -- c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  -- c_workspace constant apex_workspace_preferences.preference_value%type := svt_preferences.get_preference ('SVT_DEFAULT_WORKSPACE');
  -- begin
  --   apex_debug.message(c_debug_template,'START');

  --   for rec in (
  --     select id test_id,
  --            standard_id,
  --            test_name,
  --            query_clob,
  --            test_code,
  --            active_yn,
  --            mv_dependency,
  --            svt_component_type_id,
  --            explanation,
  --            fix,
  --            level_id,
  --            version_number
  --     from eba_stds_standard_tests
  --     order by 1
  --   ) loop
  --     upsert (
  --       p_standard_id           => rec.standard_id,
  --       p_test_name             => rec.test_name,
  --       p_workspace             => c_workspace,
  --       p_test_id               => rec.test_id,
  --       p_query_clob            => rec.query_clob,
  --       p_test_code             => rec.test_code,
  --       p_active_yn             => rec.active_yn,
  --       p_mv_dependency         => rec.mv_dependency,
  --       p_svt_component_type_id => rec.svt_component_type_id,
  --       p_explanation           => rec.explanation,
  --       p_fix                   => rec.fix,
  --       p_level_id              => rec.level_id,
  --       p_version_number        => rec.version_number
  --     );
  --   end loop;

  -- exception when others then
  --   apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
  --   raise;
  -- end take_snapshot;

  procedure install_standard_test(p_id               in eba_stds_tests_lib.id%type,
                                  p_standard_id      in eba_stds_standard_tests.standard_id%type,
                                  p_urgency_level_id in eba_stds_standard_tests.level_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'install_standard_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_lib_rec eba_stds_tests_lib%rowtype;
  l_existing_rec eba_stds_standard_tests%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_urgency_level_id', p_urgency_level_id,
                                        'p_standard_id', p_standard_id);

    select *
    into l_lib_rec
    from eba_stds_tests_lib
    where id = p_id;

    l_existing_rec := eba_stds_standard_tests_api.get_test_rec(p_test_code => l_lib_rec.test_code);

    if l_existing_rec.test_code is null then

      eba_stds_standard_tests_api.insert_test(
                  p_id                    => l_lib_rec.test_id,
                  p_standard_id           => coalesce(p_standard_id, l_lib_rec.standard_id),
                  p_test_name             => l_lib_rec.test_name,
                  p_query_clob            => l_lib_rec.query_clob,
                  p_owner                 => svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA'),
                  p_test_code             => l_lib_rec.test_code,
                  p_active_yn             => 'Y',
                  p_level_id              => coalesce(p_urgency_level_id, svt_urgency_level_api.get_default_level_id),
                  p_mv_dependency         => l_lib_rec.mv_dependency,
                  p_svt_component_type_id => l_lib_rec.svt_component_type_id,
                  p_explanation           => l_lib_rec.explanation,
                  p_fix                   => l_lib_rec.fix,
                  p_version_number        => l_lib_rec.version_number,
                  p_version_db            => l_lib_rec.version_db
                  );
    
    else 
      eba_stds_standard_tests_api.update_test(
                          p_id                    => l_existing_rec.id,
                          p_standard_id           => coalesce(p_standard_id, l_lib_rec.standard_id),
                          p_test_name             => l_lib_rec.test_name,
                          p_display_sequence      => l_existing_rec.display_sequence,
                          p_query_clob            => l_lib_rec.query_clob,
                          p_owner                 => l_existing_rec.owner,
                          p_test_code             => l_existing_rec.test_code,
                          p_active_yn             => l_existing_rec.active_yn,
                          p_level_id              => l_lib_rec.level_id,
                          p_mv_dependency         => l_lib_rec.mv_dependency,
                          p_svt_component_type_id => l_lib_rec.svt_component_type_id,
                          p_explanation           => l_lib_rec.explanation,
                          p_fix                   => l_lib_rec.fix,
                          p_version_number        => l_lib_rec.version_number,
                          p_version_db            => l_lib_rec.version_db
                      );
    end if;
    
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end install_standard_test;

  procedure install_standard (p_standard_id in eba_stds_standard_tests.standard_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'install_standard';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);
    
    for rec in (select id, standard_id, level_id
                from eba_stds_tests_lib)
    loop
      install_standard_test(p_id               => rec.id,
                            p_standard_id      => rec.standard_id,
                            p_urgency_level_id => rec.level_id);
    end loop;
  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end install_standard;

  procedure delete_test_from_lib (p_id in eba_stds_tests_lib.id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test_from_lib 1';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_id', p_id);

    delete from eba_stds_tests_lib
    where id = p_id;
    
    apex_debug.message(c_debug_template, 'sql%rowcount', sql%rowcount);

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end delete_test_from_lib;

  procedure delete_test_from_lib (p_test_code in eba_stds_tests_lib.test_code%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test_from_lib 2';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    delete from eba_stds_tests_lib
    where test_code = p_test_code;
    
    apex_debug.message(c_debug_template, 'sql%rowcount', sql%rowcount);
  
  exception when others then
  apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
  raise;
  end delete_test_from_lib;

  function get_id(p_test_code in eba_stds_tests_lib.test_code%type)
  return eba_stds_tests_lib.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_space_index constant number := instr(p_test_code,' ');
  c_test_code constant eba_stds_tests_lib.test_code%type 
                  := case when c_space_index = 0
                          then upper(p_test_code)
                          else substr (upper(p_test_code), 1,c_space_index - 1)
                          end;
  l_id eba_stds_tests_lib.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
    
    select id
    into l_id
    from eba_stds_tests_lib
    where test_code = c_test_code;

    return l_id;
  
  exception 
  when no_data_found then
    return null;
  when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_id;

  procedure md5_imported_vsn_num (
                p_test_code      in  eba_stds_tests_lib.test_code%type,
                p_md5            out nocopy varchar2,
                p_version_number out nocopy eba_stds_tests_lib.version_number%type
              )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'md5_imported_vsn_num';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_lib_rec eba_stds_tests_lib%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);
  
    select *
    into l_lib_rec
    from eba_stds_tests_lib
    where test_code = p_test_code;

    p_md5 := eba_stds_standard_tests_api.build_test_md5(
                      l_lib_rec.test_name,
                      l_lib_rec.query_clob,
                      l_lib_rec.test_code,
                      l_lib_rec.level_id,
                      l_lib_rec.mv_dependency,
                      l_lib_rec.svt_component_type_id,
                      l_lib_rec.explanation,
                      l_lib_rec.fix,
                      l_lib_rec.version_number,
                      l_lib_rec.version_db
                  );

    p_version_number := l_lib_rec.version_number;
  
  exception 
    when no_data_found then
      apex_debug.message(c_debug_template, 'no data found', p_test_code);
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end md5_imported_vsn_num;

  function current_md5(p_test_code in eba_stds_tests_lib.test_code%type)
  return varchar2
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'current_md5';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_md5 varchar2(250);
  l_version_number eba_stds_tests_lib.version_number%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

    md5_imported_vsn_num (
                p_test_code      => p_test_code,
                p_md5            => l_md5,
                p_version_number => l_version_number
              );
    
    return l_md5;

  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end current_md5;


end EBA_STDS_TESTS_LIB_API;
/
--rollback drop package body EBA_STDS_TESTS_LIB_API;