--liquibase formatted sql
--changeset view_script:V_AST_SCM_OBJECT_ASSIGNEE stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT

--------------------------------------------------------
--  DDL for View V_AST_SCM_OBJECT_ASSIGNEE
--------------------------------------------------------

create or replace view v_ast_scm_object_assignee as 
select object_name,
       email,
       folder_name 
from ast_audit_util.v_ast_scm_object_assignee()
/

--rollback drop view V_AST_SCM_OBJECT_ASSIGNEE;