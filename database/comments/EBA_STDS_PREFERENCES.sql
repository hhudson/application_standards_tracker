--liquibase formatted sql
--changeset comment_script:EBA_STDS_PREFERENCES stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_PREFERENCES.sql
--        Date:  04-Apr-2023 21:38
--     Purpose:  Comment DDL for table EBA_STDS_PREFERENCES
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_PREFERENCES is q'[]';
comment on column EBA_STDS_PREFERENCES.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_PREFERENCES.PREFERENCE_NAME                               is q'[]';
comment on column EBA_STDS_PREFERENCES.PREFERENCE_VALUE                              is q'[]';
comment on column EBA_STDS_PREFERENCES.ROW_VERSION_NUMBER                            is q'[]';
comment on column EBA_STDS_PREFERENCES.CREATED                                       is q'[The date the record was created]';
comment on column EBA_STDS_PREFERENCES.CREATED_BY                                    is q'[The user who created the record]';
comment on column EBA_STDS_PREFERENCES.UPDATED                                       is q'[The date the record was updated]';
comment on column EBA_STDS_PREFERENCES.UPDATED_BY                                    is q'[The user who updated the record]';

