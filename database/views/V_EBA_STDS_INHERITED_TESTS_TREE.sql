--liquibase formatted sql
--changeset view_script:v_svt_stds_inherited_tests_tree stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_svt_stds_inherited_tests_tree
--------------------------------------------------------

create or replace force editionable view v_svt_stds_inherited_tests_tree as
select distinct esit.parent_standard_id standard_id, ess1.full_standard_name||' (Originating standard)' standard_name, null parent_standard_id, esit.test_id
from svt_stds_inherited_tests esit
inner join v_eba_stds_standards ess1 on ess1.id = esit.parent_standard_id
union all 
select esit.standard_id, ess2.full_standard_name standard_name, esit.parent_standard_id, esit.test_id
from svt_stds_inherited_tests esit
inner join v_eba_stds_standards ess2 on ess2.id = esit.standard_id
/

--rollback drop view v_svt_stds_inherited_tests_tree;