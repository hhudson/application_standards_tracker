--liquibase formatted sql
--changeset object_type_script:V_SVT_DB_VIEW__0_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_DB_VIEW__0_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      Author:  hayhudso
-- Script name:   V_SVT_DB_VIEW__0_OT.sql
--        Date:  2023-Jan-26
--     Purpose:  Type creation DDL
--
--------------------------------------------------------------------------------

drop type v_svt_db_view__0_nt
/
drop type v_svt_db_view__0_ot
/
  create type v_svt_db_view__0_ot as object
    (   
      pass_yn    varchar2(1 char),
      schema     varchar2(128 char),
      view_name  varchar2(128 char),
      code       varchar2(1000 char),
      unqid      varchar2(5000 char)
    ) 
/
create type V_SVT_DB_VIEW__0_NT as table of V_SVT_DB_VIEW__0_OT
/
--rollback drop type V_SVT_DB_VIEW__0_OT;