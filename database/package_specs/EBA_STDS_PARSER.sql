--liquibase formatted sql
--changeset package_script:EBA_STDS_PARSER stripComments:false endDelimiter:/ runOnChange:true
create or replace package eba_stds_parser authid definer as
    -- g_collection constant varchar2(255):= 'EBA_STDS_PARSER';
    -- g_false_neg  constant varchar2(31) := 'FALSE_NEGATIVE';
    -- g_legacy     constant varchar2(31) := 'LEGACY';
    -- g_ticket     constant varchar2(31) := 'TICKET';
    -- g_dummy_name constant eba_stds_standard_tests.test_name%type := 'DUMMY';


    -- function view_sql (p_view_name in user_views.view_name%type,
    --                    p_owner     in all_views.owner%type default null) return clob;

    

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 25, 2023
-- Synopsis:
--
-- function to replace build_link using v_svt_flow_dictionary_views.link_url/component_type_id 
-- see p8000 in app 4000 and f4000_searchResults.js
/*
'<button type="button" class="a-Button edit-button" data-link="' ||
       wwv_flow_utilities.prepare_url( link_url ) || '"' ||
       case when component_type_id is not null then
         ' data-appid="'       || flow_id || '"' ||
         ' data-pageid="'      || page_id || '"' ||
         ' data-typeid="'      || component_type_id || '"' ||
         ' data-componentid="' || component_id || '"'
       end ||
       '>' || wwv_flow_lang.system_message( 'VIEW_IN_BUILDER' ) || '</button>' as view_button
*/
/*
select audit_id, test_id,
       eba_stds_parser.build_url(
                        p_svt_component_type_id => svt_component_type_id,
                        p_app_id                => application_id,
                        p_page_id               => page_id,
                        p_pk_value              => component_id,
                        p_parent_pk_value       => parent_component_id,
                        p_builder_session       => v('APX_BLDR_SESSION')
       ) the_url
from v_svt_plsql_apex_audit
where audit_id = 78318
*/
------------------------------------------------------------------------------
    function build_url( p_template_url          in v_svt_flow_dictionary_views.link_url%type,
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
    return varchar2 deterministic result_cache;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 26, 2023
-- Synopsis:
--
-- Procedure to retrieve key values about component types 
--
/*
set serveroutput on
declare
l_component_name    svt_component_types.component_name%type;
l_component_type_id v_svt_flow_dictionary_views.component_type_id%type;
l_template_url      v_svt_flow_dictionary_views.link_url%type;
begin
    eba_stds_parser.get_component_type_rec (
                        p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID, --11
                        p_component_name        => l_component_name,
                        p_component_type_id     => l_component_type_id,
                        p_template_url          => l_template_url
                    );
    dbms_output.put_line('l_component_name :'||l_component_name);
    dbms_output.put_line('l_component_type_id :'||l_component_type_id);
    dbms_output.put_line('l_template_url :'||l_template_url);
end;
*/
------------------------------------------------------------------------------
    procedure get_component_type_rec (
                        p_svt_component_type_id in svt_component_types.id%type,
                        p_component_name        out nocopy svt_component_types.component_name%type,
                        p_component_type_id     out nocopy v_svt_flow_dictionary_views.component_type_id%type,
                        p_template_url          out nocopy v_svt_flow_dictionary_views.link_url%type
                    );



    -- procedure add_applications;

    -- function default_app_id  
    --     return apex_applications.application_id%type deterministic;

    -- function accessibility_app_id
    --     return apex_applications.application_id%type deterministic;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 25, 2023
-- Synopsis:
--
-- Function to determine whether a given url is valid. Used by the 'val_button_links' test, for eg
--
------------------------------------------------------------------------------
    function is_valid_url (p_origin_app_id in apex_applications.application_id%type,
                           p_url in varchar2) 
        return varchar2 deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 25, 2023
-- Synopsis:
--
-- Function to extract the app_id from a url, used by all the mv views (mv_svt_buttons for eg)  
--
------------------------------------------------------------------------------
    function app_from_url ( p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return  apex_applications.application_id%type deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 24, 2023
-- Synopsis:
--
-- function to extract the page_id from a url  
--
/*
select eba_stds_parser.page_from_url(p_origin_app_id => application_id,
                                     p_url => home_link)
from apex_applications
*/
------------------------------------------------------------------------------
    function page_from_url (p_origin_app_id in apex_applications.application_id%type,
                            p_url           in varchar2) return apex_application_pages.page_id%type deterministic;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- function to id whether or not it is being called from a builder session
--
/*
set serveroutput on
declare
l_boolean boolean;
l_override_value number := 123123123;
begin
    l_boolean := eba_stds_parser.is_logged_into_builder(l_override_value);
    if l_boolean then 
        dbms_output.put_line('logged in');
    else 
        dbms_output.put_line('not logged in');
    end if;
end;
*/
------------------------------------------------------------------------------
    function is_logged_into_builder (p_override_value in number default null) return boolean;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- Procedure to determine if a given application is in the same workspace as the Application Standard Tracker
--
/*
declare
l_boolean boolean
begin
    l_boolean := eba_stds_parser.app_in_current_workspace(100);
end;
*/
------------------------------------------------------------------------------
    function app_in_current_workspace (p_app_id in apex_applications.application_id%type) 
    return boolean;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 30, 2023
-- Synopsis:
--
-- Function to return a default query, given an svt_component_type_id
--
/*
select eba_stds_parser.seed_default_query(p_svt_component_type_id => :P14_SVT_COMPONENT_TYPE_ID) stmt
from dual
*/
------------------------------------------------------------------------------
    function seed_default_query(p_svt_component_type_id in svt_component_types.id%type)
    return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- Function to return the base url for an apex workspace
--
/*
select eba_stds_parser.get_base_url()
from dual;
*/
------------------------------------------------------------------------------
    function get_base_url return varchar2 deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 24, 2023
-- Synopsis:
--
-- Function to determine whether or not an HTML block is valid
--
/*
    select eba_stds_parser.valid_html_yn('<b>hello</b>') valid_yn
    from dual;
*/
------------------------------------------------------------------------------
    function valid_html_yn (p_html in clob) 
    return varchar2
    deterministic;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: October 2, 2023
-- Synopsis:
--
-- Function to determine whether a given column exists in a given table 
/*
set serveroutput on
declare
l_bool boolean;
begin
    l_bool := eba_stds_parser.column_exists 
                    (p_column_name => 'UPDATED_BY',
                     p_table_name => 'APEX_APPLICATION_PAGE_REGIONS'
                    );
    if l_bool then 
        dbms_output.put_line('column exists');
    else 
        dbms_output.put_line('column does not exist');
    end if;
end;
*/
------------------------------------------------------------------------------
    function column_exists (p_column_name in all_tab_cols.column_name%type,
                            p_table_name  in all_tab_cols.table_name%type) 
    return boolean;

    e_subscript_beyond_count exception;
    pragma exception_init(e_subscript_beyond_count, -6533);
    e_not_a_number exception;
    pragma exception_init(e_not_a_number, -6502);
    e_number_conversion exception;
    pragma exception_init(e_number_conversion, -1722);
    e_table_not_exist exception;
    pragma exception_init(e_table_not_exist, -942);
    e_invalid_object exception;
    pragma exception_init(e_invalid_object, -44002);

end eba_stds_parser;
/

--rollback drop package EBA_STDS_PARSER;
