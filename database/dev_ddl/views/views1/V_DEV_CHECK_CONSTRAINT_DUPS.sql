--liquibase formatted sql
--changeset view_script:V_DEV_CHECK_CONSTRAINT_DUPS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_DEV_CHECK_CONSTRAINT_DUPS
--------------------------------------------------------

---------------------------------------------------------------------------- 
-- View V_DEV_CHECK_CONSTRAINT_DUPS checks for duplicate check               
-- constraints. It also converts search conditions with a COLNAME IN         
-- ('XYZ...') clauses containing a single operand to COLNAME = 'XYZ...'=.    
-- This is used to identify equivalent, but not the same checks.             
---------------------------------------------------------------------------- 
CREATE OR REPLACE FORCE EDITIONABLE VIEW V_DEV_CHECK_CONSTRAINT_DUPS  AS 
with chomp_ck
as   (
       select c.table_name
            , c.constraint_name
            , dev_support_utils.transform_sc(c.search_condition_vc, 'COLUMN_NAME') as column_name
            , c.search_condition_vc
            , dev_support_utils.transform_sc(c.search_condition_vc, 'CHOMP') as chomp_ck_condition
        from all_constraints  c
       where constraint_type = 'C'
       and instr(search_condition_vc, 'NOT NULL') = 0 
       and owner = sys_context('userenv', 'current_schema')
     )
,
     dups_ck_cols as
     ( 
        select table_name, chomp_ck_condition, count(*) as ck_instances
        from chomp_ck
        group by table_name, chomp_ck_condition
        having count(*) > 1
     )
select "TABLE_NAME","CONSTRAINT_NAME","COLUMN_NAME","SEARCH_CONDITION_VC","CHOMP_CK_CONDITION" 
  from chomp_ck
 where (table_name, chomp_ck_condition) 
   in (select  table_name, chomp_ck_condition from dups_ck_cols)
   order by table_name, column_name, constraint_name
/

--rollback drop view V_DEV_CHECK_CONSTRAINT_DUPS;