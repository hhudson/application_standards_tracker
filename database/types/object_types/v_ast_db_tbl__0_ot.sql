--liquibase formatted sql
--changeset object_type_script:V_AST_DB_TBL__0_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_AST_DB_TBL__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_ast_db_tbl__0_ot.sql
--        Date:  2023-Feb-7
--     Purpose:  Type creation DDL
--
-- drop type v_ast_db_tbl__0_nt
-- /
-- drop type v_ast_db_tbl__0_ot
-- /
--------------------------------------------------------------------------------

  create type v_ast_db_tbl__0_ot as object
    (   
      PASS_YN    VARCHAR2(1 CHAR),
      TABLE_NAME VARCHAR2(128 CHAR),
      UNQID      VARCHAR2(250 CHAR),
      CODE       VARCHAR2(1000 CHAR),
      OBJECT_ID  NUMBER
    ) 
/
--rollback drop type V_AST_DB_TBL__0_OT;