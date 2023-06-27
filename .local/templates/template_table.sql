--liquibase formatted sql
--changeset table_script:CHANGEME stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('CHANGEME');

create table CHANGEME (
  CHANGEME_id number generated always as identity not null,
  CHANGEME_code varchar2(30) not null,
  CHANGEME_name varchar2(30) not null,
  CHANGEME_seq number not null,
  created_on date default sysdate not null,
	created_by varchar2(255 byte) default
    coalesce(
      sys_context('APEX$SESSION','app_user'),
      regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*'),
      sys_context('userenv','session_user')
    )
    not null
    ,
  updated_on date,
  updated_by varchar2(255 byte)
);
--rollback drop table CHANGEME;
