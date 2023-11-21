--liquibase formatted sql
--changeset package_body_script:SVT_UTIL_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_UTIL as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-21 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';


  function app_name return varchar2
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'app_name';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  c_db_name constant varchar2(100) := svt_preferences.get('SVT_DB_NAME');
  c_app_name constant varchar2(100) := 'Standard Violation Tracker';
  begin
   
   return case when c_db_name is null 
               then c_app_name
               else apex_string.format('[%s] %s', c_db_name, c_app_name)
               end;

  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end app_name;


end SVT_UTIL;
/
--rollback drop package body SVT_UTIL;