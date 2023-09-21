--liquibase formatted sql
--changeset view_script:V_LOKI_OBJECT_ASSIGNEE stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View V_LOKI_OBJECT_ASSIGNEE
--------------------------------------------------------

create or replace force editionable view V_LOKI_OBJECT_ASSIGNEE as
select object_name,
       email apex_username,
       folder_name object_type
from svt_audit_util.v_loki_object_assignee()
/

--rollback drop view V_LOKI_OBJECT_ASSIGNEE;