--liquibase formatted sql
--changeset comment_script:EBA_STDS_STANDARD_STATUSES stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_STATUSES.sql
--        Date:  04-Apr-2023 22:01
--     Purpose:  Comment DDL for table EBA_STDS_STANDARD_STATUSES
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_STANDARD_STATUSES is q'[]';
comment on column EBA_STDS_STANDARD_STATUSES.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_STANDARD_STATUSES.STANDARD_ID                                   is q'[]';
comment on column EBA_STDS_STANDARD_STATUSES.APPLICATION_ID                                is q'[]';
comment on column EBA_STDS_STANDARD_STATUSES.TEST_ID                                       is q'[]';
comment on column EBA_STDS_STANDARD_STATUSES.PASS_FAIL_PCT                                 is q'[]';
comment on column EBA_STDS_STANDARD_STATUSES.TEST_DURATION                                 is q'[]';
comment on column EBA_STDS_STANDARD_STATUSES.UPDATED                                       is q'[The date the record was updated]';

