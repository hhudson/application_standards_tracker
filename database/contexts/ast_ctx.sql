--liquibase formatted sql
--changeset context_script:AST_CTX stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Context AST_CTX
--------------------------------------------------------
create or replace context ast_ctx using ast_ctx_util accessed globally
/

--rollback drop context AST_CTX;