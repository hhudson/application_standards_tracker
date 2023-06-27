select * from table(ut.run('ut_ast_create_and_run_tests'));
/
select * 
from eba_stds_standard_tests
/
select * 
from eba_stds_applications
/
select * 
from apex_applications
/
with af as ( select filter_group gp,
                 decode(match_col,'D',filter_display,filter_value) m
             from table( eba_stds_filter2_fw.get_active_filters() )
             where filter_group <> :P16_TEXT_SEARCH_LABEL ),
    tf as ( select filter_value m, upper(filter_value) um
            from table( eba_stds_filter2_fw.get_active_filters() )
            where filter_group = :P16_TEXT_SEARCH_LABEL )
select na.ID,
    na.ROW_KEY,
    ( select application_name from apex_applications aa where aa.application_id = na.apex_app_id ) application_name,
    na.APEX_APP_ID,
    na.STATUS_ID,
    na.TYPE_ID,
    na.PREFIX,
    na.LAST_ADVISOR_DATE,
    na.LAST_SECURITY_DATE
from EBA_STDS_APPLICATIONS na
where ( na.status_id in ( select af.m from af where af.gp = 'Status' )
        or not exists ( select null from af where af.gp = 'Status' ))
    and ( na.type_id in ( select af.m from af where af.gp = 'Type' )
        or not exists ( select null from af where af.gp = 'Type' ))
/
delete 
from eba_stds_test_validations
/
commit;
/
select * 
from eba_stds_standard_tests
/
select std.id,
    std.name standard,
    count( distinct t.id ) tests,
    floor(avg(ss.pass_fail_pct)) completion_std
from eba_stds_standards std
left join eba_stds_standard_tests t on t.standard_id = std.id
left join eba_stds_standard_statuses ss on ss.standard_id = t.standard_id
                                        and ss.test_id    = t.id
group by std.id, std.name
order by 4 asc, upper(std.name)
/
select std.id,
    std.name standard,
    count( distinct ss.test_id ) tests
from eba_stds_standards std
left join eba_stds_standard_tests t on t.standard_id = std.id
group by std.id, std.name