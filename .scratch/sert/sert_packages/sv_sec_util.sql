create or replace PACKAGE sv_sec_util
AS 

type t_summary is record (
    title        varchar2(255),
    initials     varchar2(4),
    color        varchar2(255),
    text         varchar2(4000),
    subtext      varchar2(4000),
    display_page varchar2(255)
    );
type t_summary_tab is table of t_summary;

---------------------------------------------------------------------
--< init >--
---------------------------------------------------------------------
PROCEDURE init
  (
  p_app_user                 IN VARCHAR2 DEFAULT v('APP_USER'),
  p_app_session              IN NUMBER   DEFAULT nv('APP_SESSION')
  );

---------------------------------------------------------------------
--< set_ctx >--
---------------------------------------------------------------------
PROCEDURE set_ctx
  (
  p_application_id           IN VARCHAR2,
  p_app_session              IN NUMBER,
  p_app_user                 IN VARCHAR2,
  p_collection_id            IN NUMBER,
  p_attribute_set_id         IN NUMBER
  );

---------------------------------------------------------------------
--< unset_ctx >--
---------------------------------------------------------------------
PROCEDURE unset_ctx
  (
  p_app_session              IN NUMBER DEFAULT nv('APP_SESSION')
  );

---------------------------------------------------------------------
--< about >--
---------------------------------------------------------------------
PROCEDURE about
  (
  p_application_id           IN NUMBER
  );

---------------------------------------------------------------------
--< stale_eval >--
---------------------------------------------------------------------
FUNCTION stale_eval
  (
  p_date_from                IN DATE,
  p_date_to                  IN DATE DEFAULT NULL      
  ) 
  RETURN VARCHAR2;

---------------------------------------------------------------------
--< populate_result >--
---------------------------------------------------------------------
PROCEDURE populate_result
  (
  p_result                   IN VARCHAR2,
  p_app_user                 IN VARCHAR2,
  p_app_session              IN VARCHAR2
  );

---------------------------------------------------------------------
--< get_collection_id >--
---------------------------------------------------------------------
FUNCTION get_collection_id
  (
  p_application_id           IN NUMBER,
  p_app_user                 IN VARCHAR2,
  p_app_session              IN VARCHAR2
  )
  RETURN NUMBER;

---------------------------------------------------------------------
--< get_version_disp >--
---------------------------------------------------------------------
FUNCTION get_version_disp
  (
  p_version                  IN VARCHAR2
  )
  RETURN VARCHAR2;

---------------------------------------------------------------------
--< get_version >--
---------------------------------------------------------------------
FUNCTION get_version
  RETURN VARCHAR2;

---------------------------------------------------------------------
--< get_color >--
---------------------------------------------------------------------
FUNCTION get_color
  (
  p_pct_score                IN NUMBER,
  p_possible_score           IN NUMBER,
  p_print                    IN BOOLEAN DEFAULT FALSE,
  p_app_session              IN NUMBER  DEFAULT nv('APP_SESSION')
  )
RETURN VARCHAR2;

---------------------------------------------------------------------
--< get_color_class >--
---------------------------------------------------------------------
-- Returns the color-class based on the percent score
---------------------------------------------------------------------
function get_color_class (
   p_pct_score in number,
   p_possible_score in number,
   p_app_session in number default nv ('APP_SESSION')
) return varchar2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION get_page_attribute_id
  (
  p_page_id                  IN NUMBER
  )
RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION get_help_class
  (
  p_page_id                  IN NUMBER
  )
RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE prepare_url
  (
  p_url                      IN VARCHAR2
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE check_gt_lt_attr_val
  (
  p_attribute_set_id           IN NUMBER, 
  p_attribute_id               IN NUMBER,
  p_value                      IN VARCHAR2,
  p_result                     IN VARCHAR2
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION internal_attr
  (
  p_attribute_id             IN NUMBER DEFAULT NULL
  )
RETURN BOOLEAN;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION internal_attr_set
  (
  p_attribute_set_id         IN NUMBER DEFAULT NULL
  )
RETURN BOOLEAN;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE redirect_when_stale;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE log_page_view;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE get_progress;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
function display_summary
  (
  p_banner_yn                   IN varchar2 default 'N',
  p_attribute_set_id         IN NUMBER,
  p_application_id           IN NUMBER,
  p_classification_key       IN VARCHAR2,
  p_print                    IN BOOLEAN DEFAULT FALSE,
  p_app_user                 IN VARCHAR2 DEFAULT v('APP_USER'),
  p_app_session              IN NUMBER DEFAULT nv('APP_SESSION'),
  p_sert_app_id              IN VARCHAR2 DEFAULT v('APP_ID')
  ) return t_summary_tab pipelined;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION print_name
  (
  p_application_id           IN NUMBER,
  p_attribute_set_id         IN NUMBER,
  p_record_score             IN BOOLEAN  DEFAULT FALSE,
  p_app_user                 IN VARCHAR2 DEFAULT v('APP_USER'),
  p_app_session              IN NUMBER   DEFAULT nv('APP_SESSION'),
  p_app_eval_id              IN NUMBER   DEFAULT NULL,
  p_scheduled_eval           IN VARCHAR2 DEFAULT 'N',
  p_evaluated_ws             IN NUMBER   DEFAULT v('G_WORKSPACE_ID')
  ) RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION display_column
  (
  p_attribute_key            IN VARCHAR2
  ) RETURN BOOLEAN;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE save_apex_link
  (
  p_page_id                  IN NUMBER,
  p_link                     IN VARCHAR2,
  p_rp                       IN VARCHAR2,
  p_component_name           IN VARCHAR2,
  p_category                 IN VARCHAR2
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION get_apex_session
   RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE print_apex_session;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION get_attr_sets
  (
  p_attribute_id             IN NUMBER
  ) RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION is_disabled
  (
  p_attribute_set_id         IN NUMBER,
  p_workspace_id             IN NUMBER DEFAULT NULL
  )
  RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION logo
  RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE compatibility_check
  (
  p_version                  IN VARCHAR
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION copyright
  RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION get_component
  (
  p_component_id             IN NUMBER   DEFAULT NULL,
  p_attribute_id             IN NUMBER   DEFAULT NULL
  )
  RETURN VARCHAR2;


---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION get_column
  (
  p_column_id                IN NUMBER   DEFAULT NULL,
  p_attribute_id             IN NUMBER   DEFAULT NULL
  )
  RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE add_attributes
  (
  p_attribute_set_id         IN NUMBER
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE remove_attribute
  (
  p_attribute_set_attrs_id   IN NUMBER
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE toggle_attr_vals
  (
  p_attribute_id             IN NUMBER,
  p_value                    IN VARCHAR2
  );  

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION int_attr
  (
  p_attribute_id             IN NUMBER
  ) RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION int_category
  (
  p_category_id              IN NUMBER
  ) RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION gt_lt_value
  (
  p_attribute_id             IN NUMBER,
  p_attribute_set_id         IN NUMBER
  ) RETURN BOOLEAN;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE copy_inline_attrs
  (
  p_copy_to                  IN NUMBER
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE copy_attr_set
  (
  p_copy_from                IN NUMBER,
  p_copy_to                  IN NUMBER
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE copy_attribute
  (
  p_attribute_id             IN NUMBER,
  p_attribute_set_id         IN NUMBER   DEFAULT NULL,
  p_attribute_sets           IN VARCHAR2 DEFAULT NULL,
  p_attribute_name           IN VARCHAR2,
  p_attribute_key            IN VARCHAR2
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE show_info
  (
  p_attribute_id             IN NUMBER
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE show_fix
  (
  p_attribute_id             IN NUMBER DEFAULT NULL,
  p_attribute_value_id       IN NUMBER DEFAULT NULL
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE view_source
  (
  p_id                       IN NUMBER DEFAULT NULL,
  p_component_type           IN VARCHAR2 DEFAULT NULL
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE record_eval
  (
  p_attribute_set_id         IN NUMBER,
  p_application_id           IN VARCHAR,
  p_app_user                 IN VARCHAR,
  p_approved_score           IN NUMBER,
  p_pending_score            IN NUMBER,
  p_raw_score                IN NUMBER,
  p_app_session              IN NUMBER   DEFAULT nv('APP_SESSION'),
  p_app_eval_id              IN NUMBER   DEFAULT NULL,
  p_scheduled_eval           IN VARCHAR2 DEFAULT 'N',
  p_evaluated_ws             IN NUMBER   DEFAULT nv('G_WORKSPACE_ID')
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE apply_notations
  (
  p_collection_id            IN NUMBER,
  p_application_id           IN NUMBER,
  p_attribute_set_id         IN NUMBER,
  p_app_session              IN NUMBER   DEFAULT nv('APP_SESSION'),
  p_sert_app_id              IN VARCHAR2 DEFAULT v('APP_ID')
  );  

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION notation_history_sql
  (
  p_application_id           IN NUMBER,
  p_attribute_set_id         IN NUMBER,
  p_notation_pk              IN VARCHAR2
  )
RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION get_checksum
  (
  p_value                    IN CLOB DEFAULT NULL
  )
  RETURN RAW;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE record_cookie
  (
  p_session_id               IN NUMBER,
  p_cookie_val               IN VARCHAR2
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE builder_auth
  (
  p_session_id               IN NUMBER
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION builder_auth_fcn
  (
  p_username                 IN VARCHAR2,
  p_password                 IN VARCHAR2
  )
  RETURN BOOLEAN;

---------------------------------------------------------------------
--< match_user >--
---------------------------------------------------------------------
-- Purpose         : briefly
-- HAS COMMITS     : YES/NO
-- HAS ROLLBACKS   : YES/NO
--
-- Purpose   : match username (authenticated) with the builder session 
--             that launched the app
--
-- Comments  : 
--
-- Call Example :
--
---------------------------------------------------------------------
procedure match_user;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION user_has_role
  (
  p_application_id           IN VARCHAR2 DEFAULT NULL,
  p_workspace_id             IN VARCHAR2,
  p_user_name                IN VARCHAR2,
  p_role_name                IN VARCHAR2
  )
  RETURN BOOLEAN;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION user_has_role_vc
  (
  p_application_id           IN VARCHAR2 DEFAULT NULL,
  p_workspace_id             IN VARCHAR2,
  p_user_name                IN VARCHAR2,
  p_role_name                IN VARCHAR2
  )
  RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION is_account_locked
  (
  p_user_name                IN VARCHAR2
  )
RETURN VARCHAR2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE purge_evals
  (
  p_eval_type                IN VARCHAR2
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE purge_events
  (
  p_event_type               IN VARCHAR2
  );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
FUNCTION bc_buttons
  (
  p_button_key               IN VARCHAR2
  )
RETURN BOOLEAN;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
PROCEDURE prepare_url
  (
  p_type                     IN VARCHAR2,
  p_page                     IN NUMBER   DEFAULT NULL,
  p_request                  IN VARCHAR2 DEFAULT NULL
  );

---------------------------------------------------------------------
--< clob_to_file >--
---------------------------------------------------------------------
-- Purpose         : briefly
-- HAS COMMITS     : YES/NO
-- HAS ROLLBACKS   : YES/NO
--
-- Purpose   : <brief description>
--
-- Comments  : <general comments>
--
-- Call Example :
--
-- create or replace directory BLOB_DIR as '/u01/mydir';
-- 
-- declare
--    l_blob      BLOB;
--    l_dir       varchar2(128) := 'BLOB_DIR';
--    l_filename  varchar2(256) := 'my_json.json';
-- begin
--    /*... setup your blob...*/
--    clob_to_file( 
--       p_clob      => l_blob,
--       p_dir       => l_dir,
--       p_Ffilename  => l_filename
--    );
-- end;
---------------------------------------------------------------------
procedure clob_to_file (
   p_clob      in  clob,
   p_dir       in  varchar2,
   p_filename  in  varchar2
);
---------------------------------------------------------------------
--< file_to_blob >--
---------------------------------------------------------------------
-- Purpose         : read a file into a blob
-- HAS COMMITS     : YES/NO
-- HAS ROLLBACKS   : YES/NO
--
-- Purpose   : read a file into a BLOB
--
-- Comments  : <general comments>
--    p_blob will hold the contents of the file
--    p_dir is the name of the directory object 
--    p_filename is the name of the file to be read
--
--    You need to pre-create the DIRECTORY object
--    eg: create directory json_exceptions as '/u01/files';
--    then you can use 'json_exceptions' for p_dir
-- Call Example :
-- create or replace directory BLOB_DIR as '/u01/mydir';
-- 
-- declare
--    l_blob      BLOB;
--    l_dir        varchar2(128) := 'JSON_DIR';
--    l_filename   varchar2(256) := 'exceptions.json';
--
-- begin
--    DBMS_LOB.createtemporary(l_dest_blob, true);
-- file_to_blob ( p_blob => l_blob,
--                p_dir => l_dir
--                p_filename => l_filename);
-- end;
---------------------------------------------------------------------

   procedure file_to_blob (
      p_blob      in out nocopy blob,
      p_dir       in  varchar2,
      p_filename  in  varchar2
   );
---------------------------------------------------------------------
--< download_blob >--
---------------------------------------------------------------------
-- Purpose         : download a blob passed as a parameter
-- HAS COMMITS     : NO
-- HAS ROLLBACKS   : NO
--
-- Purpose   : provide a single line call, to download a blob
--
-- Comments  :
--
-- Call Example :
--
-- declare 
--    l_dest_blob blob;
-- begin
--    /* ...do something */
--    download_blob(
--       p_blob => l_dest_blob,
--       p_filename => 'exceptions.json',
--       p_mime_type => 'application/json'
--    );
-- end;
---------------------------------------------------------------------
   procedure download_blob (
      p_blob       in  blob,
      p_filename   in  varchar2,
      p_mime_type  in  varchar2 default 'application/json'
   );

---------------------------------------------------------------------
-- END  SV_SEC_UTIL
---------------------------------------------------------------------
END sv_sec_util;
/