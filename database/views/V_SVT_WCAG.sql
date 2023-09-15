--liquibase formatted sql
--changeset view_script:v_svt_wcag stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_svt_wcag
--------------------------------------------------------

create or replace force editionable view V_SVT_WCAG as
select id, 
       apex_string.format('%s.%s.%s', c1st_digit, c2nd_digit, c3rd_digit) wcag_code,
       description,
       apex_string.format('%s.%s.%s', c1st_digit, c2nd_digit, c3rd_digit)
       || ' : ' ||description code_desc 
from svt_wcag
/

--rollback drop view v_svt_wcag;