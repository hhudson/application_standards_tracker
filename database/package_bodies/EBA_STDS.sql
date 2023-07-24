--liquibase formatted sql
--changeset package_body_script:EBA_STDS stripComments:false endDelimiter:/ runOnChange:true
create or replace package body eba_stds as

    gc_scope_prefix constant varchar2(32) := lower($$plsql_unit) || '.';

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
        l_stmt := q'[begin #PKG#.create_job( job_name => 'EBA_STDS_TEST_UPD_JOB', ]'
            ||q'[job_type => 'PLSQL_BLOCK', job_action => 'eba_stds_parser.update_standard_status;', ]'
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


    function get_standard_id (p_standard_name in eba_stds_standards.standard_name%type)
    return eba_stds_standards.id%type
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_standard_id';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    l_id eba_stds_standards.id%type;
    begin
        apex_debug.message(c_debug_template,'START', 'p_standard_name', p_standard_name);

        select id
        into l_id 
        from eba_stds_standards
        where upper(standard_name) =  upper(p_standard_name);

        return l_id;

    exception when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end get_standard_id;

    function get_mv_dependency(p_standard_code in eba_stds_standard_tests.standard_code%type) 
    return eba_stds_standard_tests.mv_dependency%type
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_mv_dependency';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_mv_dependency eba_stds_standard_tests.mv_dependency%type;
    begin
      apex_debug.message(c_debug_template,'START', 'p_standard_code', p_standard_code);

      select mv_dependency 
      into l_mv_dependency
      from eba_stds_standard_tests
      where standard_code = p_standard_code;

      return l_mv_dependency;
    
    exception
        when no_data_found then
            return null;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end get_mv_dependency;

    function display_initialize_button (
        p_standard_code in SVT_plsql_apex_audit.standard_code%type,
        p_level_id      in SVT_standards_urgency_level.id%type
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
                                            'p_standard_code', p_standard_code,
                                            'p_level_id', p_level_id
                                            );
        select count(1)
        into l_issue_count
        from SVT_plsql_apex_audit
        where standard_code = p_standard_code;

        select count(1)
        into l_standard_count
        from eba_stds_standard_tests
        where standard_code = p_standard_code
        and active_yn = 'Y';

        select case when urgency_level <= 100
                then 'Y'
                else 'N'
                end 
        into l_urgent_yn
        from SVT_standards_urgency_level
        where id = p_level_id;

        if l_issue_count = 0 
        and l_standard_count  = 1 
        and l_urgent_yn = 'Y'
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

end eba_stds;
/

--rollback drop package EBA_STDS;
