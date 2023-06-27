# APEX Standards Tracker Project
https://gbuconfluence.oraclecorp.com/pages/viewpage.action?pageId=323452710



## Introduction

In this repo, I am recording methods and queries to track and enforce APEX standards (including in the supporting database objects).

## The Application Standards Tracker

In this repo, I have included a modified copy of the [Application Standards Tracker](apex/f261.sql), an application that was formerly included in the APEX Sample App Gallery. I have modified the application to expand it's use to cover enforcing coding standards in the supporting database objects (tables, views, packages, etc).

### Modifications to support DB object coding standards

1. Test assertion queries are now required to be stored as views in the database, instead of as clobs in the eba_stds_standard_tests table. This is a personal preference but has many advantages:
    - the code can now be studied / referenced / corrected outside of the application (eg, merely accessing this repo in a browser allows you to study them)
    - asserting the format of the test assertion queries is simpler this way (eg, requiring field names and their order)
    - reduced risk of SQL injection / XSS attacks from evaluating query stored as a clob
2. I added "DB Supporting Objects" as an application type in the eba_stds_types table
3. I added "Database Supporting Object" to the "TEST LINK TYPES" LOV.

## How to use PLScope


PL/Scope creates the following database objects : 
- dba/all/user_identifiers (since 11.1)
- dba/all/user_statements since 12.2
These tables get populated only with the PL/SQL that compiled in sessions which have the following setting:
```
ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:ALL';
```
In order to compensate for the absence of PL/SQL that may have been compiled in different sessions without this plscope_settings value, it may be necessary to run the following command:
```
begin
    dbms_utility.compile_schema(schema => user, compile_all => true);
end;
```

## Notes
### Fixed a bug
I set session state protection to 'unrestricted' for both P19_VALIDATE and P20_VALIDATE

## DB Requirements 2023-Apr-6
These are the sys privs:
```
CREATE ANY CONTEXT,CREATE DIMENSION,CREATE TABLE,CREATE JOB,DELETE ANY TABLE,CREATE TYPE,CREATE ANY PROCEDURE,UPDATE ANY TABLE,CREATE OPERATOR,EXECUTE ANY PROCEDURE,CREATE VIEW,CREATE PUBLIC SYNONYM,INSERT ANY TABLE,CREATE INDEXTYPE,CREATE CLUSTER,SELECT ANY TABLE,READ ANY TABLE,ALTER ANY TRIGGER,ALTER ANY PROCEDURE,CREATE PROCEDURE,CREATE SESSION,CREATE MATERIALIZED VIEW,CREATE SEQUENCE,CREATE TRIGGER,CREATE SYNONYM
```
These were the table privs:
```
grant DELETE on APEX_XXXXXX.WWV_FLOW_ISSUES to AST;-- ast_flow_issues
grant INSERT on APEX_XXXXXX.WWV_FLOW_ISSUES to AST;
grant UPDATE on APEX_XXXXXX.WWV_FLOW_ISSUES to AST;
grant SELECT on APEX_SCM.CCS_FILES_VW to AST;
```
add the roles AST had were:
```
APEX_ADMINISTRATOR_ROLE
APEX_ADMINISTRATOR_READ_ROLE
```

AST had unlimited quota on a TS (CARS_TS)