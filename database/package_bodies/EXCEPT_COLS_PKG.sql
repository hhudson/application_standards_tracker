--liquibase formatted sql
--changeset package_body_script:EXCEPT_COLS_PKG stripComments:false endDelimiter:/ runOnChange:true
create or replace package body except_cols_pkg as  
-- from livesql script : https://livesql.oracle.com/apex/livesql/file/content_MXV7PC2TNA6BX952VHRGQ7P3B.html

  function describe (  
    p_tab         in out nocopy dbms_tf.table_t,  
    p_except_cols dbms_tf.columns_t
  ) return dbms_tf.describe_t as  
  begin  

    for i in 1 .. p_tab.column.count loop  

      if p_tab.column(i).description.name   
         member of p_except_cols then  

        p_tab.column(i).for_read := false;  
        p_tab.column(i).pass_through := false;  

      end if;  

    end loop;  

    return dbms_tf.describe_t ();  

  end describe;  

end except_cols_pkg;   
/

--rollback drop package EXCEPT_COLS_PKG;
