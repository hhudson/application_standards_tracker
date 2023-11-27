--liquibase formatted sql
--changeset table_script:SVT_STDS_STANDARD_TESTS stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('SVT_STDS_STANDARD_TESTS');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STDS_STANDARD_TESTS.sql
--        Date:  10-Apr-2023 17:45
--     Purpose:  Table creation DDL for table SVT_STDS_STANDARD_TESTS
--               and related objects.
-- data is deployed via SVT_STDS_TESTS_LIB
--
--------------------------------------------------------------------------------


  create table svt_stds_standard_tests 
   (	id                    number generated by default on null as identity, 
      standard_id           number not null, 
      test_name             varchar2(64 char) not null, 
      display_sequence      number, 
      query_clob            clob, 
      owner                 varchar2(128) default sys_context('userenv','current_schema'), 
      test_code             varchar2(100 char) not null, 
      level_id              number,
      explanation           varchar2(4000 char), 
      fix                   clob,
      active_yn             varchar2(1) default 'Y', 
      version_number        number not null,
      version_db            varchar2(55 char) not null,
      mv_dependency         varchar2(100),
      svt_component_type_id number not null,
      avg_exctn_scnds       number,
      created               timestamp (6) with local time zone default systimestamp not null,
      created_by            varchar2(255 char)                 default user not null,
      updated               timestamp (6) with local time zone default systimestamp not null,
      updated_by            varchar2(255 char)                 default user not null
   ) 
/

  create index svt_ststts_idx1 on svt_stds_standard_tests (standard_id) 
/
  create index svt_ststts_idx4 on svt_stds_standard_tests (level_id) 
/
  alter table svt_stds_standard_tests add constraint svt_stds_standard_tests_uk1 unique (test_name)
  using index  enable
/
  alter table svt_stds_standard_tests add constraint svt_ststts_pk primary key (id)
  using index (create unique index svt_ststts_pk_idx on svt_stds_standard_tests (id) 
  )  enable
/

alter table svt_stds_standard_tests add constraint svt_stds_standard_tests_uk2 unique (test_code)
using index  enable
/
  alter table svt_stds_standard_tests add constraint svt_stds_standard_tests_uk3 unique (standard_id, id)
  using index  enable
/
 create index svt_stds_standard_tests_idx1 on svt_stds_standard_tests (svt_component_type_id)
/

--rollback drop table SVT_STDS_STANDARD_TESTS;