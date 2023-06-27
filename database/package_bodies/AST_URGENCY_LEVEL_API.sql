--liquibase formatted sql
--changeset package_body_script:AST_URGENCY_LEVEL_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body AST_URGENCY_LEVEL_API as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   AST_URGENCY_LEVEL_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jun-14- created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  function get_default_level_id return ast_standards_urgency_level.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_default_level_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_level_id ast_standards_urgency_level.id%type;
  begin
    apex_debug.message(c_debug_template,'START');

    begin <<attempt1>>
    select id 
    into l_level_id
    from ast_standards_urgency_level
    where urgency_level = 100;

    exception when no_data_found then
      select id 
      into l_level_id
      from ast_standards_urgency_level
      fetch first 1 rows only;
    end attempt1;

    return l_level_id;

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end get_default_level_id;


end AST_URGENCY_LEVEL_API;
/
--rollback drop package body AST_URGENCY_LEVEL_API;