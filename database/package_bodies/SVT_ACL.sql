--liquibase formatted sql
--changeset package_body_script:SVT_ACL_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_ACL as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_ACL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-28 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';
  gc_y constant varchar2(1) := 'Y';
  gc_n constant varchar2(1) := 'N';
  gc_admin constant varchar2(50) := 'ADMINISTRATOR';

  procedure add_admin (p_user_name      in apex_workspace_developers.user_name%type,
                       p_application_id in apex_applications.application_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'add_admin';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_user_name', p_user_name,
                                       'p_application_id', p_application_id
                     );
   
   apex_acl.add_user_role (
            p_application_id => p_application_id,
            p_user_name      => p_user_name,
            p_role_static_id => gc_admin);
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end add_admin;

  procedure add_contributor (p_user_name      in apex_workspace_developers.user_name%type,
                             p_application_id in apex_applications.application_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'add_contributor';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_user_name', p_user_name,
                                       'p_application_id', p_application_id
                     );
   
   apex_acl.add_user_role (
            p_application_id => p_application_id,
            p_user_name      => p_user_name,
            p_role_static_id => 'CONTRIBUTOR');
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end add_contributor;
  
  procedure add_reader (p_user_name      in apex_workspace_developers.user_name%type,
                        p_application_id in apex_applications.application_id%type)
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'add_reader';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_user_name', p_user_name,
                                       'p_application_id', p_application_id
                     );
   
   apex_acl.add_user_role (
            p_application_id => p_application_id,
            p_user_name      => p_user_name,
            p_role_static_id => 'READER');
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end add_reader;

  procedure add_awd_users (p_application_id in apex_applications.application_id%type default null)
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || 'add_awd_users';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_application_id constant apex_applications.application_id%type
                   := coalesce(p_application_id, svt_apex_view.gc_svt_app_id);
  begin
    apex_debug.message(c_debug_template,'START');

    for rec in (select user_name
                from apex_workspace_developers
                where workspace_name = svt_preferences.get('SVT_WORKSPACE')
                )
    loop
      add_reader (p_user_name  => rec.user_name,
                  p_application_id => c_application_id);
    end loop;

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end add_awd_users;

  procedure add_default_admin(p_user_name      in apex_workspace_developers.user_name%type,
                              p_application_id in apex_applications.application_id%type)
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'add_default_admin';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_admin_exists_yn varchar2(1) := gc_y;
  begin
   apex_debug.message(c_debug_template,'START',
                                       'p_user_name', p_user_name,
                                       'p_application_id', p_application_id
                     );
   
    select case when count(*) = 1
                then gc_y
                else gc_n
                end into l_admin_exists_yn
        from sys.dual where exists (
            select 1
            from apex_appl_acl_users
            where application_id = p_application_id
            and upper(role_names) like '%'||gc_admin||'%'
        );

   if l_admin_exists_yn = gc_n then
      add_reader (p_user_name       => p_user_name,
                  p_application_id  => p_application_id);
      add_contributor (p_user_name       => p_user_name,
                        p_application_id  => p_application_id);
      add_admin (p_user_name       => p_user_name,
                 p_application_id  => p_application_id);
   end if;
   
  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end add_default_admin;
    


end SVT_ACL;
/
--rollback drop package body SVT_ACL;