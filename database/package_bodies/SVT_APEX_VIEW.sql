--liquibase formatted sql
--changeset package_body_script:SVT_APEX_VIEW stripComments:false endDelimiter:/ runOnChange:true
create or replace package body SVT_APEX_VIEW as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_apex_view
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Sep-16 - created
---------------------------------------------------------------------------- 

  gc_scope_prefix constant varchar2(31) := lower($$plsql_unit) || '.';


  function apex_applications (p_user in all_users.username%type default null)
  return svt_apex_applications_nt pipelined
  as
    c_scope          constant varchar2(128) := gc_scope_prefix || 'apex_applications';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    c_userenv_current_user constant varchar2(100) :=  sys_context('userenv', 'current_user');

    c_user constant all_users.username%type := coalesce(p_user, 
                                                        case when c_userenv_current_user = 'SVT'
                                                             then svt_ctx_util.get_default_user
                                                             else c_userenv_current_user
                                                             end
                                                        );

    cursor cur_aa
    is
        select  
        workspace,
        application_id, 
        application_name, 
        application_group, 
        availability_status, 
        authorization_scheme, 
        $if oracle_apex_version.version >= 21
        $then 
          created_by, 
          created_on, 
        $else 
          null created_by, 
          null created_on, 
        $end
        last_updated_by, 
        last_updated_on
        from apex_applications
        where owner = c_user;

    type r_aa is record (
      workspace      varchar2(255),
      application_id number,
      application_name varchar2(255 char),
      application_group varchar2(255 char),
      availability_status varchar2(38 char),
      authorization_scheme varchar2(259 char),
      created_by varchar2(255 char),
      created_on date,
      last_updated_by varchar2(255 char),
      last_updated_on date
    );
    type t_aa is table of r_aa index by pls_integer;
    l_aat t_aa;
  begin
    apex_debug.message(c_debug_template,'START', 'c_user', c_user);

    open cur_aa;

    loop
      fetch cur_aa bulk collect into l_aat limit 1000;

      exit when l_aat.count = 0;

      for rec in 1 .. l_aat.count
      loop
        pipe row (svt_apex_applications_ot (
                      l_aat (rec).application_id, 
                      l_aat (rec).application_name, 
                      l_aat (rec).application_group, 
                      l_aat (rec).availability_status, 
                      l_aat (rec).authorization_scheme, 
                      l_aat (rec).created_by, 
                      l_aat (rec).created_on, 
                      l_aat (rec).last_updated_by, 
                      l_aat (rec).last_updated_on,
                      l_aat (rec).workspace
                    )
                );
      end loop;
    end loop;  

  exception
    when no_data_needed then
      apex_debug.message(c_debug_template, 'No data needed');
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
      raise;
  end apex_applications;

  function apex_application_page_ir_col
  return apex_application_page_rpt_cols_nt pipelined
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'apex_application_page_ir_col';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    cursor cur_ir
    is select 
       application_id, 
       page_id, 
       region_name, 
       $if oracle_apex_version.version >= 21
       $then 
         use_as_row_header,
       $else 
         'Yes' use_as_row_header,
       $end
       region_id, 
       created_by,
       created_on,
       updated_by,
       updated_on,
       column_id,
       workspace,
       build_option
    from apex_application_page_ir_col;

    type r_ir is record (
      application_id number,
      page_id number, 
      region_name varchar2(255), 
      use_as_row_header varchar2(3),
      region_id    number, 
      created_by   varchar2(255 char),
      created_on   date,
      updated_by   varchar2(255 char),
      updated_on   date,
      column_id    number,
      workspace    varchar2(255 char),
      build_option varchar2(255 char)
    );
    type t_ir is table of r_ir index by pls_integer;
    l_irt t_ir;

  begin
    apex_debug.message(c_debug_template,'START');

    open cur_ir;

    loop
      fetch cur_ir bulk collect into l_irt limit 1000;

      exit when l_irt.count = 0;

      for rec in 1 .. l_irt.count
      loop
        pipe row (apex_application_page_rpt_cols_ot (
                      l_irt (rec).application_id,
                      l_irt (rec).page_id,
                      l_irt (rec).region_name,
                      l_irt (rec).use_as_row_header,
                      l_irt (rec).region_id,
                      l_irt (rec).created_by,
                      l_irt (rec).created_on,
                      l_irt (rec).updated_by,
                      l_irt (rec).updated_on,
                      l_irt (rec).column_id,
                      l_irt (rec).workspace,
                      l_irt (rec).build_option
                    )
                );
      end loop;
    end loop;  

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end apex_application_page_ir_col;

  function apex_appl_page_ig_columns
  return apex_application_page_rpt_cols_nt pipelined
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'apex_appl_page_ig_columns';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    cursor cur_ig
    is select 
       application_id, 
       page_id, 
       region_name, 
       $if oracle_apex_version.version >= 21
       $then 
         use_as_row_header,
       $else 
         'Yes' use_as_row_header,
       $end
       region_id, 
       null created_by,
       null created_on,
       last_updated_by updated_by,
       last_updated_on updated_on,
       column_id,
       workspace,
       build_option
    from apex_appl_page_ig_columns;

    type r_ig is record (
      application_id number,
      page_id number, 
      region_name varchar2(255), 
      use_as_row_header varchar2(3),
      region_id number, 
      created_by   varchar2(255 char),
      created_on   date,
      updated_by   varchar2(255 char),
      updated_on   date,
      column_id    number,
      workspace    varchar2(255 char),
      build_option varchar2(255 char)
    );
    type t_ig is table of r_ig index by pls_integer;
    l_igt t_ig;

  begin
    apex_debug.message(c_debug_template,'START');

    open cur_ig;

    loop
      fetch cur_ig bulk collect into l_igt limit 1000;

      exit when l_igt.count = 0;

      for rec in 1 .. l_igt.count
      loop
        pipe row (apex_application_page_rpt_cols_ot (
                      l_igt (rec).application_id,
                      l_igt (rec).page_id,
                      l_igt (rec).region_name,
                      l_igt (rec).use_as_row_header,
                      l_igt (rec).region_id,
                      l_igt (rec).created_by,
                      l_igt (rec).created_on,
                      l_igt (rec).updated_by,
                      l_igt (rec).updated_on,
                      l_igt (rec).column_id,
                      l_igt (rec).workspace,
                      l_igt (rec).build_option
                    )
                );
      end loop;
    end loop;  

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;  
  end apex_appl_page_ig_columns;

  function apex_workspace_preferences
  return svt_apex_preferences_nt pipelined
  is 
  c_scope constant varchar2(128) := gc_scope_prefix || 'apex_workspace_preferences';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

  cursor cur_awp
    is select 
       $if oracle_apex_version.version >= 21
       $then 
        workspace_id,
        workspace_name,
        workspace_display_name,
        user_name,
        preference_id,
        preference_name,
        preference_value,
        preference_type,
        preference_comment
        from apex_workspace_preferences
        where preference_name like 'SVT%'
        -- and user_name = 'SVT' --doesn't work with SVT_EMAIL_SUBSCRIPTION
       $else 
        null workspace_id,
        null workspace_name,
        null workspace_display_name,
        'HAYHUDSO' user_name,
        null preference_id,
        'SVT_EMAIL_SUBSCRIPTION' preference_name,
        null preference_value,
        null preference_type,
        null preference_comment
        from dual
       $end
       ;

    type r_awp is record (
      workspace_id           number,      
      workspace_name         varchar2(255),
      workspace_display_name varchar2(4000),
      user_name              varchar2(255),
      preference_id          number, 
      preference_name        varchar2(255),
      preference_value       varchar2(4000),
      preference_type        varchar2(23),
      preference_comment     varchar2(55)
    );
    type t_awp is table of r_awp index by pls_integer;
    l_awp t_awp;
  begin
    apex_debug.message(c_debug_template,'START');

    open cur_awp;

    loop
      fetch cur_awp bulk collect into l_awp limit 1000;

      exit when l_awp.count = 0;

      for rec in 1 .. l_awp.count
      loop
        pipe row (svt_apex_preferences_ot (
                      l_awp (rec).workspace_id,
                      l_awp (rec).workspace_name,
                      l_awp (rec).workspace_display_name,
                      l_awp (rec).user_name,
                      l_awp (rec).preference_id,
                      l_awp (rec).preference_name,
                      l_awp (rec).preference_value,
                      l_awp (rec).preference_type,
                      l_awp (rec).preference_comment
                    )
                );
      end loop;
    end loop;  

  exception when others then
    apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    raise;
  end apex_workspace_preferences;

  function display_position_is_violation (
                p_display_position_code in apex_application_page_buttons.display_position_code%type,
                p_template_id           in apex_application_page_regions.template_id%type,
                p_application_id        in apex_application_temp_region.application_id%type
  ) return varchar2 deterministic
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'display_position_is_violation';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  
  l_template  apex_application_temp_region.template%type;
  l_tags      apex_t_varchar2;
  c_display_position_code constant apex_application_page_buttons.display_position_code%type := upper(p_display_position_code);
  l_exists_in_template_yn varchar2(1) := 'N';
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_display_position_code', p_display_position_code,
                                        'p_template_id',p_template_id);
    
    select atr.template
    into l_template
    from apex_application_temp_region atr 
    where atr.region_template_id = p_template_id
    and atr.application_id = p_application_id;

    l_tags := apex_string_util.find_tags(l_template,'#');

    select case when count(*) = 1
                then 'Y'
                else 'N'
                end into l_exists_in_template_yn
    from sys.dual where exists (
       select 1
       from (select column_value sgmts
            from table(l_tags)) a
            join table(apex_string.split(a.sgmts,'#')) b on b.column_value = c_display_position_code
    );
    
    return case when l_exists_in_template_yn = 'N'
                then case when c_display_position_code in ('RIGHT_OF_IR_SEARCH_BAR',
                                                           'SUB_REGIONS',
                                                           'BODY') -- hard-coded in wwv_flow_property_dev.plb 
                          then 'N'
                          else 'Y'
                          end
                else 'N'
                end;

  exception 
    when no_data_found then
      apex_debug.error(p_message => c_debug_template, p0 =>'Template not found!', p1 => sqlerrm, p2 => p_template_id, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end display_position_is_violation;

  function rpt_link_request(
              p_issue_category   in svt_plsql_apex_audit.issue_category%type,
              p_report_type      in varchar2 default 'IR',
              p_dest_region_name in apex_appl_page_ig_rpts.region_name%type    default null,
              p_dest_page_id     in apex_appl_page_ig_rpts.page_id%type        default null,
              p_application_id   in apex_appl_page_ig_rpts.application_id%type default null
        )
  return varchar2
  as 
  c_scope constant varchar2(128) := gc_scope_prefix || 'rpt_link_request';
  c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
  c_dest_region_name constant apex_appl_page_ig_rpts.region_name%type
                     := coalesce(p_dest_region_name,'Tracking issues report');
  c_dest_page_id     constant apex_appl_page_ig_rpts.page_id%type
                     := coalesce(p_dest_page_id,1);
  c_ir constant varchar2(2) := 'IR';
  c_ig constant varchar2(2) := 'IG';
  c_application_id constant apex_appl_page_ig_rpts.application_id%type
                   := coalesce(p_application_id, v('APP_ID'));
  l_link_request varchar2(50);
  begin
    apex_debug.message(c_debug_template,'START', 
                                        'p_issue_category', p_issue_category,
                                        'p_dest_region_name', p_dest_region_name,
                                        'p_dest_page_id', p_dest_page_id,
                                        'p_report_type', p_report_type);

    if p_report_type = c_ig then

      apex_debug.message(c_debug_template, 'IG Report');
    
      select apex_string.format('%2[%0]_%1', apr.static_id, pir.static_id, c_ig) link_request
      into l_link_request
      from apex_application_page_regions apr
      inner join apex_appl_page_ig_rpts pir on apr.application_id = pir.application_id
                                            and apr.page_id = pir.page_id
                                            and apr.region_id = pir.region_id
      where pir.region_name = c_dest_region_name
      and pir.name is not null
      and pir.type = 'ALTERNATIVE'
      and pir.application_id = c_application_id
      and pir.page_id = c_dest_page_id
      and pir.static_id = p_issue_category
      fetch first 1 rows only;

    else 

      apex_debug.message(c_debug_template, 'IR Report');

      select apex_string.format('%2[%0]_%1', apr.static_id, pir.report_alias, c_ir) link_request
      into l_link_request
      from apex_application_page_regions apr
      inner join apex_application_page_ir_rpt pir on  apr.application_id = pir.application_id
                                                  and apr.page_id = pir.page_id
                                                  and apr.region_id = pir.region_id
      where apr.region_name = c_dest_region_name
      and pir.status = 'PUBLIC'
      and pir.report_name is not null
      and pir.application_id = c_application_id
      and pir.page_id = c_dest_page_id
      and pir.report_alias = p_issue_category
      fetch first 1 rows only;
    end if;

    return l_link_request;

  exception 
    when no_data_found then
      return null;
    when others then
      apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
      raise;
  end rpt_link_request;


end SVT_APEX_VIEW;
/

--rollback drop package SVT_APEX_VIEW;
