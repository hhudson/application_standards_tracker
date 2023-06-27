create or replace package sv_sec_exception as
---------------------------------------------------------------------
--
-- Copyright(C) 2020, Oracle Corporation 
-- All Rights Reserved
--
---------------------------------------------------------------------
-- Application          : Developer tools
-- Source File name     : sv_sec_exception.pks
-- Purpose              : Package of procedures relating to exceptions!
--
-- HAS COMMITS          : YES_NO1 (Type)
-- HAS ROLLBACKS        : YES_NO2
-- RUNTIME DEPLOYMENT   : YES_NO3
--
-- Comments :
--
--    MyComments
-- 
-- History :
-- 
--    MODIFIED (DD-Mon-YYYY)  
--    sspendolini ??-???-?? - Created
--    mipotter    14-OCT-21 - add constants for icon classes to display exception
--    
---------------------------------------------------------------------

-- Custom fields for use in processing inserts in export/import
-- we use column_key, attribute_key values to rebuild/setup the associated 
-- attribute_id,column_id values, as the sequences cannot be guaranteed 
-- matching across instances.
--
-- component_sig, component_sig_sql are used for FAILED imports 
-- of exceptions
--===================================================================
--< PUBLIC TYPES AND GLOBALS >--
--===================================================================
   c_failed_exception constant varchar2(256)  := 'fa fa-certificate fa-lg fam-plus u-success-text';
   c_pending_approver constant varchar2(256)  := 'fa fa-certificate fam-50-percent fam-is-info fa-lg u-info-text';
   c_pending_owner    constant varchar2(256)  := 'fa fa-certificate fam-50-percent fa-lg u-warning-text';
   c_pending_viewer   constant varchar2(256)  := 'fa fa-certificate fam-50-percent fa-lg u-info-text';
   c_rejected_owner   constant varchar2(256)  := 'fa fa-certificate fam-x fam-is-danger fa-lg u-danger-text';
   c_rejected_other   constant varchar2(256)  := 'fa fa-info-circle-o fam-x fam-is-danger fa-lg';
   c_stale_owner      constant varchar2(256)  := 'fa fa-info-circle-o fam-warning fam-is-danger fa-lg';
   c_stale_other      constant varchar2(256)  := 'fa fa-info-circle-o fam-warning fam-is-danger fa-lg';
   c_approved_owner   constant varchar2(256)  := 'fa fa-certificate fam-check fam-is-success fa-lg';
   c_approved_other   constant varchar2(256)  := 'fa fa-info-circle-o fam-check fam-is-success fa-lg';

   type exception_t is record (
      exception_id            sv_sec_exceptions.exception_id%type,
      attribute_set_id        sv_sec_exceptions.attribute_set_id%type,
      application_id          sv_sec_exceptions.application_id%type,
      attribute_id            sv_sec_exceptions.attribute_id%type,
      page_id                 sv_sec_exceptions.page_id%type,
      component_id            sv_sec_exceptions.component_id%type,
      column_id               sv_sec_exceptions.column_id%type,
      justification           sv_sec_exceptions.justification%type,
      rejected_justification  sv_sec_exceptions.rejected_justification%type,
      rejection               sv_sec_exceptions.rejection%type,
      approved_flag           sv_sec_exceptions.approved_flag%type,
      prev_approved_flag      sv_sec_exceptions.prev_approved_flag%type,
      created_by              sv_sec_exceptions.created_by%type,
      created_on              sv_sec_exceptions.created_on%type,
      created_ws              sv_sec_exceptions.created_ws%type,
      approved_by             sv_sec_exceptions.approved_by%type,
      approved_on             sv_sec_exceptions.approved_on%type,
      approved_ws             sv_sec_exceptions.approved_ws%type,
      rejected_by             sv_sec_exceptions.rejected_by%type,
      rejected_on             sv_sec_exceptions.rejected_on%type,
      rejected_ws             sv_sec_exceptions.rejected_ws%type,
      val                     sv_sec_exceptions.val%type,
      checksum                sv_sec_exceptions.checksum%type,
      exception_guid          sv_sec_exceptions.exception_guid%type,
      column_rpt_type         varchar2(1024),
      attribute_key           sv_sec_attributes.attribute_key%type,
      column_key              varchar2(1024),
      component_table         sv_sec_attributes.component_table%type,
      component_column_id     varchar2(1024),
      component_sig           sv_sec_component_sigs.component_sig%type,
      component_sig_sql       varchar2(4000)
   );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   function get_exception_id (
      p_exception_pk      in  varchar2,
      p_application_id    in  number,
      p_attribute_set_id  in  number
   ) return number;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   procedure save_exception (
      p_attribute_set_id   in  number,
      p_application_id     in  number,
      p_app_user           in  varchar2 default v('APP_USER'),
      p_exception_pk       in  varchar2,
      p_justification      in  varchar2,
      p_sert_app_id        in  number default nv('APP_ID'),
      p_app_session        in  number default nv('APP_SESSION'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   procedure save_approval (
      p_attribute_set_id   in  number,
      p_application_id     in  number,
      p_app_user           in  varchar2 default v('APP_USER'),
      p_exception_pk       in  varchar2,
      p_val                in  clob default null,
      p_checksum           in  varchar2 default null,
      p_sert_app_id        in  number default nv('APP_ID'),
      p_app_session        in  number default nv('APP_SESSION'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   procedure save_rejection (
      p_attribute_set_id   in  number,
      p_application_id     in  number,
      p_app_user           in  varchar2 default v('APP_USER'),
      p_exception_pk       in  varchar2,
      p_rejection          in  varchar2,
      p_val                in  clob default null,
      p_checksum           in  varchar2 default null,
      p_sert_app_id        in  number default nv('APP_ID'),
      p_app_session        in  number default nv('APP_SESSION'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   procedure save_notation (
      p_app_user           in  varchar2 default v('APP_USER'),
      p_attribute_set_id   in  number,
      p_application_id     in  number,
      p_notation_pk        in  varchar2,
      p_notation_msg       in  varchar2,
      p_workspace_id       in  varchar2,
      p_sert_app_id        in  number default nv('APP_ID'),
      p_app_session        in  number default nv('APP_SESSION'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   procedure delete_notation (
      p_notation_id in number
   );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   function get_exception (
      p_exception_pk in varchar2
   ) return varchar2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   function get_approval (
      p_exception_pk in varchar2
   ) return varchar2;

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   procedure delete_exception (
      p_exception_pk in varchar2
   );

---------------------------------------------------------------------
--< functionName >--
---------------------------------------------------------------------
   procedure apply_exceptions (
      p_collection_id      in  number,
      p_application_id     in  number,
      p_attribute_set_id   in  number,
      p_app_user           in  varchar2,
      p_attribute_id       in  number default null,
      p_app_session        in  number default nv('APP_SESSION'),
      p_sert_app_id        in  varchar2 default v('APP_ID'),
      p_user_workspace_id  in  number default nv('G_WORKSPACE_ID')
   );

end sv_sec_exception;
/