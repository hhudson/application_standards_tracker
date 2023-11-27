--liquibase formatted sql
--changeset package_body_script:svt_stds_types_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body svt_stds_types_api as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_stds_types_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-10 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';

  function insert_typ (
       p_id               in svt_stds_types.id%type default null,
       p_display_sequence in svt_stds_types.display_sequence%type,
       p_type_name        in svt_stds_types.type_name%type,
       p_type_code        in svt_stds_types.type_code%type,
       p_description      in svt_stds_types.description%type,
       p_active_yn        in svt_stds_types.active_yn%type
    ) return svt_stds_types.id%type
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_typ';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  c_id constant svt_stds_types.id%type 
                  := coalesce(p_id, 
                              to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
   
   insert into svt_stds_types
      (
        id,
        display_sequence,
        type_name,
        type_code,
        description,
        active_yn
      )
      values 
      (
        c_id,
        p_display_sequence,
        p_type_name,
        p_type_code,
        p_description,
        p_active_yn
      );

    apex_debug.message(c_debug_template,'c_id', c_id);

    return c_id;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end insert_typ;

  procedure update_typ (
       p_id               in svt_stds_types.id%type,
       p_display_sequence in svt_stds_types.display_sequence%type,
       p_type_name        in svt_stds_types.type_name%type,
       p_type_code        in svt_stds_types.type_code%type,
       p_description      in svt_stds_types.description%type,
       p_active_yn        in svt_stds_types.active_yn%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_typ';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );

    update svt_stds_types
    set display_sequence = p_display_sequence,
        type_name        = p_type_name,
        type_code        = p_type_code,
        description      = p_description,
        active_yn        = p_active_yn
    where id = p_id;

    apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end update_typ;

  procedure delete_typ (
        p_id in svt_stds_types.id%type
    )
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_typ';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_id', p_id
                     );
    delete from  svt_stds_types
    where id = p_id;

    apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end delete_typ;


  function get_type_id (p_type_code in svt_stds_types.type_code%type)
  return svt_stds_types.id%type
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || 'get_type_id';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_id svt_stds_types.id%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_type_code', p_type_code);

    select id 
    into l_id
    from svt_stds_types
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


end svt_stds_types_api;
/
--rollback drop package body svt_stds_types_api;