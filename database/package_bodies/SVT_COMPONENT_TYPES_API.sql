--liquibase formatted sql
--changeset package_body_script:SVT_COMPONENT_TYPES_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_COMPONENT_TYPES_API as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_COMPONENT_TYPES_API
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
       p_component_name    in svt_component_types.component_name%type,
       p_available_yn      in svt_component_types.available_yn%type,
       p_nt_type_id        in svt_component_types.nt_type_id%type,
       p_pk_value          in svt_component_types.pk_value%type,
       p_parent_pk_value   in svt_component_types.parent_pk_value%type,
       p_template_url      in svt_component_types.template_url%type,
       p_friendly_name     in svt_component_types.friendly_name%type,
       p_name_column       in svt_component_types.name_column%type,
       p_addl_cols         in svt_component_types.addl_cols%type
    ) return svt_component_types.id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_id svt_component_types.id%type;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_component_name', p_component_name
                     );
   
   insert into svt_component_types
   (
    component_name,
    available_yn,
    nt_type_id,
    pk_value,
    parent_pk_value,
    template_url,
    friendly_name,
    name_column,
    addl_cols,
    created,
    created_by,
    updated,
    updated_by
   ) values (
    p_component_name,
    p_available_yn,
    p_nt_type_id,
    p_pk_value,
    p_parent_pk_value,
    p_template_url,
    p_friendly_name,
    p_name_column,
    p_addl_cols,
    gc_systimestamp,
    gc_user,
    gc_systimestamp,
    gc_user
   ) returning id into l_id;

   return l_id;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end insert_cmp;

  procedure update_cmp (
       p_id                in svt_component_types.id%type,
       p_component_name    in svt_component_types.component_name%type,
       p_available_yn      in svt_component_types.available_yn%type,
       p_nt_type_id        in svt_component_types.nt_type_id%type,
       p_pk_value          in svt_component_types.pk_value%type,
       p_parent_pk_value   in svt_component_types.parent_pk_value%type,
       p_template_url      in svt_component_types.template_url%type,
       p_friendly_name     in svt_component_types.friendly_name%type,
       p_name_column       in svt_component_types.name_column%type,
       p_addl_cols         in svt_component_types.addl_cols%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   
   update svt_component_types
   set component_name  = p_component_name,
       available_yn    = p_available_yn,
       nt_type_id      = p_nt_type_id,
       pk_value        = p_pk_value,
       parent_pk_value = p_parent_pk_value,
       template_url    = p_template_url,
       friendly_name   = p_friendly_name,
       name_column     = p_name_column,
       addl_cols       = p_addl_cols,
       updated         = gc_systimestamp,
       updated_by      = gc_user
   where id = p_id;

   apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
   

  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end update_cmp;

  procedure delete_cmp (
        p_id in svt_component_types.id%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_cmp';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   
   delete from svt_component_types
   where id = p_id;

   apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);

  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end delete_cmp;


end SVT_COMPONENT_TYPES_API;
/
--rollback drop package body SVT_COMPONENT_TYPES_API;