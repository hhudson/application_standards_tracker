--liquibase formatted sql
--changeset view_script:v_eba_stds_standards stripComments:false endDelimiter:/ runOnChange:true

create or replace force view v_eba_stds_standards as
with jcb as (select id standard_id,
                    standard_name, 
                    description, 
                    primary_developer, 
                    implementation, 
                    date_started, 
                    created, 
                    created_by, 
                    updated, 
                    updated_by, 
                    standard_group, 
                    active_yn,
                    'application/json' mime_type,
                    apex_string.format('STANDARD-%s.json',
                                        upper(
                                            replace(
                                                regexp_replace(standard_name,'[[:punct:]]')
                                                , ' ', '_')
                                        )
                        ) file_name,
                    'UTF-8' character_set,
                    svt_deployment.json_content_blob (p_table_name => 'EBA_STDS_STANDARD_TESTS',
                                                      p_standard_id => id) file_blob
            from eba_stds_standards)
select jcb.standard_id, 
       jcb.standard_name, 
       jcb.description, 
       jcb.primary_developer, 
       jcb.implementation, 
       jcb.date_started, 
       jcb.created, 
       jcb.created_by, 
       jcb.updated, 
       jcb.updated_by, 
       jcb.standard_group, 
       jcb.active_yn,
       sys.dbms_lob.getlength(jcb.file_blob) file_size,
       jcb.file_blob,
       jcb.mime_type,
       jcb.file_name,
       jcb.character_set
from jcb
/

--rollback drop view v_eba_stds_standards;