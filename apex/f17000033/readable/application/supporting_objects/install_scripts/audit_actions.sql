begin
    --SVT_AUDIT_ACTIONS: 5/10000 rows exported, APEX$DATA$PKG/SVT_AUDIT_ACTIONS$819748
    apex_data_install.load_supporting_object_data(p_table_name => 'SVT_AUDIT_ACTIONS', p_delete_after_install => false );
end;