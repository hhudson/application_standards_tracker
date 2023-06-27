--liquibase formatted sql
--changeset package_script:DEV_SUPPORT_UTILS stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE dev_support_utils AS
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2021. All Rights Reserved.       
--                                                                     
-- NAME                                                               
--                                                                      
-- dev_support_utils                                               
--                                                                  
-- DESCRIPTION                                                       
--                                                                    
-- This package provides routines for development support.             
--                                                                      
--                                                                       
-- RUNTIME DEPLOYMENT: No                                                
--                                                                      
-- MODIFIED (MM/DD/YYYY)                                                 
--                                                                        
-- c. bostock 30/01/2021 - Created       
-- hayhudso   14/9/2022 - modified valid_constr_name                                 
----------------------------------------------------------------------------

---------------------------------------------------------------------------- 
-- Global constants                                                          
---------------------------------------------------------------------------- 
  MIN_PROD_APP_ID     constant number            := 700000;
  MAX_PROD_APP_ID     constant number            := 8000000;

  SELECT_SEARCH_STR   constant varchar2(150) := 'select.*from[[:space:][:blank:]]+([\.a-z_0-9]*).*';
  UPDATE_SEARCH_STR   constant varchar2(150) := '^.*[[:space:][:blank:]]*update[[:space:][:blank:]]+(["\.a-z_0-9]*).*';
  DELETE_SEARCH_STR   constant varchar2(150) := '^.*[[:space:][:blank:]]*delete[[:space:][:blank:]]+from[[:space:][:blank:]]+(["\.a-z_0-9]*).*';
----------------------------------------------------------------------------
-- Exceptions                                                             
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- Type declarations.                                                     
----------------------------------------------------------------------------
  type t_object_ref_row  is record 
      ( search_object          user_objects.object_name%type
      , referenced_by_name     user_objects.object_name%type
      , referenced_by_type     user_objects.object_type%type
      , application_id         apex_application_page_regions.application_id%type
      , command_type           varchar2(6)
      , supplementary          varchar2(250));

  type t_object_references is table of t_object_ref_row;


----------------------------------------------------------------------------
--  Global Constants                                                      
---------------------------------------------------------------------------- 

---------------------------------------------------------------------------- 
-- Function signatures.                                                      
---------------------------------------------------------------------------- 

  function generate_table_script( p_table_name varchar2
                                , p_include_add_cols varchar2 default 'N' 
                                , p_remove_quotes varchar2 default 'N'
                                , p_remove_nls    varchar2 default 'N'
                                , p_author        varchar2 default null
                                ) return clob;

  function generate_table_fk_script( p_table_name varchar2 
                                   , p_author     varchar2 default null) 
  return clob;

  function generate_biu_trigger_script( p_table_name   varchar2
                                      , p_sqlplus_mode varchar2 := 'Y'
                                      , p_author       varchar2 default null ) 
  return clob;

  function generate_comment_script(p_table_name in user_col_comments.table_name%type,
                                   p_author     in varchar2 default null)  
  return clob;

  function generate_package_script(p_package_name in all_source.name%type,
                                   p_schema       in all_source.owner%type default null,
                                   p_type         in all_source.type%type default null)  
  return clob;

---------------------------------------------------------------------------- 
-- The table_abbreviation function's main purpose is to formulate a          
-- table's abbreviation based upon the table's name. It can, however,        
-- determine other ralated attributes of the table. A table abbreviation     
-- is based upon its domain (three character prefix followed by an           
-- underscore), followed its alias, where the alias is made up of letters      
-- abbreviating the segements of the name, where the segments are the name   
-- parts (not including the domain), which are delimited by underscores.     
--
-- Note the number of letters taken from each segment to formulate the       
-- alias, varies, depending on the number of segements in the name. We       
-- work with a 6 character limit for the alias. So if there are 6            
-- segements in the table name, e.g. CFG_THIS_ISA_SIX_SEGMENT_TABLE_NAME.    
-- So here CFG represents the table domain, and does not count as a name     
-- segment. Where there are enough characters in a segment, we don't 
-- include vowels.
---
-- So for CFG_THIS_ISA_SIX_SEGMENT_TABLE_NAME, the table alias would be      
-- 'TSSTN' and the table abbreviation would be 'CFG_TSSTN'. If we have       
-- fewer segments, we take more characters from each segment.                
---------------------------------------------------------------------------- 

---------------------------------------------------------------------------- 
-- The load_cssap procedure performs an insert only load to the              
-- dev_ohms_cssap_data_matrix table, which is maintainded for CSSAP          
-- compliance. Any duplicate keys are skipped, during the load.              
---------------------------------------------------------------------------- 
  procedure load_cssap;

  function parse_sql ( p_sql_text         in clob )
  return varchar2;

  procedure parse_sql(
                        p_sql_text     in clob
                      , p_feedback     out nocopy clob
                      , p_sqlcode      out number
                     );

---------------------------------------------------------------------------- 
-- The update_cssap procedure provides a method of loading and updating      
-- the dev_ohms_cssap_data_matrix table. Update options (p_mode) as          
-- 'INSERT' or 'UPSERT'. Note that if a duplicate key is encountered         
-- during an insert operation we add 1 to the p_skipped output and skip to   
-- the next insert. In INSERT mode we never attempt updates. In UPSERT       
-- mode, we attempt an update and if the row does not exist, we insert it.   
--
-- The p_cssap_discards and p_blacklist_discards are determined at the       
-- very end, where we have finished loading. At this stage we purge any      
-- entries corresponding to tables either on the basis, that they are not    
-- flagged as being required as part of CSSAP compliance (e.g. tables used   
-- for development support) or because they have been blacklisted as part    
-- of the data modelling process).                                           
---------------------------------------------------------------------------- 

  procedure update_cssap ( p_mode                 in  varchar2
                         , p_start_total_tables   out number
                         , p_end_total_tables     out number
                         , p_start_total_elements out number
                         , p_end_total_elements   out number
                         , p_inserts              out number
                         , p_skipped              out number
                         , p_updates              out number
                         , p_cssap_discards       out number
                         , p_blacklist_discards   out number);

  function table_abbreviation ( p_table_name       in varchar2
                              , p_attribute        in varchar2 := 'TABLE_ABBREVIATION'
                              , p_schema_name      in varchar2 := sys_context( 'userenv', 'current_schema' )
                              , p_force_uniqueness in varchar2 := 'Y' )
  return varchar2;

  function table_referenced ( p_table_name    in varchar2
                            , p_mode          in varchar2 := 'SHALLOW' )
  return varchar2 deterministic;

  function object_references ( p_object_name    in varchar2
                             , p_all_apps       in varchar2     := 'N' 
                             , p_first_row_only in varchar2     := 'N')
  return t_object_references pipelined deterministic;

------------------------------------------------------------------------------
--  Updator: Hayden Hudson
--     Date: September 14, 2022
-- Synopsis:
--
-- Function to return valid constraint names 
--
------------------------------------------------------------------------------
  function valid_constr_name ( p_constraint_name  in varchar2
                             , p_option           in varchar2 
                             , p_schema_name      in varchar2 := sys_context( 'userenv', 'current_schema' )
                             , p_table_name       in varchar2 default null
                             )
  return varchar2;

  function valid_index_name  ( p_index_name       in varchar2
                             , p_option           in varchar2
                             , p_schema_name      in varchar2 := sys_context( 'userenv', 'current_schema' ))
  return varchar2;

---------------------------------------------------------------------------- 
-- Function specificially designed for transforming the                      
-- search_condition_vc column values for check constraints. This is used     
-- by the V_DEV_CHECK_CONSTRAINT_DUPS view.                                  
---------------------------------------------------------------------------- 
  function transform_sc ( p_search_condition   varchar2
                        , p_option             varchar2)
  return varchar2;

  function generate_table_index_script(p_table_name varchar2) return clob;

    function generate_table_constraint_script( p_table_name varchar2 ) 
  return clob ;

end dev_support_utils;
/

--rollback drop package DEV_SUPPORT_UTILS;
