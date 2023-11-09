--liquibase formatted sql
--changeset table_script:EBA_STDS_TYPES stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('EBA_STDS_TYPES');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_TYPES.sql
--        Date:  04-Apr-2023 22:12
--     Purpose:  Table creation DDL for table EBA_STDS_TYPES
--               and related objects.
--
--------------------------------------------------------------------------------

  create table eba_stds_types 
   (	id               number generated by default on null as identity, 
	    display_sequence number, 
	    type_name        varchar2(32 char) not null, 
      type_code        varchar2(10 char) not null,
	    description      varchar2(2000 char),
      active_yn        varchar2(1 char) default 'Y'
   ) 
/

  create unique index eba_stdtyp_idx1 on eba_stds_types (type_name) 
/

  alter table eba_stds_types add constraint eba_stdtyp_pk primary key (id)
  using index (create unique index eba_stdtyp_pk_idx on eba_stds_types (id) 
  )  enable
/

alter table eba_stds_types add constraint eba_stdtyp_uk2 unique (type_code)
  using index (create unique index eba_stdtyp_idx2 on eba_stds_types (type_code) 
  )  enable
/

--rollback drop table EBA_STDS_TYPES;
