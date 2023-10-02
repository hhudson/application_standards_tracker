--liquibase formatted sql
--changeset package_script:EBA_STDS_FW stripComments:false endDelimiter:/ runOnChange:true
create or replace package eba_stds_fw authid definer as
    function get_preference_value (
        p_preference_name in varchar2 )
        return varchar2;
    procedure set_preference_value (
        p_preference_name  in varchar2, 
        p_preference_value in varchar2 );
end eba_stds_fw;
/

--rollback drop package EBA_STDS_FW;
