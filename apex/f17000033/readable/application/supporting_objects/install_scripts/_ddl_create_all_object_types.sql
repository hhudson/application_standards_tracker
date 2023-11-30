create or replace type APEX_APPLICATION_PAGE_RPT_COLS_OT as object
    (   application_id    number,
        page_id           number, 
        region_name       varchar2(255), 
        use_as_row_header varchar2(3),
        region_id         number, 
        created_by        varchar2(255 char),
        created_on        date,
        updated_by        varchar2(255 char),
        updated_on        date,
        column_id         number,
        workspace         varchar2(255 char),
        build_option      varchar2(255 char)
    )
/
create or replace type SVT_APEX_APPLICATIONS_OT as object
    (
        APPLICATION_ID NUMBER,
        APPLICATION_NAME VARCHAR2(255 CHAR),
        APPLICATION_GROUP VARCHAR2(255 CHAR),
        AVAILABILITY_STATUS VARCHAR2(38 CHAR),
        AUTHORIZATION_SCHEME VARCHAR2(259 CHAR),
        CREATED_BY VARCHAR2(255 CHAR),
        CREATED_ON DATE,
        LAST_UPDATED_BY VARCHAR2(255 CHAR),
        LAST_UPDATED_ON DATE,
        WORKSPACE VARCHAR2(255 CHAR)
    )
/
create or replace type SVT_APEX_PREFERENCES_OT as object
    (
        WORKSPACE_ID           NUMBER,      
        WORKSPACE_NAME         VARCHAR2(255),
        WORKSPACE_DISPLAY_NAME VARCHAR2(4000),
        USER_NAME              VARCHAR2(255),
        PREFERENCE_ID          NUMBER, 
        PREFERENCE_NAME        VARCHAR2(255),
        PREFERENCE_VALUE       VARCHAR2(4000),
        PREFERENCE_TYPE        VARCHAR2(23),
        PREFERENCE_COMMENT     VARCHAR2(55)
    )
/
create or replace type SVT_DB_PLSQL_ISSUE_OT as object
    (
        issue_desc              varchar2(511   char),
        object_name             varchar2(128   char),  
        object_type             varchar2(23    char),   
        line                    number,
        code                    varchar2(1000 char),
        urgency                 varchar2(255  char),
        urgency_level           number,
        test_code               varchar2(100 char)
    )
/
create or replace type V_SVT_APEX_OT as object
    (
      PASS_YN                          VARCHAR2(1 CHAR),
      UNQID                            VARCHAR2(5000 CHAR),
      APPLICATION_ID                   NUMBER,
      PAGE_ID                          NUMBER,
      CREATED_BY                       VARCHAR2(1020 CHAR),
      CREATED_ON                       DATE,
      LAST_UPDATED_BY                  VARCHAR2(1020 CHAR),
      LAST_UPDATED_ON                  DATE,
      VALIDATION_FAILURE_MESSAGE       VARCHAR2(15000 CHAR),
      ISSUE_TITLE                      VARCHAR2(5000 CHAR),
      TEST_CODE                        VARCHAR2(100),
      COMPONENT_ID                     NUMBER,
      PARENT_COMPONENT_ID              NUMBER,
      WORKSPACE                        VARCHAR2(255 CHAR)
    )
/
create or replace type V_SVT_APEX__0_OT as object
    (
      PASS_YN                          VARCHAR2(1 CHAR),
      UNQID                            VARCHAR2(5000 CHAR),
      APPLICATION_ID                   NUMBER,
      PAGE_ID                          NUMBER,
      CREATED_BY                       VARCHAR2(1020 CHAR),
      CREATED_ON                       DATE,
      LAST_UPDATED_BY                  VARCHAR2(1020 CHAR),
      LAST_UPDATED_ON                  DATE,
      VALIDATION_FAILURE_MESSAGE       VARCHAR2(15000 CHAR),
      ISSUE_TITLE                      VARCHAR2(5000 CHAR)
    )
/
create or replace type v_svt_db_mv__0_ot as object
    (   
      pass_yn    varchar2(1 char),
      schema     varchar2(128 char),
      mv_name    varchar2(128 char),
      code       varchar2(1000 char),
      unqid      varchar2(5000 char)
    )
/
create or replace type V_SVT_DB_PLSQL_OT as object
    (
      PASS_YN        VARCHAR2(1 CHAR),
      SCHEMA         VARCHAR2(128 CHAR),
      OBJECT_NAME    VARCHAR2(128 CHAR),
      OBJECT_TYPE    VARCHAR2(19 CHAR),
      LINE           NUMBER,
      CODE           VARCHAR2(5000 CHAR),
      UNQID          VARCHAR2(5000 CHAR),
      TEST_CODE      VARCHAR2(100 CHAR)
    )
/
create or replace type V_SVT_DB_PLSQL_REF_OT as object
    (
      PASS_YN        VARCHAR2(1 CHAR),
      SCHEMA         VARCHAR2(128 CHAR),
      OBJECT_NAME    VARCHAR2(128 CHAR),
      OBJECT_TYPE    VARCHAR2(19 CHAR),
      LINE           NUMBER,
      CODE           VARCHAR2(5000 CHAR),
      UNQID          VARCHAR2(5000 CHAR),
      TEST_CODE      VARCHAR2(100 CHAR)
    )
/
create or replace type V_SVT_DB_TBL__0_OT as object
    (   
      PASS_YN    VARCHAR2(1 CHAR),
      SCHEMA     VARCHAR2(128 CHAR),
      TABLE_NAME VARCHAR2(128 CHAR),
      UNQID      VARCHAR2(250 CHAR),
      CODE       VARCHAR2(1000 CHAR),
      OBJECT_ID  NUMBER
    )
/
create or replace type v_svt_db_trigger__0_ot as object
    (   
      pass_yn         varchar2(1 char),
      schema          varchar2(128 char),
      trigger_name    varchar2(128 char),
      code            varchar2(1000 char),
      unqid           varchar2(5000 char)
    )
/
create or replace type v_svt_db_view__0_ot as object
    (   
      pass_yn    varchar2(1 char),
      schema     varchar2(128 char),
      view_name  varchar2(128 char),
      code       varchar2(1000 char),
      unqid      varchar2(5000 char)
    )
/
create or replace type v_svt_plsql_apex__0_ot as object
    (
        UNQID                      VARCHAR2(1000 CHAR),
        ISSUE_CATEGORY             VARCHAR2(8),
        APPLICATION_ID             NUMBER,
        PAGE_ID                    NUMBER,
        PASS_YN                    VARCHAR2(1 CHAR),
        LINE                       NUMBER,
        SCHEMA                     VARCHAR2(128 CHAR),
        OBJECT_NAME                VARCHAR2(128 CHAR),
        OBJECT_TYPE                VARCHAR2(76),
        CODE                       VARCHAR2(5000 CHAR),
        VALIDATION_FAILURE_MESSAGE VARCHAR2(32767),
        ISSUE_TITLE                VARCHAR2(32767),
        APEX_CREATED_BY            VARCHAR2(1020 CHAR),
        APEX_CREATED_ON            DATE,
        APEX_LAST_UPDATED_BY       VARCHAR2(4080),
        APEX_LAST_UPDATED_ON       DATE,
        TEST_CODE                  VARCHAR2(100),
        COMPONENT_ID               NUMBER,
        PARENT_COMPONENT_ID        NUMBER
    )
/
create or replace type V_SVT_SCM_OBJECT_ASSIGNEE_OT as object
    (
    object_name       varchar2(256),
    email             varchar2(240),
    folder_name       varchar2(256),
    lock_rank         number
);
/
create or replace type v_svt_stds_standard_tests_ot as object
    (
        STANDARD_ID             NUMBER,
        TEST_ID                 NUMBER,
        LEVEL_ID                NUMBER,
        URGENCY                 VARCHAR2(255),
        URGENCY_LEVEL           NUMBER,
        TEST_NAME               VARCHAR2(64),
        TEST_CODE               VARCHAR2(100),
        STANDARD_NAME           VARCHAR2(64),
        ACTIVE_YN               VARCHAR2(1),
        NT_NAME                 VARCHAR2(255 CHAR),
        QUERY_CLOB              CLOB,
        STD_CREATION_DATE       TIMESTAMP(6) WITH LOCAL TIME ZONE,
        MV_DEPENDENCY           VARCHAR2(100),
        SVT_COMPONENT_TYPE_ID   NUMBER,
        COMPONENT_NAME          VARCHAR2(50),
        STANDARD_ACTIVE_YN      VARCHAR2(1),
        EXPLANATION             VARCHAR2(4000 CHAR),
        FIX                     CLOB,
        DOWNLOAD                NUMBER,   
        FILE_BLOB               BLOB,
        MIME_TYPE               CHAR(16),
        FILE_NAME               VARCHAR2(4000), 
        CHARACTER_SET           CHAR(5),
        VERSION_NUMBER          NUMBER,
        VERSION_DB              VARCHAR2(55),
        VSN                     VARCHAR2(5),
        RECORD_MD5              VARCHAR2(250),
        LIB_MD5                 VARCHAR2(250),
        LIB_IMPORTED_VERSION    NUMBER,
        PUBLISHED_YN            VARCHAR2(1),
        DOWNLOAD_CSS            VARCHAR2(50),
        INHERITED_YN            VARCHAR2(1),
        CALLING_STANDARD_NAME   VARCHAR2(64), --only relevant for inherited tests
        DISPLAY_SEQUENCE        NUMBER
    )
/
create or replace type V_SVT_TABLE_DATA_LOAD_DEF_OT as object
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















 