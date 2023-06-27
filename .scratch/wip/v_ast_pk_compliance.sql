create or replace force view v_ast_db_pk_compliance as
select a.table_name, c.constraint_name, dev_support_utils.valid_constr_name(p_constraint_name => constraint_name, p_option => 'COMPLIANT_NAME') as compliant_name
  from dev_table_abbreviations   a
      , all_constraints          c
 where c.owner                   = a.schema_name
   and c.owner                   = sys_context('userenv', 'current_schema')
   and c.table_name              = a.table_name
   and c.constraint_type         = 'P'
--   and c.search_condition_vc   not like '%IS NOT NULL'
   and c.constraint_name         != dev_support_utils.valid_constr_name(p_constraint_name => constraint_name, p_option => 'COMPLIANT_NAME')
   and c.constraint_name not     like 'BIN$%'
   and  ( NVL(:P43_IS_LOADED, 'N') = 'Y' or substr(:request, instr(:request, '_', -1) + 1) in ('CSV','XLS','PDF','RTF','HTMLD') )
/
with tpr_tables as (
    select 'vsafe_cm' table_name
    from dual
    union all
    select 'vsafe_cm_registrant_group'
    from dual
    union all
    select 'vsafe_cm_dose_restrictions'
    from dual
    union all
    select 'sch_tenants'
    from dual
)
select 
    table_name,
    lower(dev_support_utils.table_abbreviation(
        p_table_name => tt.table_name)) table_abbreviation
from tpr_tables tt
order by 1
/