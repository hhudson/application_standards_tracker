--liquibase formatted sql
--changeset package_body_script:eba_stds_types_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body eba_stds_types_api as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   eba_stds_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  function get_type_id (p_type_code in eba_stds_types.type_code%type)
  return eba_stds_types.id%type
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || '_';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_id eba_stds_types.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_type_code', p_type_code);

    select id 
    into l_id
    from eba_stds_types
    where type_code = p_type_code;

    return l_id;

  exception
    when no_data_found then
      apex_debug.message(c_debug_template,'no_data_found', 'p_type_code', p_type_code);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end get_type_id;


end eba_stds_types_api;
/
--rollback drop package body eba_stds_types_api;