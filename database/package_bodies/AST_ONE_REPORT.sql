--liquibase formatted sql
--changeset package_body_script:AST_ONE_REPORT stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE BODY AST_ONE_REPORT is
--
--
function get_query( p_table_name    in varchar2,
                    p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return clob is
l_query         clob;
l_table_name    varchar2(4000) := nvl(p_table_name, 'DUAL');
begin
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
        from ast_one_report_macro.user_tab_col_macro(p_table_name => l_table_name, p_schema_name => p_schema_name)
        where column_name not in ('CREATED','CREATED_BY','UPDATED','UPDATED_BY')
        order by alias_rn ;
    l_query := 'select ' || l_query || chr(13) || ' from ' || sys.dbms_assert.enquote_name(l_table_name, false);
    return l_query;
end get_query;
--
--
function get_headers(p_table_name   in varchar2,
                     p_pretty_yn    in varchar2 default 'Y',
                     p_schema_name  in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2 is
l_headers       varchar2(4000);
l_table_name    varchar2(4000) := nvl(p_table_name, 'DUAL');
begin
    select listagg(
            nvl(
                case 
                    when p_pretty_yn = 'Y' then initcap(replace(nvl(column_name,column_alias),'_',' '))
                    else nvl(column_name,column_alias)
                    end    
                , column_alias),':') col_headers
    into l_headers
    from ast_one_report_macro.user_tab_col_macro(p_table_name => l_table_name, p_schema_name => p_schema_name) 
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
l_table_name    varchar2(4000) := nvl(p_table_name, 'DUAL');
begin
    if l_table_name = 'DUAL' then
        return true;
    end if;
    select count(*)
      into l_count
      from ast_one_report_macro.user_tab_col_macro(p_table_name => l_table_name, p_schema_name => p_schema_name) 
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
l_table_name    varchar2(4000) := nvl(p_table_name, 'DUAL');
begin
    for i in (select alias_rn, column_name, column_alias
              from ast_one_report_macro.user_tab_col_macro(p_table_name => l_table_name, p_schema_name => p_schema_name)
              order by alias_rn
              ) loop
        l_header := case 
                        when p_pretty_yn = 'Y' then initcap(replace(nvl(i.column_name, i.column_alias),'_',' '))
                        else nvl(i.column_name, i.column_alias)
                        end;
                        
        apex_util.set_session_state(p_base_item_name || i.alias_rn, l_header);
    end loop;
end set_IR_columns_headers;
end ast_one_report;
/

--rollback drop package AST_ONE_REPORT;
