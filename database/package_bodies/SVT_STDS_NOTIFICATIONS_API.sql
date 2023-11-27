--liquibase formatted sql
--changeset package_body_script:SVT_STDS_NOTIFICATIONS_API_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_STDS_NOTIFICATIONS_API as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_STDS_NOTIFICATIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-10 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_systimestamp constant svt_standards_urgency_level.created%type := systimestamp;
  gc_user         constant svt_standards_urgency_level.created_by%type := coalesce(sys_context('APEX$SESSION','APP_USER'),user);

    function insert_ntf (
       p_id                       in svt_stds_notifications.id%type default null,
       p_notification_name        in svt_stds_notifications.notification_name%type,
       p_notification_description in svt_stds_notifications.notification_description%type,
       p_notification_type        in svt_stds_notifications.notification_type%type,
       p_display_sequence         in svt_stds_notifications.display_sequence%type,
       p_display_from             in svt_stds_notifications.display_from%type,
       p_display_until            in svt_stds_notifications.display_until%type
    ) return svt_stds_notifications.id%type
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'insert_ntf';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    c_id constant svt_stds_notifications.id%type 
                  := coalesce(p_id, 
                              to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'));
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id,
                                         'p_notification_name', p_notification_name,
                                         'p_notification_description', p_notification_description,
                                         'p_notification_type', p_notification_type,
                                         'p_display_sequence', p_display_sequence,
                                         'p_display_from', p_display_from,
                                         'p_display_until', p_display_until
                       );
                       
     insert into svt_stds_notifications
      (
        id,
        notification_name,
        notification_description,
        notification_type,
        display_sequence,
        display_from,
        display_until,
        row_version_number,
        created,
        created_by,
        updated,
        updated_by
      )
      values 
      (
        c_id,
        p_notification_name,
        p_notification_description,
        p_notification_type,
        p_display_sequence,
        p_display_from,
        p_display_until,
        1,
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
    end insert_ntf;

    procedure update_ntf (
       p_id                       in svt_stds_notifications.id%type,
       p_notification_name        in svt_stds_notifications.notification_name%type,
       p_notification_description in svt_stds_notifications.notification_description%type,
       p_notification_type        in svt_stds_notifications.notification_type%type,
       p_display_sequence         in svt_stds_notifications.display_sequence%type,
       p_display_from             in svt_stds_notifications.display_from%type,
       p_display_until            in svt_stds_notifications.display_until%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'update_ntf';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );

     update svt_stds_notifications
     set notification_name        = p_notification_name,
         notification_description = p_notification_description,
         notification_type        = p_notification_type,
         display_sequence         = p_display_sequence,
         display_from             = p_display_from,
         display_until            = p_display_until,
         row_version_number       = row_version_number + 1
     where id = p_id;

     apex_debug.info(c_debug_template, 'updated :', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end update_ntf;

    procedure delete_ntf (
        p_id in svt_stds_notifications.id%type
    )
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'delete_ntf';
    c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
    begin
     apex_debug.message(c_debug_template,'START',
                                         'p_id', p_id
                       );
     
     delete from svt_stds_notifications
     where id = p_id;

     apex_debug.info(c_debug_template, 'deleted :', sql%rowcount);
     
    exception
     when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
       raise;
    end delete_ntf;


end SVT_STDS_NOTIFICATIONS_API;
/
--rollback drop package body SVT_STDS_NOTIFICATIONS_API;