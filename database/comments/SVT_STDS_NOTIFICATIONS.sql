--liquibase formatted sql
--changeset comment_script:SVT_STDS_NOTIFICATIONS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STDS_NOTIFICATIONS.sql
--        Date:  04-Apr-2023 21:36
--     Purpose:  Comment DDL for table SVT_STDS_NOTIFICATIONS
--
--------------------------------------------------------------------------------

comment on table SVT_STDS_NOTIFICATIONS is q'[]';
comment on column SVT_STDS_NOTIFICATIONS.ID                                            is q'[Primary Key]';
comment on column SVT_STDS_NOTIFICATIONS.NOTIFICATION_NAME                             is q'[]';
comment on column SVT_STDS_NOTIFICATIONS.NOTIFICATION_DESCRIPTION                      is q'[]';
comment on column SVT_STDS_NOTIFICATIONS.NOTIFICATION_TYPE                             is q'[]';
comment on column SVT_STDS_NOTIFICATIONS.DISPLAY_SEQUENCE                              is q'[]';
comment on column SVT_STDS_NOTIFICATIONS.DISPLAY_FROM                                  is q'[]';
comment on column SVT_STDS_NOTIFICATIONS.DISPLAY_UNTIL                                 is q'[]';
comment on column SVT_STDS_NOTIFICATIONS.ROW_VERSION_NUMBER                            is q'[]';
comment on column SVT_STDS_NOTIFICATIONS.CREATED                                       is q'[The date the record was created]';
comment on column SVT_STDS_NOTIFICATIONS.CREATED_BY                                    is q'[The user who created the record]';
comment on column SVT_STDS_NOTIFICATIONS.UPDATED                                       is q'[The date the record was updated]';
comment on column SVT_STDS_NOTIFICATIONS.UPDATED_BY                                    is q'[The user who updated the record]';

