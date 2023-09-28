--liquibase formatted sql
--changeset package_script:SVT_AUDIT_ON_AUDIT_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_AUDIT_ON_AUDIT_API
--------------------------------------------------------

create or replace package SVT_AUDIT_ON_AUDIT_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_ON_AUDIT_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Sep-28 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: September 28, 2023
-- Synopsis:
--
-- Procedure to insert a record in  svt_audit_on_audit
--
/*
    svt_audit_on_audit_api.insert_rec (
        p_unqid                      => p_unqid,
        p_action_name                => 'INSERT',
        p_test_code                  => p_test_code,
        p_audit_id                   => p_audit_id,
        p_validation_failure_message => p_validation_failure_message
    );
*/
------------------------------------------------------------------------------
    procedure insert_rec (
        p_unqid                      in svt_audit_on_audit.unqid%type,
        p_action_name                in svt_audit_on_audit.action_name%type,
        p_test_code                  in svt_audit_on_audit.test_code%type,
        p_audit_id                   in svt_audit_on_audit.audit_id%type,
        p_validation_failure_message in svt_audit_on_audit.validation_failure_message%type
    );

end SVT_AUDIT_ON_AUDIT_API;
/
--rollback drop package SVT_AUDIT_ON_AUDIT_API;
