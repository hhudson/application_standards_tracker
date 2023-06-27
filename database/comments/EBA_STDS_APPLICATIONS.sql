--liquibase formatted sql
--changeset comment_script:EBA_STDS_APPLICATIONS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_APPLICATIONS.sql
--        Date:  04-Apr-2023 21:18
--     Purpose:  Comment DDL for table EBA_STDS_APPLICATIONS
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_APPLICATIONS is q'[]';
comment on column EBA_STDS_APPLICATIONS.PK_ID                                         is q'[]';
comment on column EBA_STDS_APPLICATIONS.APEX_APP_ID                                   is q'[]';
comment on column EBA_STDS_APPLICATIONS.ESA_CREATED                                   is q'[]';
comment on column EBA_STDS_APPLICATIONS.ESA_CREATED_BY                                is q'[]';
comment on column EBA_STDS_APPLICATIONS.ESA_UPDATED                                   is q'[]';
comment on column EBA_STDS_APPLICATIONS.ESA_UPDATED_BY                                is q'[]';

