--changeset function_script:EXCEPT_COLS stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for function EXCEPT_COLS
-- from livesql script : https://livesql.oracle.com/apex/livesql/file/content_MXV7PC2TNA6BX952VHRGQ7P3B.html
/*
select *  
from   except_cols (  
  eba_stds_standards,  
  columns ( created_on, created_by )  
)
*/
--------------------------------------------------------

create or replace function EXCEPT_COLS (  
  p_tab         table,     
  p_except_cols columns  
) return table pipelined   
  row polymorphic   
  using except_cols_pkg
/
--rollback drop function EXCEPT_COLS;