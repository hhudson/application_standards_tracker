--liquibase formatted sql
--changeset view_script:v_download_all_standards stripComments:false endDelimiter:/ runOnChange:true

create or replace force view V_DOWNLOAD_ALL_STANDARDS as
with jcb as (select 'application/json' mime_type,
                    'ALL_STANDARDS.json' file_name,
                    'UTF-8' character_set,
                    svt_deployment.json_content_blob (p_table_name => 'V_EBA_STDS_STANDARD_TESTS_EXPORT') file_blob
            from dual)
select sys.dbms_lob.getlength(jcb.file_blob) file_size,
       jcb.file_blob,
       jcb.mime_type,
       jcb.file_name,
       jcb.character_set
from jcb
/

--rollback drop view v_download_all_standards;