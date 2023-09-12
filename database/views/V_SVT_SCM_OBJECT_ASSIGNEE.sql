--liquibase formatted sql
--changeset view_script:V_SVT_SCM_OBJECT_ASSIGNEE stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT

--------------------------------------------------------
--  DDL for View V_SVT_SCM_OBJECT_ASSIGNEE
--------------------------------------------------------

create or replace view V_SVT_SCM_OBJECT_ASSIGNEE as 
select object_name,
       email,
       folder_name 
from svt_audit_util.v_svt_scm_object_assignee()
/

--rollback drop view V_SVT_SCM_OBJECT_ASSIGNEE;