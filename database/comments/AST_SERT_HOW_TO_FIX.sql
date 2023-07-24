--liquibase formatted sql
--changeset comment_script:SVT_SERT_HOW_TO_FIX stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_SERT_HOW_TO_FIX.sql
--        Date:  04-Apr-2023 19:54
--     Purpose:  Comment DDL for table SVT_SERT_HOW_TO_FIX
--
--------------------------------------------------------------------------------

comment on table SVT_SERT_HOW_TO_FIX is q'[Guide for how to fix sert standard violations]';
comment on column SVT_SERT_HOW_TO_FIX.SOURCE_INFO_FIX_MD5                           is q'[md5 of sv_sert_apex.sv_sec_attributes info & fix columns]';
comment on column SVT_SERT_HOW_TO_FIX.TEST_ID                                       is q'[]';
comment on column SVT_SERT_HOW_TO_FIX.COLLECTION_NAME                               is q'[]';
comment on column SVT_SERT_HOW_TO_FIX.ID                                            is q'[Primary Key]';
comment on column SVT_SERT_HOW_TO_FIX.ATTRIBUTE_ID                                  is q'[references sv_sert_apex.sv_sec_attributes.attribute_id]';
comment on column SVT_SERT_HOW_TO_FIX.INFO                                          is q'[references sv_sert_apex.sv_sec_attributes.info]';
comment on column SVT_SERT_HOW_TO_FIX.FIX                                           is q'[references sv_sert_apex.sv_sec_attributes.fix]';
comment on column SVT_SERT_HOW_TO_FIX.CREATED                                       is q'[The date the record was created]';
comment on column SVT_SERT_HOW_TO_FIX.CREATED_BY                                    is q'[The user who created the record]';
comment on column SVT_SERT_HOW_TO_FIX.UPDATED                                       is q'[The date the record was udpated]';
comment on column SVT_SERT_HOW_TO_FIX.UPDATED_BY                                    is q'[The user who updated the record]';

