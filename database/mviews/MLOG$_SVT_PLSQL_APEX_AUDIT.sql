--liquibase formatted sql
--changeset mview_script:MLOG$_SVT_PLSQL_APEX_AUDIT stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_mview_logs where master = 'SVT_PLSQL_APEX_AUDIT';
--------------------------------------------------------
--  DDL for Materialized view LOG MLOG$_SVT_PLSQL_APEX_AUDIT
--------------------------------------------------------
create materialized view log on svt_plsql_apex_audit
with rowid (assignee)
including new values
/