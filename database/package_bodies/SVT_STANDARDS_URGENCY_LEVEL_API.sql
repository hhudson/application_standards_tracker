--liquibase formatted sql
--changeset package_body_script:SVT_STANDARDS_URGENCY_LEVEL_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_STANDARDS_URGENCY_LEVEL_API as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STANDARDS_URGENCY_LEVEL_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-9 created
---------------------------------------------------------------------------- 
  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_standards_urgency_level.created%type := systimestamp;
  gc_user         constant svt_standards_urgency_level.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);

  function insert_ul (
        p_id            in svt_standards_urgency_level.id%type default null,
        p_urgency_level in svt_standards_urgency_level.urgency_level%type,
        p_urgency_name  in svt_standards_urgency_level.urgency_name%type
    ) return svt_standards_urgency_level.id%type
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'insert_ul';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    l_id svt_standards_urgency_level.id%type;
    c_id constant svt_standards_urgency_level.id%type 
                  := coalesce(p_id, 
                              to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
    begin
      apex_debug.message(c_debug_template,'START',
                        'p_urgency_level', p_urgency_level,
                        'p_urgency_name', p_urgency_name
                        );

      insert into svt_standards_urgency_level
      (
        id,
        urgency_level,
        urgency_name,
        created,
        created_by,
        updated,
        updated_by
      )
      values 
      (
        c_id,
        p_urgency_level,
        p_urgency_name,
        gc_systimestamp,
        gc_user,
        gc_systimestamp,
        gc_user
      );

      apex_debug.message(c_debug_template,'l_id', l_id);

      return l_id;

    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end insert_ul;

    procedure update_ul (
        p_id            in svt_standards_urgency_level.id%type,
        p_urgency_level in svt_standards_urgency_level.urgency_level%type,
        p_urgency_name  in svt_standards_urgency_level.urgency_name%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'update_ul';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id,
                                         'p_urgency_level', p_urgency_level,
                                         'p_urgency_name', p_urgency_name
                       );

      update svt_standards_urgency_level
      set urgency_level = p_urgency_level,
          urgency_name = p_urgency_name
      where id = p_id;

      apex_debug.info(c_debug_template, 'updated urgency_level', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end update_ul;

    procedure delete_ul (
        p_id in svt_standards_urgency_level.id%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'delete_ul';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );

     delete from svt_standards_urgency_level
     where id = p_id;

     apex_debug.info(c_debug_template, 'deleted urgency_level', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end delete_ul;


end SVT_STANDARDS_URGENCY_LEVEL_API;
/
--rollback drop package body SVT_STANDARDS_URGENCY_LEVEL_API;