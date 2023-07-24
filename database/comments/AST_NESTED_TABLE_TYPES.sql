--liquibase formatted sql
--changeset comment_script:SVT_NESTED_TABLE_TYPES stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_NESTED_TABLE_TYPES.sql
--        Date:  04-Apr-2023 19:50
--     Purpose:  Comment DDL for table SVT_NESTED_TABLE_TYPES
--
--------------------------------------------------------------------------------

comment on table SVT_NESTED_TABLE_TYPES is q'[Library of available Nested Tables]';
comment on column SVT_NESTED_TABLE_TYPES.OBJECT_TYPE                                   is q'[]';
comment on column SVT_NESTED_TABLE_TYPES.ID                                            is q'[Primary Key]';
comment on column SVT_NESTED_TABLE_TYPES.NT_NAME                                       is q'[]';
comment on column SVT_NESTED_TABLE_TYPES.EXAMPLE_QUERY                                 is q'[]';
comment on column SVT_NESTED_TABLE_TYPES.CREATED                                       is q'[The date the record was created]';
comment on column SVT_NESTED_TABLE_TYPES.CREATED_BY                                    is q'[The user who created the record]';
comment on column SVT_NESTED_TABLE_TYPES.UPDATED                                       is q'[The date the record was udpated]';
comment on column SVT_NESTED_TABLE_TYPES.UPDATED_BY                                    is q'[The user who updated the record]';

