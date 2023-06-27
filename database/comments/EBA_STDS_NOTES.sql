--liquibase formatted sql
--changeset comment_script:EBA_STDS_NOTES stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_NOTES.sql
--        Date:  04-Apr-2023 21:35
--     Purpose:  Comment DDL for table EBA_STDS_NOTES
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_NOTES is q'[]';
comment on column EBA_STDS_NOTES.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_NOTES.APPLICATION_ID                                is q'[]';
comment on column EBA_STDS_NOTES.NOTE                                          is q'[]';
comment on column EBA_STDS_NOTES.ROW_VERSION_NUMBER                            is q'[]';
comment on column EBA_STDS_NOTES.CREATED                                       is q'[The date the record was created]';
comment on column EBA_STDS_NOTES.CREATED_BY                                    is q'[The user who created the record]';
comment on column EBA_STDS_NOTES.UPDATED                                       is q'[The date the record was updated]';
comment on column EBA_STDS_NOTES.UPDATED_BY                                    is q'[The user who updated the record]';

