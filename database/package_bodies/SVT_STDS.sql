--liquibase formatted sql
--changeset package_body_script:SVT_STDS stripComments:false endDelimiter:/ runOnChange:true
create or replace package body svt_stds as

    gc_scope_prefix constant varchar2(32) := lower($$plsql_unit) || '.';
    gc_y constant varchar2(1) := 'Y';
    gc_n constant varchar2(1) := 'N';

    -------------------------------------------------------------------------
    -- Generates a unique Identifier
    -------------------------------------------------------------------------
    function gen_id return number is
    begin
        return to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end gen_id;
    -------------------------------------------------------------------------
    -- Handle the process of registering the scheduled job.
    -------------------------------------------------------------------------
    procedure register_job is
        l_app_id number;
        l_stmt varchar2(1000);
    begin
        l_app_id := coalesce(wwv_flow_application_install.get_application_id,v('FB_FLOW_ID'));
        l_stmt := q'[begin #PKG#.create_job( job_name => 'SVT_STDS_TEST_UPD_JOB', ]'
            ||q'[job_type => 'PLSQL_BLOCK', job_action => 'svt_stds_parser.update_standard_status;', ]'
            ||q'[repeat_interval => 'FREQ=DAILY;interval=1', enabled => TRUE); end;]';
        for c1 in ( select object_name
                    from sys.all_objects
                    where object_name in ('DBMS_SCHEDULER', 'CLOUD_SCHEDULER')
                        and object_type = 'PACKAGE'
                    order by object_name desc ) loop
            execute immediate replace(l_stmt, '#PKG#',
                sys.dbms_assert.enquote_name(c1.object_name, false));
            return;
        end loop;
    end register_job;


    function get_standard_id (p_standard_name in svt_stds_standards.standard_name%type)
    return svt_stds_standards.id%type
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_standard_id';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    l_id svt_stds_standards.id%type;
    begin
        apex_debug.message(c_debug_template,'START', 'p_standard_name', p_standard_name);

        select id
        into l_id 
        from svt_stds_standards
        where upper(standard_name) =  upper(p_standard_name);

        return l_id;

    exception when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end get_standard_id;

    function get_mv_dependency(p_test_code in svt_stds_standard_tests.test_code%type) 
    return svt_stds_standard_tests.mv_dependency%type
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_mv_dependency';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_mv_dependency svt_stds_standard_tests.mv_dependency%type;
    begin
      apex_debug.message(c_debug_template,'START', 'p_test_code', p_test_code);

      select mv_dependency 
      into l_mv_dependency
      from svt_stds_standard_tests
      where test_code = p_test_code;

      return l_mv_dependency;
    
    exception
        when no_data_found then
            return null;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end get_mv_dependency;

    function display_initialize_button (
        p_test_code     in svt_plsql_apex_audit.test_code%type,
        p_level_id      in svt_standards_urgency_level.id%type
    ) return boolean
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'display_initialize_button';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_display boolean := false;
    l_issue_count pls_integer;
    l_standard_count pls_integer;
    l_urgent_yn varchar2(1);
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_test_code', p_test_code,
                                            'p_level_id', p_level_id
                                            );
        select count(1)
        into l_issue_count
        from svt_plsql_apex_audit
        where test_code = p_test_code;

        select count(1)
        into l_standard_count
        from svt_stds_standard_tests
        where test_code = p_test_code
        and active_yn = gc_y;

        select case when urgency_level <= 100
                then gc_y
                else gc_n
                end 
        into l_urgent_yn
        from svt_standards_urgency_level
        where id = p_level_id;

        if l_issue_count = 0 
        and l_standard_count  = 1 
        and l_urgent_yn = gc_y
        then
            l_display := true;
        else 
            l_display := false;
        end if;
        
        return l_display;
    
    exception
        when no_data_found then
            l_display := false;
            return l_display;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end display_initialize_button;


    function close_test_modal (p_request   in varchar2,
                               p_test_code in svt_plsql_apex_audit.test_code%type,
                               p_level_id  in svt_standards_urgency_level.id%type
    ) return boolean
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'close_test_modal';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_request', p_request,
                                            'p_test_code', p_test_code,
                                            'p_level_id', p_level_id);
    
        return case when p_request in ('DELETE')
                    then true
                    when p_request in ('CREATE')
                    then false
                    when p_request in ('SAVE') 
                    and display_initialize_button (
                            p_test_code  => p_test_code,
                            p_level_id   => p_level_id
                        )
                    then false
                    else false
                    end;
    exception
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end close_test_modal;

    function file_name (p_standard_name in svt_stds_standards.standard_name%type)
    return svt_stds_standards.standard_name%type
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'file_name';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START', 'p_standard_name', p_standard_name);

        return upper(
                     replace(
                        regexp_replace(p_standard_name,'[[:punct:]]')
                                                , ' ', '_'
                            )
                    );

    exception when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end file_name;

end svt_stds;
/

--rollback drop package SVT_STDS;
