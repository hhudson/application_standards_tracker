--liquibase formatted sql
--changeset package_body_script:SVT_STDS_DATA stripComments:false endDelimiter:/ runOnChange:true
create or replace package body svt_stds_data is

    gc_scope_prefix constant varchar2(32) := lower($$plsql_unit) || '.';

    procedure load_initial_data is
    c_scope constant varchar2(128) := gc_scope_prefix || 'load_initial_data';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    type rec_data is varray(3) of varchar2(4000);
    type tab_data is table of rec_data index by pls_integer;

        procedure load_svt_stds_types is 
        l_data tab_data;
        l_row svt_stds_types%rowtype;
        begin
            l_data(l_data.count + 1) := rec_data('Default'               , '10', 1);
            l_data(l_data.count + 1) := rec_data('Information Technology', '20', 2);
            l_data(l_data.count + 1) := rec_data('Engineering'           , '30', 3);
            l_data(l_data.count + 1) := rec_data('Test Application'      , '40', 4);
            l_data(l_data.count + 1) := rec_data('Initial development'   , '50', 5);
            l_data(l_data.count + 1) := rec_data('Releasable'            , '60', 6);
            l_data(l_data.count + 1) := rec_data('Production'            , '70', 7);
            l_data(l_data.count + 1) := rec_data('DB Supporting Objects' , '80', 8);

            for i in 1..l_data.count loop
                l_row.type_name := l_data(i)(1);
                l_row.id := l_data(i)(2);
                l_row.display_sequence := l_data(i)(3);

                merge into svt_stds_types dest
                using (
                    select
                    l_row.type_name type_name
                    from dual
                ) src
                on (1=1
                    and dest.type_name = src.type_name
                )
                when matched then
                update
                    set
                    dest.id = l_row.id,
                    dest.display_sequence = l_row.display_sequence
                when not matched then
                insert (
                    type_name,
                    id,
                    display_sequence)
                values(
                    l_row.type_name,
                    l_row.id,
                    l_row.display_sequence)
                ;
            end loop;
        end load_svt_stds_types;

    begin
        apex_debug.message(c_debug_template,'START');

        if not is_initial_data_loaded() then
            load_svt_stds_types;
        end if;

    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end load_initial_data;

    function is_initial_data_loaded return boolean is
    c_scope          constant varchar2(128) := gc_scope_prefix || 'is_initial_data_loaded';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    begin
        apex_debug.message(c_debug_template,'START');

        for c1 in ( select 1
                    from svt_stds_types
                    where id < 100
                     ) loop
            return true;
        end loop;
        return false;
    exception when others then 
        apex_debug.error(p_message => c_debug_template, p0 =>'Unhandled Exception', p1 => sqlerrm, p5 => sqlcode, p6 => dbms_utility.format_error_stack, p7 => dbms_utility.format_error_backtrace, p_max_length=> 4096);
        raise;
    end is_initial_data_loaded;

    procedure load_sample_data is
    c_scope          constant varchar2(128) := gc_scope_prefix || 'load_sample_data';
    c_debug_template constant varchar2(4096) := c_scope||' %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15 %16 %17 %18 %19 %20';

    begin
        apex_debug.message(c_debug_template,'START');

        -- if not is_sample_data_loaded() then
        --     load_svt_stds_standards;

        --     -- Create a few sample tests.
        --     load_svt_stds_standard_tests;
        -- end if;
    end load_sample_data;
    procedure remove_sample_data is
    begin
        delete from svt_stds_standards
        where id < 100;
    end remove_sample_data;

end svt_stds_data;
/

--rollback drop package SVT_STDS_DATA;
