create or replace package sv_sec as
---------------------------------------------------------------------
--
-- All Rights Reserved
--
---------------------------------------------------------------------
-- Application          : Developer tools
-- Source File name     : sv_sec.pks
-- Purpose              :
--
--
-- Comments :
--
--
-- History :
--
--    MODIFIED (DD-Mon-YYYY)
--    mipotter  15-Jan-2021 - modified to add category_summary_card
--       t_basic_card and dashboard_cards
--    mzimon    21-DEC-2021 - Post PL_FPDF removal refactoring.
--                            Removed dashboard and dashboard_cards.
--
--
---------------------------------------------------------------------


--===================================================================
--< TYPES AND GLOBALS >--
--===================================================================
   c_guid constant varchar2 (1000) := '9985453653DB61D2E04098427CBF1C00';

   type t_basic_card is record (
      card_title        varchar2 (255)
      , card_initials   varchar2 (8)
      , card_color      varchar2 (255)
      , card_text       varchar2 (4000)
      , card_subtext    varchar2 (4000)
      , card_link       varchar2 (4000)
   );
   type t_basic_card_tab is
      table of t_basic_card;
   function get_guid return varchar2;

---------------------------------------------------------------------
--< calc_score >--
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
---------------------------------------------------------------------
   function calc_score (
      p_attribute_set_id   in  number
    , p_application_id     in  number
    , p_page_id            in  number default null
    , p_request            in  varchar2 default v ('REQUEST')
    , p_app_user           in  varchar2 default v ('APP_USER')
    , p_workspace_id       in  number default nv ('G_WORKSPACE_ID')
    , p_sert_app_id        in  number default nv ('APP_ID')
    , p_app_session        in  number default nv ('APP_SESSION')
    , p_owner              in  varchar2
    , p_app_eval_id        in  number default null
    , p_user_workspace_id  in  number default nv ('G_WORKSPACE_ID')
    , p_scheduled_eval     in  varchar2 default 'N'
   ) return varchar2;

---------------------------------------------------------------------
--< category_summary_card >--
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
---------------------------------------------------------------------
   function category_summary_card (
      p_attribute_set_id  in  number
    , p_application_id    in  number
    , p_page_id           in  number default nv ('APP_PAGE_ID')
    , p_format            in  varchar2 default 'HTML'
    , p_app_user          in  varchar2 default v ('APP_USER')
    , p_app_session       in  number default nv ('APP_SESSION')
    , p_sert_app_id       in  number default nv ('APP_ID')
    , p_banner_yn         in  varchar2 default 'N'
   ) return t_basic_card_tab
      pipelined;
/*
---------------------------------------------------------------------
--< dashboard >--
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
---------------------------------------------------------------------
   function dashboard (
      p_attribute_set_id  in  number
    , p_application_id    in  number
    , p_page_id           in  number default nv ('APP_PAGE_ID')
    , p_format            in  varchar2 default 'HTML'
    , p_app_user          in  varchar2 default v ('APP_USER')
    , p_app_session       in  number default nv ('APP_SESSION')
    , p_sert_app_id       in  number default nv ('APP_ID')
   ) return varchar2;

---------------------------------------------------------------------
--< dashboard_cards >--
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
---------------------------------------------------------------------
   function dashboard_cards (
      p_attribute_set_id  in  number
    , p_application_id    in  number
    , p_page_id           in  number default nv ('APP_PAGE_ID')
    , p_format            in  varchar2 default 'HTML'
    , p_app_user          in  varchar2 default v ('APP_USER')
    , p_app_session       in  number default nv ('APP_SESSION')
    , p_sert_app_id       in  number default nv ('APP_ID')
   ) return t_basic_card_tab
      pipelined;
*/
---------------------------------------------------------------------
--< get_recommended_value >--
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
---------------------------------------------------------------------
   function get_recommended_value (
      p_attribute_set_id  in  number
    , p_attribute_key     in  varchar2
   ) return varchar2;

---------------------------------------------------------------------
--< get_result >--
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
---------------------------------------------------------------------
   function get_result (
      p_attribute_key      in  varchar2
    , p_attribute_set_id   in  number
    , p_value              in  varchar2
    , p_recommended_value  in  varchar2 default null
    , p_show_value         in  varchar2 default 'N'
    , p_image              in  varchar2 default 'Y'
    , p_exception_key      in  varchar2 default null
    , p_inline             in  varchar2 default 'N'
   ) return varchar2;

   PRAGMA deprecate(get_result,'sv_sec.get_result is deprecated please use sv_sec.check_attribute_rule instead.');

--------------------------------------------------------------------------------
--< check_attribute_rule >--
--------------------------------------------------------------------------------
-- Purpose         : Returns  PASS/FAIL/null when validating a value against an attribute rule check.
--
-- Comments  : Primary use is being called from a Collections SQL statement.
--------------------------------------------------------------------------------
   function check_attribute_rule(
       p_value             in varchar2
      ,p_rule_source       in varchar2
      ,p_rule_type         in varchar2
      ,p_when_not_found    in varchar2
      ,p_attribute_values  in varchar2
      ,p_attribute_results in varchar2 )
      return varchar2;

---------------------------------------------------------------------
--< summary_dashboard >--
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
---------------------------------------------------------------------
   procedure summary_dashboard (
      p_attribute_set_id  in  number
    , p_application_id    in  number
    , p_page_id           in  number
    , p_app_user          in  varchar2 default v ('APP_USER')
    , p_app_session       in  number default nv ('APP_SESSION')
    , p_sert_app_id       in  number default nv ('APP_ID')
   );
---------------------------------------------------------------------
-- E N D    S V _ S E C
---------------------------------------------------------------------
end sv_sec;
/