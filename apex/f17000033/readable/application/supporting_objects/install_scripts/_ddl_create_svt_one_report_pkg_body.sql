  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SVT_ONE_REPORT" is
--
--
function get_query( p_table_name    in varchar2,
                    p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return clob is
l_query         clob;
l_table_name    varchar2(4000) := p_table_name;
begin
    case when p_table_name is not null then 
        l_table_name := p_table_name;
    else 
        -- fetch a random table
        select table_name
        into l_table_name
        from user_tables
        order by table_name
        fetch first 1 rows only;
    end case; 
    select  listagg(case 
                    when column_name is null
                    then case 
                        when ct_val = 'NUMBER' then 'to_number(null)'
                        when ct_val = 'DATE' then 'to_date(null)'
                        else 'null'
                        end
                    else sys.dbms_assert.enquote_name(column_name)
                    end
            || ' ' ||
                    column_alias
            , ', ' || chr(13)  
                ) col_names
    into l_query
    from SVT_ONE_REPORT_MACRO.user_tab_col_macro(p_table_name => l_table_name, p_schema_name => p_schema_name)
    where column_name not in ('CREATED','CREATED_BY','UPDATED','UPDATED_BY')
    order by alias_rn ;
    l_query := 'select ' || l_query || chr(13) || ' from ' || sys.dbms_assert.enquote_name(l_table_name, false);
    return l_query;
end get_query;
--
--
function get_headers(p_table_name   in varchar2,
                     p_pretty_yn    in varchar2 default 'Y',
                     p_schema_name  in varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2 is
l_headers       varchar2(4000);
c_table_name    constant varchar2(4000) := coalesce(p_table_name, 'DUAL');
begin
    select listagg(
            coalesce(
                case 
                    when p_pretty_yn = 'Y' then initcap(replace(coalesce(column_name,column_alias),'_',' '))
                    else coalesce(column_name,column_alias)
                    end    
                , column_alias),':') col_headers
    into l_headers
    from svt_one_report_macro.user_tab_col_macro(p_table_name => c_table_name, p_schema_name => p_schema_name) 
    where column_name not in ('CREATED','CREATED_BY','UPDATED','UPDATED_BY')
    order by alias_rn;
    return l_headers;
end get_headers;
--
--
function show_column(   p_table_name        in varchar2,
                        p_column_number     in number,
                        p_schema_name       in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return boolean is
l_count         number;                        
c_table_name    constant varchar2(4000) := coalesce(p_table_name, 'DUAL');
begin
    if c_table_name = 'DUAL' then
        return true;
    end if;
    select count(*)
      into l_count
      from svt_one_report_macro.user_tab_col_macro(p_table_name => c_table_name, p_schema_name => p_schema_name) 
      where alias_rn = p_column_number
        and column_name is not null
        and rownum = 1;
    return l_count > 0;     
end show_column;
--
--
procedure set_IR_columns_headers(   p_table_name        in varchar2,
                                    p_base_item_name    in varchar2,
                                    p_pretty_yn         in varchar2 default 'Y',
                                    p_schema_name       in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) is
l_header        varchar2(4000);
c_table_name    constant varchar2(4000) := coalesce(p_table_name, 'DUAL');
begin
    for i in (select alias_rn, column_name, column_alias
              from svt_one_report_macro.user_tab_col_macro(p_table_name => c_table_name, p_schema_name => p_schema_name)
              order by alias_rn
              ) loop
        l_header := case 
                        when p_pretty_yn = 'Y' then initcap(replace(coalesce(i.column_name, i.column_alias),'_',' '))
                        else coalesce(i.column_name, i.column_alias)
                        end;
                        
        apex_util.set_session_state(p_base_item_name || i.alias_rn, l_header);
    end loop;
end set_IR_columns_headers;
end svt_one_report;
/ 