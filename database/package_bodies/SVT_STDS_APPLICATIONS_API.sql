--liquibase formatted sql
--changeset package_body_script:SVT_STDS_APPLICATIONS_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_STDS_APPLICATIONS_API as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_APPLICATIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-9 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_standards_urgency_level.created%type := systimestamp;
  gc_user         constant svt_standards_urgency_level.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  gc_y            constant varchar2(1) := 'Y';

  function insert_app (
        p_id                in svt_stds_applications.pk_id%type default null,
        p_apex_app_id       in svt_stds_applications.apex_app_id%type,
        p_default_developer in svt_stds_applications.default_developer%type,
        p_type_id           in svt_stds_applications.type_id%type,
        p_notes             in svt_stds_applications.notes%type,
        p_active_yn         in svt_stds_applications.active_yn%type default 'Y'
    ) return svt_stds_applications.pk_id%type
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'insert_app';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    c_id constant svt_stds_applications.pk_id%type 
                  := coalesce(p_id, 
                              to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id,
                                         'p_apex_app_id', p_apex_app_id,
                                         'p_default_developer', p_default_developer,
                                         'p_type_id', p_type_id,
                                         'p_notes', p_notes,
                                         'p_active_yn', p_active_yn
                       );
      insert into svt_stds_applications
      (
        pk_id,
        apex_app_id,
        default_developer,
        type_id,
        notes,
        active_yn,
        esa_created,
        esa_created_by,
        esa_updated,
        esa_updated_by
      )
      values 
      (
        c_id,
        p_apex_app_id,
        lower(p_default_developer),
        p_type_id,
        p_notes,
        p_active_yn,
        gc_systimestamp,
        gc_user,
        gc_systimestamp,
        gc_user
      );

      apex_debug.message(c_debug_template,'c_id', c_id);

      return c_id;
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end insert_app;

    procedure update_app ( 
        p_id                in svt_stds_applications.pk_id%type,
        p_apex_app_id       in svt_stds_applications.apex_app_id%type,
        p_default_developer in svt_stds_applications.default_developer%type,
        p_type_id           in svt_stds_applications.type_id%type,
        p_notes             in svt_stds_applications.notes%type,
        p_active_yn         in svt_stds_applications.active_yn%type default 'Y'
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'update_app';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );
     update svt_stds_applications
     set apex_app_id       = p_apex_app_id,
         default_developer = p_default_developer,
         type_id           = p_type_id,
         notes             = p_notes,
         active_yn         = p_active_yn
     where pk_id = p_id;

     apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end update_app;

    procedure delete_app (
        p_id in svt_stds_applications.pk_id%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'delete_app';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );
     delete from  svt_stds_applications
     where pk_id = p_id;

     apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);

    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end delete_app;

    function active_app_count return pls_integer
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'active_app_count';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    l_count pls_integer;
    begin
     apex_debug.message(c_debug_template,'START'
                       );
     
     select count(*)
     into l_count
     from v_svt_stds_applications
     where app_active_yn = gc_y
     and type_active_yn = gc_y;

     return l_count;
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end active_app_count;


end SVT_STDS_APPLICATIONS_API;
/
--rollback drop package body SVT_STDS_APPLICATIONS_API;