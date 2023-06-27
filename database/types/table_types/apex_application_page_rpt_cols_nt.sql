--liquibase formatted sql
--changeset table_type_script:APEX_APPLICATION_PAGE_RPT_COLS_NT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('APEX_APPLICATION_PAGE_RPT_COLS_NT');
create type apex_application_page_rpt_cols_nt as table of apex_application_page_rpt_cols_ot
/
--rollback drop type APEX_APPLICATION_PAGE_RPT_COLS_NT;