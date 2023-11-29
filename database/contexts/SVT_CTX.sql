--liquibase formatted sql
--changeset context_script:SVT_CTX stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Context SVT_CTX
--------------------------------------------------------
declare
  e_insufficient_priv exception;
  pragma exception_init (e_insufficient_priv, -1031);
  l_code varchar2(500):= 'create or replace context SVT_CTX using SVT_CTX_UTIL accessed globally';
begin 
    execute immediate l_code;
exception 
    when e_insufficient_priv then 
        dbms_output.put_line('FAILURE : you need create any context!');
    when others then raise;
end;
/

--rollback drop context SVT_CTX;