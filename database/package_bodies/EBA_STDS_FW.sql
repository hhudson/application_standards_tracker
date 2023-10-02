--liquibase formatted sql
--changeset package_body_script:EBA_STDS_FW stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE BODY "EBA_STDS_FW" as
    function get_preference_value (
        p_preference_name varchar2 )
        return varchar2
    is
        l_preference_value varchar2(255);
    begin
        select preference_value
            into l_preference_value
        from eba_stds_preferences
        where preference_name = p_preference_name;
        return l_preference_value;
    exception
        when no_data_found then
            return 'Preference does not exist';
    end get_preference_value;
    procedure set_preference_value (
        p_preference_name  varchar2, 
        p_preference_value varchar2 )
    is
    begin
        merge into eba_stds_preferences dest
        using ( select upper(p_preference_name) preference_name,
                    p_preference_value preference_value
                from dual ) src
        on ( upper(dest.preference_name) = src.preference_name )
        when matched then
            update set dest.preference_value = src.preference_value
        when not matched then
            insert (dest.preference_name, dest.preference_value)
            values (src.preference_name, src.preference_value);
    end set_preference_value;
end eba_stds_fw;
/

--rollback drop package EBA_STDS_FW;
