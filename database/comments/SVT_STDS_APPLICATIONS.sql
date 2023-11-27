--liquibase formatted sql
--changeset comment_script:SVT_STDS_APPLICATIONS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STDS_APPLICATIONS.sql
--        Date:  04-Apr-2023 21:18
--     Purpose:  Comment DDL for table SVT_STDS_APPLICATIONS
--
--------------------------------------------------------------------------------

comment on table SVT_STDS_APPLICATIONS is q'[]';
comment on column SVT_STDS_APPLICATIONS.PK_ID                                         is q'[]';
comment on column SVT_STDS_APPLICATIONS.APEX_APP_ID                                   is q'[]';
comment on column SVT_STDS_APPLICATIONS.ESA_CREATED                                   is q'[]';
comment on column SVT_STDS_APPLICATIONS.ESA_CREATED_BY                                is q'[]';
comment on column SVT_STDS_APPLICATIONS.ESA_UPDATED                                   is q'[]';
comment on column SVT_STDS_APPLICATIONS.ESA_UPDATED_BY                                is q'[]';

