--liquibase formatted sql
--changeset package_script:SVT_STDS_DATA stripComments:false endDelimiter:/ runOnChange:true
create or replace package svt_stds_data authid definer is

    procedure load_initial_data;

    function is_initial_data_loaded return boolean;

    procedure load_sample_data;

    procedure remove_sample_data;

    -- function is_sample_data_loaded return boolean;

end svt_stds_data;
/

--rollback drop package SVT_STDS_DATA;
