--liquibase formatted sql
--changeset package_body_script:EBA_STDS_PARSER stripComments:false endDelimiter:/ runOnChange:true
create or replace package body eba_stds_parser  
is

    gc_scope_prefix         constant varchar2(31) := lower($$plsql_unit) || '.';
    gc_default_app_id       constant apex_applications.application_id%type := 17000033;
    gc_userenv_current_user constant varchar2(100) :=  sys_context('userenv', 'current_user');


    function view_sql (p_view_name in user_views.view_name%type,
                       p_owner     in all_views.owner%type default null) return clob
    is
    c_scope varchar2(128) := gc_scope_prefix || 'view_sql';
    c_debug_template varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    l_view_name user_views.view_name%type := upper(p_view_name);
    l_owner     all_views.owner%type := upper(nvl(p_owner, case when gc_userenv_current_user = 'AST'
                                                                then ast_ctx_util.get_default_user
                                                                else gc_userenv_current_user
                                                                end));
    l_sql_long  user_views.text%type;
    begin
      apex_debug.message(c_debug_template,'START', 
                                          'p_view_name', p_view_name, 
                                          'p_owner', p_owner);
      assert.is_not_null (  
                      val_in => p_view_name
                    , msg_in => 'The View Name must not be null' 
                );

      assert.is_not_null (  
                      val_in => l_owner
                    , msg_in => 'Owner must not be null' 
                );

      select text 
        into l_sql_long
        from all_views
        where view_name  = l_view_name
        and owner = l_owner;

        return  to_clob(l_sql_long);

    exception 
        when no_data_found then
            apex_debug.message(p_message => c_debug_template, 
                               p0 => 'View does not exist: '||l_view_name, 
                               p1 => 'Owner: '||l_owner, 
                               p_level => apex_debug.c_log_level_warn, p_force => true);
            raise;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception: '||p_view_name, p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end view_sql;


    function is_logged_into_builder (p_override_value in number default null) return boolean
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'is_logged_into_builder';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    c_builder_session constant number := v('APX_BLDR_SESSION');
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'c_builder_session', c_builder_session,
                                            'p_override_value', p_override_value
                                            );

        return case when p_override_value is not null
                    then true 
                    when c_builder_session is null 
                    then false
                    else true
                    end;

    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end is_logged_into_builder;

    function app_in_current_workspace (p_app_id in apex_applications.application_id%type) 
    return boolean
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'app_in_current_workspace'; 
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    l_dummy number;
    begin
        apex_debug.message(c_debug_template,'START', 'p_app_id', p_app_id);

         assert.is_not_null (  
            val_in => p_app_id
            , msg_in => 'App id cannot be null');

        select 1
            into l_dummy
            from apex_applications aa 
            where aa.application_id = p_app_id
            and aa.workspace = (select workspace
                                from apex_applications
                                where application_id =  v('APP_ID'));

        return true;

    exception 
        when no_data_found then
            apex_debug.message(p_message => c_debug_template, p0 =>'wrong workspace', 
                                                            p1 => sqlerrm, 
                                                            p2 => 'vappid   : '||v('APP_ID'), 
                                                            p3 => 'p_app_id : '||p_app_id);
            return false;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
    end app_in_current_workspace;

    function get_base_url return varchar2 
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_base_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START');

        return ast_preferences.get_preference ('AST_BASE_URL');

    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end get_base_url;


    procedure run_all_tests (p_standard_id in eba_stds_standards.id%type)
    is 
    c_scope varchar2(50) := gc_scope_prefix || 'run_all_tests';
    c_debug_template varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';
    begin
        apex_debug.message(c_debug_template,'START', 'p_standard_id', p_standard_id);

        delete from eba_stds_standard_statuses
            where standard_id = p_standard_id;

        --select uses_plscope_yn
        --    from eba_stds_standard_tests
        --    where standard_id = p_standard_id;

    exception when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4000);
            raise;
    end run_all_tests;

    procedure add_applications
    is
    c_scope varchar2(128) := gc_scope_prefix || 'add_applications';
    c_debug_template varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20'; 
    f number;
    l_default_id eba_stds_types.id%type;
        procedure get_default_id
        is 
        begin
           select id 
            into l_default_id
            from eba_stds_types
            where lower(type_name) = 'default';

        exception when no_data_found then 
            l_default_id := null;
            apex_debug.message(c_debug_template, 'No Default ID');
        end get_default_id;
    begin
        apex_debug.message(c_debug_template,'START');

        get_default_id;

        for i in 1..wwv_flow.g_f01.count loop
            f := wwv_flow.g_f01(i);
            insert into eba_stds_applications(apex_app_id) values (f);
        end loop;

    exception when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end add_applications;

    
    function default_app_id  
        return apex_applications.application_id%type deterministic
    is 
    c_scope varchar2(50) := gc_scope_prefix || 'default_app_id';
    c_debug_template varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    l_app_id apex_applications.application_id%type;
    begin
        select application_id 
            into l_app_id
            from apex_applications aa
            where application_id = gc_default_app_id;

        return l_app_id;

    exception 
        when no_data_found then
            apex_debug.error(p_message => c_debug_template, p0 =>'You need to specify a valid default application id', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4000);
            raise;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4000);
            raise;
    end default_app_id;


    function accessibility_app_id  
        return apex_applications.application_id%type deterministic
    is 
    c_scope varchar2(50) := gc_scope_prefix || 'accessibility_app_id';
    c_debug_template varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    l_app_id apex_applications.application_id%type;

    c_accessibility_app_id constant apex_applications.application_id%type := 800042;
    begin
        select application_id 
            into l_app_id
            from apex_applications aa
            where application_id = c_accessibility_app_id;

        return l_app_id;

    exception 
        when no_data_found then
            apex_debug.error(p_message => c_debug_template, p0 =>'You need to specify a valid accessibility application id', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4000);
            raise;
        when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4000);
            raise;
    end accessibility_app_id;

    function app_from_url ( p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return apex_applications.application_id%type
    is 
    c_scope varchar2(128) := gc_scope_prefix || 'app_from_url';
    c_debug_template varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    l_url_params         apex_t_varchar2;

        function app_id_from_alias(p_app_alias in apex_applications.alias%type) 
                 return apex_applications.application_id%type
        is 
        l_application_id apex_applications.application_id%type; 
        begin

            select application_id
            into l_application_id
            from apex_applications 
            where alias = upper(p_app_alias);

            return l_application_id;

        exception 
            when no_data_found then 
            return null;
            when others then
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
            raise;
        end app_id_from_alias;
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_origin_app_id', p_origin_app_id, 
                                            'p_url', p_url);

        l_url_params := apex_string.split(upper(p_url),':',2);

        return case when p_url is null 
                    then null
                    when l_url_params(1) like 'F?P=%'
                    then case when l_url_params(1) like 'F?P=&APP_ID.%'
                              then p_origin_app_id
                              when l_url_params(1) like 'F?P=&%'
                              then null
                              when l_url_params(1) like 'F?P=#%'
                              then null
                              when (validate_conversion(substr(l_url_params(1),5) as number) = 1)
                              then substr(l_url_params(1),5)
                              else app_id_from_alias(p_app_alias => substr(l_url_params(1),5))
                              end
                    else null
                    end;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end app_from_url;

    function page_from_url (p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return apex_application_pages.page_id%type deterministic
    is 
    c_scope varchar2(128) := gc_scope_prefix || 'page_from_url';
    c_debug_template varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    l_url_params          apex_t_varchar2;

        function page_id_from_alias (p_app_id     in apex_applications.application_id%type,
                                     p_page_alias in apex_application_pages.page_alias%type) return apex_application_pages.page_id%type
        is 
        l_destination_page_id apex_application_pages.page_id%type;
        begin
          select page_id 
                into l_destination_page_id
                from apex_application_pages 
                where application_id = p_app_id
                and page_alias = upper(p_page_alias);

          return l_destination_page_id;

        exception when no_data_found then return null;
        end page_id_from_alias;

    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_origin_app_id', p_origin_app_id, 
                                            'p_url', p_url);

        l_url_params := apex_string.split(upper(p_url),':',3);

        return case when p_url is null 
                    then null
                    when l_url_params(1) like 'F?P=%'
                    then case when (validate_conversion(l_url_params(2) as number) = 1)
                              then l_url_params(2)
                              else case when (validate_conversion(substr(l_url_params(1),5) as number) = 1)
                                        then page_id_from_alias(p_app_id     => substr(l_url_params(1),5),
                                                                p_page_alias => l_url_params(2))
                                        else case when l_url_params(2) = '#'
                                                  then 0 --it needs to return not null
                                                  when l_url_params(2) = '&APP_PAGE_ID.'
                                                  then 0 --it needs to return not null
                                                  when l_url_params(2) like '&%'
                                                  then 0 --it needs to return not null
                                                  else page_id_from_alias(
                                                                p_app_id     => app_from_url (p_origin_app_id,p_url),
                                                                p_page_alias => l_url_params(2)
                                                        )
                                                  end
                                        end
                              end
                    when validate_conversion(p_url as number) = 1
                    then p_url
                    else null
                    end;
    exception 
        when e_subscript_beyond_count then 
            apex_debug.message(c_debug_template, 'Subscript beyond count');
            return null;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end page_from_url;

    function is_valid_url (p_origin_app_id in apex_applications.application_id%type,
                           p_url in varchar2) return varchar2 deterministic
    is 
    c_scope varchar2(128) := gc_scope_prefix || 'is_valid_url';
    c_debug_template varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    l_url varchar2(1026) := upper(p_url);
    l_valid_app_and_page_yn varchar2(1) := 'Y';
    l_application_id apex_applications.application_id%type;
    l_page_id apex_application_pages.page_id%type;                                                               
    begin
        apex_debug.message(c_debug_template,'START', 'p_origin_app_id', p_origin_app_id,
                                                     'p_url', p_url
                                                     );
        case when l_url is null 
             then return 'Y';
             when l_url = 'SEPARATOR'
             then return 'Y';
             when l_url = '#' 
             then return 'Y';
             when l_url = '/SIGNOUT' 
             then return 'Y';
             when l_url like '&LOGOUT_URL%' 
             then return 'Y';
             when l_url like '#%#' 
             then return 'Y';
             when l_url like '#ACTION$%' -- eg #action$a-pwa-install
             then return 'Y';
             when l_url like 'F?P=&REPORTING_APP_ID.%' 
             then return 'Y';
             when l_url like 'F?P=&LAST_APP.%' 
             then return 'Y';
             when l_url like 'F?P=&G_CALLED_FROM_APP.%' 
             then return 'Y';
             when l_url like 'F?P=&P%' 
             then return 'Y';
             when l_url like 'JAVASCRIPT%' 
             then return 'Y';
             when l_url like 'TEL:%' 
             then return 'Y';
             when l_url like 'HTTPS://%' 
             then return 'Y';
             else 
                l_application_id := app_from_url ( p_origin_app_id => p_origin_app_id,
                                                   p_url => l_url);
                l_page_id := page_from_url ( p_origin_app_id => p_origin_app_id,
                                             p_url => l_url);

                select case when count(*) = 1
                                then 'Y'
                                else 'N'
                                end into l_valid_app_and_page_yn
                from sys.dual where exists (
                    select aap.page_id 
                    from apex_application_pages aap
                    inner join apex_applications aa on aa.application_id = aap.application_id 
                    where aap.page_access_protection != 'No URL Access'
                    and aa.availability_status != 'Unavailable'
                    and aap.application_id = l_application_id
                    and (aap.page_id  = l_page_id or l_page_id = 0)
                );
        end case;

        return l_valid_app_and_page_yn;

    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end is_valid_url;

    procedure get_component_type_rec (
                        p_ast_component_type_id in ast_component_types.id%type,
                        p_component_name        out nocopy ast_component_types.component_name%type,
                        p_component_type_id     out nocopy v_ast_flow_dictionary_views.component_type_id%type,
                        p_template_url          out nocopy v_ast_flow_dictionary_views.link_url%type
                    )
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_component_type_rec';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START', 'p_ast_component_type_id', p_ast_component_type_id);

        select act.component_name, fdv.component_type_id, coalesce(fdv.link_url, act.template_url) link_url
        into p_component_name, p_component_type_id, p_template_url
        from  ast_component_types act
        left join v_ast_flow_dictionary_views fdv on fdv.view_name = act.component_name
        where act.id = p_ast_component_type_id;

    exception 
        when no_data_found then
            apex_debug.message(c_debug_template, 'No data found', p_ast_component_type_id);
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end get_component_type_rec;

    -- function build_link( p_test_id        in eba_stds_standard_tests.id%type, 
    --                      p_param          in varchar2,
    --                      p_owner          in all_views.owner%type default null
    --                       )
    -- return varchar2 deterministic result_cache
    -- is

    -- c_scope          constant varchar2(50) := gc_scope_prefix || 'build_link';
    -- c_debug_template constant varchar2(4000) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    -- c_builder_session constant number := v('APX_BLDR_SESSION');
    -- c_link_base       constant varchar2(100) := get_base_url();
    -- l_owner      all_views.owner%type := upper(coalesce(p_owner, gc_userenv_current_user));
    -- l_link_type  varchar2(100);
    -- l_app number;
    -- l_page number;
    -- l_link varchar2(4000) := null;
    -- l_version number;
    -- l_url_params apex_t_varchar2 := apex_string.split(p_param, ':');
    -- l_app_being_tested apex_applications.application_id%type;
    -- l_param varchar2(25); -- := l_url_params(2)
    -- l_app_in_current_workspace boolean := true;

    -- ------------------------------------------------------------------------------
    -- -- Nested Procedure, to assert parameter conditions.  
    -- ------------------------------------------------------------------------------
    -- -- procedure start_assertions is 
    -- -- begin
    -- --     assert.is_not_null (  
    -- --         val_in => p_test_id
    -- --         , msg_in => 'Test id cannot be null');
    -- --     assert.is_not_null (  
    -- --         val_in => p_param
    -- --         , msg_in => 'p_param cannot be null');
    -- -- end start_assertions;

    -- ------------------------------------------------------------------------------
    -- -- Nested Procedure, to build link to db objects
    -- ------------------------------------------------------------------------------
    -- procedure link_to_db_object is 
    -- l_object_name user_objects.object_name%type;
    -- l_object_type user_objects.object_type%type;
    -- l_line_number varchar(512); --user_source.line%type;
    -- l_object_id   user_objects.object_id%type;
    -- begin
    --     apex_debug.message(c_debug_template, 'building link to db object');
    --     l_app := 4500;

    --     l_url_params := apex_string.split(p_param, ':');
    --     l_object_name := l_url_params(1);
    --     l_object_type := case when l_url_params(2) = 'PACKAGE BODY'
    --                           then 'PACKAGE'
    --                           when l_url_params(2) = 'TYPE BODY'
    --                           then 'TYPE'
    --                           else l_url_params(2)
    --                           end;
    --     l_line_number := l_url_params(3);

    --     l_page := 1001;

    --     select object_id
    --     into l_object_id
    --     from all_objects
    --     where object_type = l_object_type
    --     and object_name = l_object_name
    --     and owner = l_owner;

    --     apex_debug.info(c_debug_template, 'l_object_name', l_object_name, 'l_object_type', l_object_type,'l_line_number', l_line_number, 'l_object_id', l_object_id);

    --     l_link := apex_string.format(p_message => ':FOCUS:::OB_CURRENT_TYPE,OB_FIND,OB_OBJECT_NAME,OB_OBJECT_ID'||
    --                                                     ':%1,%2,%3,%4',
    --                                  p1 => l_object_type,
    --                                  p2 => l_object_name,
    --                                  p3 => l_object_name,
    --                                  p4 => l_object_id
    --                                 );
    --     apex_debug.message(p_message => c_debug_template, p0 => 'l_link', p1 => l_link, p_level => apex_debug.c_log_level_warn, p_force => true);
    -- exception when no_data_found then
    --     apex_debug.error(p_message => c_debug_template, 
    --                      p0 =>'No data found in all_objects', 
    --                      p1 => 'l_object_type: '||l_object_type, 
    --                      p2 => 'l_object_name: '||l_object_name,
    --                      p3 => 'l_owner: '||l_owner,
    --                      p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
    --     raise;
    -- end link_to_db_object;

    -- begin
    --     apex_debug.message(c_debug_template,'START', 'p_test_id', p_test_id, 
    --                                                  'p_param', p_param,
    --                                                  'c_builder_session', c_builder_session,
    --                                                  'l_owner', l_owner);

    --     -- Do things differently depending on the APEX version.
    --     for c1 in ( select to_number(substr(version_no,0,instr(version_no,'.'))) vrsn from apex_release ) loop
    --         l_version := c1.vrsn;
    --     end loop;
    --     if l_version >= 5 then
    --         l_app := 4000;
    --         l_page := 4500;
    --     end if;
    --     apex_debug.info(c_debug_template, 'l_version', l_version);

    --     l_link_type := 'DB_SUPPORTING_OBJECT';

    --         apex_debug.message(p_message => c_debug_template, p0 => 'link_type', p1 => l_link_type, p_level => apex_debug.c_log_level_warn, p_force => true);

    --         case l_link_type
    --         when 'DB_SUPPORTING_OBJECT' then
    --             link_to_db_object;
    --         else 
    --             null;
    --         end case;
    --     apex_debug.message(c_debug_template, '. l_app', l_app);
    --     apex_debug.message(c_debug_template, '. l_page', l_page);
    --     apex_debug.message(c_debug_template, '. c_builder_session', c_builder_session);
    --     apex_debug.message(c_debug_template, '. l_link', l_link);

    --     l_link := case when p_param is null 
    --                    then null
    --                    when l_link is not null
    --                    then c_link_base||'f?p='||l_app||':'||l_page||':'||c_builder_session||l_link
    --                    end;
    --     apex_debug.info(c_debug_template, 'l_link', l_link);
    --     return l_link;

    -- exception 
    --     when e_subscript_beyond_count then 
    --         apex_debug.error(p_message => c_debug_template, p0 =>'Invalid reference code'
    --                                                       , p1 => 'p_test_id', p2 => p_test_id
    --                                                       , p3 => 'p_param', p4 => p_param
    --                                                       , p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4000);
    --         raise;
    --     when others then 
    --         apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4000);
    --         raise;
    -- end build_link;

    function build_url( p_template_url          in v_ast_flow_dictionary_views.link_url%type,
                        p_app_id                in ast_plsql_apex_audit.application_id%type,
                        p_page_id               in ast_plsql_apex_audit.page_id%type,
                        p_pk_value              in ast_plsql_apex_audit.component_id%type,
                        p_parent_pk_value       in ast_plsql_apex_audit.object_name%type,
                        p_opt_parent_pk_value   in ast_plsql_apex_audit.object_type%type default null,
                        p_builder_session       in number default null)
    return varchar2 deterministic result_cache
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'build_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
    c_app_id constant ast_plsql_apex_audit.application_id%type := p_app_id;
    c_page_id constant ast_plsql_apex_audit.page_id%type := p_page_id;
    c_pk_value constant ast_plsql_apex_audit.component_id%type := p_pk_value;
    c_parent_pk_value constant varchar2(100) := p_parent_pk_value;
    c_opt_parent_pk_value constant varchar2(100) := p_opt_parent_pk_value;
    c_builder_session constant number := coalesce(v('APX_BLDR_SESSION'),p_builder_session);
    c_template_url v_ast_flow_dictionary_views.link_url%type := p_template_url;
    l_url varchar2(2000);
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_template_url', p_template_url,
                                            'p_app_id', p_app_id,
                                            'p_page_id', p_page_id,
                                            'p_pk_value', p_pk_value,
                                            'p_parent_pk_value', p_parent_pk_value,
                                            'p_opt_parent_pk_value', p_opt_parent_pk_value,
                                            'p_builder_session', p_builder_session
                           );
        
        l_url := case when c_template_url is not null 
                      then  replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            c_template_url
                            , '%session%', c_builder_session)
                            , '%application_id%', c_app_id)
                            , '%page_id%', c_page_id)
                            , '%pk_value%', c_pk_value)
                            , '%parent_pk_value%', c_parent_pk_value)
                            , '%opt_parent_pk_value%', c_opt_parent_pk_value)
                      end;
        
        apex_debug.message(c_debug_template, 'l_url', l_url);

        return l_url;

    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end build_url;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 29, 2023
-- Synopsis:
--
-- Private function to assemble the additional columns
--
------------------------------------------------------------------------------

    function assemble_addlcols( p_initials              in varchar2,
                                p_ast_component_type_id in ast_component_types.id%type) 
    return ast_component_types.addl_cols%type
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'assemble_addlcols';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_addl_cols        ast_component_types.addl_cols%type;
    l_addl_cols_final  ast_component_types.addl_cols%type;
    l_name_column      ast_component_types.name_column%type;
    l_count pls_integer := 0;
    c_padding constant varchar2(20) := '       ';
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_initials', p_initials, 
                                            'p_ast_component_type_id', p_ast_component_type_id);

        select lower(act.addl_cols), lower(act.name_column)
        into l_addl_cols, l_name_column
        from ast_nested_table_types antt
        inner join ast_component_types act on act.nt_type_id = antt.id
        where act.id = p_ast_component_type_id;
        
        l_addl_cols_final := chr(10)||c_padding||p_initials||'.'||l_name_column; --||','||chr(10);

        for rec in (select column_value extra_col
                    from table(apex_string.split(l_addl_cols,':'))
        ) loop
            l_addl_cols_final := l_addl_cols_final||
                                 ','||chr(10)||
                                 c_padding||p_initials||'.'||rec.extra_col;
            l_count := l_count + 1;
        end loop;

        return l_addl_cols_final;

    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end assemble_addlcols;

    function seed_default_query(p_ast_component_type_id in ast_component_types.id%type)
    return varchar2
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'seed_default_query';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
    l_example_query ast_nested_table_types.example_query%type;
    l_view             ast_component_types.component_name%type;
    l_pk_value         ast_component_types.pk_value%type;
    l_parent_pk_value  ast_component_types.parent_pk_value%type;
    l_friendly_name    ast_component_types.friendly_name%type;
    l_name_column      ast_component_types.name_column%type;
    l_opt_parent_pk_value  all_objects.object_type%type;
    l_initials varchar2(5);
    l_app_id all_tab_cols.column_name%type;
    c_application_id  constant varchar2(25) := 'application_id';
    c_page_id         constant varchar2(25) := 'page_id';
    c_created_by      constant varchar2(25) := 'created_by';
    c_created_on      constant varchar2(25) := 'created_on';
    c_updated_by      constant varchar2(25) := 'updated_by';
    c_updated_on      constant varchar2(25) := 'updated_on';
    c_last_updated_by constant varchar2(25) := 'last_updated_by';
    c_last_updated_on constant varchar2(25) := 'last_updated_on';
    c_build_option    constant varchar2(25) := 'build_option';

        function column_exists (p_column_name in varchar2) return boolean
        as 
        l_column_exists_yn varchar2(1) := 'N';
        begin
            select case when count(*) = 1
                            then 'Y'
                            else 'N'
                            end into l_column_exists_yn
                    from sys.dual where exists (
                        select 1
                            from all_tab_cols 
                            where lower(table_name) = l_view
                            and lower(column_name) = p_column_name
                    );
            return case when l_column_exists_yn = 'Y'
                        then true 
                        else false
                        end;
        end column_exists; 

    begin

        select antt.example_query, 
               lower(act.component_name), 
               lower(act.pk_value), 
               lower(act.parent_pk_value), 
               upper(antt.object_type),
               initcap(act.friendly_name),
               lower(act.name_column)
        into l_example_query, 
             l_view, 
             l_pk_value, 
             l_parent_pk_value, 
             l_opt_parent_pk_value,
             l_friendly_name,
             l_name_column
        from ast_nested_table_types antt
        inner join ast_component_types act on act.nt_type_id = antt.id
        where act.id = p_ast_component_type_id;


        l_initials := case when l_view is not null
                           then lower(apex_string.get_initials(l_view,5))
                           else 'st'
                           end;
        
        l_example_query := replace(l_example_query, '%astview%', coalesce(l_view, 'dual')||' '||l_initials);
        l_example_query := replace(l_example_query, '%pk_value%', case when l_pk_value is not null 
                                                                       then l_initials||'.'||l_pk_value
                                                                       else 'null'
                                                                       end
                                  );
        l_example_query := replace(l_example_query, '%parent_pk_value%', case when l_parent_pk_value is not null
                                                                              then l_initials||'.'||l_parent_pk_value
                                                                              else 'null'
                                                                              end
                                  );
        
        l_example_query := replace(l_example_query, '%appid%', case when column_exists (c_application_id)
                                                                    then l_initials||'.'
                                                                    else 'null '
                                                                    end
                                  );
        l_example_query := replace(l_example_query, '%pageid%', case when column_exists (c_page_id)
                                                                     then l_initials||'.'
                                                                     else 'null '
                                                                     end
                                  );
        l_example_query := replace(l_example_query, '%createdby%', case when column_exists (c_created_by)
                                                                        then l_initials||'.'
                                                                        else 'null '
                                                                        end
                                  );
        l_example_query := replace(l_example_query, '%createdon%', case when column_exists (c_created_on)
                                                                        then l_initials||'.'
                                                                        else 'null '
                                                                        end
                                  );
        l_example_query := replace(l_example_query, '%updatedby%', case when column_exists (c_last_updated_by)
                                                                        then l_initials||'.'
                                                                        when column_exists (c_updated_by)
                                                                        then l_initials||'.'||c_updated_by||' '
                                                                        else 'null '
                                                                        end
                                  );
        l_example_query := replace(l_example_query, '%updatedon%', case when column_exists (c_last_updated_on)
                                                                        then l_initials||'.'
                                                                        when column_exists (c_updated_on)
                                                                        then l_initials||'.'||c_updated_on||' '
                                                                        else 'null '
                                                                        end
                                  );
        l_example_query := replace(l_example_query, '%issuedesc%', apex_string.format(q'['%1 `%2` (app %3%5) REPLACEME', 
        p0 => %0.%4, 
        p1 => %0.application_id%6]',
                                                                        p0 => l_initials,
                                                                        p1 => l_friendly_name,
                                                                        p2 => '%0',
                                                                        p3 => '%1',
                                                                        p4 => l_name_column,
                                                                        p5 => case when column_exists (c_page_id)
                                                                                   then ', page %2'
                                                                                   end,
                                                                        p6 => case when column_exists (c_page_id)
                                                                                   then',
        p2 => '||l_initials||'.page_id'
        end
                                                                    )
                                    );
        l_example_query := replace(l_example_query, '%addl_cols%', 
                                    assemble_addlcols(p_initials              => l_initials,
                                                      p_ast_component_type_id => p_ast_component_type_id));
        l_example_query := l_example_query||case when column_exists (c_page_id) and l_view != 'apex_application_pages'
                                                 then chr(10)||'inner join apex_application_pages aap on aap.page_id = '||l_initials||'.'||c_page_id
                                                                                                  ||' and aap.application_id = '||l_initials||'.'||c_application_id
                                                    ||chr(10)||'left outer join apex_application_build_options aabo1 on aabo1.build_option_name = aap.'||c_build_option
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_build_option)
                                                 then chr(10)||'left outer join apex_application_build_options aabo2 on aabo2.build_option_name = '||l_initials||'.'||c_build_option
                                                 end;
        l_example_query := l_example_query||chr(10)||'where 1=1';
        l_example_query := l_example_query||case when column_exists (c_page_id) and l_view != 'apex_application_pages'
                                                 then chr(10)||q'[and coalesce(aabo1.status_on_export,'NA') != 'Exclude']'
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_build_option)
                                                 then chr(10)||q'[and coalesce(aabo2.status_on_export,'NA') != 'Exclude']'
                                                 end;
        l_example_query := l_example_query||case when l_opt_parent_pk_value in ('TABLE','VIEW')
                                                 then chr(10)||apex_string.format(q'[and ao.object_type = '%s']',l_opt_parent_pk_value)
                                                 end;
        

        return l_example_query;

    exception 
        when no_data_found then 
            apex_debug.message(c_debug_template, 'no data found', p_ast_component_type_id);
            return null;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end seed_default_query;


end eba_stds_parser;
/

--rollback drop package EBA_STDS_PARSER;
