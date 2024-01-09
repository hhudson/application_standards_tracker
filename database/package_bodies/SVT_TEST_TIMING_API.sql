--liquibase formatted sql
--changeset package_body_script:svt_test_timing_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body svt_test_timing_api as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_test_timing_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Oct-9 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  procedure insert_timing(p_test_code in svt_test_timing.test_code%type,
                          p_seconds   in svt_test_timing.elapsed_seconds%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_timing';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    insert into svt_test_timing (test_code, elapsed_seconds, created) 
    values(p_test_code, p_seconds, localtimestamp);

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end insert_timing;

  procedure purge_old
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'purge_old';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');

    delete from svt_test_timing
    where created < add_months(trunc(sysdate,'mm'),-0.5);
    apex_debug.message(c_debug_template, 'deleted :', sql%rowcount);

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end purge_old;

end svt_test_timing_api;
/
--rollback drop package body svt_test_timing_api;