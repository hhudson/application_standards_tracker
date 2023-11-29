create or replace function EXCEPT_COLS (  
  p_tab         table,     
  p_except_cols columns  
) return table pipelined   
  row polymorphic   
  using except_cols_pkg;
  
--rollback drop function EXCEPT_COLS;
/
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
/ 