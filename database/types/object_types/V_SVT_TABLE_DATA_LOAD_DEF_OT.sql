
--liquibase formatted sql
--changeset object_type_script:V_SVT_TABLE_DATA_LOAD_DEF_OT stripComments:false endDelimiter:/ runOnChange:true
--preconditions onFail:MARK_RAN onError:HALT
--precondition-sql-check expectedResult:0 select count(1) from all_types where upper(type_name) = upper('V_SVT_TABLE_DATA_LOAD_DEF_OT');
-- set serveroutput on
--------------------------------------------------------------------------------
--
--      author:  hayhudso
-- script name:   v_svt_table_data_load_def_ot.sql
--        date:  2023-jun-21
--     purpose:  type creation ddl
--
--------------------------------------------------------------------------------
  create type V_SVT_TABLE_DATA_LOAD_DEF_OT as object
    (
        TABLE_NAME                   VARCHAR2(128),
        IMPLICIT_TABLE               VARCHAR2(128),
        FILE_BLOB                    BLOB,
        MIME_TYPE                    CHAR(16),
        FILE_NAME                    VARCHAR2(4000), 
        STATIC_FILE_NAME             VARCHAR2(255),  
        CHARACTER_SET                CHAR(5),        
        FILE_SIZE                    NUMBER,
        DOWNLOAD                     NUMBER,
        DATA_LOAD_DEFINITION_NAME    VARCHAR2(255),  
        STATIC_APPLICATION_FILE_NAME VARCHAR2(255),  
        INSPECT_STATIC_FILE_ICON     CHAR(65),       
        PAGE_ID                      NUMBER,
        PAGE_ID_ICON                 CHAR(66),       
        APPLICATION_FILE_ID          NUMBER,
        ZIP_BLOB                     BLOB,
        ZIP_FILE_SIZE                NUMBER,
        ZIP_DOWNLOAD                 NUMBER,
        ZIP_MIME_TYPE                VARCHAR2(255),  
        ZIP_CHARSET                  VARCHAR2(128),  
        ZIP_UPDATED_ON               DATE,
        TABLE_LAST_UPDATED_ON        DATE,
        STATIC_FILE_CREATED_ON       DATE,
        STALE_YN                     CHAR(1)
    )
/
--rollback drop type V_SVT_TABLE_DATA_LOAD_DEF_OT;