--liquibase formatted sql
--changeset package_script:SVT_STDS_NOTIFICATIONS_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_STDS_NOTIFICATIONS_API
--------------------------------------------------------

create or replace package SVT_STDS_NOTIFICATIONS_API authid definer as
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
/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P31_ID := svt_stds_notifications_api.insert_ntf (
                    p_notification_name        => :P31_NOTIFICATION_NAME,
                    p_notification_description => :P31_NOTIFICATION_DESCRIPTION,
                    p_notification_type        => :P31_NOTIFICATION_TYPE,
                    p_display_sequence         => :P31_DISPLAY_SEQUENCE,
                    p_display_from             => :P31_DISPLAY_FROM,
                    p_display_until            => :P31_DISPLAY_UNTIL
                );
    when 'U' then
      svt_stds_notifications_api.update_ntf(
            p_id                       => :P31_ID,
            p_notification_name        => :P31_NOTIFICATION_NAME,
            p_notification_description => :P31_NOTIFICATION_DESCRIPTION,
            p_notification_type        => :P31_NOTIFICATION_TYPE,
            p_display_sequence         => :P31_DISPLAY_SEQUENCE,
            p_display_from             => :P31_DISPLAY_FROM,
            p_display_until            => :P31_DISPLAY_UNTIL
        );
    when 'D' then
      svt_stds_notifications_api.delete_ntf(p_id => :P31_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to insert records into SVT_STDS_NOTIFICATIONS
--
------------------------------------------------------------------------------
    function insert_ntf (
       p_id                       in svt_stds_notifications.id%type default null,
       p_notification_name        in svt_stds_notifications.notification_name%type,
       p_notification_description in svt_stds_notifications.notification_description%type,
       p_notification_type        in svt_stds_notifications.notification_type%type,
       p_display_sequence         in svt_stds_notifications.display_sequence%type,
       p_display_from             in svt_stds_notifications.display_from%type,
       p_display_until            in svt_stds_notifications.display_until%type
    ) return svt_stds_notifications.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to update records into SVT_STDS_NOTIFICATIONS
--
------------------------------------------------------------------------------
    procedure update_ntf (
       p_id                       in svt_stds_notifications.id%type,
       p_notification_name        in svt_stds_notifications.notification_name%type,
       p_notification_description in svt_stds_notifications.notification_description%type,
       p_notification_type        in svt_stds_notifications.notification_type%type,
       p_display_sequence         in svt_stds_notifications.display_sequence%type,
       p_display_from             in svt_stds_notifications.display_from%type,
       p_display_until            in svt_stds_notifications.display_until%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-10
-- Synopsis:
--
-- Procedure to delete records into SVT_STDS_NOTIFICATIONS
--
------------------------------------------------------------------------------
    procedure delete_ntf (
        p_id in svt_stds_notifications.id%type
    );


end SVT_STDS_NOTIFICATIONS_API;
/
--rollback drop package SVT_STDS_NOTIFICATIONS_API;
