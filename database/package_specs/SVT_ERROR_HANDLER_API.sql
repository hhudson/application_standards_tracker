--liquibase formatted sql
--changeset package_script:SVT_ERROR_HANDLER_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package SVT_ERROR_HANDLER_API
--------------------------------------------------------
create or replace package SVT_ERROR_HANDLER_API authid definer is

/*
svt_error_handler_api.error_handler
*/
function error_handler 
   (p_error in apex_error.t_error
   ) return apex_error.t_error_result
;    


end SVT_ERROR_HANDLER_API;
/
--rollback drop package body SVT_ERROR_HANDLER_API;