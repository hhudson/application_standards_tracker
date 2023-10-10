--liquibase formatted sql
--changeset package_body_script:eba_stds_inherited_tests_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body eba_stds_inherited_tests_api as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   eba_stds_inherited_tests_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  procedure inherit_test (
    p_test_id            in eba_stds_inherited_tests.test_id%type,
    p_standard_id        in eba_stds_inherited_tests.standard_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'inherit_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_parent_standard_id eba_stds_standard_tests.standard_id%type;
  c_sysdate constant eba_stds_inherited_tests.updated%type := sysdate;
  c_user    constant eba_stds_inherited_tests.updated_by%type 
                     := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_id', p_test_id,
                                        'p_standard_id', p_standard_id
                                        );

    l_parent_standard_id := eba_stds_standard_tests_api.get_standard_id (p_test_id => p_test_id);

    insert into eba_stds_inherited_tests 
           (parent_standard_id,
           test_id,
           standard_id,
           created,
           created_by,
           updated,
           updated_by)
    values (l_parent_standard_id, 
            p_test_id, 
            p_standard_id,
            c_sysdate,
            c_user,
            c_sysdate,
            c_user
            );

    apex_debug.message(c_debug_template, 'inserted : ', sql%rowcount);

  exception
    when dup_val_on_index then
      apex_debug.message(c_debug_template, 'dup_val_on_index : ', p_test_id, p_standard_id);
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end inherit_test;

  procedure disinherit (
    p_test_id            in eba_stds_inherited_tests.test_id%type,
    p_standard_id        in eba_stds_inherited_tests.standard_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'disinherit';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_test_id', p_test_id,
                                        'p_standard_id', p_standard_id);
    
    delete from eba_stds_inherited_tests
    where test_id = p_test_id
    and standard_id = p_standard_id;

    apex_debug.message(c_debug_template, 'deleted : ', sql%rowcount);
  
  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end disinherit;

  procedure delete_std (p_standard_id  in eba_stds_inherited_tests.standard_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_std';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);

    delete from eba_stds_inherited_tests
    where standard_id = p_standard_id;

    apex_debug.message(c_debug_template, 'deleted records : ', sql%rowcount);
  
  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_std;

  procedure delete_test (p_test_id  in eba_stds_inherited_tests.test_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_test';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_test_id', p_test_id);

    delete from eba_stds_inherited_tests
    where test_id = p_test_id;

    apex_debug.message(c_debug_template, 'deleted records : ', sql%rowcount);
  
  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end delete_test;

  procedure bulk_add(p_test_ids    in varchar2,
                     p_standard_id in eba_stds_inherited_tests.standard_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_add';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);

     for rec in (select column_value test_id
                  from table(apex_string.split(p_test_ids, ':'))
                )
    loop
      inherit_test (
          p_test_id            => rec.test_id,
          p_standard_id        => p_standard_id
      );
    end loop;
  
  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end bulk_add;

  procedure bulk_remove(p_test_ids    in varchar2,
                        p_standard_id in eba_stds_inherited_tests.standard_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'bulk_remove';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);

     for rec in (select column_value test_id
                  from table(apex_string.split(p_test_ids, ':'))
                )
    loop
      disinherit (
          p_test_id            => rec.test_id,
          p_standard_id        => p_standard_id
      );
    end loop;
  
  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end bulk_remove;

  procedure inherit_all(
                p_parent_standard_id in eba_stds_inherited_tests.parent_standard_id%type,
                p_standard_id        in eba_stds_inherited_tests.standard_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'inherit_all';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_parent_standard_id', p_parent_standard_id,
                                        'p_standard_id', p_standard_id);
    if p_parent_standard_id is null then 
      apex_debug.message(c_debug_template,'p_parent_standard_id is null');
    elsif p_standard_id is null then 
      apex_debug.message(c_debug_template,'p_standard_id is null');
    else 
      for rec in (select test_id
                  from eba_stds_standard_tests_api.v_eba_stds_standard_tests(
                            p_standard_id => p_parent_standard_id
                        ) 
                  )
      loop
        inherit_test (
            p_test_id            => rec.test_id,
            p_standard_id        => p_standard_id
        );
      end loop;
    end if;

  exception  when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end inherit_all;



end eba_stds_inherited_tests_api;
/
--rollback drop package body eba_stds_inherited_tests_api;