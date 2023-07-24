--liquibase formatted sql
--changeset table_type_script:V_SVT_SERT_NT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from all_types where upper(type_name) = upper('V_SVT_SERT_OT');
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_SERT_NT');

create type V_SVT_SERT_NT as table of V_SVT_SERT_OT 
/
--rollback drop type V_SVT_SERT_NT;