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
      name,
      query_clob,
      owner,
      standard_code,
      active_yn,
      issue_desc,
      level_id,
      mv_dependency,
      ast_component_type_id
    )
    values 
    (
      l_test_rec.standard_id,
      l_test_rec.test_type,
      l_test_rec.name||' [COPY]',
      l_test_rec.query_clob,
      l_test_rec.owner,
      c_new_standard_code,
      'N',
      l_test_rec.issue_desc,
      l_test_rec.level_id,
      l_test_rec.mv_dependency,
      l_test_rec.ast_component_type_id
    ) returning id into l_new_test_id;

    ast_sub_reference_codes_api.duplicate_standard_help (
                                    p_from_test_id  => l_test_rec.id,
                                    p_to_test_id    => l_new_test_id
                                );

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

  procedure insert_test(p_id                    in eba_stds_standard_tests.id%type default null,
                        p_standard_id           in eba_stds_standard_tests.standard_id%type,
                        p_test_type             in eba_stds_standard_tests.test_type%type,
                        p_name                  in eba_stds_standard_tests.name%type,
                        p_display_sequence      in eba_stds_standard_tests.display_sequence%type default null,
                        p_query_clob            in eba_stds_standard_tests.query_clob%type,
                        p_owner                 in eba_stds_standard_tests.owner%type,
                        p_standard_code         in eba_stds_standard_tests.standard_code%type,
                        p_active_yn             in eba_stds_standard_tests.active_yn%type,
                        p_issue_desc            in eba_stds_standard_tests.issue_desc%type,
                        p_level_id              in eba_stds_standard_tests.level_id%type,
                        p_mv_dependency         in eba_stds_standard_tests.mv_dependency%type,
                        p_ast_component_type_id in eba_stds_standard_tests.ast_component_type_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_id eba_stds_standard_tests.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_id', p_id,
                                        'p_standard_id', p_standard_id,
                                        'p_test_type', p_test_type,
                                        'p_name', p_name,
                                        'p_display_sequence', p_display_sequence,
                                        'p_standard_code', p_standard_code,
                                        'p_active_yn', p_active_yn,
                                        'p_level_id', p_level_id,
                                        'p_mv_dependency', p_mv_dependency,
                                        'p_ast_component_type_id', p_ast_component_type_id
                                        );

    insert into eba_stds_standard_tests 
    (
      id,
      standard_id,
      test_type,
      name,
      display_sequence,
      query_clob,
      owner,
      standard_code,
      active_yn,
      issue_desc,
      level_id,
      mv_dependency,
      ast_component_type_id
    )
    values (
      p_id,
      p_standard_id,
      p_test_type,
      p_name,
      p_display_sequence,
      p_query_clob,
      p_owner,
      p_standard_code,
      p_active_yn,
      p_issue_desc,
      p_level_id,
      p_mv_dependency,
      p_ast_component_type_id
    ) returning id into l_id;

    apex_debug.message(c_debug_template, 'l_id', l_id);

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end insert_test;

end eba_stds_standard_tests_api;
/
--rollback drop package body eba_stds_standard_tests_api;