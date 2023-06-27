--liquibase formatted sql
--changeset view_script:v_ast_table_data_load_def stripComments:false endDelimiter:/ runOnChange:true
--------------------------------------------------------
--  DDL for View v_ast_table_data_load_def
--------------------------------------------------------

create or replace force editionable view v_ast_table_data_load_def as
select table_name,
       implicit_table,
       file_blob,
       mime_type,
       file_name,
       static_file_name,
       character_set,
       file_size,
       download,
       data_load_definition_name,
       static_application_file_name,
       inspect_static_file_icon,
       page_id,
       page_id_icon,
       application_file_id,
       zip_file_size,
       zip_download,
       table_last_updated_on,
       static_file_created_on,
       stale_yn,
       zip_blob,
       zip_mime_type,
       zip_charset,
       zip_updated_on
  from ast_deployment.v_ast_table_data_load_def(p_application_id => v('APP_ID'))
/

--rollback drop view v_ast_table_data_load_def;