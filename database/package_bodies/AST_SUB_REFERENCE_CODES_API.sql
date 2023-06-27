--liquibase formatted sql
--changeset package_body_script:AST_SUB_REFERENCE_CODES_API stripComments:false endDelimiter:/ runOnChange:true

create or replace package body AST_SUB_REFERENCE_CODES_API as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   AST_SUB_REFERENCE_CODES_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  procedure insert_help (p_sub_code    in ast_sub_reference_codes.sub_code%type,
                         p_explanation in ast_sub_reference_codes.explanation%type,
                         p_fix         in ast_sub_reference_codes.fix%type,
                         p_test_id     in ast_sub_reference_codes.test_id%type
  )
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_help';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_sub_code', p_sub_code);

    insert into ast_sub_reference_codes
    (
      sub_code,
      explanation,
      fix,
      test_id
    )
    values 
    (
      p_sub_code,
      p_explanation,
      p_fix,
      p_test_id
    );
  
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_help;
  
  procedure duplicate_standard_help (
                                        p_from_test_id in eba_stds_standard_tests.id%type,
                                        p_to_test_id   in eba_stds_standard_tests.id%type
                                    )
  as
    c_scope          constant varchar2(128) := gc_scope_prefix || 'duplicate_standard_help';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_from_test_id', p_from_test_id,
                                        'p_to_test_id', p_to_test_id);

    for rec in (select sub_code, explanation, fix, p_to_test_id test_id
                from ast_sub_reference_codes asrc
                inner join eba_stds_standard_tests esst on esst.id = asrc.test_id
                                                        and esst.id = p_from_test_id
    )
    loop
      insert_help (p_sub_code    => rec.sub_code||'_COPY',
                   p_explanation => rec.explanation,
                   p_fix         => rec.fix,
                   p_test_id     => rec.test_id
                ); 
    end loop;

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end duplicate_standard_help;


end AST_SUB_REFERENCE_CODES_API;
/
--rollback drop package body AST_SUB_REFERENCE_CODES_API;