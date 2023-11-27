--liquibase formatted sql
--changeset view_script:V_ALL_STANDARDS_EXPORT stripComments:false endDelimiter:/ runOnChange:true

create or replace force view V_ALL_STANDARDS_EXPORT as
with jcb as (select 'application/json' mime_type,
                    'UTF-8' character_set,
                    svt_deployment.json_content_blob (p_table_name => 'V_SVT_STDS_STANDARD_TESTS_EXPORT') all_tests_file_blob,
                    svt_deployment.json_content_blob (p_table_name => 'EBA_STDS_STANDARDS') std_file_blob
            from dual)
select sys.dbms_lob.getlength(jcb.all_tests_file_blob) all_tests_file_size,
       sys.dbms_lob.getlength(jcb.std_file_blob) std_file_size,
       jcb.all_tests_file_blob,
       jcb.std_file_blob,
       jcb.mime_type,
       'ALL_STANDARDS.json' std_file_name,
       'ALL_TESTS.json' all_tests_file_name,
       jcb.character_set
from jcb
/

--rollback drop view V_ALL_STANDARDS_EXPORT;