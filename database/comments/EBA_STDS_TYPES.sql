--liquibase formatted sql
--changeset comment_script:EBA_STDS_TYPES stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_TYPES.sql
--        Date:  04-Apr-2023 22:13
--     Purpose:  Comment DDL for table EBA_STDS_TYPES
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_TYPES is q'[]';
comment on column EBA_STDS_TYPES.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_TYPES.DISPLAY_SEQUENCE                              is q'[]';
comment on column EBA_STDS_TYPES.NAME                                          is q'[]';
comment on column EBA_STDS_TYPES.DESCRIPTION                                   is q'[]';

