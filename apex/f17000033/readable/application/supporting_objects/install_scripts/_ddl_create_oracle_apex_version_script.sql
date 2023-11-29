begin
-- create the ORACLE_APEX_VERSION package
   compile_conditional_compilation_version_package_for(
      p_product_name             => 'oracle_apex',
      p_product_version_function => 'orclapex_version',
      p_min_version_number       => 18,
      p_max_release_number       => 2,
      p_send_to_screen           => true
   );
end;
/