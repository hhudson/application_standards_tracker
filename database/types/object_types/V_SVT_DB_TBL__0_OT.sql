--liquibase formatted sql
--changeset object_type_script:V_SVT_DB_TBL__0_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_TBL__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   v_svt_db_tbl__0_ot.sql
--        date:  2023-feb-7
--     purpose:  type creation ddl
--
-- drop type v_svt_db_tbl__0_nt
-- /
-- drop type v_svt_db_tbl__0_ot
-- /
--------------------------------------------------------------------------------

  create type V_SVT_DB_TBL__0_OT as object
    (   
      PASS_YN    VARCHAR2(1 CHAR),
      TABLE_NAME VARCHAR2(128 CHAR),
      UNQID      VARCHAR2(250 CHAR),
      CODE       VARCHAR2(1000 CHAR),
      OBJECT_ID  NUMBER
    ) 
/
--rollback drop type V_SVT_DB_TBL__0_OT;