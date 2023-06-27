--liquibase formatted sql
--changeset package_script:AST_ONE_REPORT_MACRO stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE AST_ONE_REPORT_MACRO authid definer as
-- SQL Macro
-- https://github.com/ainielse/rando/blob/master/f_one_report.sql
-- updated to allow different schemas
/*
select * 
from ast_one_report_macro.user_tab_col_macro(p_table_name => 'AST_AUDIT_ACTIONS', p_schema_name => 'REDWOOD')
*/
function user_tab_col_macro(p_table_name    in  varchar2,
                            p_schema_name   in  varchar2 default sys_context('USERENV', 'CURRENT_USER')) return varchar2 SQL_MACRO;
                   
end ast_one_report_macro;
/

--rollback drop package AST_ONE_REPORT_MACRO;
