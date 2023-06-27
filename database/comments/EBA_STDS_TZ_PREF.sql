--liquibase formatted sql
--changeset comment_script:EBA_STDS_TZ_PREF stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_TZ_PREF.sql
--        Date:  04-Apr-2023 22:14
--     Purpose:  Comment DDL for table EBA_STDS_TZ_PREF
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_TZ_PREF is q'[]';
comment on column EBA_STDS_TZ_PREF.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_TZ_PREF.USERNAME                                      is q'[]';
comment on column EBA_STDS_TZ_PREF.TIMEZONE_PREFERENCE                           is q'[]';
comment on column EBA_STDS_TZ_PREF.ROW_VERSION_NUMBER                            is q'[]';
comment on column EBA_STDS_TZ_PREF.CREATED                                       is q'[The date the record was created]';
comment on column EBA_STDS_TZ_PREF.CREATED_BY                                    is q'[The user who created the record]';
comment on column EBA_STDS_TZ_PREF.UPDATED                                       is q'[The date the record was updated]';
comment on column EBA_STDS_TZ_PREF.UPDATED_BY                                    is q'[The user who updated the record]';

