select * from table(ut.run('ut_ast_create_and_run_tests'));

/
set serveroutput on
set define off
declare
l_view_sql clob;
l_number number;
l_test_id number := 123;
l_bldr_session number := 999;
l_app_id number := 234;
l_application_id number := 345;
l_inner_sql clob := q'[select :test_id,:bldr_session,:app_id,:apppp
            from dual
            ]';
l_inner_sql2 clob := eba_stds_parser.test_results_sql;

begin
l_view_sql := 'begin select count(*) into :l_number from ('||l_inner_sql2||'); end;';
--l_view_sql := replace(l_view_sql, ''||:P19_TEST_ID||'', 123);

execute immediate l_view_sql using in out l_number, l_test_id,l_bldr_session,l_app_id,l_application_id;
dbms_output.put_line(l_view_sql);
dbms_output.put_line(l_number);
end;
/
DECLARE
    l_output    VARCHAR2(10);
BEGIN
    EXECUTE IMMEDIATE 'BEGIN :1 := 5; END;' USING OUT l_output;
    dbms_output.put_line('l_output = ' || l_output);
END;
/
set serveroutput on
declare
l_code varchar2(4000);
l_number number;
l_number2 number:= 3;
begin
l_code := 'select :a from dual';

execute immediate l_code into l_number using l_number2;
dbms_output.put_line(l_number);
end;
/
select apex_string.format(q'[select 'N' pass_fail, %s reference_code, %s as application_id from dual]', :gc_generic_app_id, :gc_generic_app_id)
from dual;
/
select sum(thecount)
from (
select count(*) thecount     from eba_stds_standards 
      where name  = :gc_dummy_name
      union all
      
      select count(*) thecount
      from eba_stds_types
      where name = :gc_dummy_name
      union all
      select count(*) thecount
      from eba_stds_standard_tests 
      where name = :gc_dummy_name
      ) z
/
select apex_string.format('drop view %s;',view_name) thecode
from user_views
where view_name like 'V_XXX_DROP_ME_%';
/
drop view V_XXX_DROP_ME_DB4FFF7626BCDE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF7626BDDE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF7626BEDE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF7626BFDE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF7626C0DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF762724DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF762725DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF762726DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF762727DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF762728DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF76277ADE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF76277BDE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF76277CDE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF76277DDE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF76277EDE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF762787DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF762788DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF762789DE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF76278ADE5BE053FB290A0A1580;
drop view V_XXX_DROP_ME_DB4FFF76278BDE5BE053FB290A0A1580;