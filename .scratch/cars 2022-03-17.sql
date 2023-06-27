select *
from eba_stds_test_validations
/
commit;
/
/*
eba_stds_parser.assert_exception START p_result_identifier +100:2271831070945160430 p_test_id 290155040291781009737965021596341644792 p_app_id  p_exception_type FALSE_NEGATIVE
eba_stds_parser.assert_exception parse_result_identifier l_params(1) +100 l_params(2) 2271831070945160430 l_app_id 2271831070945160430 l_test_id 290155040291781009737965021596341644792
*/
select * 
from eba_stds_standard_tests
where id  = 290155040291781009737965021596341644792
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
            end as button_link,
            case when t.test_type = 'PASS_FAIL' 
                 then case when tv.false_positive_yn = 'Y' 
                           then 'Marked as Valid '||apex_util.get_since(tv.updated)||' by '||apex_escape.html(tv.updated_by)
                           when s.pass_fail_pct < 100 and nvl(tv.false_positive_yn,'X') <> 'Y' 
                           then 'Mark as Valid'
                           end
                 end as validation_button_message,
            case when t.test_type = 'PASS_FAIL' 
                 then case when tv.false_positive_yn = 'Y' 
                           then
                                'javascript:$s(''P20_VALIDATE'',''-'||t.id||':'||a.apex_app_id||''');'
                           when s.pass_fail_pct < 100 and nvl(tv.false_positive_yn,'X') <> 'Y' 
                           then
                                'javascript:$s(''P20_VALIDATE'',''+'||t.id||':'||a.apex_app_id||''');'
                           end
                 end as validation_javascript
        from 
            eba_stds_standard_statuses s join eba_stds_applications a on a.id = s.application_id
            inner join eba_stds_standard_tests t on t.id = s.test_id and t.standard_id = s.standard_id
            left outer join eba_stds_test_validations tv on s.test_id = tv.test_id and a.apex_app_id = tv.application_id
        where s.application_id = :P20_APPLICATION_ID
            and s.standard_id = :P20_ID
        order by t.display_sequence nulls last, lower(t.name)    
        /
select id, name 
from eba_stds_types
order by display_sequence
/
select * 
from eba_stds_app_statuses