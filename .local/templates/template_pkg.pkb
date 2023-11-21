--liquibase formatted sql
--changeset package_body_script:CHANGEME_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body CHANGEME as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   CHANGEME
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';


  procedure P_CHANGEME(
    p_param1_todo in varchar2)
  as
    c_scope          constant varchar2(128) := gc_scope_prefix || 'P_CHANGEME';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  begin
    apex_debug.message(c_debug_template,'START', 'p_param1_todo', p_param1_todo);

    ...
    -- All calls to logger should pass in the scope
    ...

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end P_CHANGEME;


end CHANGEME;
/
--rollback drop package body CHANGEME;