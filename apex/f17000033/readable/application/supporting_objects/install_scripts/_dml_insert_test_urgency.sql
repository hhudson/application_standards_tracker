begin
    --SVT_STANDARDS_URGENCY_LEVEL: 5/10000 rows exported, APEX$DATA$PKG/SVT_STANDARDS_URGENCY_LE$842372
    apex_data_install.load_supporting_object_data(p_table_name => 'SVT_STANDARDS_URGENCY_LEVEL', p_delete_after_install => false );
end;