--liquibase formatted sql
--changeset comment_script:EBA_STDS_USERS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_USERS.sql
--        Date:  04-Apr-2023 21:45
--     Purpose:  Comment DDL for table EBA_STDS_USERS
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_USERS is q'[]';
comment on column EBA_STDS_USERS.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_USERS.USERNAME                                      is q'[]';
comment on column EBA_STDS_USERS.ACCESS_LEVEL_ID                               is q'[]';
comment on column EBA_STDS_USERS.ACCOUNT_LOCKED                                is q'[]';
comment on column EBA_STDS_USERS.ROW_VERSION_NUMBER                            is q'[]';
comment on column EBA_STDS_USERS.CREATED                                       is q'[The date the record was created]';
comment on column EBA_STDS_USERS.CREATED_BY                                    is q'[The user who created the record]';
comment on column EBA_STDS_USERS.UPDATED                                       is q'[The date the record was updated]';
comment on column EBA_STDS_USERS.UPDATED_BY                                    is q'[The user who updated the record]';

