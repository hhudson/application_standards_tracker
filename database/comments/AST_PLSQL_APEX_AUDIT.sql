--liquibase formatted sql
--changeset comment_script:AST_PLSQL_APEX_AUDIT stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  AST_PLSQL_APEX_AUDIT.sql
--        Date:  04-Apr-2023 19:52
--     Purpose:  Comment DDL for table AST_PLSQL_APEX_AUDIT
--
--------------------------------------------------------------------------------

comment on table AST_PLSQL_APEX_AUDIT is q'[table to capture standard violations (merged into from V_AST_PLSQL_APEX_ALL)]';
comment on column AST_PLSQL_APEX_AUDIT.UNQID                                         is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.LEGACY_YN                                     is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.OWNER                                         is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.STANDARD_CODE                                 is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.CHILD_CODE                                    is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.ID                                            is q'[Primary Key]';
comment on column AST_PLSQL_APEX_AUDIT.REFERENCE_CODE                                is q'[references AST_STANDARDS_REFERENCE_CODES]';
comment on column AST_PLSQL_APEX_AUDIT.ISSUE_CATEGORY                                is q'[APEX/SERT/PLSQL]';
comment on column AST_PLSQL_APEX_AUDIT.APPLICATION_ID                                is q'[apex application id]';
comment on column AST_PLSQL_APEX_AUDIT.APPLICATION_NAME                              is q'[apex application name]';
comment on column AST_PLSQL_APEX_AUDIT.PAGE_ID                                       is q'[the apex page where the violation occurred]';
comment on column AST_PLSQL_APEX_AUDIT.PASS_YN                                       is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.LINE                                          is q'[the line number in source code]';
comment on column AST_PLSQL_APEX_AUDIT.OBJECT_NAME                                   is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.OBJECT_TYPE                                   is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.CODE                                          is q'[only for PLSQL]';
comment on column AST_PLSQL_APEX_AUDIT.VALIDATION_FAILURE_MESSAGE                    is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.APEX_CREATED_BY                               is q'[points to apex audit cols]';
comment on column AST_PLSQL_APEX_AUDIT.APEX_CREATED_ON                               is q'[points to apex audit cols]';
comment on column AST_PLSQL_APEX_AUDIT.APEX_LAST_UPDATED_BY                          is q'[points to apex audit cols]';
comment on column AST_PLSQL_APEX_AUDIT.APEX_LAST_UPDATED_ON                          is q'[points to apex audit cols]';
comment on column AST_PLSQL_APEX_AUDIT.ASSIGNEE                                      is q'[to whom the resolution of the standard violation is assigned]';
comment on column AST_PLSQL_APEX_AUDIT.NOTES                                         is q'[notes on issue resolution]';
comment on column AST_PLSQL_APEX_AUDIT.CREATED                                       is q'[The date the record was created]';
comment on column AST_PLSQL_APEX_AUDIT.CREATED_BY                                    is q'[The user who created the record]';
comment on column AST_PLSQL_APEX_AUDIT.UPDATED                                       is q'[The date the record was udpated]';
comment on column AST_PLSQL_APEX_AUDIT.UPDATED_BY                                    is q'[The user who updated the record]';
comment on column AST_PLSQL_APEX_AUDIT.ACTION_ID                                     is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.APEX_ISSUE_ID                                 is q'[]';
comment on column AST_PLSQL_APEX_AUDIT.ISSUE_TITLE                                   is q'[Issue title, not always unique]';
comment on column AST_PLSQL_APEX_AUDIT.APEX_ISSUE_TITLE_SUFFIX                       is q'[suffix to make issue title unique]';

