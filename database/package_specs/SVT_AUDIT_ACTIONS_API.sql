--liquibase formatted sql
--changeset package_script:SVT_AUDIT_ACTIONS_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_AUDIT_ACTIONS_API
--------------------------------------------------------

create or replace package SVT_AUDIT_ACTIONS_API authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_AUDIT_ACTIONS_API
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-13 - created

/*
begin
  case :APEX$ROW_STATUS
    when 'C' then
      :P56_ID := svt_audit_actions_api.insert_aua (
                    p_action_name          => :P56_ACTION_NAME,
                    p_include_in_report_yn => :P56_INCLUDE_IN_REPORT_YN
                );
    when 'U' then
      svt_audit_actions_api.update_aua (
            p_id                   => :P56_ID,
            p_action_name          => :P56_ACTION_NAME,
            p_include_in_report_yn => :P56_INCLUDE_IN_REPORT_YN
        );
    when 'D' then
      svt_audit_actions_api.delete_aua(p_id => :P56_ID);
  end case;
end;
*/
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to insert records into SVT_AUDIT_ACTIONS
--
------------------------------------------------------------------------------
    function insert_aua (
        p_action_name          in svt_audit_actions.action_name%type,
        p_include_in_report_yn in svt_audit_actions.include_in_report_yn%type
    ) return svt_audit_actions.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to update records into SVT_AUDIT_ACTIONS
--
------------------------------------------------------------------------------
    procedure update_aua (
        p_id                   in svt_audit_actions.id%type,
        p_action_name          in svt_audit_actions.action_name%type,
        p_include_in_report_yn in svt_audit_actions.include_in_report_yn%type
    );

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Nov-13
-- Synopsis:
--
-- Procedure to delete records into SVT_AUDIT_ACTIONS
--
------------------------------------------------------------------------------
    procedure delete_aua (
        p_id in svt_audit_actions.id%type
    );
---------------------------------------------------------------------------- 


end SVT_AUDIT_ACTIONS_API;
/
--rollback drop package SVT_AUDIT_ACTIONS_API;
