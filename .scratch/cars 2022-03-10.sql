select * 
from eba_stds_standard_statuses
/
select t.name test_name,
    s.pass_fail_pct,
    case
        when s.pass_fail_pct is null then
            'The query for this test is invalid.'
        when s.pass_fail_pct < 100 then
            t.failure_help_text
        else
            null
    end as message,
    t.id test_id,
    a.apex_app_id application_id,
    case
        when t.test_type != 'FAIL_REPORT' then
            'display: none;'
        else
            null
    end as report_link_class,
    case when t.test_type = 'PASS_FAIL' then
        case when tv.false_positive_yn = 'Y' then
            '<a href="javascript:$s(''P20_VALIDATE'',''-'||t.id||':'||a.apex_app_id||''');" '
                ||'class="t-Button t-Button--success t-Button--stretch">'
                ||'Marked as Valid</a>'
                ||'<div style="text-align:center">'||apex_util.get_since(tv.updated)
                ||' by '||apex_escape.html(tv.updated_by)||'</div>'
            when s.pass_fail_pct < 100
                and nvl(tv.false_positive_yn,'X') <> 'Y' then
                '<a href="javascript:$s(''P20_VALIDATE'',''+'||t.id||':'||a.apex_app_id||''');" '
                ||'class="t-Button t-Button--stretch">'
                ||'Mark as Valid</a>'
            else '&nbsp;'
        end
        else
            '<a href="'
                ||apex_util.prepare_url('f?p='||:APP_ID||':19:'||:APP_SESSION
                    ||':::19:P19_TEST_ID,P19_APPLICATION_ID:'||t.id||','||a.apex_app_id)
                ||'" class="t-Button t-Button--warning t-Button--stretch">View Report</a>'
    end as button_link
from 
    eba_stds_standard_statuses s join eba_stds_applications a on a.id = s.application_id
    inner join eba_stds_standard_tests t on t.id = s.test_id and t.standard_id = s.standard_id
    left outer join eba_stds_test_validations tv on s.test_id = tv.test_id and a.apex_app_id = tv.application_id
where 
1=1
--and s.application_id = :P20_APPLICATION_ID --289638095879711251021594587741383446889
--and s.standard_id = :P20_ID --289604702854377363590371590292789428649
order by t.display_sequence nulls last, lower(t.name)    
/
select * 
from eba_stds_applications
/
update eba_stds_applications
set type_id = 1
/
commit;
/
insert into eba_stds_types (id, display_sequence, name)
                values (1, 10, 'Default');
            insert into eba_stds_types (id, display_sequence, name)
                values (2, 20, 'Information Technology');
            insert into eba_stds_types (id, display_sequence, name)
                values (3, 30, 'Engineering');
            insert into eba_stds_app_statuses (id, display_sequence, name)
                values (1, 10,'Test Application');
            insert into eba_stds_app_statuses (id, display_sequence, name)
                values (2, 20,'Initial development');
            insert into eba_stds_app_statuses (id, display_sequence, name)
                values (3, 30,'Releasable');
            insert into eba_stds_app_statuses (id, display_sequence, name)
                values (4, 40,'Production');
                /
alter table EBA_STDS_STANDARD_TESTS drop column USES_PLSCOPE_YN;
/
select * 
from EBA_STDS_STANDARD_TESTS
/
begin
    eba_stds_fw.set_preference_value (
        p_preference_name  => 'ACCESS_CONTROL_ENABLED',
        p_preference_value => :P35_AC_ENABLED);
    eba_stds_fw.set_preference_value (
        p_preference_name  => 'ACCESS_CONTROL_SCOPE',
        p_preference_value => (case 
                                   when :P35_AC_ENABLED = 'Y' then :P35_ACCESS_CONTROL_SCOPE --PUBLIC_CONTRIBUTE
                                   else 'ACL_ONLY' 
                               end) );

    -- Seed user table with current user as an administrator or set the current user as administrator
    declare
       l_count number;
    begin
        select count(*) 
            into l_count 
        from eba_stds_users
        where username = :APP_USER;
        if l_count = 0 then
            insert into eba_stds_users(username, access_level_id) values (:APP_USER, 3);   
        else
            update eba_stds_users
            set access_level_id = 3
            where username = :APP_USER;
        end if;
    end;
end;
/
select * 
from eba_stds_users;
/
update eba_stds_users
set username = upper('hayden.h.hudson@oracle.com');
/
commit;
/
begin
eba_stds_parser.validate_view( p_view_name => :P14_QUERY_VIEW,
                               x_view_sql  => :P14_CHECK_SQL,
                               x_feedback  => :P14_FAILURE_HELP_TEXT);
end;
/
select * 
from all_objects
where lower(object_name) like 'hhh%'
/
create table hhh_deleteme (field1 number);