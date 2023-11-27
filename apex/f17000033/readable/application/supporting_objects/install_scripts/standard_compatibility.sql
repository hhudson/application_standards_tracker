begin
    --SVT_COMPATIBILITY: 11/10000 rows exported, APEX$DATA$PKG/SVT_COMPATIBILITY$803877
    apex_data_install.load_supporting_object_data(p_table_name => 'SVT_COMPATIBILITY', p_delete_after_install => false );
end;