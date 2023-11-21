--liquibase formatted sql
--changeset table_script:SVT_STANDARDS_URGENCY_LEVEL stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('SVT_STANDARDS_URGENCY_LEVEL');
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  SVT_STANDARDS_URGENCY_LEVEL.sql
--        Date:  10-Apr-2023 18:40
--     Purpose:  Table creation DDL for table SVT_STANDARDS_URGENCY_LEVEL
--               and related objects.
--
--------------------------------------------------------------------------------


  create table svt_standards_urgency_level 
   (	id            number generated by default on null as identity, 
	    urgency_level number not null, 
	    urgency_name  varchar2(255 char) not null, 
	    created       timestamp (6) with local time zone default systimestamp not null,
      created_by    varchar2(255 char)                 default user not null,
      updated       timestamp (6) with local time zone default systimestamp not null,
      updated_by    varchar2(255 char)                 default user not null
   )
/
  create index svt_sturlv_idx2 on svt_standards_urgency_level (urgency_level) 
/
  alter table svt_standards_urgency_level add constraint svt_sturlv_pk primary key (id)
  using index (create unique index svt_sturlv_pk_idx on svt_standards_urgency_level (id) 
  )  enable
/


--rollback drop table SVT_STANDARDS_URGENCY_LEVEL;
