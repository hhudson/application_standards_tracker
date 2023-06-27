SELECT *
FROM apex_200100.apex_debug_messages
WHERE application_id = 261
    AND page_id = 19
    AND message LIKE '%eba_stds_parser.assert_exception%'
ORDER BY message_timestamp DESC
/
select * 
from eba_stds_standard_tests
/
begin
eba_stds_data.load_initial_data();
eba_sts_data.load_sample_data;
end;
/
select * 
from eba_stds_types
/
select * 
from eba_stds_app_statuses
/
select * 
from eba_stds_access_levels
/
select standard_id,
                id test_id,
                test_type,
                name,
                query_view,
                app_bind_variable,
                failure_help_text
            from eba_stds_standard_tests;
/
desc eba_stds_test_validations
/
select case when when ac.c001 = 'N' and tv.false_positive_yn = 'Y'
                                          then '-%1:' ||ac.c002
                                          when ac.c001 = 'N'
                                          then '+%1:'||ac.c002
                                          else ''
                                          end
from dual
/
--eba_stds_parser.test_results_sql START p_test_id 290141158187491859543554358026888179598 p_origin_app_id 100 p_ast_app_id 261 p_page_id 19 p_showonly F
/

select 
case when aap.help_text is null
     then 'N'
     else 'Y'
     end as pass_fail,
apex_string.format('%0:%1', aap.application_id, aap.page_id) reference_code,
aap.application_id,
aap.page_id, 
aap.page_name,
aap.help_text
from apex_application_pages aap
where 1=1
and app.page_id is not null
order by aap.application_id, aap.page_id  
/
declare
 l_query_view  eba_stds_standard_tests.query_view%type;
        begin
          select query_view
            into l_query_view
            from eba_stds_standard_tests st 
            where st.id = :p_test_id;
            end;
/
select * 
from eba_stds_standard_tests
/
select case when length(''''||eba_stds_parser.build_link(  p_test_id        => '290019771628015543158582811403521528177', 
                                    p_application_id => null, 
                                    p_param          => '102:210')||'''') > 2
            then 'there is a link'
            else 'no link'
            end as srgsgsrg,
length(''''||eba_stds_parser.build_link(  p_test_id        => '290019771628015543158582811403521528177', 
                                    p_application_id => null, 
                                    p_param          => '102:210')||'''') sdvsdf
from dual
/
select eba_stds_parser.build_link(  p_test_id        => '290019771628015543158582811403521528177', 
                                    p_application_id => null, 
                                    p_param          => '102:210') thgelink
from dual;
/
select * 
from apex_applications
where application_id = 102
/
select * 
from eba_stds_applications
where apex_app_id = 102
/