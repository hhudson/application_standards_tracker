--liquibase formatted sql
--changeset view_script:CHANGEME stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View CHANGEME
--------------------------------------------------------

create or replace force editionable view CHANGEME as
select 1 from dual
/

--rollback drop view CHANGEME;