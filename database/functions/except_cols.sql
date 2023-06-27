--changeset function_script:EXCEPT_COLS stripComments:false runOnChange:true
--------------------------------------------------------
--  DDL for function EXCEPT_COLS
-- from livesql script : https://livesql.oracle.com/apex/livesql/file/content_MXV7PC2TNA6BX952VHRGQ7P3B.html
--------------------------------------------------------

create or replace function except_cols (  
  tab         table,     
  except_cols columns  
) return table pipelined   
  row polymorphic   
  using except_cols_pkg;

--rollback drop function EXCEPT_COLS;