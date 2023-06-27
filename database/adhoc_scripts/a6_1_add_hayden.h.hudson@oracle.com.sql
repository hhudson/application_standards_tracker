begin

    -- Seed user table with current user as an administrator or set the current user as administrator
    declare
       l_count number;
    begin
        select count(*) 
            into l_count 
        from eba_stds_users
        where username = 'HAYDEN.H.HUDSON@ORACLE.COM';
        if l_count = 0 then
            insert into eba_stds_users(username, access_level_id) values ('HAYDEN.H.HUDSON@ORACLE.COM', 3);   
        else
            update eba_stds_users
            set access_level_id = 3
            where username = 'HAYDEN.H.HUDSON@ORACLE.COM';
        end if;
    end;
end;
/