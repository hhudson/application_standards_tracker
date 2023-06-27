--liquibase formatted sql
--changeset package_script:AST_APEX_SERT_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package ast_apex_sert_util authid definer as
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2020. All Rights Reserved.
-- 
-- NAME
--   ast_apex_sert_util
--
-- DESCRIPTION
--
-- RUNTIME DEPLOYMENT: Yes
--
-- MODIFIED  (YYYY-MON-DD)
-- hayhudso  2022-Nov-22 - created
---------------------------------------------------------------------------- 

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: April 11, 2023
-- Synopsis:
--
-- Procedure to query existing SERT views
--
/*
select 
      collection_name,
      collection_sql,
      category_name,
      category_short_name,
      attribute_name,
      attribute_key,
      attribute_id,
      rule_source,
      rule_type,
      when_not_found,
      table_name,
      column_name,
      fix,
      info,
      category_id,
      category_key
from ast_apex_sert_util.v_ast_sert()
*/
------------------------------------------------------------------------------
function v_ast_sert
return v_ast_sert_nt pipelined;

$if oracle_apex_version.c_sert_access
$then
------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 22, 2022
-- Synopsis:
--
-- Generate view from category key (overloaded)
/*
select ast_apex_sert_util.generate_ast_view (p_collection_name => 'SV_XSS_PLSQL_OUTPUT',
                                             p_author => 'hayden.h.hudson@oracle.com') stmt
from dual
*/
--
------------------------------------------------------------------------------
function generate_ast_view (p_collection_name     in sv_sert_apex.sv_sec_score_collections.collection_name%type,
                            p_author              in varchar2 default null,
                            p_select_stmt_only_yn in varchar2 default 'N')
return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 30, 2022
-- Synopsis:
--
-- Generate view from view name (overloaded)
/*
select ast_apex_sert_util.generate_ast_view (p_view_name => 'V_AST_APEX_SERT_59_SV_XSS_UNESCAPED_REGIONS',
                                             p_author => 'hayden.h.hudson@oracle.com') stmt
from dual
*/
--
------------------------------------------------------------------------------
function generate_ast_view (p_view_name in varchar2, 
                            p_author    in varchar2 default null)
return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: January 24, 2023
-- Synopsis:
--
-- Procedure to populate eba_stds_standard_tests with SERT queries
/*
begin
       ast_apex_sert_util.populate_eba_stds_standard_tests_w_sert_queries;
end;
*/
------------------------------------------------------------------------------
procedure populate_eba_stds_standard_tests_w_sert_queries;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2022
-- Synopsis:
--
-- Get view name for a given security attribute
--
/*
select ast_apex_sert_util.generate_view_name(p_collection_name => 'SV_XSS_PLSQL_OUTPUT')
from dual
*/
------------------------------------------------------------------------------
function generate_view_name(p_collection_name in v_ast_sert.collection_name%type)
return varchar2;

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 28, 2022
-- Synopsis:
--
-- Generate the 1st part of the view ddl
--
/*
select ast_apex_sert_util.generate_create_stmt(p_collection_name => 'SV_XSS_PLSQL_OUTPUT')
from dual
*/
------------------------------------------------------------------------------
function generate_create_stmt(p_collection_name in v_ast_sert.collection_name%type,
                              p_author          in varchar2 default null)
return varchar2;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 29, 2022
-- Synopsis:
--
-- generate the select part of the view
/*
select ast_apex_sert_util.generate_select_stmt(p_collection_name => 'SV_XSS_PLSQL_OUTPUT')
from dual
*/
--
------------------------------------------------------------------------------
function generate_select_stmt (p_collection_name in v_ast_sert.collection_name%type)
return v_ast_sert.collection_sql%type;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: November 30, 2022
-- Synopsis:
--
-- generate view that unions all the sert views
/*
select ast_apex_sert_util.generate_union_view(p_author => 'hayden.h.hudson@oracle.com')
from dual
*/
--
------------------------------------------------------------------------------
function generate_union_view (p_author in varchar2)
return clob;


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 22, 2022
-- Synopsis:
--
-- Procedure to populate the ast_sert_how_to_fix.SOURCE_INFO_FIX_MD5 column 
--
------------------------------------------------------------------------------
procedure populate_ast_sert_how_to_fix_md5;
$end

end ast_apex_sert_util;
/

--rollback drop package AST_APEX_SERT_UTIL;
