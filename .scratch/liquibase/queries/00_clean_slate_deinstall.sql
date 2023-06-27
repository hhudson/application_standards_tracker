drop TABLE AST_AUDIT_ACTIONS;
drop package AIT_PKG;
drop package AST_PLSQL_REVIEW;
drop PACKAGE MYPKG;
drop TABLE   DATABASECHANGELOG;
-- drop TABLE   DATABASECHANGELOGLOCK; --run 00_correct_bug_ORA-12838 if dropped
drop TABLE   DATABASECHANGELOG_ACTIONS;
drop TRIGGER DATABASECHANGELOG_ACTIONS_TRG;
drop VIEW    DATABASECHANGELOG_DETAILS;
drop TABLE   EMPLOYEES;
drop TABLE   DEPARTMENTS;
drop VIEW    EMP_V
/
select object_type, object_name
from user_objects
where object_type in ('PACKAGE', 'PACKAGE BODY', 'TABLE', 'VIEW', 'TRIGGER')
and object_name != 'DATABASECHANGELOGLOCK'
order by 1,2
/