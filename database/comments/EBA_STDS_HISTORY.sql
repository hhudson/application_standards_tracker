--liquibase formatted sql
--changeset comment_script:EBA_STDS_HISTORY stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_HISTORY.sql
--        Date:  04-Apr-2023 21:33
--     Purpose:  Comment DDL for table EBA_STDS_HISTORY
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_HISTORY is q'[]';
comment on column EBA_STDS_HISTORY.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_HISTORY.COMPONENT_ID                                  is q'[]';
comment on column EBA_STDS_HISTORY.COMPONENT_ROWKEY                              is q'[]';
comment on column EBA_STDS_HISTORY.TABLE_NAME                                    is q'[]';
comment on column EBA_STDS_HISTORY.COLUMN_NAME                                   is q'[]';
comment on column EBA_STDS_HISTORY.OLD_VALUE                                     is q'[]';
comment on column EBA_STDS_HISTORY.NEW_VALUE                                     is q'[]';
comment on column EBA_STDS_HISTORY.ACTION_DATE                                   is q'[]';
comment on column EBA_STDS_HISTORY.ACTION_BY                                     is q'[]';
comment on column EBA_STDS_HISTORY.ROW_VERSION_NUMBER                            is q'[]';

