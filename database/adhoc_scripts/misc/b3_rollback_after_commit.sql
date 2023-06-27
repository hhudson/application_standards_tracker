delete from eba_stds_standard_tests;
delete from eba_stds_standards;--
delete from eba_stds_applications;--
delete from eba_stds_standard_type_ref;--
delete from eba_stds_types;--
/
insert into eba_stds_standards (id, name, description)
select id, name, description
from eba_stds_standards AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_types (id, display_sequence, name)
select id, display_sequence, name
from eba_stds_types AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_applications (id, apex_app_id, status_id, type_id)
select id, apex_app_id, status_id, type_id
from eba_stds_applications AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_standard_type_ref (standard_id, type_id)
select standard_id, type_id
from eba_stds_standard_type_ref AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_standard_tests ( id, standard_id, test_type, name, display_sequence, query_view, link_type, failure_help_text)
select id, standard_id, test_type, name, display_sequence, query_view, link_type, failure_help_text
from eba_stds_standard_tests AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/
insert into eba_stds_test_validations (id, test_id, application_id, result_identifier, false_positive_yn, legacy_yn, created, created_by, updated, updated_by)
select id, test_id, application_id, result_identifier, false_positive_yn, legacy_yn, created, created_by, updated, updated_by
from eba_stds_test_validations AS OF TIMESTAMP 
   TO_TIMESTAMP('2022-03-23 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
/

MERGE
INTO    ast_plsql_apex_audit trg
USING   (
        select reference_code, notes, action_id, created
        from ast_plsql_apex_audit AS OF TIMESTAMP 
           TO_TIMESTAMP('2022-09-26 15:30:00', 'YYYY-MM-DD HH24:MI:SS')
           where issue_category = 'APEX'
        ) src
ON      (trg.reference_code = src.reference_code)
WHEN MATCHED THEN UPDATE
    SET trg.notes = src.notes,
        trg.action_id = src.action_id,
        trg.created = src.created
    ;