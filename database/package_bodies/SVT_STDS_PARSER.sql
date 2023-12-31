--liquibase formatted sql
--changeset package_body_script:SVT_STDS_PARSER stripComments:false endDelimiter:/ runOnChange:true
-- set define off
create or replace package body svt_stds_parser  
is

    gc_scope_prefix         constant varchar2(31) := lower($$plsql_unit) || '.';
    gc_y                    constant varchar2(1) := 'Y';
    gc_n                    constant varchar2(1) := 'N';


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
              p_val_in => p_app_id
            , p_msg_in => 'App id cannot be null');

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

    function get_base_url return varchar2 deterministic
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_base_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START');

        return svt_preferences.get('SVT_BASE_URL');

    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end get_base_url;

    function app_from_url ( p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return apex_applications.application_id%type
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'app_from_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    l_url_params         apex_t_varchar2;

        ------------------------------------------------------------------------------
        -- Nested function to get the app id from a given app alias
        ------------------------------------------------------------------------------
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
    c_scope constant varchar2(128) := gc_scope_prefix || 'page_from_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    l_url_params          apex_t_varchar2;

        ------------------------------------------------------------------------------
        -- Nested Function to get the page id from a given page alias
        ------------------------------------------------------------------------------
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
    c_scope constant varchar2(128) := gc_scope_prefix || 'is_valid_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    c_url constant varchar2(1026) := upper(p_url);
    l_valid_app_and_page_yn varchar2(1) := gc_y;
    l_application_id apex_applications.application_id%type;
    l_page_id apex_application_pages.page_id%type;                                                               
    begin
        apex_debug.message(c_debug_template,'START', 'p_origin_app_id', p_origin_app_id,
                                                     'p_url', p_url
                                                     );
        case when c_url is null 
             then return gc_y;
             when c_url = 'SEPARATOR'
             then return gc_y;
             when c_url = '#' 
             then return gc_y;
             when c_url = '/SIGNOUT' 
             then return gc_y;
             when c_url like '&%.'
             then return gc_y;
             when c_url like '&LOGOUT_URL%' 
             then return gc_y;
             when c_url like '#%#' 
             then return gc_y;
             when c_url like '#ACTION$%' -- eg #action$a-pwa-install
             then return gc_y;
             when c_url like 'F?P=&REPORTING_APP_ID.%' 
             then return gc_y;
             when c_url like 'F?P=&LAST_APP.%' 
             then return gc_y;
             when c_url like 'F?P=&G_CALLED_FROM_APP.%' 
             then return gc_y;
             when c_url like 'F?P=&P%' 
             then return gc_y;
             when c_url like 'JAVASCRIPT%' 
             then return gc_y;
             when c_url like 'TEL:%' 
             then return gc_y;
             when c_url like 'HTTPS://%' 
             then return gc_y;
             else 
                l_application_id := app_from_url ( p_origin_app_id => p_origin_app_id,
                                                   p_url => c_url);
                l_page_id := page_from_url ( p_origin_app_id => p_origin_app_id,
                                             p_url => c_url);

                select case when count(*) = 1
                                then gc_y
                                else gc_n
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

    function adapt_url (p_template_url in svt_component_types.template_url%type)
    return svt_component_types.template_url%type
    is 
    c_scope constant varchar2(128) := gc_scope_prefix || 'adapt_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    cursor cur_params 
    is select column_value
       from table(apex_string.split(p_template_url, ':'))
       where column_value is not null
       and column_value not in ('NO','YES')
       and column_value not like 'RP%';
    type t_params is table of varchar2(100) index by pls_integer;
    l_params t_params;
    begin
        apex_debug.message(c_debug_template,'START', 'p_template_url', p_template_url);

        open cur_params;
        fetch cur_params bulk collect into l_params;
        
        apex_debug.message(c_debug_template,'l_params.count', l_params.count,
                                            'p_application', replace(l_params(1), 'f?p='),
                                            'p_page'       , l_params(2),
                                            'p_session'    , l_params(3),
                                            'p_items'      , l_params(4));
        apex_debug.message(c_debug_template,'p_values'     , l_params(5));

        return case when l_params.count >= 5
                    then apex_page.get_url (
                            p_application => replace(l_params(1), 'f?p='),
                            p_page        => l_params(2),
                            p_session     => l_params(3),
                            p_items       => l_params(4),
                            p_values      => l_params(5)
                            )
                    else p_template_url
                    end;
    exception 
        when no_data_found then
            apex_debug.message(c_debug_template,'no_data_found', 'p_template_url', p_template_url);
            return p_template_url;
        when e_not_a_number then 
            apex_debug.message(c_debug_template,'e_not_a_number', 'p_template_url', p_template_url);
            return p_template_url;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end adapt_url;

    procedure get_component_type_rec (
                        p_svt_component_type_id in svt_component_types.id%type,
                        p_component_name        out nocopy svt_component_types.component_name%type,
                        p_component_type_id     out nocopy svt_component_types.component_type_id%type,
                        p_template_url          out nocopy svt_component_types.template_url%type
                    ) deterministic
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_component_type_rec';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    begin
        apex_debug.message(c_debug_template,'START', 'p_svt_component_type_id', p_svt_component_type_id);

        select act.component_name, 
               act.component_type_id, 
               act.template_url link_url
        into   p_component_name, 
               p_component_type_id, 
               p_template_url
        from  svt_component_types act
        where act.id = p_svt_component_type_id;

    exception 
        when no_data_found then
            apex_debug.message(c_debug_template, 'No data found', p_svt_component_type_id);
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end get_component_type_rec;

    function build_url( p_template_url          in svt_component_types.template_url%type,
                        p_app_id                in svt_plsql_apex_audit.application_id%type,
                        p_page_id               in svt_plsql_apex_audit.page_id%type,
                        p_pk_value              in svt_plsql_apex_audit.component_id%type,
                        p_parent_pk_value       in svt_plsql_apex_audit.object_name%type,
                        p_issue_category        in svt_plsql_apex_audit.issue_category%type,
                        p_opt_parent_pk_value   in svt_plsql_apex_audit.object_type%type default null,
                        p_line                  in svt_plsql_apex_audit.line%type default null, 
                        p_object_name           in svt_plsql_apex_audit.object_name%type default null,
                        p_object_type           in svt_plsql_apex_audit.object_type%type default null,
                        p_schema                in svt_plsql_apex_audit.owner%type default null,
                        p_builder_session       in number default null
                        )
    return varchar2 deterministic result_cache
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'build_url';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
    c_app_id constant svt_plsql_apex_audit.application_id%type := p_app_id;
    c_page_id constant svt_plsql_apex_audit.page_id%type := p_page_id;
    c_pk_value constant svt_plsql_apex_audit.component_id%type := p_pk_value;
    c_parent_pk_value constant varchar2(100) := p_parent_pk_value;
    c_opt_parent_pk_value constant varchar2(100) := p_opt_parent_pk_value;
    c_builder_session constant number := coalesce(v('APX_BLDR_SESSION'),p_builder_session);
    c_template_url  constant svt_component_types.template_url%type := p_template_url;
    l_url varchar2(2000);
    c_schema      constant svt_plsql_apex_audit.owner%type := 
                            coalesce(p_schema, svt_preferences.get(p_preference_name  => 'SVT_DEFAULT_SCHEMA'));
    c_object_name constant svt_plsql_apex_audit.object_name%type := upper(p_object_name);
    c_object_type constant svt_plsql_apex_audit.object_type%type := upper(p_object_type);
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_template_url', p_template_url,
                                            'p_app_id', p_app_id,
                                            'p_page_id', p_page_id,
                                            'p_pk_value', p_pk_value,
                                            'p_parent_pk_value', p_parent_pk_value,
                                            'p_opt_parent_pk_value', p_opt_parent_pk_value,
                                            'p_builder_session', p_builder_session,
                                            'p_issue_category', p_issue_category,
                                            'p_schema', p_schema
                           );
        
        l_url := case when c_template_url is not null 
                      then  replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            replace(
                            c_template_url
                            , '%session%', case when p_issue_category = 'APEX'
                                                then c_builder_session
                                                else v('APP_SESSION')
                                                end)
                            , '%application_id%', c_app_id)
                            , '%page_id%', c_page_id)
                            , '%pk_value%', c_pk_value)
                            , '%parent_pk_value%', c_parent_pk_value)
                            , '%opt_parent_pk_value%', c_opt_parent_pk_value)
                            , '%line%', p_line)
                            , '%schema%'     , c_schema)
                            , '%object_name%', c_object_name)
                            , '%object_type%', c_object_type)
                      end;
        
        apex_debug.message(c_debug_template, 'l_url', l_url);

        -- l_url := apex_util.prepare_url(l_url);
        l_url := adapt_url(l_url);

        apex_debug.message(c_debug_template, 'prepared l_url', l_url);

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
                                p_svt_component_type_id in svt_component_types.id%type) 
    return svt_component_types.addl_cols%type
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'assemble_addlcols';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    l_addl_cols        svt_component_types.addl_cols%type;
    l_addl_cols_final  svt_component_types.addl_cols%type;
    l_name_column      svt_component_types.name_column%type;
    l_count pls_integer := 0;
    c_padding constant varchar2(20) := '       ';
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_initials', p_initials, 
                                            'p_svt_component_type_id', p_svt_component_type_id);

        select lower(act.addl_cols), lower(act.name_column)
        into l_addl_cols, l_name_column
        from svt_nested_table_types antt
        inner join svt_component_types act on act.nt_type_id = antt.id
        where act.id = p_svt_component_type_id;
        
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

    ------------------------------------------------------------------------------
    -- Nested function to determine whether a given column exists in a given table 
    ------------------------------------------------------------------------------
    function column_exists (p_column_name in all_tab_cols.column_name%type,
                            p_table_name  in all_tab_cols.table_name%type) 
    return boolean
    as
    c_scope constant varchar2(128) := gc_scope_prefix || 'column_exists';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
    l_column_exists_yn varchar2(1) := gc_n;
    c_column_name constant all_tab_cols.column_name%type := lower(p_column_name);
    c_table_name  constant all_tab_cols.table_name%type := lower(p_table_name);
    begin
        apex_debug.message(c_debug_template,'START', 
                                            'p_column_name', p_column_name, 
                                            'p_table_name', p_table_name);
        select case when count(*) = 1
                        then gc_y
                        else gc_n
                        end into l_column_exists_yn
                from sys.dual where exists (
                    select 1
                        from all_tab_cols 
                        where lower(table_name) = c_table_name
                        and lower(column_name) = c_column_name
                );
        return case when l_column_exists_yn = gc_y
                    then true 
                    else false
                    end;

    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end column_exists; 


    function seed_default_query(p_svt_component_type_id in svt_component_types.id%type)
    return varchar2
    as 
    c_scope constant varchar2(128) := gc_scope_prefix || 'seed_default_query';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15';
    l_example_query svt_nested_table_types.example_query%type;
    l_view             svt_component_types.component_name%type;
    l_pk_value         svt_component_types.pk_value%type;
    l_parent_pk_value  svt_component_types.parent_pk_value%type;
    l_friendly_name    svt_component_types.friendly_name%type;
    l_name_column      svt_component_types.name_column%type;
    l_opt_parent_pk_value  all_objects.object_type%type;
    l_initials varchar2(5);
    c_application_id  constant varchar2(25) := 'application_id';
    c_page_id         constant varchar2(25) := 'page_id';
    c_created_by      constant varchar2(25) := 'created_by';
    c_created_on      constant varchar2(25) := 'created_on';
    c_updated_by      constant varchar2(25) := 'updated_by';
    c_updated_on      constant varchar2(25) := 'updated_on';
    c_last_updated_by constant varchar2(25) := 'last_updated_by';
    c_last_updated_on constant varchar2(25) := 'last_updated_on';
    c_build_option    constant varchar2(25) := 'build_option';
    c_workspace       constant varchar2(25) := 'workspace';
    c_3_spaces        constant varchar2(100) := chr(32)||chr(32)||chr(32);
    c_7_spaces        constant varchar2(100) := c_3_spaces||c_3_spaces||chr(32);
    c_10_spaces       constant varchar2(100) := c_7_spaces||chr(32)||chr(32)||chr(32);
    c_20_spaces       constant varchar2(100) := c_10_spaces||c_10_spaces;
    c_30_spaces       constant varchar2(100) := c_20_spaces||c_10_spaces;
    c_50_spaces       constant varchar2(100) := c_20_spaces||c_20_spaces||c_10_spaces;
    c_object_name     constant varchar2(25)  := 'object_name';
    begin
        apex_debug.message(c_debug_template,'START', 'p_svt_component_type_id', p_svt_component_type_id);

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
        from svt_nested_table_types antt
        inner join svt_component_types act on act.nt_type_id = antt.id
        where act.id = p_svt_component_type_id;


        l_initials := case when l_name_column = c_object_name
                           then 'ao' --for all_objects
                           when l_view is not null
                           then lower(apex_string.get_initials(l_view,5))
                           else 'st'
                           end;
        
        l_example_query := replace(l_example_query, '%svtview%', coalesce(l_view, 'dual')||' '||l_initials);
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
        
        l_example_query := replace(l_example_query, '%appid%', case when column_exists (c_application_id,l_view)
                                                                    then l_initials||'.'
                                                                    else 'null '
                                                                    end
                                  );
        l_example_query := replace(l_example_query, '%pageid%', case when column_exists (c_page_id,l_view)
                                                                     then l_initials||'.'
                                                                     else 'null '
                                                                     end
                                  );
        l_example_query := replace(l_example_query, '%createdby%', case when column_exists (c_created_by,l_view)
                                                                        then l_initials||'.'
                                                                        else 'null '
                                                                        end
                                                                        ||c_created_by
                                  );
        l_example_query := replace(l_example_query, '%createdon%', case when column_exists (c_created_on,l_view)
                                                                        then l_initials||'.'
                                                                        else 'null '
                                                                        end
                                                                        ||c_created_on
                                  );
        l_example_query := replace(l_example_query, '%updatedby%', case when column_exists (c_last_updated_by,l_view)
                                                                        then l_initials||'.'
                                                                        when column_exists (c_updated_by,l_view)
                                                                        then l_initials||'.'||c_updated_by||' '
                                                                        else 'null '
                                                                        end
                                                                        ||c_last_updated_by
                                  );
        l_example_query := replace(l_example_query, '%updatedon%', case when column_exists (c_last_updated_on,l_view)
                                                                        then l_initials||'.'
                                                                        when column_exists (c_updated_on,l_view)
                                                                        then l_initials||'.'||c_updated_on||' '
                                                                        else 'null '
                                                                        end
                                                                        ||c_last_updated_on
                                  );
        l_example_query := replace(l_example_query, '%wrkspc%', case when column_exists (c_workspace,l_view)
                                                                     then l_initials||'.'
                                                                     else 'null '
                                                                     end
                                                                     ||c_workspace
                                  );
        l_example_query := case when column_exists (c_application_id,l_view)
                                then replace(l_example_query, '%issuedesc%', apex_string.format(q'['%1 `%2` (app %3%5) REPLACEME', 
        p0 => %0.%4, 
        p1 => %0.application_id%6]',
                                                                        p0 => l_initials,
                                                                        p1 => l_friendly_name,
                                                                        p2 => '%0',
                                                                        p3 => '%1',
                                                                        p4 => l_name_column,
                                                                        p5 => case when column_exists (c_page_id,l_view)
                                                                                   then ', page %2'
                                                                                   end,
                                                                        p6 => case when column_exists (c_page_id,l_view)
                                                                                   then',
        p2 => '||l_initials||'.page_id'
                                                                                   end
                                                                    )
                                    )
                                 else replace(l_example_query, '%issuedesc%', apex_string.format(q'['%1 `%2` REPLACEME', 
        p0 => %0.%4]',
                                                                        p0 => l_initials,
                                                                        p1 => l_friendly_name,
                                                                        p2 => '%0',
                                                                        p3 => '%1',
                                                                        p4 => l_name_column)
                                            )
                                 end;
        l_example_query := replace(l_example_query, '%addl_cols%', 
                                    assemble_addlcols(p_initials              => l_initials,
                                                      p_svt_component_type_id => p_svt_component_type_id));
        l_example_query := l_example_query||case when column_exists (c_page_id,l_view) and l_view != 'apex_application_pages'
                                                 then chr(10)||'inner join apex_application_pages aap on aap.page_id = '||l_initials||'.'||c_page_id
                                                    ||chr(10)||c_30_spaces||c_7_spaces||' and aap.application_id = '||l_initials||'.'||c_application_id
                                                    ||chr(10)||'left outer join apex_application_build_options aabo1 on  aabo1.build_option_name = aap.'||c_build_option
                                                    ||chr(10)||c_50_spaces||c_3_spaces||'and aabo1.application_id = aap.application_id'
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_build_option,l_view)
                                                 then chr(10)||'left outer join apex_application_build_options aabo2 on  aabo2.build_option_name = '||l_initials||'.'||c_build_option
                                                    ||chr(10)||c_50_spaces||c_3_spaces||'and aabo2.application_id = '||l_initials||'.application_id'
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_workspace,l_view)
                                                 then chr(10)||apex_string.format(q'[where %0.workspace = svt_preferences.get('SVT_WORKSPACE')]', l_initials)
                                                 else chr(10)||apex_string.format(q'[where 1=1]', l_initials)
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_page_id,l_view) and l_view != 'apex_application_pages'
                                                 then chr(10)||q'[and coalesce(aabo1.status_on_export,'NA') != 'Exclude']'
                                                 end;
        l_example_query := l_example_query||case when column_exists (c_build_option,l_view)
                                                 then chr(10)||q'[and coalesce(aabo2.status_on_export,'NA') != 'Exclude']'
                                                 end;
        l_example_query := l_example_query||case when l_opt_parent_pk_value in ('TABLE','VIEW')
                                                 then chr(10)||apex_string.format(q'[and ao.object_type = '%s']',l_opt_parent_pk_value)
                                                 end;
        

        return l_example_query;

    exception 
        when no_data_found then 
            apex_debug.message(c_debug_template, 'no data found', p_svt_component_type_id);
            return null;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end seed_default_query;

    function valid_html_yn (p_html in clob) 
    return varchar2 
    deterministic
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'valid_html_yn';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    c_html constant clob := replace(
                            replace(
                            lower(trim(p_html))
                            , '&')
                            , '<br>');
    l_xml xmltype;
    e_malformed_xml exception;
    pragma exception_init(e_malformed_xml, -31011);
    l_skip_parse_yn varchar2(1) := gc_n;
    begin
        -- apex_debug.message(c_debug_template,'START', 'p_html', p_html);

        l_skip_parse_yn := case when c_html is null 
                                then gc_y
                                when c_html like '<input%'
                                then gc_y
                                when c_html like '<img%'
                                then gc_y
                                when c_html like '%{if%'
                                then gc_y
                                when c_html like '%autoplay%'
                                then gc_y
                                else gc_n
                                end;

        if l_skip_parse_yn = gc_n then
            select xmlparse(content c_html) as po
            into l_xml 
            from dual;
        end if;

        return gc_y;
    exception 
        when e_malformed_xml then 
            return gc_n;
        when others then 
            apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
            raise;
    end valid_html_yn;


end SVT_STDS_PARSER;
/

--rollback drop package SVT_STDS_PARSER;
