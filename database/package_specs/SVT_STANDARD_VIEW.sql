--liquibase formatted sql
--changeset package_script:SVT_STANDARD_VIEW stripComments:false endDelimiter:/ runOnChange:true
create or replace package SVT_STANDARD_VIEW authid current_user as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   svt_standard_view
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2023-Jan-24 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 23, 2023
-- Synopsis:
--
-- pipeline function for v_svt_db_plsql
--
/*
select  object_name,
        object_type,
        line,
        code,
        unqid,
        ref_code
from svt_standard_view.v_svt_db_plsql(
                        p_standard_code    => 'IDENTIFIER_NAMING',
                        p_failures_only => 'Y'); 
*/
------------------------------------------------------------------------------
  function v_svt_db_plsql(p_standard_code in eba_stds_standard_tests.standard_code%type,
                          p_failures_only in varchar2 default 'N',
                          p_object_name   in SVT_plsql_apex_audit.object_name%type default null )
  return v_svt_db_plsql_ref_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- function to pipeline sert views
--
/*
select application_id, 
       attribute_id, 
       category_key, 
       collection_name, 
       component_signature, 
       issue_title, 
       last_updated_by, 
       last_updated_on, 
       link, 
       link_desc, 
       page_id, 
       result, 
       validation_failure_message
from svt_standard_view.v_svt_sert__0(
                        p_standard_code    => 'SV_PS_DEEP_LINKING',
                        p_failures_only => 'Y'); 
*/
------------------------------------------------------------------------------
  function v_svt_sert__0(p_standard_code in eba_stds_standard_tests.standard_code%type,
                         p_failures_only in varchar2 default 'N')
  return v_svt_sert__0_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jan-25
-- Synopsis:
--
-- function to pipeline apex views
--
/*
select pass_yn,
       application_id,
       page_id,
       created_by,
       created_on,
       last_updated_by,
       last_updated_on,
       validation_failure_message,
       issue_title,
       standard_code
from svt_standard_view.v_svt_apex(
                        p_standard_code => 'APP_AUTH',
                        p_failures_only => 'Y'); 
*/
------------------------------------------------------------------------------
  function v_svt_apex(p_standard_code        in eba_stds_standard_tests.standard_code%type,
                      p_failures_only        in varchar2 default 'N',
                      p_production_apps_only in varchar2 default 'N' )
  return v_svt_apex_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jan-25
-- Synopsis:
--
-- function to pipeline view views
--
/*
select view_name
from svt_standard_view.v_svt_db_view__0(
                        p_standard_code => 'VIEW_NAME'); 
*/
------------------------------------------------------------------------------
  function v_svt_db_view__0(p_standard_code in eba_stds_standard_tests.standard_code%type,
                            p_failures_only in varchar2 default 'N')
  return v_svt_db_view__0_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Feb-7
-- Synopsis:
--
-- function to pipeline table views
--
/*
select *
from svt_standard_view.v_svt_db_tbl__0(
                        p_standard_code => 'fk_indexed'); 
*/
------------------------------------------------------------------------------
  function v_svt_db_tbl__0(p_standard_code in eba_stds_standard_tests.standard_code%type,
                           p_failures_only in varchar2 default 'N')
  return v_svt_db_tbl__0_nt pipelined;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: 2023-Jan-25
-- Synopsis:
--
-- function to pipeline v_svt_plsql_apex_all
--
/*
select *
from svt_standard_view.v_svt(p_standard_code => 'MISSING_COMMENT'); 
*/
------------------------------------------------------------------------------
  function v_svt(p_standard_code        in eba_stds_standard_tests.standard_code%type,
                 p_failures_only        in varchar2 default 'N',
                 p_urgent_only          in varchar2 default 'N',
                 p_production_apps_only in varchar2 default 'N',
                 p_unqid                in SVT_plsql_apex_audit.unqid%type default null,
                 p_audit_id             in SVT_plsql_apex_audit.id%type default null
                 )
  return v_SVT_plsql_apex__0_nt pipelined;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- Function to determine if a given query clob will error when pipelined
--
/*
return svt_standard_view.query_feedback (
                p_query_code => :P14_QUERY_CLOB,
                p_SVT_component_type_id => :P14_SVT_COMPONENT_TYPE_ID
              );
*/
------------------------------------------------------------------------------
  function query_feedback (p_query_code            in eba_stds_standard_tests.query_clob%type,
                           p_svt_component_type_id in eba_stds_standard_tests.svt_component_type_id%type)
  return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- private function to return the id of a nest table type name
--
/*
select svt_standard_view.get_nt_type_id('v_SVT_sert__0_nt')
from dual;
*/
------------------------------------------------------------------------------
  function get_nt_type_id (p_nt_name in svt_nested_table_types.nt_name%type) return svt_nested_table_types.id%type;


------------------------------------------------------------------------------
-- exceptions
------------------------------------------------------------------------------
   gc_missing_field constant number := -0904;
   e_missing_field exception;
   pragma exception_init(e_missing_field, gc_missing_field);
   gc_inconsistent_data_types constant number := -0932;
   e_inconsistent_data_types exception;
   pragma exception_init(e_inconsistent_data_types,gc_inconsistent_data_types);
   gc_table_or_view_does_not_exist constant number := -0942;
   e_table_or_view_does_not_exist exception;
   pragma exception_init(e_table_or_view_does_not_exist,gc_table_or_view_does_not_exist);

end SVT_STANDARD_VIEW;
/

--rollback drop package SVT_STANDARD_VIEW;
