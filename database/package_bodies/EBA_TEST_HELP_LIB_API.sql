--liquibase formatted sql
--changeset package_body_script:EBA_TEST_HELP_LIB_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body EBA_TEST_HELP_LIB_API as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   EBA_TEST_HELP_LIB_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-15 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  procedure merge_help (
    p_workspace     in eba_test_help_lib.workspace%type,
    p_test_id       in eba_test_help_lib.test_id%type,
    p_standard_code in eba_test_help_lib.standard_code%type,
    p_sub_code      in eba_test_help_lib.sub_code%type,
    p_explanation   in eba_test_help_lib.explanation%type,
    p_fix           in eba_test_help_lib.fix%type
  )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'merge_help';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_workspace', p_workspace,
                                        'p_test_id', p_test_id,
                                        'p_standard_code', p_standard_code,
                                        'p_sub_code', p_sub_code,
                                        'p_explanation', p_explanation,
                                        'p_fix', p_fix
                                        );
    merge into eba_test_help_lib e
    using (select p_workspace     workspace,
                  p_test_id       test_id,
                  p_standard_code standard_code,
                  p_sub_code      sub_code,
                  p_explanation   explanation,
                  p_fix           fix
           from dual) h
    on (e.sub_code = h.sub_code and e.workspace = h.workspace)
    when matched then
    update set e.test_id       = h.test_id,
               e.standard_code = h.standard_code,
               e.explanation   = h.explanation,
               e.fix           = h.fix
    when not matched then
    insert (workspace,
            test_id,
            standard_code,
            sub_code,
            explanation,
            fix)
    values (h.workspace,
            h.test_id,
            h.standard_code,
            h.sub_code,
            h.explanation,
            h.fix);
    
    apex_debug.message(c_debug_template, 'sql%rowcount', sql%rowcount);

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end merge_help;

  procedure take_snapshot
  as
    c_scope          constant varchar2(128) := gc_scope_prefix || 'take_snapshot';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_workspace constant apex_workspace_preferences.preference_value%type := ast_preferences.get_preference ('AST_DEFAULT_WORKSPACE');
  begin
    apex_debug.message(c_debug_template,'START');

    for rec in (
      select  child_code,
              explanation,
              fix,
              test_id,
              standard_code
      from v_ast_sub_reference_codes
    ) loop
      merge_help (
        p_workspace     => c_workspace,
        p_test_id       => rec.test_id,
        p_standard_code => rec.standard_code,
        p_sub_code      => rec.child_code,
        p_explanation   => rec.explanation,
        p_fix           => rec.fix
      );
    end loop;

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end take_snapshot;

  procedure insert_help (p_test_id in eba_stds_standard_tests.id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_help';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_lib_help_rec eba_test_help_lib%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_id', p_test_id);

    select *
    into l_lib_help_rec
    from eba_test_help_lib
    where test_id = p_test_id
    fetch first 1 rows only;


    ast_sub_reference_codes_api.insert_help (
            p_sub_code    => l_lib_help_rec.sub_code,
            p_explanation => l_lib_help_rec.explanation,
            p_fix         => l_lib_help_rec.fix,
            p_test_id     => l_lib_help_rec.test_id
        );

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_help;


end EBA_TEST_HELP_LIB_API;
/
--rollback drop package body EBA_TEST_HELP_LIB_API;