--liquibase formatted sql
--changeset package_script:SVT_PLSQL_REVIEW stripComments:false endDelimiter:/ runOnChange:true
create or replace package SVT_PLSQL_REVIEW authid current_user as

    ------------------------------------------------------------------------------
    --  Creator: Hayden Hudson
    --     Date: June 17, 2022
    -- Synopsis:
    --
    -- Pipelined function to list all programed issues and warnings for a given package
    --
    /*
    select issue_desc, object_type, line, code, check_type, urgency, object_name, reference_code
    from svt_plsql_review.issues(p_object_name   => 'svt_stds')
    order by urgency_level,  issue_desc, object_name, object_type, line, code
    */
    ------------------------------------------------------------------------------
    function issues (p_object_name             in user_plsql_object_settings.name%type default null,
                     p_object_type             in user_plsql_object_settings.type%type default null,
                     p_max_test_code_count     in number default null,
                     p_max_issue_count         in number default null,
                     p_file_dirname            in varchar2 default null
                    )
    return svt_db_plsql_issue_nt pipelined;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 4, 2023
-- Synopsis:
--
-- Function to query the db for an object_type for a object_name 
--
------------------------------------------------------------------------------
  function get_object_type (p_object_name in user_objects.object_name%type) 
  return user_objects.object_type%type;

end SVT_PLSQL_REVIEW;
/

--rollback drop package SVT_PLSQL_REVIEW;
