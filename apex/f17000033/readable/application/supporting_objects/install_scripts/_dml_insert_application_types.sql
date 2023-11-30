begin
    --SVT_STDS_TYPES: 3/10000 rows exported, APEX$DATA$PKG/SVT_STDS_TYPES$344811
    apex_data_install.load_supporting_object_data(p_table_name => 'SVT_STDS_TYPES', p_delete_after_install => false );
end;