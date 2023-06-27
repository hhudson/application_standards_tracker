select * 
from eba_stds_test_validations
/
select * 
from v_ast_apex_accessibility_theme
where application_id  = 112
/
select * 
from apex_applications
where application_id  in (112,261, 101)
/
merge into eba_stds_test_validations dest
                using ( select 
            :l_test_id test_id,
            :l_app_id application_id,
            substr(:p_result_identifier,2) result_identifier
        from dual ) src
on ( dest.test_id = src.test_id
    and dest.application_id = src.application_id
    and dest.result_identifier = src.result_identifier
)
when matched then
update set dest.false_positive_yn = case when :p_exception_type = :g_false_neg
                                         then 'Y'
                                         else dest.false_positive_yn
                                         end,
           dest.legacy_yn = case when :p_exception_type = :g_legacy
                                 then 'Y'
                                 else dest.legacy_yn
                                 end
when not matched then
insert ( test_id    , application_id    , result_identifier    ,   false_positive_yn,  legacy_yn )
values ( src.test_id, src.application_id, src.result_identifier, :l_false_positive_yn,:l_legacy_yn );
/*
eba_stds_parser.assert_exception START p_result_identifier +289000659480371409667981223032034850687:112 p_test_id 289000659480371409667981223032034850687 p_app_id  p_exception_type LEGACY	
eba_stds_parser.assert_exception parse_result_identifier l_params(1) +289000659480371409667981223032034850687 l_params(2) 112 l_app_id 112 l_test_id 289000659480371409667981223032034850687
*/
/
select * 
from eba_stds_test_validations
where test_id = :l_test_id
--and result_identifier = substr(:p_result_identifier,2)
/
select * 
from EBA_STDS_TEST_VALIDATIONS
/
select * 
from EBA_STDS_APPLICATIONS
where 1=1
and apex_app_id = :l_app_id
/
select * 
from user_constraints
where constraint_name = 'EBA_STDS_TEST_VAL_APP_FK'
/
alter table eba_stds_standard_tests add (uses_plscope_yn varchar2(1)
constraint eba_stds_standard_tests_ck2 check( uses_plscope_yn in ('Y','N')))
/
alter table eba_stds_test_validations drop column uses_plscope_yn
/
select USES_PLSCOPE_YN
from eba_stds_standard_tests
/
select * 
from eba_stds_standard_statuses
/
select * 
from V_AST_APEX_APP_AUTH