--liquibase formatted sql
--changeset object_type_script:V_SVT_SERT_OT stripComments:false endDelimiter:/
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_SERT_OT');
  
create type V_SVT_SERT_OT as object
    (
        collection_name     varchar2(255),
        collection_sql      varchar2(4000),
        category_name       varchar2(255),
        category_short_name varchar2(255),
        attribute_name      varchar2(4000),
        attribute_key       varchar2(4000),
        attribute_id        number,
        rule_source         varchar2(255),
        rule_type           varchar2(255),
        when_not_found      varchar2(100),
        table_name          varchar2(255),
        column_name         varchar2(4000),
        fix                 clob,
        info                clob,
        category_id         number,
        category_key        varchar2(255)
);
/
--rollback drop type V_SVT_SERT_OT;