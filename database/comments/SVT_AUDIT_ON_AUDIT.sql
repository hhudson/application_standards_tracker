--liquibase formatted sql
--changeset comment_script:SVT_AUDIT_ON_AUDIT stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_AUDIT_ON_AUDIT.sql
--        Date:  05-Apr-2023 13:58
--     Purpose:  Comment DDL for table SVT_AUDIT_ON_AUDIT
--
--------------------------------------------------------------------------------

comment on table SVT_AUDIT_ON_AUDIT is q'[]';
comment on column SVT_AUDIT_ON_AUDIT.ID                                            is q'[Primary Key]';
comment on column SVT_AUDIT_ON_AUDIT.UNQID                                         is q'[]';
comment on column SVT_AUDIT_ON_AUDIT.ACTION_NAME                                   is q'[]';
comment on column SVT_AUDIT_ON_AUDIT.CREATED                                       is q'[The date the record was created]';
comment on column SVT_AUDIT_ON_AUDIT.CREATED_BY                                    is q'[The user who created the record]';

