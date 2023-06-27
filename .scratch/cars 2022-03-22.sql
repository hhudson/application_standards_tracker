select apex_string.format('drop view %0;',lower(view_name)) stmt
from user_views
where (lower(view_name) like '%ast%' ) or  (lower(view_name) like 'v_eba%' )
/
select * from table(ut.run(a_path=>'ut_ast_create_and_run_tests'));
/
declare
gc_dummy_view_base varchar2(50):= 'hhh_';
l_view_name user_views.view_name%type := gc_dummy_view_base||sys_guid();
  l_sql_clob clob;
  l_feedback varchar2(4096);
  l_pass     boolean;
  begin
    
    eba_stds_parser.validate_view( 
        p_view_name => l_view_name,
        p_test_id   => null,
        x_view_sql  => l_sql_clob,
        x_feedback  => l_feedback,
        x_pass      => l_pass);
end;
/
select APEX_LANG.MESSAGE (p_name => 'view_not_in_schema', p_application_id => 261) --, p_lang => 'en', p_application_id => 261) 
from dual
/
begin
for c1 in (select workspace_id
                from apex_workspaces
                where workspace = 'COVID_CARS') 
        loop
            apex_util.set_security_group_id( c1.workspace_id );
            exit;
        end loop;
/*apex_lang.create_message
      (p_application_id  => 261,
       p_name            => 'view_not_in_schema',
       p_language        => 'en',
       p_message_text    => 'test' 
       );*/
end;
/
select workspace_id
from apex_workspaces
where workspace = 'COVID_CARS'
/
select * 
from APEX_DEBUG_MESSAGE
/
select * from table(ut.run(a_path=>'ut_ast_create_and_run_tests'));
/
select * 
from eba_stds_types
/
select * 
from eba_stds_standard_type_ref
/
select * 
from EBA_STDS_APPLICATIONS
/
select * 
from eba_stds_standard_statuses
/
 create or replace view v_xxx_drop_me as select 1 myfield from dual;
 /
 select sys_guid() 
from dual
/
drop view v_xxx_drop_me
/
select * 
from user_views
where view_name like 'V_XXX_DROP%'
/
drop view V_XXX_DROP_ME_DAD347F1C1AD9589E053FB290A0AA9E0