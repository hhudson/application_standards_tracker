--liquibase formatted sql
--changeset trigger_script:svt_compatibility_biu_biu stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Trigger svt_compatibility_biu
--------------------------------------------------------

create or replace trigger svt_compatibility_biu
    before insert or update 
    on svt_compatibility
    for each row
begin
    if inserting then
        :new.created := sysdate;
        :new.created_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
end svt_compatibility_biu;
/

alter trigger svt_compatibility_biu enable;