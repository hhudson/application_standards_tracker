--liquibase formatted sql
--changeset comment_script:AST_PLSQL_EXCEPTIONS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_PLSQL_EXCEPTIONS.sql
--        Date:  04-Apr-2023 20:59
--     Purpose:  Comment DDL for table AST_PLSQL_EXCEPTIONS
--
--------------------------------------------------------------------------------

comment on table AST_PLSQL_EXCEPTIONS is q'[]';
comment on column AST_PLSQL_EXCEPTIONS.ID                                            is q'[Primary Key]';
comment on column AST_PLSQL_EXCEPTIONS.REFERENCE_CODE                                is q'[]';
comment on column AST_PLSQL_EXCEPTIONS.FALSE_POSITIVE_YN                             is q'[]';
comment on column AST_PLSQL_EXCEPTIONS.EXPLANATION                                   is q'[]';
comment on column AST_PLSQL_EXCEPTIONS.CREATED                                       is q'[The date the record was created]';
comment on column AST_PLSQL_EXCEPTIONS.CREATED_BY                                    is q'[The user who created the record]';
comment on column AST_PLSQL_EXCEPTIONS.UPDATED                                       is q'[The date the record was updated]';
comment on column AST_PLSQL_EXCEPTIONS.UPDATED_BY                                    is q'[The user who updated the record]';

