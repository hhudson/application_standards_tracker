--liquibase formatted sql
--changeset package_script:SVT_CTX_UTIL stripComments:false endDelimiter:/ runOnChange:true
create or replace package SVT_CTX_UTIL authid definer
as

------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: December 21, 2022
-- Synopsis:
--
-- Set the value of the schema to be reviewed  
--
/*
begin
  SVT_ctx_util.set_review_schema (p_schema => sys_context('userenv', 'current_user'));
end;
*/
------------------------------------------------------------------------------
    procedure set_review_schema (p_schema in all_users.username%type default null);


------------------------------------------------------------------------------
--  Creator: Hayden Hudson
--     Date: February 8, 2023
-- Synopsis:
--
-- return default user
--
/*
select SVT_ctx_util.get_default_user
from dual;
*/
------------------------------------------------------------------------------
    function get_default_user return all_users.username%type deterministic;

end SVT_CTX_UTIL;
/

--rollback drop package SVT_CTX_UTIL;
