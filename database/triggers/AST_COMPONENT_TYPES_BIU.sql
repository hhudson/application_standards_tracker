--liquibase formatted sql
--changeset trigger_script:ast_component_types_biu stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for Trigger ast_component_types
--------------------------------------------------------

create or replace editionable trigger ast_component_types_biu
    before insert or update 
    on ast_component_types
    for each row
begin
 
  if inserting then 
    :new.created := localtimestamp; 
    :new.created_by := nvl ( sys_context ( 'APEX$SESSION', 'APP_USER' ), user ); 
  end if; 
  :new.component_name := upper(:new.component_name);
  :new.component_code := upper(:new.component_code);
  :new.pk_value := upper(:new.pk_value);
  :new.parent_pk_value := upper(:new.parent_pk_value);
  :new.updated := localtimestamp; 
  :new.updated_by := nvl ( sys_context ( 'APEX$SESSION', 'APP_USER' ), user ); 
  :new.available_yn := case when upper(:new.available_yn) = 'Y'
                            then 'Y'
                            else 'N'
                            end;
end ast_component_types_biu;
/