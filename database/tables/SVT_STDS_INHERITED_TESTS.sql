--liquibase formatted sql
--changeset table_script:svt_stds_inherited_tests stripComments:false runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('svt_stds_inherited_tests');

create table svt_stds_inherited_tests (
    id                 number generated by default on null as identity 
                       constraint svt_stds_inherited_id_pk primary key,
    parent_standard_id number not null,
    test_id            number not null,
    standard_id        number not null,
    created            timestamp (6) with local time zone  default systimestamp not null,
    created_by         varchar2(255 char)                  default user not null,
    updated            timestamp (6) with local time zone  default systimestamp not null,
    updated_by         varchar2(255 char)                  default user not null
)
/

alter table svt_stds_inherited_tests
add constraint eb_std_inh_c1 check (parent_standard_id != standard_id)
/

  alter table svt_stds_inherited_tests add constraint eb_std_inh_uk1 unique (standard_id, test_id)
  using index  enable
/

create index eb_std_inh_idx1 on svt_stds_inherited_tests (parent_standard_id,test_id)
/
 
--rollback drop table svt_stds_inherited_tests;
