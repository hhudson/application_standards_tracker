--liquibase formatted sql
--changeset comment_script:AST_AUDIT_ON_AUDIT stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_AUDIT_ON_AUDIT.sql
--        Date:  05-Apr-2023 13:58
--     Purpose:  Comment DDL for table AST_AUDIT_ON_AUDIT
--
--------------------------------------------------------------------------------

comment on table AST_AUDIT_ON_AUDIT is q'[]';
comment on column AST_AUDIT_ON_AUDIT.ID                                            is q'[Primary Key]';
comment on column AST_AUDIT_ON_AUDIT.UNQID                                         is q'[]';
comment on column AST_AUDIT_ON_AUDIT.ACTION_NAME                                   is q'[]';
comment on column AST_AUDIT_ON_AUDIT.CREATED                                       is q'[The date the record was created]';
comment on column AST_AUDIT_ON_AUDIT.CREATED_BY                                    is q'[The user who created the record]';

