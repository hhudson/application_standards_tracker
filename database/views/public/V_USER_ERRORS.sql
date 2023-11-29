--liquibase formatted sql
--changeset view_script:V_USER_ERRORS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_user_errors
--------------------------------------------------------

create or replace force editionable view v_user_errors as
select name, 
       type,
       line, 
       text,
       message_number, 
       sequence,
       position,
       attribute,
       owner
from all_errors
where owner = svt_ctx_util.get_default_user
/
--rollback drop view V_USER_ERRORS;