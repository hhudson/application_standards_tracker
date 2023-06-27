alter package eba_stds_parser_validate_view_ut compile;
alter package EBA_STDS_PARSER compile;
select * from table(ut.run('eba_stds_parser_validate_view_ut'));
/
select * 
from v_ast_db_plsql_all
where object_name = 'EBA_STDS_PARSER_VALIDATE_VIEW_UT'
/
select object_name  
, object_type  
, name
, type
, signature
, line
from user_identifiers  
where     usage = 'DECLARATION'
and type in ('VARIABLE', 'EXCEPTION', 'CONSTANT')
and object_name = 'EBA_STDS_PARSER_VALIDATE_VIEW_UT'
/
select apex_string.format('drop view %s;',view_name) thecode
        from user_views
        where view_name like 'V_XXX_DROP_ME%';
/
alter package ut_ast_create_and_run_tests compile;
select * from table(ut.run('ut_ast_create_and_run_tests'));
/
begin
eba_stds_parser.remove_test_data;  
commit;
end;
/
select count(*) rec_count
      from eba_stds_standards 
      where name  = :g_dummy_name
      union all
      select count(*) rec_count
      from eba_stds_types
      where name = :g_dummy_name
      union all 
      select count(*) rec_count
      from eba_stds_standard_tests 
      where name = :g_dummy_name
      union all
      select count(*) rec_count 
      from eba_stds_applications
      where type_id  = (select id from eba_stds_types where name = :g_dummy_name);
/
drop view V_XXX_DROP_ME_DB99263AC97C11BCE053FB290A0A60B9;
drop view V_XXX_DROP_ME_DB99263AC97D11BCE053FB290A0A60B9;
drop view V_XXX_DROP_ME_DB99263AC97E11BCE053FB290A0A60B9;
drop view V_XXX_DROP_ME_DB99263AC97F11BCE053FB290A0A60B9;
drop view V_XXX_DROP_ME_DB99263AC98011BCE053FB290A0A60B9;
drop view V_XXX_DROP_ME_DB9E9EAFFB013A52E053FB290A0A5ABB;
drop view V_XXX_DROP_ME_DB9E9EAFFB023A52E053FB290A0A5ABB;
drop view V_XXX_DROP_ME_DB9E9EAFFB033A52E053FB290A0A5ABB;
drop view V_XXX_DROP_ME_DB9E9EAFFB043A52E053FB290A0A5ABB;
drop view V_XXX_DROP_ME_DB9E9EAFFB053A52E053FB290A0A5ABB;