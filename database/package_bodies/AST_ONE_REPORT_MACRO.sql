--liquibase formatted sql
--changeset package_body_script:AST_ONE_REPORT_MACRO stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE BODY AST_ONE_REPORT_MACRO as
-- SQL Macro
function user_tab_col_macro(p_table_name    in  varchar2,
                            p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2 SQL_MACRO is
begin
    return q'~with cols as (
            select row_number() over (order by ct.column_value desc, nums.column_value asc) alias_rn,
                    ct.column_value ct_val, nums.column_value nums_val,
                    case ct.column_value
                        when 'VARCHAR2' then 'vc' || nums.column_value
                        when 'NUMBER' then 'n' || nums.column_value
                        when 'DATE' then 'd' || nums.column_value
                        end column_alias
            from apex_string.split_numbers('1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20',',') nums
               , apex_string.split('VARCHAR2,NUMBER,DATE',',') ct
            order by ct.column_value desc, nums.column_value 
            )
            select utc.table_name, utc.column_name, utc.data_type, utc.column_id, utc.rn,
                   cols.alias_rn, cols.ct_val, cols.nums_val, cols.column_alias
            from cols
            left outer join (
                            select table_name, column_name, data_type, column_id,
                                row_number() over (partition by table_name, data_type order by column_id) rn
                            from all_tab_cols
                            where table_name = user_tab_col_macro.p_table_name 
                              and owner = user_tab_col_macro.p_schema_name 
                            ) utc 
                on utc.rn = cols.nums_val
                and utc.data_type = cols.ct_val ~';
                           
                              -- and column_name not in ('CREATED','CREATED_BY','UPDATED','UPDATED_BY')
end user_tab_col_macro;
                   
end ast_one_report_macro;
/

--rollback drop package AST_ONE_REPORT_MACRO;
