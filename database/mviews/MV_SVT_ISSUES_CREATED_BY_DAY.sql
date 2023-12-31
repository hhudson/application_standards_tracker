--liquibase formatted sql
--changeset mview_script:MV_SVT_ISSUES_CREATED_BY_DAY stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('MV_SVT_ISSUES_CREATED_BY_DAY');
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:  mv_svt_issues_created_by_day.sql
--        Date:  2023-Jun-20
--     Purpose:  Materialized view to evaluate urls from apex metadata.
-- Refreshed by apex automation (2023-May-22)
--
/*
drop materialized view mv_svt_issues_created_by_day;

begin
  dbms_mview.refresh ('MV_SVT_ISSUES_CREATED_BY_DAY');
end;
*/
--------------------------------------------------------------------------------

-- drop materialized view MV_SVT_ISSUES_CREATED_BY_DAY
-- /

create materialized view MV_SVT_ISSUES_CREATED_BY_DAY
    -- refresh complete
    -- start   with sysdate --needs to be refreshed with svt_audit_util.set_workspace
    -- next  (sysdate + 1/24) -- refreshed by apex automation (2023-May-22)
    refresh on demand
    evaluate using current edition
    as
    with std as (select trunc(created) action_date, 
                    action_name, 
                    case when action_name = 'INSERT'
                         then count(*) 
                         else count(*) * -1
                         end quantity
                from svt_audit_on_audit
                group by trunc(created), action_name)
    select action_date, quantity, action_name,
        sum ( quantity ) over ( 
            order by action_date 
            rows unbounded preceding 
        ) cumul_issues
    from   std
/