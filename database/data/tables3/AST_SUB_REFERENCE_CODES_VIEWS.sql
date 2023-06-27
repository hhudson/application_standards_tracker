--liquibase formatted sql
--changeset data_script:AST_SUB_REFERENCE_CODES_VIEWS.sql stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from AST_SUB_REFERENCE_CODES asrc inner join EBA_STDS_STANDARD_TESTS esst on asrc.test_id = esst.id and esst.nt_type_id = 81;
--REM INSERTING into AST_SUB_REFERENCE_CODES
--SET DEFINE OFF;
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VALID_VIEW',null,'Fix the view and recompile',323233516941547792622002847102867742286);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VIEW_NAME','Views must be prefixed with ''V_''','Fix the view name',323000080806947879035411858367238017007);
