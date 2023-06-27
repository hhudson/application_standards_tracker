create or replace package body sv_sec_util as
---------------------------------------------------------------------
--
-- All Rights Reserved
--
---------------------------------------------------------------------
-- Application          : Developer tools
-- Source File name     : sv_sec_util.pkb
-- Purpose              : MyPurpose
--
-- HAS COMMITS          : No (Type)
-- HAS ROLLBACKS        : No
-- RUNTIME DEPLOYMENT   : No
--
-- Comments :
--
--    MyComments
--
-- History :
--
--    MODIFIED (DD-Mon-YYYY)
--    mipotter  11-Jan-2021 - modified display_summary2 to truncate score after
--                            rounding to 1 decimal
--    mzimon    02-NOV-2021 - GAT-61. Modified display_summary.
--    mzimon    21-DEC-2021 - Added conditional compile for ADB build.
--
---------------------------------------------------------------------

--------------------------------------------------------------------------------
-- PROCEDURE: I N I T
--------------------------------------------------------------------------------
-- Cleans up collection data, etc.
--------------------------------------------------------------------------------
   procedure init (
      p_app_user     in  varchar2 default v('APP_USER'),
      p_app_session  in  number default nv('APP_SESSION')
   ) is
   begin

   -- Clean up stale collection values
      delete from sv_sec_collection
       where app_user = p_app_user
         and app_session != p_app_session
         and created_on > sysdate - 1;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end init;

--------------------------------------------------------------------------------
-- PROCEDURE: S E T _ C T X
--------------------------------------------------------------------------------
-- Sets the Application Context for the Collection and Application
--------------------------------------------------------------------------------
   procedure set_ctx (
      p_application_id    in  varchar2,
      p_app_session       in  number,
      p_app_user          in  varchar2,
      p_collection_id     in  number,
      p_attribute_set_id  in  number
   ) is
      l_collection_id number := p_collection_id;
   begin

-- Get the Collection ID if coming from APEX
      if l_collection_id is null then
         for x in (
            select collection_id
              from sv_sec_collection
             where app_session = p_app_session
               and app_user = p_app_user
               and app_id = p_application_id
         ) loop
            l_collection_id := x.collection_id;
         end loop;
      end if;

-- Set the Context for COLLECTION_ID
      dbms_session.set_context(
         namespace  => 'SV_SERT_CTX',
         attribute  => 'COLLECTION_ID',
         value      => l_collection_id,
         username   => p_app_user,
         client_id  => p_app_session
      );

-- Set the Context for APPLICATION_ID
      dbms_session.set_context(
         namespace  => 'SV_SERT_CTX',
         attribute  => 'APPLICATION_ID',
         value      => p_application_id,
         username   => p_app_user,
         client_id  => p_app_session
      );

-- Set the Context for APPLICATION_ID
      dbms_session.set_context(
         namespace  => 'SV_SERT_CTX',
         attribute  => 'ATTRIBUTE_SET_ID',
         value      => p_attribute_set_id,
         username   => p_app_user,
         client_id  => p_app_session
      );

-- Set the Context for APPROVER
      if apex_util.current_user_in_group('SV_SERT_APPROVER') = true then
         dbms_session.set_context(
            namespace  => 'SV_SERT_CTX',
            attribute  => 'SV_SEC_APPROVER',
            value      => 'Y',
            username   => p_app_user,
            client_id  => p_app_session
         );
      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end set_ctx;

--------------------------------------------------------------------------------
-- PROCEDURE: U N S E T _ C T X
--------------------------------------------------------------------------------
-- Unsets the Application Context
--------------------------------------------------------------------------------
   procedure unset_ctx (
      p_app_session in number default nv('APP_SESSION')
   ) is
   begin
      dbms_session.clear_context('SV_SERT_CTX', p_app_session);
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end unset_ctx;

--------------------------------------------------------------------------------
-- PROCEDURE: A B O U T
--------------------------------------------------------------------------------
-- Displays the About sumnevaSERT Message
--------------------------------------------------------------------------------
   procedure about (
      p_application_id in number
   ) is
      l_version  varchar2(255);
      l_owner    varchar2(255);
   begin
      select get_version_disp(version),
             owner
        into l_version,
             l_owner
        from apex_applications
       where application_id = p_application_id;

      htp.prn('<p><b>Version</b>: '
              || l_version
              || '<br />');
      htp.prn('<b>Parse As Schema</b>: '
              || l_owner
              || '</p>');
   end about;

--------------------------------------------------------------------------------
-- FUNCTION: S T A L E _ E V A L
--------------------------------------------------------------------------------
-- Determines the lag time between an update and evaluation for an application
--------------------------------------------------------------------------------
   function stale_eval (
      p_date_from  in  date,
      p_date_to    in  date default null
   ) return varchar2 is
      l_date     date;
      l_sysdate  date;
   begin
      l_date := p_date_from;
      if p_date_to is null then
         l_sysdate := sysdate;
      else
         l_sysdate := p_date_to;
      end if;

      if p_date_from is null then
         return null;
      elsif l_sysdate = l_date then
         return 'Now';
      elsif l_sysdate - l_date between 0 and 1 / 720 then
         return replace('#time# Seconds', '#time#', round(24 * 60 * 60 *(l_sysdate - l_date)));
      elsif l_sysdate - l_date between 1 / 720 and 1 / 12 then
         return replace('#time# Minutes', '#time#', round(24 * 60 *(l_sysdate - l_date)));
      elsif l_sysdate - l_date between 1 / 12 and 2 then
         return replace('#time# Hours', '#time#', round(24 *(l_sysdate - l_date)));
      elsif l_sysdate - l_date between 2 and 14 then
         return replace('#time# Days', '#time#', trunc(l_sysdate - l_date));
      elsif l_sysdate - l_date between 14 and 60 then
         return replace('#time# Weeks', '#time#', trunc((l_sysdate - l_date) / 7));
      elsif l_sysdate - l_date between 60 and 365 then
         return replace('#time# Months', '#time#', round(months_between(l_sysdate, l_date)));
      elsif l_date < l_sysdate then
         return replace('#time# Years', '#time#', round(months_between(l_sysdate, l_date) / 12, 1));
      else
         return null;
      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end stale_eval;

--------------------------------------------------------------------------------
-- PROCEDURE: P O P U L A T E _ R E S U L T
--------------------------------------------------------------------------------
-- Populates SV_SEC_RESULT_TEMP with the current score types
--------------------------------------------------------------------------------
   procedure populate_result (
      p_result       in  varchar2,
      p_app_user     in  varchar2,
      p_app_session  in  varchar2
   ) is
   begin

-- Clear out the temporary table for a specific user session
      delete from sv_sec_result_temp
       where app_session = p_app_session
         and app_user = p_app_user;

-- Determine which type of score to show and add that to the temporary table
      if p_result = 'Approved' then
         insert into sv_sec_result_temp (
            app_user,
            app_session,
            result
         ) values (
            p_app_user,
            p_app_session,
            'PASS'
         );

         insert into sv_sec_result_temp (
            app_user,
            app_session,
            result
         ) values (
            p_app_user,
            p_app_session,
            'APPROVED'
         );

      elsif p_result = 'Pending' then
         insert into sv_sec_result_temp (
            app_user,
            app_session,
            result
         ) values (
            p_app_user,
            p_app_session,
            'PASS'
         );

         insert into sv_sec_result_temp (
            app_user,
            app_session,
            result
         ) values (
            p_app_user,
            p_app_session,
            'APPROVED'
         );

         insert into sv_sec_result_temp (
            app_user,
            app_session,
            result
         ) values (
            p_app_user,
            p_app_session,
            'PENDING'
         );

      else
         insert into sv_sec_result_temp (
            app_user,
            app_session,
            result
         ) values (
            p_app_user,
            p_app_session,
            'PASS'
         );

      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end populate_result;

--------------------------------------------------------------------------------
-- PROCEDURE: G E T _ C O L L E C T I O N _ I D
--------------------------------------------------------------------------------
-- Gets the current COLLECTION_ID
--------------------------------------------------------------------------------
   function get_collection_id (
      p_application_id  in  number,
      p_app_user        in  varchar2,
      p_app_session     in  varchar2
   ) return number is
   begin
      for x in (
         select collection_id
           from sv_sec_collection
          where app_user = p_app_user
            and app_id = p_application_id
            and app_session = p_app_session
      ) loop
         return x.collection_id;
      end loop;

      return null;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_collection_id;

--------------------------------------------------------------------------------
-- PROCEDURE: G E T _ V E R S I O N _ D I S P
--------------------------------------------------------------------------------
-- Gets the current version of sumnevaSERT separated by periods
--------------------------------------------------------------------------------
   function get_version_disp (
      p_version in varchar2
   ) return varchar2 is
      l_version_disp varchar2(100);
   begin
      select to_number(substr(p_version, 1, 2))
             || '.'
             || to_number(substr(p_version, 3, 2))
             || '.'
             || to_number(substr(p_version, 5, 2))
        into l_version_disp
        from dual;

      return l_version_disp;
   exception
      when others then
         return '***DEVELOPMENT***';
   end get_version_disp;

--------------------------------------------------------------------------------
-- PROCEDURE: G E T _ V E R S I O N
--------------------------------------------------------------------------------
-- Gets the raw current version of sumnevaSERT
-- return MAX in case there is more than one row...
--------------------------------------------------------------------------------
   function get_version return varchar2 is
      l_version sv_sec_version.version%type;
   begin
      select max(version)
        into l_version
        from sv_sec_version;

      return l_version;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_version;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ C O L O R
--------------------------------------------------------------------------------
-- Returns the color-class based on the percent score
--------------------------------------------------------------------------------
   function get_color_class (
      p_pct_score       in  number,
      p_possible_score  in  number,
      p_app_session     in  number default nv('APP_SESSION')
   ) return varchar2 is
      l_color                   varchar2(255);
      l_pref_failure_tolerance  number;
      l_pref_accept_tolerance   number;
   begin

      -- Set preferences, if coming from APEX
      if p_app_session < 0 then
         l_pref_failure_tolerance  := 60;
         l_pref_accept_tolerance   := 100;
      else
         l_pref_failure_tolerance  :=
            nvl(
               apex_util.get_preference(
                  p_preference  => 'FAILURE_TOLERANCE',
                  p_user        => v('APP_USER')
               ),
               60
            );

         l_pref_accept_tolerance   :=
            nvl(
               apex_util.get_preference(
                  p_preference  => 'ACCEPTABLE_TOLERANCE',
                  p_user        => v('APP_USER')
               ),
               100
            );

      end if;

      case
         when p_pct_score <= l_pref_failure_tolerance then
            l_color := 'u-danger';
         when p_pct_score >= l_pref_accept_tolerance then
            l_color := 'u-success';
         when p_possible_score = 0 then
            l_color := 'u-warning';
         else
            l_color := '#e6ac58';
      end case;

      return l_color;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_color_class;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ C O L O R
--------------------------------------------------------------------------------
-- Returns the color based on the percent score
--------------------------------------------------------------------------------
   function get_color (
      p_pct_score       in  number,
      p_possible_score  in  number,
      p_print           in  boolean default false,
      p_app_session     in  number default nv('APP_SESSION')
   ) return varchar2 is
      l_color                   varchar2(255);
      l_color_rgb               varchar2(255);
      l_pref_failure_tolerance  number;
      l_pref_accept_tolerance   number;
   begin

      -- Set preferences, if coming from APEX
      if p_app_session < 0 then
         l_pref_failure_tolerance  := 60;
         l_pref_accept_tolerance   := 100;
      else
         l_pref_failure_tolerance  :=
            nvl(
               apex_util.get_preference(
                  p_preference  => 'FAILURE_TOLERANCE',
                  p_user        => v('APP_USER')
               ),
               60
            );

         l_pref_accept_tolerance   :=
            nvl(
               apex_util.get_preference(
                  p_preference  => 'ACCEPTABLE_TOLERANCE',
                  p_user        => v('APP_USER')
               ),
               100
            );

      end if;
   -- prep the case statement for redwood colours
      case
         when p_pct_score <= l_pref_failure_tolerance then
            l_color      := '#c74634';
            l_color_rgb  := 'red';
      --l_color := '#ff0000';
      --l_color_rgb := 'red';

         when p_pct_score >= l_pref_accept_tolerance then
            l_color      := '#759c6c';
            l_color_rgb  := 'green';
      --l_color := '#66cc33';
      --l_color_rgb := 'green';

         when p_possible_score = 0 then
            l_color      := '#759c6c';
            l_color_rgb  := 'green';
      --l_color := '#66cc33';
      --l_color_rgb := 'green';

         else
            l_color      := '#e6ac58';
            l_color_rgb  := 'yellow';
      --l_color := '#FFCE00';
      --l_color_rgb := 'yellow';

      end case;

      if p_print = true then
         return l_color_rgb;
      else
         return l_color;
      end if;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_color;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ P A G E _ A T T R I B U T E _ I D
--------------------------------------------------------------------------------
-- Returns the ATTRIBUTE_ID associated to a given page
--------------------------------------------------------------------------------
   function get_page_attribute_id (
      p_page_id in number
   ) return varchar2 is
   begin

-- Locate and return the Attribute that matches the DISPLAY_PAGE_ID
      for x in (
         select attribute_id
           from sv_sec_attributes
          where display_page_id = p_page_id
            and active_flag like 'Y'
      ) loop
         return x.attribute_id;
      end loop;

-- No matching attribute defined; return NULL
      return null;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_page_attribute_id;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ H E L P _ C L A S S
--------------------------------------------------------------------------------
-- Gets the proper class for IR Reports based on the users role
--------------------------------------------------------------------------------
   function get_help_class (
      p_page_id in number
   ) return varchar2 is
   begin

-- If the user is an approver, then add more space
      if apex_util.current_user_in_group(p_group_name => 'SV_SERT_APPROVER') = true then
         if p_page_id in (
                   210, 220, 230, 235, 240, 245, 250, 255, 570, 705, 710, 715, 720, 725, 730, 735, 740, 745, 750, 755, 760,
                   765, 770, 775, 780, 785
                ) then
            return 'formRegionIRHelp1';
         else
            return 'formRegionIRHelp1';
         end if;
-- Else, just make room for the Submit All button
      else
         if p_page_id in (
                   210, 220, 230, 235, 240, 245, 250, 255, 570, 705, 710, 715, 720, 725, 730, 735, 740, 745, 750, 755, 760,
                   765, 770, 775, 780, 785
                ) then
            return 'formRegionIRHelp2';
         else
            return 'formRegionIRHelp3';
         end if;
      end if;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_help_class;

--------------------------------------------------------------------------------
-- PROCEDURE: P R E P A R E _ U R L
--------------------------------------------------------------------------------
-- Prepares the URL - can be called via Application Process from JavaScript
--------------------------------------------------------------------------------
   procedure prepare_url (
      p_url in varchar2
   ) is
      l_url varchar2(4000);
   begin
      l_url := apex_util.prepare_url(p_url);
      htp.prn(l_url);
   end prepare_url;

--------------------------------------------------------------------------------
-- PROCEDURE: C H E C K _ G T _ L T _ A T T  R _ V A L
--------------------------------------------------------------------------------
-- Ensures that no more than one value is inserted for a GT or LT rule
--------------------------------------------------------------------------------
   procedure check_gt_lt_attr_val (
      p_attribute_set_id  in  number,
      p_attribute_id      in  number,
      p_value             in  varchar2,
      p_result            in  varchar2
   ) is
      l_rule_type  varchar2(100);
      l_ok         boolean := true;
      l_count      number;
      l_number     number;
      l_msg        varchar2(100) := 'OK';
   begin

-- Get the rule type used
      select rule_type
        into l_rule_type
        from sv_sec_attributes
       where attribute_id = p_attribute_id;

      if l_rule_type in (
                'LESS_THAN', 'GREATER_THAN'
             ) then

  -- Determine how many existing rules exist for this specific attribute
         select count(*)
           into l_count
           from sv_sec_attribute_values
          where attribute_id = p_attribute_id
            and attribute_set_id = p_attribute_set_id;

         if l_count > 0 then
            l_ok   := false;
            l_msg  := 'FAIL';
         else
            begin
               l_number := to_number(p_value);
            exception
               when others then
                  l_ok   := false;
                  l_msg  := 'NOT_NUMBER';
            end;
         end if;

      end if;

      if l_ok = true then
         insert into sv_sec_attribute_values (
            attribute_set_id,
            attribute_id,
            value,
            result,
            active_flag
         ) values (
            p_attribute_set_id,
            p_attribute_id,
            p_value,
            p_result,
            'Y'
         );

         htp.prn(l_msg);
      else
         htp.prn(l_msg);
      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end check_gt_lt_attr_val;

--------------------------------------------------------------------------------
-- FUNCTION: I N T E R N A L _ A T T R
--------------------------------------------------------------------------------
-- Determines whether an Attribute is INTERNAL or not
--------------------------------------------------------------------------------
   function internal_attr (
      p_attribute_id in number default null
   ) return boolean is
      l_internal_flag varchar2(1);
   begin

-- User is creating a new attribute; return FALSE
      if p_attribute_id is null then
         return false;
      end if;

-- Get the internal flag for the attribute
      select internal_flag
        into l_internal_flag
        from sv_sec_attributes
       where attribute_id = p_attribute_id;

      if l_internal_flag = 'Y' then
         if apex_util.current_user_in_group(p_group_name => 'SV_SERT_SU') then
            return false;
         else
            return true;
         end if;
      else
         return false;
      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end internal_attr;

--------------------------------------------------------------------------------
-- FUNCTION: I N T E R N A L _ A T T R _ S E T
--------------------------------------------------------------------------------
-- Determines whether an Attribute Set is INTERNAL or not
--------------------------------------------------------------------------------
   function internal_attr_set (
      p_attribute_set_id in number default null
   ) return boolean is
   begin

-- User is creating a new attribute; return FALSE
      if p_attribute_set_id is null then
         return false;
      end if;
      if p_attribute_set_id < 0 then
         if apex_util.current_user_in_group(p_group_name => 'SV_SERT_SU') then
            return false;
         else
            return true;
         end if;

      else
         return false;
      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end internal_attr_set;

--------------------------------------------------------------------------------
-- PROCEDURE: R E D I R E C T _ W H E N _ S T A L E
--------------------------------------------------------------------------------
-- Redirect to Page 1 if the SCORE collection does not exist
--------------------------------------------------------------------------------
   procedure redirect_when_stale is
      l_count number;
   begin
      select count(*)
        into l_count
        from sv_sec_collection
       where app_user = v('APP_USER')
         and app_session = v('APP_SESSION')
         and app_id = v('G_APPLICATION_ID');

      if l_count = 0 then
         owa_util.redirect_url('f?p='
                               || v('APP_ID')
                               || ':1:'
                               || v('APP_SESSION'));

      end if;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end redirect_when_stale;

--------------------------------------------------------------------------------
-- PROCEDURE: L O G _ P A G E _ V I E W
--------------------------------------------------------------------------------
-- Logs the page view, if preference is enabled
--------------------------------------------------------------------------------
   procedure log_page_view is
   begin
      if apex_util.get_preference(
         p_preference  => 'LOG_PAGE_VIEWS',
         p_user        => v('G_WORKSPACE_ID')
                   || '.'
                   || v('APP_USER')
      ) = 'Y' then
         logger.log('Page '
                    || v('APP_PAGE_ID')
                    || ' Viewed');
      end if;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end log_page_view;

--------------------------------------------------------------------------------
-- PROCEDURE: G E T _ P R O G R E S S
--------------------------------------------------------------------------------
-- Provides updates to the status progress bar
--------------------------------------------------------------------------------
   procedure get_progress is
   begin

      -- Update the progress bar
      htp.prn('[{'
              || v('G_PROGRESS')
              || '}]');
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_progress;

--------------------------------------------------------------------------------
-- PROCEDURE: D I S P L A Y _ S U M M A R Y
--------------------------------------------------------------------------------
-- Displays a specific category score summary
--------------------------------------------------------------------------------
      function display_summary (
      p_banner_yn           in  varchar2 default 'N',
      p_attribute_set_id    in  number,
      p_application_id      in  number,
      p_classification_key  in  varchar2,
      p_print               in  boolean default false,
      p_app_user            in  varchar2 default v('APP_USER'),
      p_app_session         in  number default nv('APP_SESSION'),
      p_sert_app_id         in  varchar2 default v('APP_ID')
   ) return t_summary_tab
      pipelined
   is
      type summary_array is
         table of t_summary index by pls_integer;
      l_basic_card_arr        summary_array;
      l_basic_card            t_summary;
      l_attr_count            number;
      l_count                 number;
      l_collection_id         number;
      l_pct_score             number;
      l_fix_count             number;  
      l_score                 number := 0;
      l_possible_score        number := 0;
      l_total_score           number := 0;
      l_total_possible_score  number := 0;
      l_color                 varchar2(255);
      l_raw_style             varchar2(255);
      l_pending_style         varchar2(255);
      l_approved_style        varchar2(255);
      l_pending_count         number := 0;
      l_classification_name   varchar2(255);
      l_classification_id     number;
      l_color_rgb             apex_application_global.vc_arr2;
      l_pref_score_precision  number := 1;
      l_time_to_fix           varchar2(100);
      l_banner                boolean := upper(p_banner_yn) = 'Y';
   begin

      -- Get the Classification ID and Page Title
      select classification_id,
             classification_name || ' Summary'
        into l_classification_id,
             l_classification_name
        from sv_sec_classifications
       where classification_key = p_classification_key;

      -- Get the current collection ID
      l_collection_id :=
         sv_sec_util.get_collection_id(
            p_app_user        => p_app_user,
            p_app_session     => p_app_session,
            p_application_id  => p_application_id
         );

      -- get total count
      select count(*) cnt
        into l_total_score
        from sv_sec_collection_data cd,
             sv_sec_categories c,
             sv_sec_result_temp r
       where cd.result = r.result
         and r.app_session = p_app_session
         and r.app_user = p_app_user
         and cd.category_key = c.category_key
         and cd.collection_id = l_collection_id
         and c.classification_id = l_classification_id;

      -- get the total possible count
      select count(*) cnt
        into l_total_possible_score
        from sv_sec_collection_data cd,
             sv_sec_categories c
       where cd.category_key = c.category_key
         and cd.collection_id = l_collection_id
         and c.classification_id = l_classification_id;

      if l_banner = false then
         for rec in (
            select c.category_id,
                   c.category_name,
                   c.category_short_name,
                   c.category_key,
                   c.display_page
              from sv_sec_categories c
             where c.classification_id = l_classification_id
         ) loop

            -- Determine if there are any attributes for a given category
            select count(*)
              into l_attr_count
              from sv_sec_attribute_set_attrs asa,
                   sv_sec_attributes a
             where a.attribute_id = asa.attribute_id
               and a.category_id = rec.category_id
               and a.active_flag = 'Y'
               and asa.attribute_set_id = p_attribute_set_id;

            if l_attr_count > 0 then
               -- Calculate the Score for a Category
               select count(*) cnt
                 into l_score
                 from sv_sec_collection_data cd,
                      sv_sec_result_temp r
                where cd.result = r.result
                  and r.app_session = p_app_session
                  and r.app_user = p_app_user
                  and cd.category_key = rec.category_key
                  and cd.collection_id = l_collection_id;

               -- Calculate the Possible Score for a Category
               select count(*) cnt
                 into l_possible_score
                 from sv_sec_collection_data cd
                where cd.category_key = rec.category_key
                  and cd.collection_id = l_collection_id;

               -- Calculate the percentage score
               if l_possible_score != 0 then
                  l_pct_score := trunc(round(((l_score / l_possible_score) * 100), l_pref_score_precision));
                  l_fix_count :=  l_possible_score - l_score;
               else
                  l_pct_score := 101;
                  l_fix_count := -1;
               end if;

               -- Get the corresponding color
               l_color := get_color(
                  p_pct_score       => l_pct_score,
                  p_possible_score  => l_possible_score,
                  p_print           => true
               );

               case l_color
                  when 'red' then
                     l_basic_card.color := 'u-danger';
                  when 'yellow' then
                     l_basic_card.color := 'u-warning';
                  when 'green' then
                     l_basic_card.color := 'u-success';
               end case;

               if p_print = false then
                  l_basic_card.display_page    := rec.display_page;
                  l_basic_card.title           := substr(rec.category_name, instr(rec.category_name, ':', 1) + 1);
                  --
                  -- colours are defined by the pct_score but we 
                  -- want to provide the number left to FIX...
                  l_basic_card.initials :=
                     case 
                        when l_fix_count = -1 then null
                        when l_fix_count < 100 then l_fix_count
                        else '99+'
                     end;                                         
                     -- case
                     --    when l_pct_score > 100 then
                     --       null
                     --    else l_pct_score
                     -- end;
                  l_basic_card.text            :=
                     case
                        when l_possible_score = 0 then
                           'No '
                           || substr(rec.category_name, instr(rec.category_name, ':', 1) + 1)
                           || ' in this application'
                        else to_char(l_score, '999G999')
                             || ' out of '
                             || to_char(l_possible_score, '999G999')
                             || ' Possible Points'
                     end;

                  l_basic_card.subtext         := '<div class="a-Report-percentChart" style="background-color:#'
                                          ||
                     case
                        when l_possible_score = 0 then
                           'FCFCFC; border: none; box-shadow: none;'
                        else 'DBDBDB'
                     end
                                          || ';">'
                                          || '<div class="a-Report-percentChart-fill" style="width:'
                                          || l_pct_score
                                          || '%; background-color:#'
                                          ||
                     case
                        when l_possible_score = 0 then
                           'FFF'
                        else '999'
                     end
                                          || ';"></div>'
                                          || '</div>';

                  pipe row ( l_basic_card );
               else
                  -- Store the PLPDF data in a temp table
                  null;
               end if; --p_print = false
            end if; -- l_attr_count > 0
         end loop;
      else

         -- Calculate the percentage score
         if l_total_possible_score != 0 then
            l_pct_score := round(((l_total_score / l_total_possible_score) * 100), l_pref_score_precision);
            l_fix_count :=  l_total_possible_score - l_total_score;
         else
            l_pct_score := 100;
            l_fix_count :=  0;    
         end if;

         -- Calculate the total time to fix
         select nvl(round((sum(s.time_to_fix) / 60), 2), 0)
           into l_time_to_fix
           from sv_sec_attribute_set_attrs s,
                sv_sec_collection_data c,
                sv_sec_attributes a,
                sv_sec_categories cat
          where s.attribute_set_id = p_attribute_set_id
            and s.attribute_id = c.attribute_id
            and c.attribute_id = a.attribute_id
            and a.category_id = cat.category_id
            and cat.classification_id = l_classification_id
            and c.collection_id = l_collection_id
            and c.result not in (
                   'PASS', 'APPROVED', 'PENDING'
                );

         if p_print = false then

            -- Print the summary percentage and score type toggle controls
            l_color                 :=
               get_color(
                  p_pct_score       => l_pct_score,
                  p_possible_score  => l_total_possible_score,
                  p_print           => true
               );

            case l_color
               when 'red' then
                  l_basic_card.color := 'u-danger';
               when 'yellow' then
                  l_basic_card.color := 'u-warning';
               when 'green' then
                  l_basic_card.color := 'u-success';
            end case;

            l_basic_card.title      := to_char(l_total_score, '999G999')
                                  || ' out of '
                                  || to_char(l_total_possible_score, '999G999')
                                  || ' points';


            case
               when l_fix_count > 99 then
                  l_basic_card.initials := '99+';
               else
                  l_basic_card.initials := l_fix_count;
            end case;

            -- case
            --    when l_pct_score > 100 then
            --       l_basic_card.initials := 100;
            --    else
            --       l_basic_card.initials := floor(l_pct_score);
            -- end case;

            l_basic_card.text       := 'Approximate Time to Fix: '
                                 || l_time_to_fix
                                 || ' hours';
            l_basic_card.subtext    := null;
            pipe row ( l_basic_card );
         else
            -- PRINTING PLACEHOLDER
            null;
         end if;

      end if;
     -- l_banner = FALSE

   exception
      when no_data_found then
         logger.log('NO DATA');
      when others then
         sv_sec_error.raise_unanticipated;
   end display_summary;

--------------------------------------------------------------------------------
-- PROCEDURE: P R I N T _ N A M E
--------------------------------------------------------------------------------
--
--
-- Purpose         : Prints the name of an application, it's scores, and
--                   optionally records the scan execution (page or full)
-- HAS COMMITS     : NO
-- HAS ROLLBACKS   : NO
--
--
-- Comments  : this procedure has 2 functions
--    1: to return html text that displays approved/pending/raw scores as a
--       formatted table of html
--    2: to record the results via sv_sec_util.record_eval
--
-- refactoring:
--    rewrite to return a pipelined function. this may require to  seperate the record of the results
--    alternatively, return a delimited string of results, or json.
--    this will then allow us to present the data returned using standard
--    APEX report templates ( Cards, Badges, whatever) via a sql query
--
--    This function is called as part of Application Process 'Record Score'
--    when REQUEST in ('SCORE','PAGE_SCORE')
--    the printed html is captured, but not used.
--    Candidate for removal
-- 
-- Call Example :
--    only used in-app with p_record_score = TRUE !
---------------------------------------------------------------------

--------------------------------------------------------------------------------
   function print_name (
      p_application_id    in  number,
      p_attribute_set_id  in  number,
      p_record_score      in  boolean default false,
      p_app_user          in  varchar2 default v('APP_USER'),
      p_app_session       in  number default nv('APP_SESSION'),
      p_app_eval_id       in  number default null,
      p_scheduled_eval    in  varchar2 default 'N',
      p_evaluated_ws      in  number default v('G_WORKSPACE_ID')
   ) return varchar2 is
      l_color                 varchar2(255);
      l_result                varchar2(255) := v('P0_RESULT');
      l_raw_score             number;
      l_pending_score         number;
      l_approved_score        number;
      type l_score_t is
         table of number index by binary_integer;
      l_score_arr             l_score_t;
      l_total                 number := 0;
      l_total_pct             number := 0;
      l_collection_id         sv_sec_collection.collection_id%type;
      l_pct_score             number;
      l_possible_score        number := 0;
--      l_score                 number;
      l_html                  varchar2(4000);
      l_time_to_fix           number;
   begin
      l_html := 'success';

   -- Get the current collection ID
      l_collection_id   :=
         sv_sec_util.get_collection_id(
            p_app_user        => p_app_user,
            p_app_session     => p_app_session,
            p_application_id  => p_application_id
         );

   -- Get the value of Result
      l_result          := nvl(v('P0_RESULT'), 'Raw');

   -- Calculate the score totals
      select count(*)
        into l_score_arr(1)
        from sv_sec_collection_data cd
       where cd.collection_id = l_collection_id
         and cd.result in (
                'PASS', 'APPROVED'
             );

   -- PENDING Score
      select count(*)
        into l_score_arr(2)
        from sv_sec_collection_data cd
       where cd.collection_id = l_collection_id
         and cd.result in (
                'PASS', 'PENDING', 'APPROVED'
             );

   -- RAW Score
      select count(*)
        into l_score_arr(3)
        from sv_sec_collection_data cd
       where cd.collection_id = l_collection_id
         and cd.result = 'PASS';

   -- POSSIBLE Score
      select count(*)
        into l_possible_score
        from sv_sec_collection_data cd
       where cd.collection_id = l_collection_id;

   -- Calculate the Totals
      if l_possible_score = 0 then
         l_total_pct  := 0;
         l_total      := 0;

      else
         l_raw_score       := round((l_score_arr(3) /(l_possible_score)) * 100, 1);
         l_pending_score   := round((l_score_arr(2) /(l_possible_score)) * 100, 1);
         l_approved_score  := round((l_score_arr(1) /(l_possible_score)) * 100, 1);

      end if;

      if p_record_score = false then
      -- Print the application title and scores
         l_html := 'success';

      else
      -- Record the Evaluation
         if p_app_session < 0 or v('REQUEST') in (
                   'SCORE', 'PAGE_SCORE'
                ) then
            sv_sec_util.record_eval(
               p_application_id    => p_application_id,
               p_app_user          => p_app_user,
               p_approved_score    => nvl(l_approved_score, 0),
               p_pending_score     => nvl(l_pending_score, 0),
               p_raw_score         => nvl(l_raw_score, 0),
               p_attribute_set_id  => p_attribute_set_id,
               p_app_session       => p_app_session,
               p_app_eval_id       => p_app_eval_id,
               p_scheduled_eval    => p_scheduled_eval,
               p_evaluated_ws      => p_evaluated_ws
            );

         end if;
      end if;

   -- Return the HTML to the calling report
      return l_html;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end print_name;

--------------------------------------------------------------------------------
-- FUNCTION: D I S P L A Y _ C O L U M N
--------------------------------------------------------------------------------
-- Determines whether to display a column based on Attribute
--------------------------------------------------------------------------------
   function display_column (
      p_attribute_key in varchar2
   ) return boolean is
   begin
      for x in (
         select a.attribute_key
           from sv_sec_attribute_set_attrs asa,
                sv_sec_attributes a,
                sv_sec_attribute_sets s
          where asa.attribute_id = a.attribute_id
            and a.attribute_key = p_attribute_key
            and s.attribute_set_id = asa.attribute_set_id
            and s.attribute_set_id = nv('P0_ATTRIBUTE_SET_ID')
      ) loop
         return true;
      end loop;

      return false;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end display_column;

--------------------------------------------------------------------------------
-- PROCEDURE S A V E _ A P E X _ L I N K
--------------------------------------------------------------------------------
-- Records any edit of an APEX component
--------------------------------------------------------------------------------
   procedure save_apex_link (
      p_page_id         in  number,
      p_link            in  varchar2,
      p_rp              in  varchar2,
      p_component_name  in  varchar2,
      p_category        in  varchar2
   ) is
   begin
      insert into sv_sec_apex_links (
         app_user,
         application_id,
         clicked_on,
         page_id,
         link,
         rp,
         component_name,
         category
      ) values (
         v('APP_USER'),
         v('G_APPLICATION_ID'),
         sysdate,
         p_page_id,
         p_link,
         p_rp,
         p_component_name,
         p_category
      );

      htp.prn('[{"result":"OK"}]');
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end save_apex_link;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ A P E X _ S E S S I O N
--------------------------------------------------------------------------------
-- Returns the APEX session ID from the builder, if the user is evaluating
-- an application from the same workspace in which they are logged into
--------------------------------------------------------------------------------
   function get_apex_session return varchar2 is
      c        sys.owa_cookie.cookie;
      l_count  number;
   begin

-- Get the Workspace ID for the application being evaluated
      for x in (
         select workspace_id
           from apex_applications
          where application_id = v('G_APPLICATION_ID')
      ) loop
  -- If that Workspace ID matches the builder Workspace ID, then return the Builder Session ID
         if x.workspace_id = nv('G_WORKSPACE_ID') then
            return v('G_APEX_BUILDER_SESSION_ID');
         else
            return null;
         end if;
      end loop;

-- No current evaluation, so return a NULL
      return null;
   exception
      when no_data_found then
         return null;
   end get_apex_session;

--------------------------------------------------------------------------------
-- PROCEDURE: P R I N T _ A P E X _ S E S S I O N
--------------------------------------------------------------------------------
-- Prints the APEX session ID
--------------------------------------------------------------------------------
   procedure print_apex_session is
   begin
      htp.prn(
         '
<script type="text/javascript">
var gApexSession = "'
         || v('G_APEX_SESSION_ID')
         || '";
</script>'
      );
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end print_apex_session;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ A T T R _ S E T S
--------------------------------------------------------------------------------
-- Gets the source of the Attribute Set multi-select list
--------------------------------------------------------------------------------
   function get_attr_sets (
      p_attribute_id in number
   ) return varchar2 is
      l_attr_sets varchar2(4000);
   begin
      for x in (
         select attribute_set_id
           from sv_sec_attribute_set_attrs
          where attribute_id = p_attribute_id
      ) loop
         l_attr_sets := l_attr_sets
                        || x.attribute_set_id
                        || ':';
      end loop;

      return l_attr_sets;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_attr_sets;

--------------------------------------------------------------------------------
-- FUNCTION: I S _ D I S A B L E D
--------------------------------------------------------------------------------
-- Determines whether or not to disable items or buttons
--------------------------------------------------------------------------------
   function is_disabled (
      p_attribute_set_id  in  number,
      p_workspace_id      in  number default null
   ) return varchar2 is
   begin
-- Check to see if the user is a member of the SV_SERT_SU group and if so, return NULL
      if apex_util.current_user_in_group(p_group_name => 'SV_SERT_SU') then
         return null;
      else

  -- Check to see if this is for Shared Attribute Sets
         if p_workspace_id is not null then
            if p_workspace_id = nv('WORKSPACE_ID') then
               return null;
            else
               return 'DISABLED';
            end if;
         else
            if p_attribute_set_id < 0 then
               return 'DISABLED';
            else
               return null;
            end if;
         end if;
      end if;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end is_disabled;

--------------------------------------------------------------------------------
-- FUNCTION: L O G O
--------------------------------------------------------------------------------
-- Prints the logo
--------------------------------------------------------------------------------
   function logo return varchar2 is
   begin
      return null;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end logo;

--------------------------------------------------------------------------------
-- PROCEDURE: C O M P A T I B I L I T Y _ C H E C K
--------------------------------------------------------------------------------
-- Checks to ensure that the application and data schema are the same version
--------------------------------------------------------------------------------
   procedure compatibility_check (
      p_version in varchar
   ) is
   begin
      for x in (
         select *
           from apex_applications
          where application_id = v('APP_ID')
      ) loop
         if x.version != p_version then
            raise_application_error(
               -20000,
               'The version of the application ('
               || x.version
               || ') is not compatible with the version of the schema ('
               || p_version
               || ').  Please contact support.'
            );

         end if;
      end loop;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end compatibility_check;

--------------------------------------------------------------------------------
-- FUNCTION: C O P Y R I G H T
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
   function copyright return varchar2 is
      l_copyright varchar2(255);
   begin
      select 'SERT - Licensed via <a target="_blank" href="http://opensource.org/licenses/lgpl-3.0.html">LGPL3</a> '
             || '| <a target="_blank" href="https://github.com/OraOpenSource/apexsert">Download</a> | Version '
             || v('G_VERSION_DISP')
        into l_copyright
        from apex_applications
       where application_id = nv('APP_ID');

      return l_copyright;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end copyright;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ C O M P O N E N T
--------------------------------------------------------------------------------
-- Returns the corresponding component name for a given exception
--------------------------------------------------------------------------------

   function get_component (
      p_component_id  in  number default null,
      p_attribute_id  in  number default null
   ) return varchar2 is
      l_sql      varchar2(1000);
      l_display  varchar2(1000);
   begin
      if p_component_id is not null and p_attribute_id is not null then
         for x in (
            select *
              from sv_sec_attributes
             where attribute_id = p_attribute_id
         ) loop
            l_sql := 'SELECT '
                     || x.component_column_display
                     || ' FROM '
                     || x.component_table
                     || ' WHERE '
                     || x.component_column_id
                     || ' = '
                     || p_component_id;

            if x.component_column_display is not null and x.component_table is not null and x.component_column_id is not
            null then
               execute immediate l_sql
                 into l_display;
            end if;

         end loop;
      end if;

      return l_display;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_component;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ C O L U M N
--------------------------------------------------------------------------------
-- Returns the corresponding component name for a given exception
--------------------------------------------------------------------------------

   function get_column (
      p_column_id     in  number default null,
      p_attribute_id  in  number default null
   ) return varchar2 is
      l_sql      varchar2(1000);
      l_display  varchar2(1000);
   begin
      if p_column_id is not null and p_attribute_id is not null then
         for x in (
            select *
              from sv_sec_attributes
             where attribute_id = p_attribute_id
         ) loop
            l_sql := 'SELECT '
                     || x.column_column_display
                     || ' FROM '
                     || x.column_table
                     || ' WHERE '
                     || x.column_column_id
                     || ' = '
                     || p_column_id;

            if x.column_column_display is not null and x.column_table is not null and x.column_column_id is not null then
               execute immediate l_sql
                 into l_display;
            end if;

         end loop;
      end if;

      return l_display;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_column;

--------------------------------------------------------------------------------
-- PROCEDURE: A D D _ A T T R I B U T E S
--------------------------------------------------------------------------------
-- Adds an attribute(s) to a specific Attribute Set
--------------------------------------------------------------------------------
   procedure add_attributes (
      p_attribute_set_id in number
   ) is
   begin

-- Loop through all selected attributes and add them to the selected attribute set
      for x in 1..apex_application.g_f01.count loop
         for y in (
            select *
              from sv_sec_attributes
             where attribute_id = apex_application.g_f01(x)
         ) loop
            insert into sv_sec_attribute_set_attrs (
               attribute_set_id,
               attribute_id,
               active_flag,
               time_to_fix,
               severity_level
            ) values (
               p_attribute_set_id,
               apex_application.g_f01(x),
               'Y',
               y.time_to_fix,
               y.severity_level
            );

         end loop;

  -- Add attribute values from the DEFAULT attribute set
         if p_attribute_set_id > 0 then
            for y in (
               select *
                 from sv_sec_attribute_values
                where attribute_id = apex_application.g_f01(x)
                  and attribute_set_id = - 1
            ) loop
               insert into sv_sec_attribute_values (
                  attribute_id,
                  active_flag,
                  value,
                  result,
                  attribute_set_id
               ) values (
                  apex_application.g_f01(x),
                  y.active_flag,
                  y.value,
                  y.result,
                  p_attribute_set_id
               );

            end loop;

         end if;

      end loop;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end add_attributes;

--------------------------------------------------------------------------------
-- PROCEDURE: R E M O V E _ A T T R I B U T E
--------------------------------------------------------------------------------
-- Removes an attribute from a specific Attribute Set
--------------------------------------------------------------------------------
   procedure remove_attribute (
      p_attribute_set_attrs_id in number
   ) is
      l_attribute_id      sv_sec_attribute_set_attrs.attribute_id%type;
      l_attribute_set_id  sv_sec_attribute_set_attrs.attribute_set_id%type;
   begin

-- Get the ATTRIBUTE_ID and ATTRIBUTE_SET_ID
      select attribute_id,
             attribute_set_id
        into l_attribute_id,
             l_attribute_set_id
        from sv_sec_attribute_set_attrs
       where attribute_set_attrs_id = p_attribute_set_attrs_id;
     --apex_application.g_x01;

-- Remove the attribute
      delete from sv_sec_attribute_set_attrs
       where attribute_set_attrs_id = p_attribute_set_attrs_id;
     --apex_application.g_x01;

-- Remove the corresponding Attribute Values
      delete from sv_sec_attribute_values
       where attribute_id = l_attribute_id
         and attribute_set_id = l_attribute_set_id;

-- Return OK
--htp.prn('OK');

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end remove_attribute;

--------------------------------------------------------------------------------
-- PROCEDURE: S A V E _ R U L E _ T Y P E
--------------------------------------------------------------------------------
-- Asynchronously Sets Attribute Values to Enabled or Disabled
--------------------------------------------------------------------------------
   procedure toggle_attr_vals (
      p_attribute_id  in  number,
      p_value         in  varchar2
   ) is
   begin
      update sv_sec_attribute_values
         set active_flag = p_value
       where attribute_id = p_attribute_id;

      htp.prn('OK');
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end toggle_attr_vals;

--------------------------------------------------------------------------------
-- FUNCTION: I N T _ A T T R
--------------------------------------------------------------------------------
-- Determines whether or not an attribute is internal
--------------------------------------------------------------------------------
   function int_attr (
      p_attribute_id in number
   ) return varchar2 is
      l_internal_flag sv_sec_attributes.internal_flag%type;
   begin

-- If creating an attribute or the user is a superuser, then return NULL
      if p_attribute_id is null or apex_util.current_user_in_group(p_group_name => 'SV_SERT_SU') then
         return null;
      else

  -- Otherwise, determine if the attribute is internal, and return the corresponding value
         select internal_flag
           into l_internal_flag
           from sv_sec_attributes
          where attribute_id = p_attribute_id;

         if l_internal_flag = 'Y' then
            return 'disabled';
         else
            return null;
         end if;
      end if;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end int_attr;

--------------------------------------------------------------------------------
-- FUNCTION: I N T _ C A T E G O R Y
--------------------------------------------------------------------------------
-- Determines whether or not a category is internal
--------------------------------------------------------------------------------
   function int_category (
      p_category_id in number
   ) return varchar2 is
      l_internal_flag sv_sec_categories.internal_flag%type;
   begin

-- If creating an attribute or the user is a superuser, then return NULL
      if p_category_id is null or apex_util.current_user_in_group(p_group_name => 'SV_SERT_SU') then
         return null;
      else

  -- Otherwise, determine if the attribute is internal, and return the corresponding value
         select internal_flag
           into l_internal_flag
           from sv_sec_categories
          where category_id = p_category_id;

         if l_internal_flag = 'Y' then
            return 'disabled';
         else
            return null;
         end if;
      end if;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end int_category;

--------------------------------------------------------------------------------
-- FUNCTION: GT_LT_VALUE
--------------------------------------------------------------------------------
-- Validates number of values for GT or LT Attribute
--------------------------------------------------------------------------------
   function gt_lt_value (
      p_attribute_id      in  number,
      p_attribute_set_id  in  number
   ) return boolean is
      l_count integer;
   begin
      for x in (
         select *
           from sv_sec_attributes
          where attribute_id = p_attribute_id
      ) loop
         if x.rule_type not in (
                   'LESS_THAN', 'GREATER_THAN'
                ) then
            return true;
         else
            select count(*)
              into l_count
              from sv_sec_attribute_values
             where attribute_id = p_attribute_id
               and attribute_set_id = p_attribute_set_id;

            if l_count > 1 then
               return false;
            else
               return true;
            end if;
         end if;
      end loop;

      return false;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end gt_lt_value;

--------------------------------------------------------------------------------
-- PROCEDURE: C O P Y _ I N L I N E  _ A T T R S
--------------------------------------------------------------------------------
-- Copies the Inline Attributes to a new Attribute Set
--------------------------------------------------------------------------------
   procedure copy_inline_attrs (
      p_copy_to in number
   ) is
   begin
-- Copy the attributes
      for x in (
         select sa.attribute_id
           from sv_sec_attribute_set_attrs sa,
                sv_sec_attributes a
          where sa.attribute_set_id = - 1
            and sa.attribute_id = a.attribute_id
            and a.category_id = - 1
      ) loop
         insert into sv_sec_attribute_set_attrs (
            attribute_id,
            attribute_set_id,
            active_flag
         ) values (
            x.attribute_id,
            p_copy_to,
            'Y'
         );

  -- Copy the attribute values
         for y in (
            select *
              from sv_sec_attribute_values
             where attribute_set_id = - 1
               and attribute_id = x.attribute_id
         ) loop
            insert into sv_sec_attribute_values (
               attribute_id,
               active_flag,
               value,
               result,
               attribute_set_id
            ) values (
               x.attribute_id,
               y.active_flag,
               y.value,
               y.result,
               p_copy_to
            );

         end loop;

      end loop;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end copy_inline_attrs;

--------------------------------------------------------------------------------
-- PROCEDURE: C O P Y _ A T T R _ S E T
--------------------------------------------------------------------------------
-- Copies an existing Attribute Set to a new one
--------------------------------------------------------------------------------
   procedure copy_attr_set (
      p_copy_from  in  number,
      p_copy_to    in  number
   ) is
   begin

-- Copy the attributes
      for x in (
         select sa.attribute_id,
                sa.time_to_fix,
                sa.severity_level
           from sv_sec_attribute_set_attrs sa,
                sv_sec_attributes a
          where sa.attribute_set_id = p_copy_from
            and sa.attribute_id = a.attribute_id
            and a.category_id > 0
      ) loop
         insert into sv_sec_attribute_set_attrs (
            attribute_id,
            attribute_set_id,
            active_flag,
            time_to_fix,
            severity_level
         ) values (
            x.attribute_id,
            p_copy_to,
            'Y',
            x.time_to_fix,
            x.severity_level
         );

  -- Copy the attribute values
         for y in (
            select *
              from sv_sec_attribute_values
             where attribute_set_id = p_copy_from
               and attribute_id = x.attribute_id
         ) loop
            insert into sv_sec_attribute_values (
               attribute_id,
               active_flag,
               value,
               result,
               attribute_set_id
            ) values (
               x.attribute_id,
               y.active_flag,
               y.value,
               y.result,
               p_copy_to
            );

         end loop;

      end loop;

-- Copy the Inline Attributes from the Default Set
      copy_inline_attrs(p_copy_to => p_copy_to);
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end copy_attr_set;

--------------------------------------------------------------------------------
-- PROCEDURE: C O P Y _ A T T R I B U T E
--------------------------------------------------------------------------------
   procedure copy_attribute (
      p_attribute_id      in  number,
      p_attribute_set_id  in  number default null,
      p_attribute_sets    in  varchar2 default null,
      p_attribute_name    in  varchar2,
      p_attribute_key     in  varchar2
   ) is
      l_attr           sv_sec_attributes%rowtype;
      l_attr_set_attr  sv_sec_attribute_set_attrs%rowtype;
      l_attribute_id   number;
      l_attr_set_arr   apex_application_global.vc_arr2;
   begin

-- Get the PK
      select sv_sec_attributes_seq.nextval
        into l_attribute_id
        from dual;

-- Get the row to be copied
      select *
        into l_attr
        from sv_sec_attributes
       where attribute_id = p_attribute_id;

-- Convert the To Attribute Set ID to an Array
      l_attr_set_arr := apex_util.string_to_table(p_attribute_sets);

-- Copy the attribute
      insert into sv_sec_attributes (
         attribute_id,
         category_id,
         attribute_name,
         attribute_key,
         active_flag,
         rule_source,
         table_name,
         column_name,
         view_name,
         score_collection_id,
         rule_plsql,
         rule_type,
         info,
         fix,
         when_not_found,
         seq,
         internal_flag,
         help_page,
         impact,
         col_template_id,
         display_page_id,
         summary_page_id,
         component_table,
         component_column_id,
         component_column_display,
         column_table,
         column_column_id,
         column_column_display,
         component_sig_id,
         time_to_fix,
         severity_level
      ) values (
         l_attribute_id,
         l_attr.category_id,
         p_attribute_name,
         p_attribute_key,
         l_attr.active_flag,
         l_attr.rule_source,
         l_attr.table_name,
         l_attr.column_name,
         l_attr.view_name,
         l_attr.score_collection_id,
         l_attr.rule_plsql,
         l_attr.rule_type,
         l_attr.info,
         l_attr.fix,
         l_attr.when_not_found,
         l_attr.seq,
         'N',
         l_attr.help_page,
         l_attr.impact,
         l_attr.col_template_id,
         l_attr.display_page_id,
         l_attr.summary_page_id,
         l_attr.component_table,
         l_attr.component_column_id,
         l_attr.component_column_display,
         l_attr.column_table,
         l_attr.column_column_id,
         l_attr.column_column_display,
         l_attr.component_sig_id,
         l_attr.time_to_fix,
         l_attr.severity_level
      );

      for z in 1..l_attr_set_arr.count loop

  -- Add new Attribute to the Attribute Set
         insert into sv_sec_attribute_set_attrs (
            attribute_set_id,
            attribute_id,
            active_flag,
            time_to_fix,
            severity_level
         ) values (
            l_attr_set_arr(z),
            l_attribute_id,
            'Y',
            l_attr.time_to_fix,
            l_attr.severity_level
         );

  -- Loop through each Target Attribute Set
         if p_attribute_set_id is not null then
            for x in (
               select *
                 from sv_sec_attribute_values
                where attribute_id = p_attribute_id
                  and attribute_set_id = p_attribute_set_id
            ) loop

      -- Create the new Attribute Values
               insert into sv_sec_attribute_values (
                  attribute_id,
                  value,
                  result,
                  attribute_set_id,
                  active_flag
               ) values (
                  l_attribute_id,
                  x.value,
                  x.result,
                  l_attr_set_arr(z),
                  'Y'
               );

            end loop;

         end if;

      end loop;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end copy_attribute;

--------------------------------------------------------------------------------
-- PROCEDURE: M A N A G E _ A T T R _ S E T _ M A P P I N G
--------------------------------------------------------------------------------
-- Manage Mapping of Attributes to Attribute Sets
--------------------------------------------------------------------------------

   procedure manage_attr_set_mapping (
      p_attribute_id  in  number,
      p_rule_type     in  varchar2,
      p_attr_sets     in  varchar2,
      p_val           in  number default null
   ) is
      l_attr_sets apex_application_global.vc_arr2;
   begin

-- Process Attribute Set Mappings
      delete from sv_sec_attribute_set_attrs
       where attribute_id = p_attribute_id;

      l_attr_sets := apex_util.string_to_table(p_attr_sets);
      for x in 1..l_attr_sets.count loop
         insert into sv_sec_attribute_set_attrs (
            attribute_id,
            attribute_set_id,
            active_flag
         ) values (
            p_attribute_id,
            l_attr_sets(x),
            'Y'
         );

  -- If a value was provided for a GT or LT rule, add that value here
         if p_rule_type in (
                      'LESS_THAN', 'GREATER_THAN'
                   ) and p_val is not null then
            insert into sv_sec_attribute_values (
               attribute_set_id,
               attribute_id,
               value,
               result
            ) values (
               l_attr_sets(x),
               p_attribute_id,
               p_val,
               'PASS'
            );

         end if;

      end loop;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end manage_attr_set_mapping;

--------------------------------------------------------------------------------
-- PROCEDURE: S H O W _ I N F O
--------------------------------------------------------------------------------
-- Source for the Info popup window
--------------------------------------------------------------------------------
   procedure show_info (
      p_attribute_id in number
   ) is
      l_info       varchar2(4000);
      l_label      varchar2(4000);
      l_info_link  varchar2(4000);
      l_url        varchar2(4000);
   begin

-- Get the Help URL
      select snippet
        into l_url
        from sv_sec_snippets
       where snippet_key = 'HELP_URL';

-- Search for any info associated with attribute
      for x in (
         select *
           from sv_sec_attributes
          where attribute_id = p_attribute_id
      ) loop
         l_info   := x.info;
         l_label  := x.attribute_name;
         if x.help_page is not null then
            l_info_link := '<div style="text-align:right;padding-top:5px;border-top:1px solid #aaa;">'
                           || '<a href="'
                           || l_url
                           || x.help_page
                           || '" target="_blank">View Related Oracle Help</a></div>';
         end if;

      end loop;

-- Open the JSON document
      apex_json.open_array;
      apex_json.open_object;
      if l_info is not null then
  -- Print the info
         apex_json.write('label', l_label);
         apex_json.write('info', l_info || l_info_link);
      else
  -- No info found; print corresponding icon and message
         apex_json.write('label', 'Not Found');
         apex_json.write('info', 'There is no information defined for this attribute');
      end if;

-- Close the JSON document
      apex_json.close_object;
      apex_json.close_array;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end show_info;

--------------------------------------------------------------------------------
-- PROCEDURE: S H O W _ F I X
--------------------------------------------------------------------------------
-- Source for the Fix popup window
--------------------------------------------------------------------------------
   procedure show_fix (
      p_attribute_id        in  number default null,
      p_attribute_value_id  in  number default null
   ) is
      l_fix        clob;
      l_label      varchar2(1000);
      l_rule_type  sv_sec_attributes.rule_type%type;
   begin

-- Needed to make bold text the same size as non-bold text
--htp.prn('<style type="text/css">strong {font-size:12px;} li strong{font-size: 11px;}</style>');

-- First, check if the rule is NOT NULL, GREATER or LESS THAN
      for x in (
         select *
           from sv_sec_attributes
          where attribute_id = p_attribute_id
      ) loop
         l_rule_type  := x.rule_type;
         l_label      := x.attribute_name;
      end loop;

--IF l_rule_type IN ('NOT_NULL', 'LESS_THAN', 'GREATER_THAN') THEN

  -- Use the fix at the attribute level
      select fix
        into l_fix
        from sv_sec_attributes
       where attribute_id = p_attribute_id;

-- Revert to the fix embedded in the attribute, if no fix is found
      if l_fix is null then
  -- For attributes
         if p_attribute_id is not null then
            for x in (
               select fix,
                      attribute_name
                 from sv_sec_attributes a
                where a.attribute_id = p_attribute_id
            ) loop
               l_fix    := x.fix;
               l_label  := x.attribute_name;
            end loop;
  -- For attribute values
         else
            for x in (
               select fix,
                      attribute_name
                 from sv_sec_attributes a
                where a.attribute_id = (
                  select attribute_id
                    from sv_sec_attribute_values
                   where attribute_value_id = p_attribute_value_id
               )
            ) loop
               l_fix    := x.fix;
               l_label  := x.attribute_name;
            end loop;
         end if;
      end if;

      if l_fix is null then
         l_label  := 'Not Found';
         l_fix    := 'There is no fix defined for this attribute';
      end if;

-- Print the fix
      apex_json.open_array;
      apex_json.open_object;
      apex_json.write('label', l_label);
      apex_json.write('info', l_fix);
      apex_json.close_object;
      apex_json.close_array;
   exception
      when no_data_found then
  -- No fix found; print corresponding icon and message
         apex_json.open_array;
         apex_json.open_object;
         apex_json.write('label', 'Not Found');
         apex_json.write('info', 'There is no fix defined for this attribute');
         apex_json.close_object;
         apex_json.close_array;
      when others then
         sv_sec_error.raise_unanticipated;
   end show_fix;

--------------------------------------------------------------------------------
-- PROCEDURE: V I E W _ S O U R C E
--------------------------------------------------------------------------------
-- Source source in a popup window
--------------------------------------------------------------------------------
   procedure view_source (
      p_id              in  number default null,
      p_component_type  in  varchar2 default null
   ) is
      l_title   varchar2(4000);
      l_source  clob;
      l_legend  varchar2(32767);
      l_count   number;

  --TEXT    VARCHAR2(32767) := '#ITEM #APP_ID. #ITEM2. #DOUG. #SESSION.';
      x         number;
      v_start   number := 1;
      v_end     number;
   begin
      l_legend := '
  <div>
   <table>
    <tr><td colspan="3" style="padding-bottom:10px;"><b>Legend</b></td></tr>
    <tr>
     <td style="color:red;padding-right:20px;font-weight:bold;">&ITEM. Syntax</td>
     <td style="color:blue;padding-right:20px;font-weight:bold;">EXECUTE IMMEDIATE</td>
     <td style="color:green;padding-right:20px;font-weight:bold;">Dynamic SQL</td></tr>
   </table>
  </div>';
      case
  -- Report and Interactive Report, PLSQL Regions, Calendars, Regions
         when p_component_type in (
                   'REPORT', 'PLSQL', 'CALENDAR', 'REGION', 'REGION_XSS'
                ) then
            select 'Page '
                   || page_id
                   || ' : '
                   || region_name,
                   region_source
              into l_title,
                   l_source
              from apex_application_page_regions
             where region_id = p_id;

  -- Page Process
         when p_component_type in (
                   'PAGE_PROCESS', 'PAGE_PROCESS_XSS'
                ) then
            select 'Page '
                   || page_id
                   || ' : '
                   || process_name,
                   process_source
              into l_title,
                   l_source
              from apex_application_page_proc
             where process_id = p_id;

  -- Application Process
         when p_component_type = 'APP_PROCESS' then
            select 'Application Process: ' || process_name,
                   process
              into l_title,
                   l_source
              from apex_application_processes
             where application_process_id = p_id;

  -- Page Computations
         when p_component_type = 'PAGE_COMPUTATION' then
            select 'Page '
                   || page_id
                   || ' : '
                   || item_name,
                   computation
              into l_title,
                   l_source
              from apex_application_page_comp
             where computation_id = p_id;

  -- Application Computations
         when p_component_type = 'APP_COMPUTATION' then
            select 'Application Computation: ' || computation_item,
                   computation
              into l_title,
                   l_source
              from apex_application_computations
             where application_computation_id = p_id;

  -- Validations
         when p_component_type = 'VALIDATION' then
            select 'Page '
                   || page_id
                   || ' : '
                   || validation_name,
                   validation_expression1
              into l_title,
                   l_source
              from apex_application_page_val
             where validation_id = p_id;

  -- Branches
         when p_component_type = 'BRANCH' then
            select 'Page '
                   || page_id
                   || ' : '
                   || branch_type,
                   branch_action
              into l_title,
                   l_source
              from apex_application_page_branches
             where branch_id = p_id;

  -- Charts and Maps
  -- apex_application_page_flash_s no longer exists in 21.1.
--         when p_component_type = 'FLASH' then
--            select 'Page ' || page_id || ' : ' || region_name || ' : ' || series_name,
--                   q
--              into
--               l_title,
--               l_source
--              from (
--               select series_query q,
--                      region_id,
--                      series_id,
--                      page_id,
--                      region_name,
--                      series_name
--                 from apex_application_page_flash5_s
--  --    UNION ALL
--  --    SELECT series_query q, region_id, series_id, page_id, region_name, series_name
--  --      FROM apex_application_page_flash_s
--            )
--             where series_id = p_id;

  -- Trees
         when p_component_type = 'TREE' then
            select 'Page '
                   || page_id
                   || ' : '
                   || region_name,
                   tree_query
              into l_title,
                   l_source
              from apex_application_page_trees
             where region_id = p_id;

  -- Dynamic Actions
         when p_component_type = 'DYNAMIC_ACTION' then
            select 'Page '
                   || page_id
                   || ' : '
                   || dynamic_action_name,
                   attribute_01
              into l_title,
                   l_source
              from apex_application_page_da_acts
             where action_id = p_id;

  -- Plugins
         when p_component_type = 'PLUGIN' then
            select display_name,
                   plsql_code
              into l_title,
                   l_source
              from apex_appl_plugins
             where plugin_id = p_id;

  -- Authorization Scheme
         when p_component_type = 'AUTHORIZATION_SCHEME' then
            select authorization_scheme_name,
                   attribute_01
              into l_title,
                   l_source
              from apex_application_authorization
             where authorization_scheme_id = p_id;
  -- FACET_LOVs
         when p_component_type = 'FACET_LOV' then
            select 'Page '
                   || page_id
                   || ' : '
                   || item_name,
                   lov_definition
              into l_title,
                   l_source
              from apex_appl_page_facets
             where item_id = p_id;

  -- Item LOVs
         when p_component_type = 'ITEM_LOV' then
            select 'Page '
                   || page_id
                   || ' : '
                   || item_name,
                   lov_definition
              into l_title,
                   l_source
              from apex_application_page_items
             where item_id = p_id;

         when p_component_type = 'ITEM_SOURCE' then
            select 'Page '
                   || page_id
                   || ' : '
                   || item_name,
                   item_source
              into l_title,
                   l_source
              from apex_application_page_items
             where item_id = p_id;

         when p_component_type = 'ITEM_DEFAULT' then
            select 'Page '
                   || page_id
                   || ' : '
                   || item_name,
                   item_default
              into l_title,
                   l_source
              from apex_application_page_items
             where item_id = p_id;

         when p_component_type = 'LIST' then
            select list_name,
                   list_query
              into l_title,
                   l_source
              from apex_application_lists
             where list_id = p_id;

  -- Shared LOVs
         when p_component_type = 'SHARED_LOV' then
            select list_of_values_name,
                   list_of_values_query
              into l_title,
                   l_source
              from apex_application_lovs
             where lov_id = p_id;

  -- Page Headers: JS Onload
         when p_component_type like 'PAGE_HEADER_JS_ONLOAD' then
            select 'Page '
                   || page_id
                   || ' : '
                   || page_name
                   || ' : onLoad',
                   javascript_code_onload
              into l_title,
                   l_source
              from apex_application_pages
             where page_id = p_id
               and application_id = nv('G_APPLICATION_ID');

  -- Page Headers: JS and Globals
         when p_component_type like 'PAGE_HEADER_PAGE_HTML_HEAD' then
            select 'Page '
                   || page_id
                   || ' : '
                   || page_name
                   || ' : Page HTML Header',
                   page_html_header
              into l_title,
                   l_source
              from apex_application_pages
             where page_id = p_id
               and application_id = nv('G_APPLICATION_ID');

  -- Page Headers: JS and Globals
         when p_component_type like 'PAGE_HEADER_JS_GLOBALS' then
            select 'Page '
                   || page_id
                   || ' : '
                   || page_name
                   || ' : JS & Globals',
                   javascript_code
              into l_title,
                   l_source
              from apex_application_pages
             where page_id = p_id
               and application_id = nv('G_APPLICATION_ID');

  -- Page Headers: HTML Body
         when p_component_type like 'PAGE_HEADER_HTML_BODY' then
            select 'Page '
                   || page_id
                   || ' : '
                   || page_name
                   || ' : HTML Body',
                   page_html_onload
              into l_title,
                   l_source
              from apex_application_pages
             where page_id = p_id
               and application_id = nv('G_APPLICATION_ID');

  -- Page Headers: Header Text
         when p_component_type like 'PAGE_HEADER_HEADER_TEXT' then
            select 'Page '
                   || page_id
                   || ' : '
                   || page_name
                   || ' : Header Text',
                   header_text
              into l_title,
                   l_source
              from apex_application_pages
             where page_id = p_id
               and application_id = nv('G_APPLICATION_ID');

  -- Page Headers: Footer Text
         when p_component_type like 'PAGE_HEADER_FOOTER_TEXT' then
            select 'Page '
                   || page_id
                   || ' : '
                   || page_name
                   || ' : Footer Text',
                   footer_text
              into l_title,
                   l_source
              from apex_application_pages
             where page_id = p_id
               and application_id = nv('G_APPLICATION_ID');
      end case;

-- SQLi Checks
      if p_component_type not in (
                   'REGION', 'REGION_XSS', 'PAGE_PROCESS_XSS'
                ) and p_component_type not like 'PAGE_HEADER%' then
  -- EXECUTE IMMEDIATE
         l_source  :=
            regexp_replace(
               l_source,
               '(execute+[ ]+immediate)',
               '~OPEN_EXEC~\1~CLOSE~',
               1,
               0,
               'i'
            );

  -- DBMS_SQL
         l_source  :=
            regexp_replace(
               l_source,
               '(DBMS_SQL)',
               '~OPEN_DBMS~\1~CLOSE~',
               1,
               0,
               'i'
            );

  -- ITEM Syntax
         x         :=
            regexp_instr(
               l_source,
               '(&([0-9a-zA-Z_$]+)(\.))',
               v_start,
               1,
               0,
               'i'
            );
         while ( x != 0 ) loop
            if ( regexp_substr(
                    l_source,
                    '(&([0-9a-zA-Z_$]+)(\.))',
                    v_start,
                    1,
                    'i'
                 ) not in (
                      '&APP_ID.', '&FLOW_ID.', '&APP_PAGE_ID.', '&APP_USER.', '&DEBUG.', '&APP_SECURITY_GROUP_ID.', '&SESSION.',
                      '&APP_SESSION.', '&APP_ALIAS.', '&FLOW_PAGE_ID.'
                   ) ) then
               l_source :=
                  regexp_replace(
                     l_source,
                     '(&([0-9a-zA-Z_$]+)(\.))',
                     '~OPEN~\1~CLOSE~',
                     v_start,
                     1,
                     'i'
                  );
            end if;

    -- PREP FOR THE NEXT ITTERATION OF THE LOOP
            v_start  := regexp_instr(
               l_source,
               '(&([0-9a-zA-Z_$]+)(\.))',
               v_start,
               1,
               1,
               'i'
            ) + 1;

            x        :=
               regexp_instr(
                  l_source,
                  '(&([0-9a-zA-Z_$]+)(\.))',
                  v_start,
                  1,
                  0,
                  'i'
               );
         end loop;

      else

-- XSS Checks
  -- Remove all page items from item_source
         for z in (
            select item_name
              from apex_application_page_items
             where application_id = nv('G_APPLICATION_ID')
         ) loop
            l_source := replace(l_source, '&'
                                          || z.item_name
                                          || '.', '<<<!'
                                                  || z.item_name
                                                  || '!>>>');
         end loop;

  -- Check each instance &ITEM. in the source
         x :=
            regexp_instr(
               l_source,
               '(&([0-9a-zA-Z_$]+)(\.))',
               v_start,
               1,
               0,
               'i'
            );
         while ( x != 0 ) loop
            if ( regexp_substr(
                    l_source,
                    '(&([0-9a-zA-Z_$]+)(\.))',
                    v_start,
                    1,
                    'i'
                 ) not in (
                      '&APP_ID.', '&FLOW_ID.', '&APP_PAGE_ID.', '&APP_USER.', '&DEBUG.', '&APP_SECURITY_GROUP_ID.', '&SESSION.',
                      '&APP_SESSION.', '&APP_ALIAS.', '&FLOW_PAGE_ID.'
                   ) ) then
      -- Add the tags that will highlight failures
               l_source :=
                  regexp_replace(
                     l_source,
                     '(&([0-9a-zA-Z_$]+)(\.))',
                     '~OPEN~\1~CLOSE~',
                     v_start,
                     1,
                     'i'
                  );
            end if;

    -- PREP FOR THE NEXT ITTERATION OF THE LOOP
            v_start  := regexp_instr(
               l_source,
               '(&([0-9a-zA-Z_$]+)(\.))',
               v_start,
               1,
               1,
               'i'
            ) + 1;

            x        :=
               regexp_instr(
                  l_source,
                  '(&([0-9a-zA-Z_$]+)(\.))',
                  v_start,
                  1,
                  0,
                  'i'
               );
         end loop;

      end if;

-- htp.p Checks
      if p_component_type in (
                'REGION', 'REGION_XSS', 'PAGE_PROCESS', 'PAGE_PROCESS_XSS'
             ) then
  -- Loop through all potentially dangerous HTP calls
         for x in (
            select *
              from sv_sec_htp_procs
             where active_flag = 'Y'
             order by htp_proc_id
         ) loop
            l_source :=
               regexp_replace(
                  l_source,
                  '('
                  || x.htp_proc
                  || ')',
                  '~OPEN_HTP~\1~CLOSE~',
                  1,
                  0,
                  'i'
               );
         end loop;
      end if;

-- Print the results
      apex_json.open_array;
      apex_json.open_object;
      apex_json.write('title', l_title);
      if length(l_source) > 0 then
  -- Put back the & and .
         l_source  := replace(l_source, '<<<!', '&');
         l_source  := replace(l_source, '!>>>', '.');

  -- Escape the contents of the source
         l_source  := htf.escape_sc(l_source);

  -- Add highlighting based on the condition found
         l_source  := replace(l_source, '~OPEN~', '<span style="background-color:yellow;font-family:Courier;">');
         l_source  := replace(l_source, '~OPEN_EXEC~', '<span style="background-color:pink;font-family:Courier;">');
         l_source  := replace(l_source, '~OPEN_DBMS~', '<span style="background-color:cyan;font-family:Courier;">');
         l_source  := replace(l_source, '~OPEN_HTP~', '<span style="background-color:orange;font-family:Courier;">');
         l_source  := replace(l_source, '~CLOSE~', '</span>');
         l_source  := '<span style="padding:10px;"><b>Source</b><pre style="font-family:Courier;padding:10px;">'
                     || l_source
                     || '</pre></span>';
      else
         l_source := 'This region contains no contents';
      end if;

      apex_json.write('source', l_source);
      apex_json.close_object;
      apex_json.close_array;
   exception
      when no_data_found then
         apex_json.open_array;
         apex_json.open_object;
         apex_json.write('title', 'An Error Had Occured');
         apex_json.write('source', p_id);
         apex_json.close_object;
         apex_json.close_array;
      when others then
         sv_sec_error.raise_unanticipated;
   end view_source;

--------------------------------------------------------------------------------
-- PROCEDURE: R E C O R D _ E V A L
--------------------------------------------------------------------------------
-- Records an evaluation run
--------------------------------------------------------------------------------
   procedure record_eval (
      p_attribute_set_id  in  number,
      p_application_id    in  varchar,
      p_app_user          in  varchar,
      p_approved_score    in  number,
      p_pending_score     in  number,
      p_raw_score         in  number,
      p_app_session       in  number default nv('APP_SESSION'),
      p_app_eval_id       in  number default null,
      p_scheduled_eval    in  varchar2 default 'N',
      p_evaluated_ws      in  number default nv('G_WORKSPACE_ID')
   ) is
      l_app_eval_id          number;
      l_cls_raw_score        number := 0;
      l_cls_pending_score    number := 0;
      l_cls_approved_score   number := 0;
      l_cls_possible_score   number := 0;
      l_cat_raw_score        number := 0;
      l_cat_pending_score    number := 0;
      l_cat_approved_score   number := 0;
      l_cat_possible_score   number := 0;
      l_collection_id        number;
      l_attr_possible_score  number := 0;
      type l_score_t is
         table of number index by binary_integer;
      l_score_arr            l_score_t;
   begin

-- Get the Collection ID
      l_collection_id :=
         get_collection_id(
            p_application_id  => p_application_id,
            p_app_user        => p_app_user,
            p_app_session     => p_app_session
         );

-- Get the sequence ID
      if p_app_eval_id is null then
         select sv_sec_app_eval_seq.nextval
           into l_app_eval_id
           from dual;

      else
         l_app_eval_id := p_app_eval_id;
      end if;

-- Update the eval table
      insert into sv_sec_app_evals (
         app_eval_id,
         attribute_set_id,
         application_id,
         app_user,
         eval_date,
         approved_score,
         pending_score,
         raw_score,
         scheduled_eval,
         evaluated_ws
      ) values (
         l_app_eval_id,
         p_attribute_set_id,
         p_application_id,
         p_app_user,
         sysdate,
         p_approved_score,
         p_pending_score,
         p_raw_score,
         p_scheduled_eval,
         p_evaluated_ws
      );

      for x in (
         select *
           from sv_sec_classifications
          order by seq
      ) loop
         for y in (
            select distinct c.category_id,
                            c.category_key
              from sv_sec_categories c,
                   sv_sec_attribute_set_attrs asa,
                   sv_sec_attributes a
             where c.classification_id = x.classification_id
               and c.category_id = a.category_id
               and a.attribute_id = asa.attribute_id
               and asa.attribute_set_id = p_attribute_set_id
         ) loop
            for z in (
               select a.attribute_id,
                      a.attribute_key
                 from sv_sec_attributes a,
                      sv_sec_attribute_set_attrs asa
                where a.category_id = y.category_id
                  and asa.attribute_set_id = p_attribute_set_id
                  and asa.attribute_id = a.attribute_id
            ) loop
               select count(*)
                 into l_score_arr(1)
                 from sv_sec_collection_data cd
                where cd.attribute_id = z.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result in (
                         'PASS', 'APPROVED'
                      );

               select count(*)
                 into l_score_arr(2)
                 from sv_sec_collection_data cd
                where cd.attribute_id = z.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result in (
                         'PASS', 'PENDING', 'APPROVED'
                      );

               select count(*)
                 into l_score_arr(3)
                 from sv_sec_collection_data cd
                where cd.attribute_id = z.attribute_id
                  and cd.collection_id = l_collection_id
                  and cd.result = 'PASS';

               select count(*)
                 into l_attr_possible_score
                 from sv_sec_collection_data cd
                where cd.attribute_id = z.attribute_id
                  and cd.collection_id = l_collection_id;

      -- Save the classificaiton tally
               l_cls_possible_score  := l_cls_possible_score + l_attr_possible_score;
               l_cls_approved_score  := l_cls_approved_score + l_score_arr(1);
               l_cls_pending_score   := l_cls_pending_score + l_score_arr(2);
               l_cls_raw_score       := l_cls_raw_score + l_score_arr(3);

      -- Save the Category tally
               l_cat_possible_score  := l_cat_possible_score + l_attr_possible_score;
               l_cat_approved_score  := l_cat_approved_score + l_score_arr(1);
               l_cat_pending_score   := l_cat_pending_score + l_score_arr(2);
               l_cat_raw_score       := l_cat_raw_score + l_score_arr(3);

      -- Save the Attribute Score
               insert into sv_sec_app_eval_attr (
                  app_eval_id,
                  attribute_id,
                  approved_score,
                  pending_score,
                  raw_score,
                  possible_score
               ) values (
                  l_app_eval_id,
                  z.attribute_id,
                  l_score_arr(1),
                  l_score_arr(2),
                  l_score_arr(3),
                  l_attr_possible_score
               );

      -- Reset the array
               l_score_arr.delete;
            end loop;

    -- Save the Category Score
            insert into sv_sec_app_eval_cat (
               app_eval_id,
               category_id,
               approved_score,
               pending_score,
               raw_score,
               possible_score
            ) values (
               l_app_eval_id,
               y.category_id,
               l_cat_approved_score,
               l_cat_pending_score,
               l_cat_raw_score,
               l_cat_possible_score
            );

            l_cat_approved_score  := 0;
            l_cat_pending_score   := 0;
            l_cat_raw_score       := 0;
            l_cat_possible_score  := 0;
         end loop;

  -- Save the Classification Score
         insert into sv_sec_app_eval_cls (
            app_eval_id,
            classification_id,
            approved_score,
            pending_score,
            raw_score,
            possible_score
         ) values (
            l_app_eval_id,
            x.classification_id,
            l_cls_approved_score,
            l_cls_pending_score,
            l_cls_raw_score,
            l_cls_possible_score
         );

         l_cls_approved_score  := 0;
         l_cls_pending_score   := 0;
         l_cls_raw_score       := 0;
         l_cls_possible_score  := 0;
      end loop;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end record_eval;

--------------------------------------------------------------------------------
-- PROCEDURE: A P P L Y _ N O T A T I O N S
--------------------------------------------------------------------------------
-- Applies all the notations
--------------------------------------------------------------------------------
   procedure apply_notations (
      p_collection_id     in  number,
      p_application_id    in  number,
      p_attribute_set_id  in  number,
      p_app_session       in  number default nv('APP_SESSION'),
      p_sert_app_id       in  varchar2 default v('APP_ID')
   ) is
   begin

-- Update all attributes with a Add Notation link
      update sv_sec_collection_data
         set notation = '<i class="fa fa-comment" style="color:#999;"></i>',
             notation_url = 'f?p='
                            || p_sert_app_id
                            || ':20:'
                            || p_app_session
                            || ':::20:P20_NOTATION_PK:'
                            || attribute_id
                            || '|'
                            ||
                            case
                            when page_id = - 1 then
                                  null
                            else
                                  page_id
                            end
                            || '|'
                            || component_id
                            || '|'
                            || column_id
       where notation is null
         and collection_id = p_collection_id;

-- Add an Edit Notation link for any existing notations
      for x in (
         select distinct attribute_id,
                         page_id,
                         component_id,
                         column_id,
                         count(*) c
           from sv_sec_notations
          where application_id = p_application_id
            and attribute_set_id = p_attribute_set_id
          group by attribute_id,
                   page_id,
                   component_id,
                   column_id
      ) loop
         update sv_sec_collection_data
            set notation = '<i class="fa fa-comments" style="color:#999;padding-left:3px;" title="'
                           || x.c
                           || ' Comments"></i>',
                notation_url = 'f?p='
                               || p_sert_app_id
                               || ':20:'
                               || p_app_session
                               || ':::20:P20_NOTATION_PK:'
                               || attribute_id
                               || '|'
                               ||
                               case
                               when page_id = - 1 then
                                     null
                               else
                                     page_id
                               end
                               || '|'
                               || component_id
                               || '|'
                               || column_id
    -- Note Edit
          where collection_id = p_collection_id
            and case
                when attribute_id is not null
                   and ( page_id is null
                    or page_id = - 1 )
                   and component_id is null
                   and column_id is null
                   and attribute_id = x.attribute_id then
                   1
                when attribute_id is not null
                   and page_id is not null
                   and component_id is null
                   and column_id is null
                   and attribute_id = x.attribute_id
                   and ( page_id = x.page_id
                    or page_id = - 1 ) then
                   1
                when attribute_id is not null
                   and page_id is not null
                   and component_id is not null
                   and column_id is null
                   and attribute_id = x.attribute_id
                   and page_id = x.page_id
                   and component_id = x.component_id then
                   1
                when attribute_id is not null
                   and page_id is not null
                   and component_id is not null
                   and column_id is not null
                   and attribute_id = x.attribute_id
                   and page_id = x.page_id
                   and component_id = x.component_id
                   and column_id = x.column_id then
                   1
                else
                   0
             end = 1;

      end loop;

   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end apply_notations;

--------------------------------------------------------------------------------
-- FUNCTION: N O T A T I O N _ H I S T O R Y _ S Q L
--------------------------------------------------------------------------------
-- Returns the SQL for the Notation History Report
--------------------------------------------------------------------------------
   function notation_history_sql (
      p_application_id    in  number,
      p_attribute_set_id  in  number,
      p_notation_pk       in  varchar2
   ) return varchar2 is
      l_sql           varchar2(32767);
      l_pk            apex_application_global.vc_arr2;
      l_attribute_id  number;
      l_page_id       number;
      l_component_id  varchar2(1000);
      l_column_id     number;
   begin

-- Parse through the p_exception_pk and decompose into individual items
      l_pk := apex_util.string_to_table(p_notation_pk, '|');

-- Loop through the table and assign each component
-- String should conform to this: ATTRIBUTE_ID:PAGE_ID:COMPONENT_ID:COLUMN_ID
      for x in 1..l_pk.count loop
         case
            when x = 1 then
               l_attribute_id := l_pk(x);
            when x = 2 then
               l_page_id := l_pk(x);
            when x = 3 then
               l_component_id := l_pk(x);
            when x = 4 then
               l_column_id := l_pk(x);
         end case;
      end loop;

      if p_notation_pk is null then
         l_sql := 'SELECT
  NOTATION comment_text,
  CREATED_BY user_name,
  CREATED_ON comment_date,
  NULL actions,
  NULL attribute_1,
  NULL attribute_2,
  NULL attribute_3,
  NULL attribute_4
FROM
sv_sec_notations WHERE 1 = 2 ';
      else

-- Assemble the SQL to be used
         l_sql := '
SELECT
  n.NOTATION comment_text,
  n.CREATED_BY || '' ('' || au.workspace_name || '')'' user_name,
  n.CREATED_ON comment_date,
  CASE
    WHEN n.created_by = v(''APP_USER'') AND au.workspace_name = (SELECT workspace_name FROM apex_workspaces WHERE workspace_id = nv(''G_WORKSPACE_ID'')) THEN
      ''<a href="#" id="'' || n.notation_id || ''" class="removeNotation"><i class="fa fa-trash"></i></a>''
    ELSE NULL
  END actions,
  NULL attribute_1,
  NULL attribute_2,
  NULL attribute_3,
  NULL attribute_4
FROM
  sv_sec_notations n,
  apex_workspace_apex_users au
WHERE
  n.application_id = '
                  || p_application_id
                  || '
  AND n.attribute_set_id = '
                  || p_attribute_set_id
                  || '
  AND n.attribute_id = '
                  || l_attribute_id
                  || '
  AND n.created_ws = au.workspace_id
  AND n.created_by = au.user_name';

-- Include Page, if one exists
         if l_page_id is not null then
            l_sql := l_sql
                     || ' AND page_id = '
                     || l_page_id;
         end if;

-- Include Component, if one exists
         if l_component_id is not null then
            apex_util.set_session_state('P20_COMPONENT_ID', l_component_id);
            l_sql := l_sql || ' AND component_id = :P20_COMPONENT_ID';
         end if;

-- Include Column, if one exists
         if l_column_id is not null then
            l_sql := l_sql
                     || ' AND column_id = '
                     || l_column_id;
         end if;

      end if;

      return l_sql;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end notation_history_sql;

--------------------------------------------------------------------------------
-- FUNCTION: G E T _ C H E C K S U M
--------------------------------------------------------------------------------
-- Returns an MD5 checksum for a value
--------------------------------------------------------------------------------
   function get_checksum (
      p_value in clob default null
   ) return raw is
      l_checksum  long raw(2048);
      l_value     clob;
   begin
      if p_value is null then
         l_value := 'NULL';
      else
         l_value := replace(replace(p_value, chr(10), null), chr(13), null);
      end if;

      l_checksum := dbms_crypto.hash(l_value, 1);
      return l_checksum;
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end get_checksum;

--------------------------------------------------------------------------------
-- PROCEDURE: R E C O R D _ C O O K I E
--------------------------------------------------------------------------------
-- Records Session ID and Cookie for Builder Authentication
--------------------------------------------------------------------------------
   procedure record_cookie (
      p_session_id  in  number,
      p_cookie_val  in  varchar2
   ) is
   begin

-- Store the Session ID and Cookie Value
      insert into sv_sec_cookie_sessions (
         session_id,
         cookie_val
      ) values (
         to_char(p_session_id),
         to_char(p_cookie_val)
      );

   end record_cookie;

--------------------------------------------------------------------------------
-- PROCEDURE: B U I L D E R _ A U T H
--------------------------------------------------------------------------------
-- Authenticates users to SERT by inspecting the APEX Builder cookie
-- this version of the auth procedure does not use cookie name to identify the 
-- session.  It uses only SESSION id.
-- Active only in non ADB installation.
-- mipotter  30-May-2022  - remove conditional compilation flags, only use ADB 
--    thi function is now entirely redundant. Consider removal
--------------------------------------------------------------------------------
   procedure builder_auth (
      p_session_id in number
   ) is
      l_username  varchar2(1000);
      l_sgid      number;
   begin
      null;

   exception
      when no_data_found then
         logger.log_error('builder_auth error');
         delete from sv_sec_cookie_sessions
          where session_id = p_session_id;

         owa_util.redirect_url('f?p='
                               || v('APP_ID')
                               || ':102:0:ERROR');
   end builder_auth;

--------------------------------------------------------------------------------
-- FUNCTION: B U I L D E R _ A U T H _ F C N
--------------------------------------------------------------------------------
-- Placeholder Authentication Scheme called by BUILDER_AUTH
--------------------------------------------------------------------------------
   function builder_auth_fcn (
      p_username  in  varchar2,
      p_password  in  varchar2
   ) return boolean is
   begin
      return true;
   end builder_auth_fcn;


---------------------------------------------------------------------
--< match_user >--
---------------------------------------------------------------------
-- Purpose         : briefly
-- HAS COMMITS     : YES/NO
-- HAS ROLLBACKS   : YES/NO
--
-- Purpose   : match username (authenticated) with the builder session 
--             that launched the app
--             Active only in non ADB installation.
--
-- Comments  : 
--
--
-- mipotter  30-May-2022  - remove non-adb code for unification
-- Call Example :
--
---------------------------------------------------------------------
   procedure match_user is
      l_username    varchar2(1000);
      l_sgid        number;
      l_session_id  varchar2(255);

   begin

     null;

   exception
      when no_data_found then
         owa_util.redirect_url('f?p='
                               || v('APP_ID')
                               || ':102:0:ERROR');
   end match_user;

--------------------------------------------------------------------------------
-- FUNCTION: U S E R _ H A S _ R O L E
--------------------------------------------------------------------------------
-- Determines whether or not a user has a role
--------------------------------------------------------------------------------
   function user_has_role (
      p_application_id  in  varchar2 default null,
      p_workspace_id    in  varchar2,
      p_user_name       in  varchar2,
      p_role_name       in  varchar2
   ) return boolean is
      l_application_id  number := p_application_id;
      l_workspace_id    number;
      l_roles_arr       apex_application_global.vc_arr2;
   begin
      l_roles_arr := apex_util.string_to_table(p_role_name);

-- Get the workspace ID of the current application, if one was passed in
      if l_application_id is not null and l_application_id != 0 then
         select workspace_id
           into l_workspace_id
           from apex_applications
          where application_id = l_application_id;

      end if;

-- Determine if the role exists
      for z in 1..l_roles_arr.count loop
         if l_roles_arr(z) = 'SV_SERT_APPROVER_ALL' then
            l_application_id := 0;
         end if;
         for x in (
            select *
              from sv_sec_user_roles
             where user_name = p_user_name
               and user_workspace_id = p_workspace_id
               and role_name = l_roles_arr(z)
               and 1 = case
                       when l_application_id = 0
                          and workspace_id = 0 then
                          1
                       when l_application_id is null then
                          1
                       when l_application_id is not null
                          and workspace_id = l_workspace_id then
                          1
                       else
                          0
                    end
         ) loop
            return true;
         end loop;

      end loop;

      return false;
   end user_has_role;

--------------------------------------------------------------------------------
-- FUNCTION: U S E R _ H A S _ R O L E _ V C
--------------------------------------------------------------------------------
-- Determines whether or not a user has a role and returns a VARCHAR
--------------------------------------------------------------------------------
   function user_has_role_vc (
      p_application_id  in  varchar2 default null,
      p_workspace_id    in  varchar2,
      p_user_name       in  varchar2,
      p_role_name       in  varchar2
   ) return varchar2 is
      l_result boolean;
   begin
      l_result :=
         user_has_role(
            p_application_id  => p_application_id,
            p_workspace_id    => p_workspace_id,
            p_user_name       => p_user_name,
            p_role_name       => p_role_name
         );

      if l_result = true then
         return 'TRUE';
      else
         return 'FALSE';
      end if;
   end user_has_role_vc;

--------------------------------------------------------------------------------
-- FUNCTION: I S _ A C C O U N T _ L O C K E D
--------------------------------------------------------------------------------
-- Wrapper with VARCHAR for apex_util.get_account_locked_status
--------------------------------------------------------------------------------
   function is_account_locked (
      p_user_name in varchar2
   ) return varchar2 is
   begin
      if apex_util.get_account_locked_status(p_user_name => p_user_name) = true then
         return 'Y';
      else
         return 'N';
      end if;
   end is_account_locked;

--------------------------------------------------------------------------------
-- PROCEDURE: P U R G E _ E V A L S
--------------------------------------------------------------------------------
-- Purges either all or selected evaluations
--------------------------------------------------------------------------------
   procedure purge_evals (
      p_eval_type in varchar2
   ) is
   begin

-- Purge all evaluations
      if p_eval_type = 'PURGE_ALL' then
         delete from sv_sec_app_evals;

-- Purge just the selected evaluations
      elsif p_eval_type = 'PURGE_SELECTED' then
         for x in 1..apex_application.g_f01.count loop
            delete from sv_sec_app_evals
             where app_eval_id = apex_application.g_f01(x);

         end loop;

-- Purge all scheduled results
      elsif p_eval_type = 'PURGE_ALL_SCHEDULED' then
         delete from sv_sec_app_evals
          where scheduled_eval = 'Y';

      end if;
   end purge_evals;

--------------------------------------------------------------------------------
-- PROCEDURE: P U R G E _ E V E N T S
--------------------------------------------------------------------------------
-- Purges either all or selected events
--------------------------------------------------------------------------------
   procedure purge_events (
      p_event_type in varchar2
   ) is
   begin

-- Purge all evaluations
      if p_event_type = 'PURGE_ALL' then
         delete from sv_sec_events;

-- Purge just the selected evaluations
      elsif p_event_type = 'PURGE_SELECTED' then
         for x in 1..apex_application.g_f01.count loop
            delete from sv_sec_events
             where event_id = apex_application.g_f01(x);

         end loop;
      end if;
   end purge_events;

--------------------------------------------------------------------------------
-- FUNCTION: B C _ B U T T O N S
--------------------------------------------------------------------------------
-- Determines which buttons to render in the breadcrumb region
--------------------------------------------------------------------------------
   function bc_buttons (
      p_button_key in varchar2
   ) return boolean is
      l_app_page_id  number := nv('APP_PAGE_ID');
      l_count        number;
   begin

-- Reject by Page Range First
      if l_app_page_id < 400 or l_app_page_id > 799 then
         return false;
      end if;

-- Determine SEV
      if p_button_key like 'SEV%' then
         select count(*)
           into l_count
           from sv_sec_attribute_set_attrs
          where attribute_id = nv('G_ATTRIBUTE_ID')
            and attribute_set_id = nv('P0_ATTRIBUTE_SET_ID')
            and severity_level = substr(p_button_key, 4);

         if l_count = 1 then
            return true;
         else
            return false;
         end if;
      elsif p_button_key like '%MULT' then
         if l_app_page_id in (
                   300, 400, 500, 600, 700, 450, 570, 701, 705, 710, 715, 720, 725, 730, 735, 740, 745, 750, 755, 760, 765,
                   770, 775, 780, 785
                ) then
            return false;
         else
            return true;
         end if;
      elsif p_button_key = 'HELP' then
         if l_app_page_id in (
                   0, 400, 500, 600, 700
                ) or v('G_ATTRIBUTE_ID') is null then
            return false;
         else
            return true;
         end if;
      elsif p_button_key = 'FIX' then
         if l_app_page_id in (
                   300, 400, 500, 600, 700, 450, 570, 701, 705, 710, 715, 720, 725, 730, 735, 740, 745, 750, 755, 760, 765,
                   770, 775, 780, 785
                ) then
            return false;
         else
            return true;
         end if;
      end if;

-- Catch All Return False
      return false;
   end bc_buttons;

--------------------------------------------------------------------------------
-- PROCEDURE: P R E P A R E _ U R L
--------------------------------------------------------------------------------
-- Prepares URLs called by Score Buttons
--------------------------------------------------------------------------------
   procedure prepare_url (
      p_type     in  varchar2,
      p_page     in  number default null,
      p_request  in  varchar2 default null
   ) is
      l_url varchar2(1000);
   begin

-- Determine which type of URL to assemble
      if p_type = 'CANCEL' then
         l_url := 'f?p='
                  || v('APP_ID')
                  || ':1:'
                  || v('APP_SESSION')
                  || ':CANCEL';
      elsif p_type = 'SCORE' then

  -- Ensure that p_request is either SCORE or PAGE_SCORE
         if p_request in (
                   'SCORE', 'PAGE_SCORE'
                ) then
            l_url := 'f?p='
                     || v('APP_ID')
                     || ':'
                     || p_page
                     || ':'
                     || v('APP_SESSION')
                     || ':'
                     || p_request;

         else
            l_url := 'f?p='
                     || v('APP_ID')
                     || ':1:'
                     || v('APP_SESSION');
         end if;
      end if;

-- Print out the Prepared URL
      htp.prn('[{"url":"'
              || apex_util.prepare_url(l_url)
              || '"}]');
   end prepare_url;

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
   ) as
      l_file    utl_file.file_type;
      l_buffer  varchar2(32767);
      l_amount  binary_integer := 32767;
      l_pos     integer := 1;
   begin
      l_file := utl_file.fopen(p_dir, p_filename, 'w', 32767);
      loop
         dbms_lob.read(p_clob, l_amount, l_pos, l_buffer);
         utl_file.put(l_file, l_buffer);
         utl_file.fflush(l_file);
         l_pos := l_pos + l_amount;
      end loop;
   exception
      when no_data_found then
    -- expected end.
         if utl_file.is_open(l_file) then
            utl_file.fclose(l_file);
         end if;
      when others then
         if utl_file.is_open(l_file) then
            utl_file.fclose(l_file);
         end if;
         raise;
   end clob_to_file;

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
   ) as
      l_bfile        bfile;
      l_dest_offset  integer := 1;
      l_src_offset   integer := 1;
   begin
   -- get the bfile locator for the directory/filename
      l_bfile := bfilename(upper(p_dir), p_filename);
      dbms_lob.fileopen(l_bfile, dbms_lob.file_readonly);
      dbms_lob.trim(p_blob, 0);
      if dbms_lob.getlength(l_bfile) > 0 then
         dbms_lob.loadblobfromfile(
            dest_lob     => p_blob,
            src_bfile    => l_bfile,
            amount       => dbms_lob.lobmaxsize,
            dest_offset  => l_dest_offset,
            src_offset   => l_src_offset
         );
      end if;
      dbms_lob.fileclose(l_bfile);
   exception
      when others then
         sv_sec_error.raise_unanticipated;
         raise;
   end file_to_blob;
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
   ) is
      l_warning    integer;
      l_file_size  integer;
      o1           integer := 1;
      o2           integer := 1;
      l_blob       blob;
   begin
      l_blob := p_blob;

      l_file_size := dbms_lob.getlength(l_blob);
   -- do the download use an NVL around the mime type and if it is a null 
   -- set it to application/octect
   -- application/octect may launch a download window from windows
      owa_util.mime_header(nvl(p_mime_type, 'application/octet'), FALSE);

   -- set the size so the browser knows how much to download
      htp.p('Content-length: ' || l_file_size);
   -- the filename will be used by the browser if the users does a save as
   -- remove anything after the first '/'
   -- remove chr(10), chr(13) from the filename
      htp.p(
         'Content-Disposition:  attachment; filename="'
         || replace(
            replace(substr(p_filename, instr(p_filename, '/') + 1), chr(10), null),
            chr(13),
            null
         )
         || '"'
      );
      htp.p('Set-Cookie: fileDownload=true; path=/');
   -- close the headers and download the BLOB
      owa_util.http_header_close;
      sys.wpg_docload.download_file(l_blob);
   exception
      when others then
         sv_sec_error.raise_unanticipated;
   end download_blob;

---------------------------------------------------------------------
-- END  SV_SEC_UTIL
---------------------------------------------------------------------
end sv_sec_util;
/