--liquibase formatted sql
--changeset table_script:svt_wcag stripComments:false 
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_tables where upper(table_name) = upper('svt_wcag');

create table svt_wcag (
    id                             number generated by default on null as identity 
                                   constraint svt_wcag_id_pk primary key,
    c1st_digit                     number,
    c2nd_digit                     number,
    c3rd_digit                     number,
    description                    varchar2(4000 char),
    conformance_level              varchar2(10 char)
)
/
--rollback drop table svt_wcag;
