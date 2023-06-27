create or replace function CHANGEME(
    tab dbms_tf.table_t, 
    col dbms_tf.columns_t,
    p1 number default 1
) 
return varchar2 sql_macro 
is
begin
  return q'{
    select CHANGEME.p1
    from CHANGEME.tab
  }';
end CHANGEME;
/