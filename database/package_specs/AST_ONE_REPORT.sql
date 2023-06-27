--liquibase formatted sql
--changeset package_script:AST_ONE_REPORT stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE AST_ONE_REPORT authid definer as
-- Note: this package is dependent upon the package ast_one_report_macro
-- Updated for multiple schemas
-- from https://github.com/ainielse/rando/blob/master/f_one_report.sql
--
--
function get_query( p_table_name    in varchar2,
                    p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return clob;
--
-- used for classic reports
function get_headers(p_table_name   in varchar2,
                     p_pretty_yn    in varchar2 default 'Y',
                     p_schema_name  in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2;
--
--
function show_column(   p_table_name        in varchar2,
                        p_column_number     in number,
                        p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return boolean;       
--
-- used for Interactive Reports
procedure set_IR_columns_headers(   p_table_name        in varchar2,
                                    p_base_item_name    in varchar2,
                                    p_pretty_yn         in varchar2 default 'Y',
                                    p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) ;  
end ast_one_report;
/

--rollback drop package AST_ONE_REPORT;
