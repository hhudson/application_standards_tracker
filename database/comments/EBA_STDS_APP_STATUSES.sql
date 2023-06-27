--liquibase formatted sql
--changeset comment_script:EBA_STDS_APP_STATUSES stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_APP_STATUSES.sql
--        Date:  04-Apr-2023 21:14
--     Purpose:  Comment DDL for table EBA_STDS_APP_STATUSES
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_APP_STATUSES is q'[]';
comment on column EBA_STDS_APP_STATUSES.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_APP_STATUSES.DISPLAY_SEQUENCE                              is q'[]';
comment on column EBA_STDS_APP_STATUSES.NAME                                          is q'[]';
comment on column EBA_STDS_APP_STATUSES.DESCRIPTION                                   is q'[]';

