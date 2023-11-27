--changeset function_script:ORCLAPEX_VERSION stripComments:false runOnChange:true
--------------------------------------------------------
--  DDL for function orclapex_version
--------------------------------------------------------

-- https://livesql.oracle.com/apex/livesql/file/content_MYKQ2SIS76LD5JDBJGKKEXK6V.html
create or replace function ORCLAPEX_VERSION return number authid definer
is
   vr number;
begin
   select to_number(substr(version_no, 1, instr(version_no, '.', 1, 2) - 1))
     into vr
     from apex_release;
   return vr;
end;

--rollback drop function ORCLAPEX_VERSION;