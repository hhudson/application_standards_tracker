--liquibase formatted sql
--changeset comment_script:SVT_STANDARDS_URGENCY_LEVEL stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STANDARDS_URGENCY_LEVEL.sql
--        Date:  04-Apr-2023 21:05
--     Purpose:  Comment DDL for table SVT_STANDARDS_URGENCY_LEVEL
--
--------------------------------------------------------------------------------

comment on table SVT_STANDARDS_URGENCY_LEVEL is q'[]';
comment on column SVT_STANDARDS_URGENCY_LEVEL.ID                                            is q'[Primary Key]';
comment on column SVT_STANDARDS_URGENCY_LEVEL.URGENCY_LEVEL                                 is q'[]';
comment on column SVT_STANDARDS_URGENCY_LEVEL.NAME                                          is q'[]';
comment on column SVT_STANDARDS_URGENCY_LEVEL.CREATED                                       is q'[The date the record was created]';
comment on column SVT_STANDARDS_URGENCY_LEVEL.CREATED_BY                                    is q'[The user who created the record]';
comment on column SVT_STANDARDS_URGENCY_LEVEL.UPDATED                                       is q'[The date the record was updated]';
comment on column SVT_STANDARDS_URGENCY_LEVEL.UPDATED_BY                                    is q'[The user who updated the record]';

