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
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  procedure add_awd_users
  as
  c_scope          constant varchar2(128) := gc_scope_prefix || 'add_awd_users';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  begin
    apex_debug.message(c_debug_template,'START');

    for rec in (select user_name
                from apex_workspace_developers
                where workspace_name = svt_preferences.get_preference ('SVT_WORKSPACE')
                )
    loop
      apex_acl.add_user_role (
            p_application_id => svt_apex_view.gc_svt_app_id,
            p_user_name      => rec.user_name,
            p_role_static_id => 'READER');
    end loop;

  exception
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end add_awd_users;


end SVT_ACL;
/
--rollback drop package body SVT_ACL;