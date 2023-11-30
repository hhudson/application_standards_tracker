--liquibase formatted sql
--changeset view_script:v_svt_apex_application_page_ir_col stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_SVT_APEX_APPLICATION_PAGE_IR_COL
--------------------------------------------------------

create or replace force editionable view v_svt_apex_application_page_ir_col as
select application_id, 
       page_id, 
       region_name, 
       use_as_row_header,
       region_id, 
       created_by,
       created_on,
       updated_by,
       updated_on,
       column_id,
       workspace,
       build_option
from svt_apex_view.apex_application_page_ir_col() 
/

--rollback drop view v_svt_apex_application_page_ir_col;