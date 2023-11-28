--liquibase formatted sql
--changeset package_body_script:SVT_UTIL_body stripComments:false endDelimiter:/ runOnChange:true

create or replace package body SVT_UTIL as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_UTIL
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Nov-21 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(41) := lower($$plsql_unit) || '.';
  gc_n constant varchar2(1) := 'N';
  gc_y constant varchar2(1) := 'Y';


  function app_name return varchar2
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'app_name';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  c_db_name constant varchar2(100) := svt_preferences.get('SVT_DB_NAME');
  c_app_name constant varchar2(100) := 'Standard Violation Tracker';
  begin
   
   return case when c_db_name is null 
               then c_app_name
               else apex_string.format('[%s] %s', c_db_name, c_app_name)
               end;

  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end app_name;

  function alerts_yn return varchar2
  as
  c_scope constant varchar2(128) := gc_scope_prefix || 'alerts_yn';
  c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7';
  l_alerts_yn varchar2(1) := gc_n;
  begin
   apex_debug.message(c_debug_template,'START');
   
  begin <<missing_data>>
    if l_alerts_yn = gc_n then
      select case when count(*) = 1
                            then 'Y'
                            else 'N'
                            end into l_alerts_yn
                    from sys.dual where exists (
                        select 1 
                        from v_svt_missing_base_data
                    );
    end if;
  end missing_data;

  begin <<disabled_jobs>>
    if l_alerts_yn = gc_n then
      select case when count(*) = 1
                            then 'Y'
                            else 'N'
                            end into l_alerts_yn
                    from sys.dual where exists (
                        select 1
                        from apex_appl_automations
                        where polling_status_code = 'DISABLED'
                        and application_id = v('APP_ID')
                    );
    end if;
  end disabled_jobs;

  begin <<failed_jobs>>
    if l_alerts_yn = gc_n then
      select case when count(*) = 1
                            then 'Y'
                            else 'N'
                            end into l_alerts_yn
                    from sys.dual where exists (
                        select 1 
                        from v_automations_problems
                    );
    end if;
  end failed_jobs;

  begin <<missing_preferences>>
    if l_alerts_yn = gc_n then
      select case when count(*) = 1
                            then 'Y'
                            else 'N'
                            end into l_alerts_yn
                    from sys.dual where exists (
                        select 1 
                        from v_svt_preference_problems
                    );
    end if;
  end missing_preferences;

  begin <<problem_assignments>>
    if l_alerts_yn = gc_n then
      select case when count(*) = 1
                            then 'Y'
                            else 'N'
                            end into l_alerts_yn
                    from sys.dual where exists (
                        select 1 
                        from v_svt_problem_assignees
                    );
    end if;
  end problem_assignments;

  return l_alerts_yn;

  exception
   when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
     raise;
  end alerts_yn;


end SVT_UTIL;
/
--rollback drop package body SVT_UTIL;