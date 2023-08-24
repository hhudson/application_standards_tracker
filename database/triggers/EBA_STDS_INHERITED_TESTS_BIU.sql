--liquibase formatted sql
--changeset trigger_script:eba_stds_inherited_tests_biu_biu stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Trigger eba_stds_inherited_tests_biu
--------------------------------------------------------

create or replace trigger eba_stds_inherited_tests_biu
    before insert or update 
    on eba_stds_inherited_tests
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end eba_stds_inherited_tests_biu;
/