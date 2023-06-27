--liquibase formatted sql
--changeset data_script:AST_SUB_REFERENCE_CODES_PLSQL.sql stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from AST_SUB_REFERENCE_CODES asrc inner join EBA_STDS_STANDARD_TESTS esst on asrc.test_id = esst.id and esst.nt_type_id = 1;
--REM INSERTING into AST_SUB_REFERENCE_CODES
--SET DEFINE OFF;
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('ANCHORED_DECLARATION',null,'If possible, declare your variable in the style:

`l_query_clob eba_stds_standard_tests.query_clob%type;`',322950935720880724502166080490484453457);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('ANSI','Use ANSI SQL Syntax','Use ANSI SQL Syntax',322950935720877097724707236602960334929);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('CASE','Replace with CASE statement','Replace with CASE statement',322950935720877097724707236602960334929);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('COMMIT','Avoid adding commits to your code','Remove commit or at least add an explanatory comment',322950935720877097724707236602960334929);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('CONSTANT_VARIABLE','This variable should be a constant','Make the variable a constant',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('CURSOR','Cursor names must begin with cur_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('DATATYPE','Datatypes must begin with ty_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('DBMS_ASSERT',null,'Use the dbms\_assert package to sanitize the input parameters to your “execute immediate” statement. If none of the active sanitization procedures are appropriate, at least use “noop” and write a comment to acknowledge the standard.',322950935720881933427985695119659159633);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('DUPLICATE_STATEMENTS','duplicate statements may cause inefficiency','Consider consolidating the statements into a single function or procedure',322950935720878306650526851232135041105);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('EXCEPTION','Exceptions must begin with e_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('GLOBAL_CONSTANT','Package body global constants must begin with gc_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('GOTO','GOTO increases the complexity of the code','Remove GOTO or at least add an explanatory comment',322950935720877097724707236602960334929);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('LOCAL_CONSTANT','Package body local constants must begin with c_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('LOCAL_GLOBAL_CONSTANT','This global constant should be a local constant','Make it a local constant',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('MISSING_COMMENT','All package procedures and functions require an explanatory comment','Add a comment in the format:

\------------------------------------------------------------------------------  
\--  Creator: Hayden Hudson  
\--     Date: February 2, 2023  
\-- Synopsis:  
\--  
\-- Procedure, used to set employeed salary grade.    
\--  
\------------------------------------------------------------------------------',322950935720875888798887621973785628753);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('NVL','Replace with coalesce','Replace nvl with coalesce',322950935720877097724707236602960334929);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('PROC_PARAM','Procedure parameters must begin with p_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('RECORD_TYPE','Record types must begin with r_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('SPEC_CONSTANT','Package spec constants must begin with gc_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('SPEC_VARIABLE','Variables in the package spec are discouraged','Remove the variable from the package spec',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('TABLE_TYPE','Table types must begin with t_','Fix the name',322644166044903412309423206446895134070);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('UNUSED_IDENTIFIERS',null,'Remove the identifier or use it',322950935720879515576346465861309747281);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('URGENT_PLSQL_WARNINGS','This script has some important violations caught by enabling PLSQL_WARNINGS','Address the PLSQL warning and recompile',322950935720883142353805309748833865809);
Insert into AST_SUB_REFERENCE_CODES (SUB_CODE,EXPLANATION,FIX,TEST_ID) values ('VALID_OBJECTS','Object should be valid','Make the object valid or drop the object',325133220238080489354356193467575231833);
