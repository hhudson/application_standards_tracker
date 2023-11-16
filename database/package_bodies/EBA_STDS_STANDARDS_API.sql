--liquibase formatted sql
--changeset package_body_script:eba_stds_standards_api_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body eba_stds_standards_api as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   eba_stds_standards_api
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Aug-17 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_localtimestamp constant eba_stds_standards.created%type := localtimestamp;
  gc_user constant eba_stds_standards.created_by%type := coalesce(wwv_flow.g_user,user);

  function insert_std (
    p_standard_name         in eba_stds_standards.standard_name%type,
    p_description           in eba_stds_standards.description%type,
    p_primary_developer     in eba_stds_standards.primary_developer%type,
    p_implementation        in eba_stds_standards.implementation%type,
    p_date_started          in eba_stds_standards.date_started%type,
    p_standard_group        in eba_stds_standards.standard_group%type,
    p_active_yn             in eba_stds_standards.active_yn%type,
    p_compatibility_mode_id in eba_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in eba_stds_standards.parent_standard_id%type
  ) return eba_stds_standards.id%type
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'insert_std';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_id constant eba_stds_standards.id%type := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  c_active_yn constant eba_stds_standards.active_yn%type := coalesce(p_active_yn, 'N');
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_name', p_standard_name);

    insert into eba_stds_standards
    (
      id,
      standard_name,
      description,
      primary_developer,
      implementation,
      date_started,
      standard_group,
      active_yn,
      compatibility_mode_id,
      parent_standard_id,
      created,
      created_by,
      updated,
      updated_by
    )
    values (
      c_id,
      p_standard_name,
      p_description,
      p_primary_developer,
      p_implementation,
      p_date_started,
      p_standard_group,
      c_active_yn,
      p_compatibility_mode_id,
      p_parent_standard_id,
      gc_localtimestamp,
      gc_user,
      gc_localtimestamp,
      gc_user
    );

    eba_stds_inherited_tests_api.inherit_all(
                    p_parent_standard_id => p_parent_standard_id,
                    p_standard_id => c_id
                );

    return c_id;

  exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end insert_std;

  procedure updated_std (
    p_id                    in eba_stds_standards.id%type,
    p_standard_name         in eba_stds_standards.standard_name%type,
    p_description           in eba_stds_standards.description%type,
    p_primary_developer     in eba_stds_standards.primary_developer%type,
    p_implementation        in eba_stds_standards.implementation%type,
    p_date_started          in eba_stds_standards.date_started%type,
    p_standard_group        in eba_stds_standards.standard_group%type,
    p_active_yn             in eba_stds_standards.active_yn%type,
    p_compatibility_mode_id in eba_stds_standards.compatibility_mode_id%type,
    p_parent_standard_id    in eba_stds_standards.parent_standard_id%type
  ) as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'updated_std';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_current_rec eba_stds_standards%rowtype;
  begin
    l_current_rec := eba_stds_standards_api.get_rec (p_standard_id => p_id);

    update eba_stds_standards
    set standard_name         = p_standard_name,
        description           = p_description,
        primary_developer     = p_primary_developer,
        implementation        = p_implementation,
        date_started          = p_date_started,
        standard_group        = p_standard_group,
        active_yn             = p_active_yn,
        compatibility_mode_id = p_compatibility_mode_id,
        parent_standard_id    = p_parent_standard_id,
        updated               = gc_localtimestamp,
        updated_by            = gc_user
    where id = p_id;

    apex_debug.message(c_debug_template, 'updated : ', sql%rowcount);

    if p_parent_standard_id is null 
    and l_current_rec.parent_standard_id is not null 
    then
      eba_stds_inherited_tests_api.delete_std (
                    p_standard_id => p_id,
                    p_former_parent_standard_id => l_current_rec.parent_standard_id);
    end if;

  exception when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end updated_std;

  function get_rec (p_standard_id in eba_stds_standards.id%type)
  return eba_stds_standards%rowtype
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_rec';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_rec eba_stds_standards%rowtype;
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);
    
    select *
    into l_rec
    from eba_stds_standards
    where id = p_standard_id;

    return l_rec;

  exception 
    when no_data_found then
      apex_debug.message(c_debug_template, 'no data found');
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_rec;

  procedure delete_std (p_standard_id in eba_stds_standards.id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'delete_std';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);

    eba_stds_inherited_tests_api.delete_std (p_standard_id => p_standard_id);

    delete from eba_stds_standards
    where id = p_standard_id;

    apex_debug.message(c_debug_template, 'deleted row : ', sql%rowcount);

  exception 
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end delete_std;

  function get_full_name (p_standard_id in eba_stds_standards.id%type)
  return eba_stds_standards.standard_name%type
  deterministic
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'get_full_name';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  l_full_name eba_stds_standards.standard_name%type;
  begin
    apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);

    select full_standard_name
    into l_full_name
    from v_eba_stds_standards
    where id = p_standard_id;

    return l_full_name;

  exception 
    when no_data_found then 
      apex_debug.message(c_debug_template, 'no data found ', p_standard_id);
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end get_full_name;

  procedure update_test_avg_time
  is
  c_scope constant varchar2(128) := gc_scope_prefix || 'update_test_avg_time';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');
    
    merge into eba_stds_standard_tests e
    using (select test_code, avg_seconds from v_svt_test_timing) h
    on (e.test_code = h.test_code)
    when matched then
    update set e.avg_exctn_scnds = h.avg_seconds;

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end update_test_avg_time;


end eba_stds_standards_api;
/
--rollback drop package body eba_stds_standards_api;