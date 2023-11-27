--liquibase formatted sql
--changeset table_script:SVT_STDS_ERROR_LOOKUP stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('SVT_STDS_ERROR_LOOKUP');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STDS_ERROR_LOOKUP.sql
--        Date:  04-Apr-2023 21:20
--     Purpose:  Table creation DDL for table SVT_STDS_ERROR_LOOKUP
--               and related objects.
--
--------------------------------------------------------------------------------

  create table svt_stds_error_lookup 
   (	constraint_name varchar2(30 char) not null, 
      message         varchar2(4000 char) not null, 
      language_code   varchar2(30 char) not null
   ) 
/

  alter table svt_stds_error_lookup add constraint svt_sterlk_pk primary key (constraint_name)
  using index (create unique index svt_sterlk_pk_idx on svt_stds_error_lookup (constraint_name) 
  )  enable
/


  alter table svt_stds_error_lookup add constraint svt_sterlk_uk1 unique (constraint_name, language_code)
  using index (create unique index svt_sterlk_uk1_idx on svt_stds_error_lookup (constraint_name, language_code) 
  )  enable
/


--rollback drop table SVT_STDS_ERROR_LOOKUP;
