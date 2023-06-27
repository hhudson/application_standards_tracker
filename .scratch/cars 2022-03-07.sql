select application_id
            --into l_application_id
            from eba_stds_test_validations
            where 1=1
             --and result_identifier = :p_result_identifier --3716510126216353716
            and test_id = :p_test_id --
            ;
            /
select * 
from eba_stds_test_validations
/
select * 
from eba_stds_standard_tests
where id = 289000659480371409667981223032034850687
/
desc user_views
/
declare
l_long long;
l_clob clob;
begin
select text
into l_long
from user_views
where rownum =1;

l_clob := to_clob(l_long);
end;
/
declare
    l_collection varchar2(255) := 'EBA_STDS_P15_TEST_RESULTS';
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
                where id = :P15_TEST_ID ) loop
        l_names := apex_util.string_to_table( c1.app_bind_variable );
        l_values := apex_util.string_to_table( :P15_APPLICATION_ID );

        apex_collection.create_collection_from_query_b(
            p_collection_name => l_collection,
            p_query => c1.check_sql,
            p_names => l_names,
            p_values => l_values
        );
    
        -- Now get the column headings and which columns to display.
        l_cursor := dbms_sql.open_cursor;
        dbms_sql.parse(l_cursor, c1.check_sql, dbms_sql.native);
        sys.dbms_sql.bind_variable( l_cursor, c1.app_bind_variable, :P15_APPLICATION_ID );

        l_feedback := dbms_sql.execute(l_cursor);

        dbms_sql.describe_columns(l_cursor, col_cnt, l_rec_tab);

        for j in 3..10 loop
            apex_util.set_session_state('P15_COL'||j, initcap(replace(l_rec_tab(j).col_name,'_',' ')));
            l_headers := l_headers||':'||initcap(replace(l_rec_tab(j).col_name,'_',' '));
            l_cols    := l_cols||':c0'||to_char(j,'fm00');
        end loop;
        dbms_sql.close_cursor(l_cursor);
    end loop;

    :P15_HEADINGS := l_headers;
    :P15_COLS := l_cols;
end;
/
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
    eba_stds_parser.load_collection(  
                        p_page_id           => :PAGE_ID,
                        p_application_id => :P19_APPLICATION_ID,
                        p_test_id           => :P19_TEST_ID);
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

        for j in 3..10 loop
            apex_util.set_session_state('P19_COL'||j, initcap(replace(l_rec_tab(j).col_name,'_',' ')));
            l_headers := l_headers||':'||initcap(replace(l_rec_tab(j).col_name,'_',' '));
            l_cols    := l_cols||':c0'||to_char(j,'fm00');
        end loop;
        dbms_sql.close_cursor(l_cursor);
    end loop;

    :P19_HEADINGS := l_headers;
    :P19_COLS := l_cols;
end;
/
alter table EBA_STDS_STANDARD_TESTS add query_view varchar2(255) 
/
alter table EBA_STDS_STANDARD_TESTS drop column query_view
/
select * 
from EBA_STDS_STANDARD_TESTS
/
select * 
from apex_collections
/
select * 
from apex_applications
/
select page_id, page_name
from apex_application_pages
where application_id = :APP_ID
and page_mode = 'Normal'
and page_alias in (select substr(view_name,7,29)
                    from user_views
                    where view_name like 'V_AST%')
order by page_name
/
and page_alias in (select substr(view_name,7,29) page_alias
                    from user_views
                    where view_name like 'V_AST%'
                    order by view_name)
/
select
null as col1,
'hh' badge_text,
apex_string.format(p_message => 'f?p=%0:%1', p1 => v.page_alias, p2 => :APP_SESSION) thelink,
v.badge_title
from 
(select 
view_name badge_title,
substr(view_name,7,29) page_alias
from user_views
where view_name like 'V_AST%'
order by view_name) v
/
select substr(replace(vname,'_','-'),7,29) vvname
from (
select 'v_ast_db_plsql_unusued_identifiers' vname
from dual ) z
/
select view_name, substr(view_name,7,29) page_alias
from user_views
where view_name like 'V_AST%'
order by view_name