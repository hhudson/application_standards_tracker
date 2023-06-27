--liquibase formatted sql
--changeset package_script:AST_ERROR_HANDLER_API stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Package AST_ERROR_HANDLER_API
--------------------------------------------------------
create or replace package ast_error_handler_api authid definer is

/*
ast_error_handler_api.error_handler
*/
function error_handler 
   (p_error in apex_error.t_error
   ) return apex_error.t_error_result
;    


end ast_error_handler_api;
/
--rollback drop package body AST_ERROR_HANDLER_API;