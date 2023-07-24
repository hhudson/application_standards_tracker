--------------------------------------------------------
--  DDL for View v_SVT_db_view_naming
--------------------------------------------------------

create or replace force view v_SVT_db_view_naming as
select pass_yn,
       view_name,
       unqid
from SVT_standard_view.v_SVT_db_view__0(p_standard_code => 'VIEW_NAME',
                                        p_failures_only => 'Y')
/