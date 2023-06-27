--liquibase formatted sql
--changeset comment_script:EBA_STDS_ACCESS_LEVELS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_ACCESS_LEVELS.sql
--        Date:  04-Apr-2023 21:12
--     Purpose:  Comment DDL for table EBA_STDS_ACCESS_LEVELS
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_ACCESS_LEVELS is q'[]';
comment on column EBA_STDS_ACCESS_LEVELS.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_ACCESS_LEVELS.ACCESS_LEVEL                                  is q'[]';

