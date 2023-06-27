--liquibase formatted sql
--changeset comment_script:AST_SUB_REFERENCE_CODES stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_SUB_REFERENCE_CODES.sql
--        Date:  04-Apr-2023 21:07
--     Purpose:  Comment DDL for table AST_SUB_REFERENCE_CODES
--
--------------------------------------------------------------------------------

comment on table AST_SUB_REFERENCE_CODES is q'[]';
comment on column AST_SUB_REFERENCE_CODES.TEST_ID                                       is q'[]';
comment on column AST_SUB_REFERENCE_CODES.FIX                                           is q'[]';
comment on column AST_SUB_REFERENCE_CODES.ID                                            is q'[Primary Key]';
comment on column AST_SUB_REFERENCE_CODES.SUB_CODE                                      is q'[]';
comment on column AST_SUB_REFERENCE_CODES.EXPLANATION                                   is q'[]';
comment on column AST_SUB_REFERENCE_CODES.CREATED                                       is q'[The date the record was created]';
comment on column AST_SUB_REFERENCE_CODES.CREATED_BY                                    is q'[The user who created the record]';
comment on column AST_SUB_REFERENCE_CODES.UPDATED                                       is q'[The date the record was updated]';
comment on column AST_SUB_REFERENCE_CODES.UPDATED_BY                                    is q'[The user who updated the record]';

