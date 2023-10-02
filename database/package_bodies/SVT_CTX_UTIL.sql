--liquibase formatted sql
--changeset package_body_script:SVT_CTX_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package body SVT_CTX_UTIL
as
    gc_scope_prefix constant varchar2(32) := lower($$plsql_unit) || '.';
    gc_default_schema constant all_users.username%type := svt_preferences.get_preference ('SVT_DEFAULT_SCHEMA');

    procedure set_review_schema (p_schema in all_users.username%type default null)
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'set_review_schema';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';
    c_schema constant all_users.username%type := 
                                        case when p_schema is not null
                                             then p_schema
                                             else gc_default_schema
                                             end;
    begin
        apex_debug.message(c_debug_template,'START', 'p_schema', p_schema);
        if coalesce(sys_context('svt_ctx', 'review_schema'),'NA') = c_schema then
            apex_debug.message(c_debug_template, 'schema already set to :'||c_schema);
        else 
            dbms_session.set_context('svt_ctx',
                                    'review_schema', 
                                    c_schema
                                    );
        end if;
    end set_review_schema;

    function get_default_user
    return all_users.username%type
    is
    c_scope constant varchar2(128) := gc_scope_prefix || 'get_default_user';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10';

    c_set_schema constant all_users.username%type := sys_context('svt_ctx', 'review_schema');
    begin
        apex_debug.message(c_debug_template,'START');

        return case when c_set_schema is null
                    then gc_default_schema
                    else c_set_schema
                    end;

    exception when others then
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length => 4096);
        raise;
    end get_default_user;

end SVT_CTX_UTIL;
/

--rollback drop package SVT_CTX_UTIL;
