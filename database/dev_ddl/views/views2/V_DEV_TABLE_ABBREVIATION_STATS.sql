--liquibase formatted sql
--changeset view_script:V_DEV_TABLE_ABBREVIATION_STATS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_DEV_TABLE_ABBREVIATION_STATS
--------------------------------------------------------

----------------------------------------------------------------------------
-- DDL for View V_DEV_TABLE_ABBREVIATION_STATS                                
--                                                                       
-- View Description:
-- Used to underpin the MV_DEV_TABLE_ABBREVIATION_STATS materialised view. 
-- The MV_DEV_TABLE_ABBREVIATION_STATS is used to enhance performance in 
-- the Development Support Utilities app, specifically when dealing with
-- data modelling pages.
---------------------------------------------------------------------------- 
create or replace view v_dev_table_abbreviation_stats as
select 
       schema_name,
       table_name,
       (select valid_name_format from v_dev_table_abbreviations a
         where a.table_name = ta.table_name)     as valid_name_format,
       (select created from all_objects where object_name = ta.table_name and owner = ta.schema_name) as table_created,
       (select last_ddl_time from all_objects where object_name = ta.table_name and owner = ta.schema_name) as last_ddl_time,
       (select sysdate - created from all_objects where object_name = ta.table_name and owner = ta.schema_name) as table_days_old,
       (select count(*) from user_tab_comments c where c.table_name = ta.table_name and c.comments is not null) as tab_comments_count,
       (select count(*) from user_col_comments c where c.table_name = ta.table_name and c.comments is not null) as col_comments_count
  from dev_table_abbreviations ta
/
--rollback drop view V_DEV_TABLE_ABBREVIATION_STATS;