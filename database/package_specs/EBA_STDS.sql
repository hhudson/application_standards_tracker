--liquibase formatted sql
--changeset package_script:EBA_STDS stripComments:false endDelimiter:/ runOnChange:true
create or replace package eba_stds authid definer is
    -------------------------------------------------------------------------
    -- Generates a unique Identifier
    -------------------------------------------------------------------------
    function gen_id return number;
    -------------------------------------------------------------------------
    -- Handle the process of registering the scheduled job.
    -------------------------------------------------------------------------
    procedure register_job;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- public function to convert a standard name into it's primary key
--
/*
select eba_stds.get_standard_id (p_standard_name => :P34_STANDARD_NAME)
from dual
*/
------------------------------------------------------------------------------
    function get_standard_id (p_standard_name in eba_stds_standards.standard_name%type) 
    return eba_stds_standards.id%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 16, 2023
-- Synopsis:
--
-- function to get eba_stds_standard_tests.mv_dependency for a given standard code
--
/*
select eba_stds.get_mv_dependency(p_standard_code => 'UNREACHABLE_PAGE') mv
from dual;
*/
------------------------------------------------------------------------------
    function get_mv_dependency(p_standard_code in eba_stds_standard_tests.standard_code%type) 
    return eba_stds_standard_tests.mv_dependency%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: May 19, 2023
-- Synopsis:
--
-- Function to determine whether to display the 'initialize standard' on p14 
--
/*
set serveroutput on
declare
l_boolean boolean;
begin
    l_boolean := eba_stds.display_initialize_button (
                    p_standard_code => :P14_STANDARD_CODE,
                    p_level_id      => :P14_LEVEL_ID
                );
    if l_boolean then 
        dbms_output.put_line('display');
    else 
        dbms_output.put_line('do not display');
    end if;
end;
*/
------------------------------------------------------------------------------
    function display_initialize_button (
        p_standard_code in SVT_plsql_apex_audit.standard_code%type,
        p_level_id      in SVT_standards_urgency_level.id%type
    ) return boolean;

end eba_stds;
/

--rollback drop package EBA_STDS;
