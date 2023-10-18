--liquibase formatted sql
--changeset object_type_script:APEX_APPLICATION_PAGE_RPT_COLS_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('APEX_APPLICATION_PAGE_RPT_COLS_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   apex_application_page_rpt_cols_ot.sql
--        Date:  2022-Oct-14
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------
create type APEX_APPLICATION_PAGE_RPT_COLS_OT as object
    (   application_id    number,
        page_id           number, 
        region_name       varchar2(255), 
        use_as_row_header varchar2(3),
        region_id         number, 
        created_by        varchar2(255 char),
        created_on        date,
        updated_by        varchar2(255 char),
        updated_on        date,
        column_id         number,
        workspace         varchar2(255 char),
        build_option      varchar2(255 char)
    )
/
--rollback drop type APEX_APPLICATION_PAGE_RPT_COLS_OT;