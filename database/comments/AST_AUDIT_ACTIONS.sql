--liquibase formatted sql
--changeset comment_script:SVT_AUDIT_ACTIONS stripComments:false 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_AUDIT_ACTIONS.sql
--        Date:  04-Apr-2023 19:48
--     Purpose:  Comment DDL for table SVT_AUDIT_ACTIONS
--
--------------------------------------------------------------------------------

comment on table SVT_AUDIT_ACTIONS is q'[list of actions that can be assigned to a given standard violation]';
comment on column SVT_AUDIT_ACTIONS.ID                                            is q'[Primary Key]';
comment on column SVT_AUDIT_ACTIONS.ACTION_NAME                                   is q'[the action chosen for a given standard violation]';
comment on column SVT_AUDIT_ACTIONS.CREATED                                       is q'[The date the record was created]';
comment on column SVT_AUDIT_ACTIONS.CREATED_BY                                    is q'[The user who created the record]';
comment on column SVT_AUDIT_ACTIONS.UPDATED                                       is q'[The date the record was updated]';
comment on column SVT_AUDIT_ACTIONS.UPDATED_BY                                    is q'[The user who updated the record]';

