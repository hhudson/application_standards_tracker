create or replace function EXCEPT_COLS (  
  p_tab         table,     
  p_except_cols columns  
) return table pipelined   
  row polymorphic   
  using except_cols_pkg;
  
--rollback drop function EXCEPT_COLS;
/ 