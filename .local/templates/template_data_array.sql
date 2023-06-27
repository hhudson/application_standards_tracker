set define off;

declare
  type rec_data is varray(3) of varchar2(4000);
  type tab_data is table of rec_data index by pls_integer;
  l_data tab_data;
  l_row CHANGEME%rowtype;
begin

  -- Column order:
  -- CHANGEME
  -- 1: CHANGE_ME_code
  -- 2: CHANGE_ME_name
  -- 3: CHANGE_ME_seq

  -- Template
  -- l_data(l_data.count + 1) := rec_data('CHANGE_ME', 'CHANGE_ME', 1);


  for i in 1..l_data.count loop
    l_row.CHANGE_ME_code := l_data(i)(1);
    l_row.CHANGE_ME_name := l_data(i)(2);
    l_row.CHANGE_ME_seq := l_data(i)(3);

    merge into CHANGEME dest
      using (
        select
          l_row.CHANGE_ME_code CHANGE_ME_code
        from dual
      ) src
      on (1=1
        and dest.CHANGE_ME_code = src.CHANGE_ME_code
      )
    when matched then
      update
        set
          -- Don't update the value as it's probably a key/secure value
          -- Deletions are handled above
          dest.CHANGE_ME_name = l_row.CHANGE_ME_name,
          dest.CHANGE_ME_seq = l_row.CHANGE_ME_seq
    when not matched then
      insert (
        CHANGE_ME_code,
        CHANGE_ME_name,
        CHANGE_ME_seq)
      values(
        l_row.CHANGE_ME_code,
        l_row.CHANGE_ME_name,
        l_row.CHANGE_ME_seq)
    ;
  end loop;

end;
/
