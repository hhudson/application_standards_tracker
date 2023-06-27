declare
    l_collection varchar2(255) := 'EBA_STDS_P19_TEST_RESULTS';
    l_names apex_application_global.vc_arr2;
    l_values apex_application_global.vc_arr2;

    l_cursor    number;
    l_feedback  number;
    col_cnt     integer;
    l_rec_tab   dbms_sql.desc_tab;
    col_num     number;
    l_headers   varchar2(4000);
    l_cols      varchar2(4000);
begin
    l_headers := ':Status:Validation:';
    -- The first three columns are special-cased.
    l_cols    := 'c002';

    -- If the collection already exists, we need to delete it; otherwise,
    -- create_collection_from_query_b will throw an error.
    if apex_collection.collection_exists( l_collection ) then
        apex_collection.delete_collection( l_collection );
    end if;

    for c1 in ( select check_sql,
                    ltrim(app_bind_variable,':') app_bind_variable,
                    link_type
                from eba_stds_standard_tests
                where id = :P19_TEST_ID ) loop
        l_names := apex_util.string_to_table( c1.app_bind_variable );
        l_values := apex_util.string_to_table( :P19_APPLICATION_ID );

        apex_collection.create_collection_from_query_b(
            p_collection_name => l_collection,
            p_query => c1.check_sql,
            p_names => l_names,
            p_values => l_values
        );
    
        -- Now get the column headings and which columns to display.
        l_cursor := dbms_sql.open_cursor;
        dbms_sql.parse(l_cursor, c1.check_sql, dbms_sql.native);
        sys.dbms_sql.bind_variable( l_cursor, c1.app_bind_variable, :P19_APPLICATION_ID );

        l_feedback := dbms_sql.execute(l_cursor);

        dbms_sql.describe_columns(l_cursor, col_cnt, l_rec_tab);

        for j in 3..col_cnt loop
            apex_util.set_session_state('P19_COL'||j, initcap(replace(l_rec_tab(j).col_name,'_',' ')));
            l_headers := l_headers||':'||initcap(replace(l_rec_tab(j).col_name,'_',' '));
            l_cols    := l_cols||':c0'||to_char(j,'fm00');
        end loop;
        dbms_sql.close_cursor(l_cursor);
    end loop;

    :P19_HEADINGS := l_headers;
    :P19_COLS := l_cols;
end;