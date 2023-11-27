--liquibase formatted sql
--changeset comment_script:SVT_STDS_STANDARD_TESTS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STDS_STANDARD_TESTS.sql
--        Date:  10-Apr-2023 16:02
--     Purpose:  Comment DDL for table SVT_STDS_STANDARD_TESTS
--
--------------------------------------------------------------------------------

comment on table SVT_STDS_STANDARD_TESTS is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.ID                                            is q'[Primary Key]';
comment on column SVT_STDS_STANDARD_TESTS.STANDARD_ID                                   is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.TEST_NAME                                     is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.DISPLAY_SEQUENCE                              is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.FAILURE_HELP_TEXT                             is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.CREATED                                       is q'[The date the record was created]';
comment on column SVT_STDS_STANDARD_TESTS.CREATED_BY                                    is q'[The user who created the record]';
comment on column SVT_STDS_STANDARD_TESTS.UPDATED                                       is q'[The date the record was updated]';
comment on column SVT_STDS_STANDARD_TESTS.UPDATED_BY                                    is q'[The user who updated the record]';
comment on column SVT_STDS_STANDARD_TESTS.TEST_CODE                                     is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.ACTIVE_YN                                     is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.NT_TYPE_ID                                    is q'[refs SVT_NESTED_TABLE_TYPES.id]';
comment on column SVT_STDS_STANDARD_TESTS.SRC                                           is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.LEVEL_ID                                      is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.QUERY_CLOB                                    is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.OWNER                                         is q'[]';
comment on column SVT_STDS_STANDARD_TESTS.AVG_EXCTN_SCNDS                               is q'[the average amount of time it takes to run the job]';

