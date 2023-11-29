# APEX Standards Tracker Project

## Introduction

In this repo, I am recording methods and queries to track and enforce APEX standards (including in the supporting database objects).

## The Application Standards Tracker

In this repo, I have included a modified copy of the [Application Standards Tracker](apex/f17000033/f17000033.sql), an application that was formerly included in the APEX Sample App Gallery. I have modified the application to expand it's use to cover enforcing coding standards in the supporting database objects (tables, views, packages, etc).

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