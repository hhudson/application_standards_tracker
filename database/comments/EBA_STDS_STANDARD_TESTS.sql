--liquibase formatted sql
--changeset comment_script:EBA_STDS_STANDARD_TESTS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_STANDARD_TESTS.sql
--        Date:  10-Apr-2023 16:02
--     Purpose:  Comment DDL for table EBA_STDS_STANDARD_TESTS
--
--------------------------------------------------------------------------------

comment on table EBA_STDS_STANDARD_TESTS is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.ID                                            is q'[Primary Key]';
comment on column EBA_STDS_STANDARD_TESTS.STANDARD_ID                                   is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.TEST_TYPE                                     is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.NAME                                          is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.DISPLAY_SEQUENCE                              is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.COMPONENT_CODE                                is q'[points to ast_component_types.component_code]';
comment on column EBA_STDS_STANDARD_TESTS.FAILURE_HELP_TEXT                             is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.CREATED                                       is q'[The date the record was created]';
comment on column EBA_STDS_STANDARD_TESTS.CREATED_BY                                    is q'[The user who created the record]';
comment on column EBA_STDS_STANDARD_TESTS.UPDATED                                       is q'[The date the record was updated]';
comment on column EBA_STDS_STANDARD_TESTS.UPDATED_BY                                    is q'[The user who updated the record]';
comment on column EBA_STDS_STANDARD_TESTS.STANDARD_CODE                                 is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.ACTIVE_YN                                     is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.NT_TYPE_ID                                    is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.ISSUE_DESC                                    is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.SRC                                           is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.LEVEL_ID                                      is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.QUERY_CLOB                                    is q'[]';
comment on column EBA_STDS_STANDARD_TESTS.OWNER                                         is q'[]';

