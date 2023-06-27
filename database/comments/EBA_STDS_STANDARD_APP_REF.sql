--liquibase formatted sql
--changeset comment_script:EBA_STDS_STANDARD_APP_REF stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_APP_REF.sql
--        Date:  04-Apr-2023 21:40
--     Purpose:  Comment DDL for table EBA_STDS_STANDARD_APP_REF
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_STANDARD_APP_REF is q'[]';
comment on column EBA_STDS_STANDARD_APP_REF.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_STANDARD_APP_REF.STANDARD_ID                                   is q'[]';
comment on column EBA_STDS_STANDARD_APP_REF.APPLICATION_ID                                is q'[]';

