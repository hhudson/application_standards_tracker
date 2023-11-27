--liquibase formatted sql
--changeset view_script:V_SVT_PLSQL_APEX__0 stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--------------------------------------------------------
--  DDL for View v_svt_db_apex__0
-- used in svt_stds_data.merge_audit_tbl to populate the svt_plsql_apex_audit table
--------------------------------------------------------

create or replace force editionable view V_SVT_PLSQL_APEX__0 as
select a.issue_category,
       a.application_id, 
       a.page_id, 
       a.pass_yn, 
       a.line, 
       a.object_name, 
       a.object_type,
       a.code,
       a.validation_failure_message,
       a.issue_title,
       a.apex_created_by, 
       a.apex_created_on, 
       a.apex_last_updated_by, 
       a.apex_last_updated_on,
       esst.test_code,
       a.unqid
from v_svt_stds_standard_tests esst
join svt_standard_view.v_svt(p_test_code        => esst.test_code,
                             p_failures_only        => 'Y',
                             p_urgent_only          => 'Y',
                             p_production_apps_only => 'Y') a
        on  esst.query_clob is not null
        and esst.active_yn = 'Y'
/