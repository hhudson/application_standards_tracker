----------------------------------------------------------------------------
-- Copyright (c) Oracle Corporation 2022. All Rights Reserved.
--
-- Author: Clive Bostock
--
-- DESCRIPTION
--
--   This script must be run in SQL*Plus - not sqlcl.
--
--   Code generator; driving script. This suite of scripts
--   generates code, which in turn generates wrapped DDL
--   for fixing table constraint names, index names where
--   they are not found to be in compliance with naming 
--   standards.
--
-- The script prompts for a schema name to operate against.
--
--
----------------------------------------------------------------------------

-- accept schema_name prompt "Please enter the target data schema name: "
-- accept table_match default '%' prompt 'Please enter the target table(s) match [Return for All] : '
set verify off linesize 250 trimspool on
alter session set current_schema = &&schema_name;
set head off feedback off term off
spool name_fixer.dat
select '&&schema_name'
from dual;
set term on
spool off
prompt Checking pre-requisites...
select 'Started at: ' || to_char(sysdate, 'DD-Mon-YYYY HH24:MI')
from dual;

select 'Sheriff app not in operation for schema &&schema_name!'
from dual
where not exists (select 'x'
                   from all_tables
                  where table_name = 'DEV_TABLE_ABBREVIATIONS'
                    and owner      = upper('&&schema_name'));

whenever sqlerror exit failure
set term off feedback off 
select 'x' 
  from &&schema_name..dev_table_abbreviations
 where rownum < 2;
set term on

declare
  table_not_found exception;
  pragma exception_init (table_not_found, -00942);
begin
  execute immediate 'drop table xxx_constraints_cache';
exception
  when table_not_found then null;
end;
/
prompt Creating table xxx_constraints_cache...
create table xxx_constraints_cache 
( 
  table_name               varchar2(128) not null, 
  current_constraint_name  varchar2(128) not null, 
  expected_constraint_name varchar2(128) not null, 
  constraint_type          varchar2(1)   not null,
  column_list              varchar2(2000),
  r_table_name             varchar2(128) null 
);

create unique index cc_uk1_idx on xxx_constraints_cache (table_name, current_constraint_name);
create unique index cc_uk2_idx on xxx_constraints_cache (table_name, expected_constraint_name);
create index cc_idx2 on xxx_constraints_cache (constraint_type);
create index cc_idx3 on xxx_constraints_cache (column_list);
prompt Please be patient...
prompt Generating Non Foreign Key name fixes...
set term off
@gen_non_fk_renames.sql
set term on
prompt Generating Foreign Key name fixes...
set term off
@gen_fk_renames.sql
set term on
prompt Generating Index name fixes...
set term off
@gen_ix_renames.sql

set term on feedback off
select 'Completed at: ' || to_char(sysdate, 'DD-Mon-YYYY HH24:MI')
from dual;
set feedback on

prompt Thankyou for your patience, my work here is done!

-- prompt Dropping table xxx_constraints_cache
-- drop table xxx_constraints_cache;
set feedback on
