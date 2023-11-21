--liquibase formatted sql
--changeset context_script:SVT_CTX stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Context SVT_CTX
--------------------------------------------------------
create or replace context SVT_CTX using SVT_CTX_UTIL accessed globally
/

--rollback drop context SVT_CTX;