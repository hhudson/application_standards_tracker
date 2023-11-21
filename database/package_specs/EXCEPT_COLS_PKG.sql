--liquibase formatted sql
--changeset package_script:EXCEPT_COLS_PKG stripComments:false endDelimiter:/ runOnChange:true
create or replace package except_cols_pkg authid definer as  
-- from livesql script : https://livesql.oracle.com/apex/livesql/file/content_MXV7PC2TNA6BX952VHRGQ7P3B.html

  function describe (  
    p_tab         in out nocopy dbms_tf.table_t,  
    p_except_cols dbms_tf.columns_t  
  ) return dbms_tf.describe_t;  

end except_cols_pkg;   
/

--rollback drop package EXCEPT_COLS_PKG;
