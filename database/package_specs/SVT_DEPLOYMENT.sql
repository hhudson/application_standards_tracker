--liquibase formatted sql
--changeset package_script:SVT_DEPLOYMENT stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_DEPLOYMENT
--------------------------------------------------------

create or replace package SVT_DEPLOYMENT authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   SVT_DEPLOYMENT
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- change_me  YYYY-MON-DD - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 28, 2023
-- Synopsis:
--
-- Assemble to query to return the json that is used in json_content_blob
--
/*
set serveroutput on
declare 
l_clob clob;
begin
    l_clob := svt_deployment.assemble_json_query (
                p_table_name => 'V_EBA_STDS_STANDARD_TESTS_EXPORT',
                p_standard_id => :p_standard_id,
                p_datatype => 'clob');
    dbms_output.put_line(l_clob);
end;
*/
------------------------------------------------------------------------------
    function assemble_json_query (
                p_table_name    in user_tables.table_name%type,
                p_row_limit     in number default null,
                p_test_code     in eba_stds_standard_tests.test_code%type default null,
                p_standard_id   in eba_stds_standards.id%type default null,
                p_datatype      in varchar2 default 'blob')
    return clob;
    
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 7, 2023
-- Synopsis:
--
-- function to return a blob of the json output of a table
--
/*
select svt_deployment.json_content_blob (p_table_name => 'EBA_STDS_STANDARD_TESTS')
from dual
*/
------------------------------------------------------------------------------
    function json_content_blob (p_table_name     in user_tables.table_name%type,
                                p_row_limit      in number default null,
                                p_test_code      in eba_stds_standard_tests.test_code%type default null,
                                p_standard_id    in eba_stds_standards.id%type default null,
                                p_zip_yn         in varchar2 default null)
    return blob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: July 28, 2023
-- Synopsis:
--
-- function to return a clob of the json output of a table
--
/*
set serveroutput on
declare 
l_clob clob;
begin
    l_clob := svt_deployment.json_content_clob (
                p_table_name => 'EBA_STDS_STANDARD_TESTS',
                p_test_code => 'PG_NAME_TITLE');
    dbms_output.put_line(l_clob);
end;
*/
------------------------------------------------------------------------------
    function json_content_clob (p_table_name    in user_tables.table_name%type,
                                p_row_limit     in number default null,
                                p_test_code     in eba_stds_standard_tests.test_code%type default null,
                                p_standard_id   in eba_stds_standards.id%type default null)
    return clob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 7, 2023
-- Synopsis:
--
-- Function to return json blob template file for a given table (for the purpose of uploading to Data Load Definition)
-- v_svt_table_data_load_definition
/*
select SVT_DEPLOYMENT.sample_template_file (p_table_name => 'SVT_COMPONENT_TYPES') thblob
from dual
*/
------------------------------------------------------------------------------
    function sample_template_file (p_table_name in user_tables.table_name%type)
    return blob;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 7, 2023
-- Synopsis:
--
-- Procedure to add a zip file of the json output of a given table to APEX_APPLICATION_STATIC_FILES  
--
/*
begin
    SVT_audit_util.set_workspace;
    SVT_DEPLOYMENT.upsert_static_file(p_table_name => 'SVT_COMPONENT_TYPES');
    commit;
end;
*/
------------------------------------------------------------------------------
    procedure upsert_static_file(p_table_name in user_tables.table_name%type);

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 8, 2023
-- Synopsis:
--
-- Procedure to merge the contents from a zip file  
--
/*
begin
    apex_session.create_session( 17000033, 1, 'hayden.h.hudson@oracle.com' );
    SVT_DEPLOYMENT.merge_from_zip (p_table_name => 'svt_audit_actions');
    commit;
end;
*/
------------------------------------------------------------------------------
    procedure merge_from_zip (p_table_name in user_tables.table_name%type);


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: June 21, 2023
-- Synopsis:
--
-- Function to return the date of the latest date audit value of a given table
--
/*
select svt_deployment.table_last_updated_on('SVT_AUDIT_ACTIONS')
from dual
*/
------------------------------------------------------------------------------
    function table_last_updated_on (p_table_name in user_tables.table_name%type) return apex_application_static_files.created_on%type;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 9, 2023
-- Synopsis:
--
-- pipeline the apex_workspace_preferences view
--
/*
select table_name,
       implicit_table,
       file_blob,
       mime_type,
       file_name,
       static_file_name,
       character_set,
       file_size,
       download,
       data_load_definition_name,
       static_application_file_name,
       inspect_static_file_icon,
       page_id,
       page_id_icon,
       application_file_id,
       zip_blob,
       zip_file_size,
       zip_download,
       zip_mime_type,
       zip_charset,
       zip_updated_on,
       table_last_updated_on,
       static_file_created_on,
       stale_yn
from svt_deployment.v_svt_table_data_load_def(p_application_id => 17000033) 
*/
------------------------------------------------------------------------------
function v_svt_table_data_load_def (p_application_id in apex_applications.application_id%type)
return v_svt_table_data_load_def_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: August 3, 2023
-- Synopsis:
--
-- Function to output the markdown in the github readme summary of published tests 
--
/*
select svt_deployment.markdown_summary() md
from dual;
*/
------------------------------------------------------------------------------
function markdown_summary return clob;

------------------------------------------------------------------------------
-- exceptions
------------------------------------------------------------------------------
   gc_missing_field constant number := -0904;
   e_missing_field exception;
   pragma exception_init(e_missing_field, gc_missing_field);
   gc_non_existent_tbl constant number := -0942;
   e_non_existent_tbl exception;
   pragma exception_init(e_non_existent_tbl, gc_non_existent_tbl);

end SVT_DEPLOYMENT;
/
--rollback drop package SVT_DEPLOYMENT;
