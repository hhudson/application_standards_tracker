--liquibase formatted sql
--changeset mview_script:MV_SVT_ASSIGNEE_COUNT stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_ASSIGNEE_COUNT');
--------------------------------------------------------
--  DDL for Materialized View MV_SVT_ASSIGNEE_COUNT
--------------------------------------------------------
create materialized view log on svt_plsql_apex_audit
with rowid (assignee)
including new values
/
-- drop materialized view mv_svt_assignee_count
-- /
create materialized view MV_SVT_ASSIGNEE_COUNT
refresh fast on commit
as
select assignee, count(*) assignee_count
from svt_plsql_apex_audit
group by assignee
/