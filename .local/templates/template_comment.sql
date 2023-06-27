--liquibase formatted sql
--changeset comments:CHANGEME stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  Comments for table CHANGEME
--------------------------------------------------------

comment on table CHANGEME is q'[]';

comment on column CHANGEME.ID is q'[Primary Key]';
