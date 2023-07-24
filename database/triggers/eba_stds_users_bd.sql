--liquibase formatted sql
--changeset trigger_script:EBA_STDS_USERS_BD stripComments:false  endDelimiter:/ 
--------------------------------------------------------------------------------
--
--      Author:  hayden.h.hudson@oracle.com
-- Script name:  EBA_STDS_USERS_BD.sql
--        Date:  05-Apr-2023 22:15
--     Purpose:  BD Trigger creation DDL for table eba_stds_users
--
--------------------------------------------------------------------------------

create or replace trigger EBA_STDS_USERS_BD
    before delete on eba_stds_users
    for each row
declare
    pragma autonomous_transaction;
begin
    -- Disallow deletes to a user's own record unless LAST one.
    if v('APP_USER') = upper(:old.username) then
       for c1 in (
          select count(*) cnt
            from eba_stds_users
           where id != :old.id )
       loop
          if c1.cnt > 0 then
             raise_application_error(-20002, 'Delete disallowed, you cannot delete your own access control details.');
          end if;
       end loop;
    end if;    
end EBA_STDS_USERS_BD;
/
alter trigger eba_stds_users_bd enable
/