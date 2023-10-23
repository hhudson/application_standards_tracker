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
GRANT CREATE SESSION TO SVT;
GRANT CREATE TABLE TO SVT;
GRANT CREATE VIEW TO SVT;
GRANT CREATE SEQUENCE TO SVT;
GRANT CREATE PROCEDURE TO SVT;
GRANT CREATE TRIGGER TO SVT;
GRANT CREATE ANY CONTEXT TO SVT;
GRANT CREATE JOB TO SVT;
GRANT CREATE TYPE TO SVT;
GRANT CREATE MATERIALIZED VIEW TO SVT;
GRANT CREATE SEQUENCE TO SVT;
GRANT CREATE SYNONYM TO SVT;

ALTER USER SVT QUOTA UNLIMITED ON USERS;

GRANT DELETE ON APEX_230100.WWV_FLOW_ISSUES TO SVT;
GRANT INSERT ON APEX_230100.WWV_FLOW_ISSUES TO SVT;
GRANT UPDATE ON APEX_230100.WWV_FLOW_ISSUES TO SVT;
GRANT SELECT ON APEX_230100.WWV_FLOW_ISSUES TO SVT;
GRANT SELECT ON APEX_230100.WWV_FLOW_DICTIONARY_VIEWS to SVT;

GRANT SELECT ON LOKI.LOKI_LOCKS_LOG TO SVT;
GRANT SELECT ON LOKI.LOKI_SCHEMAS TO SVT;
GRANT SELECT ON LOKI.LOKI_USERS TO SVT;

GRANT APEX_ADMINISTRATOR_ROLE TO SVT;

GRANT SELECT_CATALOG_ROLE TO SVT;

GRANT SELECT ON DBA_SOURCE TO SVT;
GRANT SELECT ON DBA_TAB_COLS TO SVT;
GRANT SELECT ON DBA_CONS_COLUMNS TO SVT;
GRANT SELECT ON DBA_CONSTRAINTS TO SVT;
GRANT SELECT ON DBA_ERRORS TO SVT;
GRANT SELECT ON DBA_IDENTIFIERS TO SVT;
GRANT SELECT ON DBA_IND_COLUMNS TO SVT;
GRANT SELECT ON DBA_MVIEWS TO SVT;
GRANT SELECT ON DBA_OBJECTS TO SVT;
GRANT SELECT ON DBA_PLSQL_OBJECT_SETTINGS TO SVT;
GRANT SELECT ON DBA_VIEWS TO SVT;
GRANT SELECT ON DBA_STATEMENTS TO SVT;

```

TOO MUCH:
```
GRANT SELECT ANY TABLE TO SVT; 
--allows me to see other ables in all_tables
GRANT DEBUG ANY PROCEDURE TO SVT; 
--allows me to see package body in all_source
/*
Justification : technically I can see anything I want from the dba_ * views but I can’t reference dba_* views in my own views, which is a bother. If I want to create view that queries the package body in a different schema, it has to be all_source, not dba_source
*/
```
alternative approach :
```
select apex_string.format('GRANT SELECT ON %0.%1 TO SVT;',
         p0 => dt.owner,
         p1 => dt.object_name
        ) stmt
from dba_objects dt
where object_type in ('TABLE', 'VIEW', 'MATERIALIZED VIEW')
and   dt.owner in (select column_value
                    from table(apex_string.split(svt_preferences.get_preference ('SVT_REVIEW_SCHEMAS'), ':'))
                    where column_value not in ('SVT'))
and dt.object_name not like 'XXX%'
order by dt.object_type, dt.object_name
union all
select apex_string.format('GRANT DEBUG ON %0.%1 TO SVT;',
         p0 => dt.owner,
         p1 => dt.object_name
        ) stmt
from dba_objects dt
where object_type in ('PACKAGE', 'FUNCTION', 'PROCEDURE')
and   dt.owner in (select column_value
                    from table(apex_string.split(svt_preferences.get_preference ('SVT_REVIEW_SCHEMAS'), ':'))
                    where column_value not in ('SVT'))
and dt.object_name not like 'XXX%'
order by dt.object_type, dt.object_name
```