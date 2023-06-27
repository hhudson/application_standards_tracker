begin
  ast_ctx_util.set_review_schema (p_schema => sys_context('userenv', 'current_user'));
end;
/