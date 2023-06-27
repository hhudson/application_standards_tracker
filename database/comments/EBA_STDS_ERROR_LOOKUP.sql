--liquibase formatted sql
--changeset comment_script:EBA_STDS_ERROR_LOOKUP stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_ERROR_LOOKUP.sql
--        Date:  04-Apr-2023 21:20
--     Purpose:  Comment DDL for table EBA_STDS_ERROR_LOOKUP
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_ERROR_LOOKUP is q'[]';
comment on column EBA_STDS_ERROR_LOOKUP.CONSTRAINT_NAME                               is q'[]';
comment on column EBA_STDS_ERROR_LOOKUP.MESSAGE                                       is q'[]';
comment on column EBA_STDS_ERROR_LOOKUP.LANGUAGE_CODE                                 is q'[]';

