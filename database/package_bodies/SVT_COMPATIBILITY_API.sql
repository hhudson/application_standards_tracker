--liquibase formatted sql
--changeset package_body_script:svt_compatibility_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body svt_compatibility_api as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_compatibility_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_nested_table_types.created%type := systimestamp;
  gc_user         constant svt_nested_table_types.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);

  function insert_cmp (
        p_display_order      in svt_compatibility.display_order%type,
        p_compatibility_mode in svt_compatibility.compatibility_mode%type,
        p_compatibility_desc in svt_compatibility.compatibility_desc%type,
        p_type_name          in svt_compatibility.type_name%type
    ) return svt_compatibility.id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_id svt_compatibility.id%type;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_display_order', p_display_order,
                                       'p_compatibility_mode', p_compatibility_mode,
                                       'p_compatibility_desc', p_compatibility_desc,
                                       'p_type_name', p_type_name
                     );
   
   insert into svt_compatibility
   (
    display_order,
    compatibility_mode,
    compatibility_desc,
    type_name,
    created,
    created_by,
    updated,
    updated_by
   )
   values (
    p_display_order,
    p_compatibility_mode,
    p_compatibility_desc,
    p_type_name,
    gc_systimestamp,
    gc_user,
    gc_systimestamp,
    gc_user
   ) returning id into l_id;

   apex_debug.info(c_debug_template, 'l_id', l_id);

   return l_id;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end insert_cmp;

  procedure update_cmp (
        p_id                 in svt_compatibility.id%type,
        p_display_order      in svt_compatibility.display_order%type,
        p_compatibility_mode in svt_compatibility.compatibility_mode%type,
        p_compatibility_desc in svt_compatibility.compatibility_desc%type,
        p_type_name          in svt_compatibility.type_name%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   
   update svt_compatibility
   set display_order      = p_display_order,
       compatibility_mode = p_compatibility_mode,
       compatibility_desc = p_compatibility_desc,
       type_name          = p_type_name
    where id = p_id;

    apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end update_cmp;

  procedure delete_cmp (
        p_id in svt_compatibility.id%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );

   delete from svt_compatibility
    where id = p_id;

    apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end delete_cmp;


end svt_compatibility_api;
/
--rollback drop package body svt_compatibility_api;